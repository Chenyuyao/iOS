#import "MCTitlePipe.h"
#import "MCDatabaseManager.h"
#import "MCCoreDataDictionaryWord.h"
#import "MCAppDelegate.h"
#import "MCCoreDataWordOccurrence.h"

static NSString *kStrDictionaryEntityName = @"MCCoreDataDictionaryWord";
static NSString *kStrWordOccurrenceEntityName = @"MCCoreDataWordOccurrence";

@implementation MCTitlePipe

+ (NSDictionary *)getPosScore {
  static NSDictionary *posScore = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    posScore = @{
                 @"noun": @5,
                 @"noun-plural": @5,
                 @"adjective": @1,
                 };
  });
  return posScore;
}

//Singletons
+ (MCTitlePipe *)sharedInstance {
  static MCTitlePipe *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCTitlePipe alloc] init];
  });
  return service;
}

//change all words to lower case
- (NSString *)lowerCaseFilter:(NSString *) title {
  NSString * lowerCaseTitle = [title lowercaseString];
  return lowerCaseTitle;
}

//split the title into an array of words separated by whitespace
- (NSArray *)splitByWhiteSpaceFilter:(NSString *) title {
  NSArray *wordArray =
  [title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  wordArray = [wordArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
  return wordArray;
}

- (void) fetchWordScore:(NSString *) word
        withBlock:(void(^)(NSNumber *, NSError *)) block{
  //Get the score of this word according to the part-of-speech
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"word", word];
  
  id dictionaryBlock = ^(NSArray * dictionaryWords, NSError * error) {
    if (!error) {
      NSNumber * wordScore;
      if ([dictionaryWords count] == 0) {
        //this word cannot be found in build-in dictionary, we treat it as a noun
        wordScore = [[MCTitlePipe getPosScore]
                     objectForKey:[NSString stringWithFormat:@"noun"]];
      } else {
        MCCoreDataDictionaryWord * coreDataDictionaryWord =
        (MCCoreDataDictionaryWord *)[dictionaryWords objectAtIndex:0];
        wordScore = [[MCTitlePipe getPosScore] objectForKey:[coreDataDictionaryWord pos]];
        if (wordScore == nil) {
          wordScore = @0;
        }
      }
      
      //Get the word count and last modified date from Core Data
      id occBlock = ^(NSArray * wordOccurrences, NSError * error) {
        if (!error) {
          if ([wordOccurrences count] > 0) {
            NSNumber * occurrence = @0;
            NSDate * lastModified;
            MCCoreDataWordOccurrence * wordOccurrence =
            (MCCoreDataWordOccurrence *)[wordOccurrences objectAtIndex:0];
            occurrence = [wordOccurrence count];
            lastModified = [wordOccurrence lastModified];
            //Calculate the total word score by multiply wordScore and occurrence
            //TODO: calculate totalScore considering lastModified
            
            //Word score calculation ALG start
            double wordScoreDoubleValue = [wordScore doubleValue];
            double occurrenceDoubleValue = [occurrence doubleValue];
            double totalScoreDoubleValue = wordScoreDoubleValue * occurrenceDoubleValue;
            //Word score calculation ALG end
            
            NSNumber * totalScore = [NSNumber numberWithDouble:totalScoreDoubleValue];
            block(totalScore, nil);
          }
        } else {
          NSLog(@"Error fetch word occurrence in MCTitlePipe.fetchWordScore");
          block(@(0),error);
        }
      };
      //Fetch Request to find the target word
      [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrWordOccurrenceEntityName
                                                              async:YES
                                                        onPredicate:predicate
                                                             onSort:nil
                                                    completionBlock:occBlock];
    } else {
      NSLog(@"Error fetch dictionary word in MCTitlePipe.fetchWordScore");
      block(@(0),error);
    }
  };
  
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrDictionaryEntityName
                                                          async:YES
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:dictionaryBlock];
}

//Store word in MCWordOccurrence Data Model
- (void) saveWord:(NSString *) word {
  //Find word through Core Data
  id occBlock = ^(NSArray * wordOccurrences, NSError * error) {
    if (!error) {
      if ([wordOccurrences count] == 0) {
        //word does not in MCWordOccurrence Data Model, create an instance with count = 0
        MCCoreDataWordOccurrence * newWord =
        (MCCoreDataWordOccurrence *)[[MCDatabaseManager defaultManager]
                                     createEntityWithName:kStrWordOccurrenceEntityName];
        [newWord setWord:word];
        [newWord setCount:0];
        [newWord setLastModified:[NSDate date]];
        
        NSError * saveError = nil;
        if (![newWord.managedObjectContext save:&saveError]) {
          NSLog(@"%@, %@",saveError,saveError.localizedDescription);
        }
      } else if ([wordOccurrences count] == 1) {
        //word does exist in MCWordOccurrence Data Model, increment count and set lastModified to now
        MCCoreDataWordOccurrence * wordOccurrence =
        (MCCoreDataWordOccurrence *)[wordOccurrences objectAtIndex:0];
        [wordOccurrence setCount:[NSNumber numberWithInt:[[wordOccurrence count] intValue] + 1]];
        [wordOccurrence setLastModified:[NSDate date]];
        
        NSError * saveError = nil;
        if (![wordOccurrence.managedObjectContext save:&saveError]) {
          NSLog(@"%@, %@",saveError,saveError.localizedDescription);
        }
      } else {
        //duplicated recore of MCWordOccurrence found. Should NOT happen
        NSLog(@"duplicated recore of MCWordOccurrence found");
      }
    } else {
      NSLog(@"Error fetch word occurrence in MCTitlePipe.saveWord");
      NSLog(@"%@ %@", error, error.localizedDescription);
    }
  };
  
  //Fetch Request to find the target word
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"word", word];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrWordOccurrenceEntityName
                                                          async:YES onPredicate:predicate onSort:nil completionBlock:occBlock];
}

//Return the Recommended ALG Score for an array of words
- (void) wordScoreSink:(NSArray *) wordArray
       withBlock:(void(^)(NSNumber *, NSError *)) block{
  __block double sum = 0.0;
  __block NSUInteger completeCount = 0;
  for (NSString * word in wordArray) {
    id completionBlock = ^(NSNumber * wordScore, NSError * error) {
      if (!error) {
        double wordScoreDoubleValue = [wordScore doubleValue];
        sum += wordScoreDoubleValue;
        completeCount++;
        if (completeCount == [wordArray count]) {
          block([NSNumber numberWithDouble:sum], nil);
        }
      } else {
        block(@(0), error);
      }
    };
    [self fetchWordScore:word withBlock:completionBlock];
  }
}

//Save all word in array into Core Data
- (void)saveWordSink:(NSArray *) wordArray {
  for (NSString * word in wordArray) {
    [self saveWord:word];
  }
}

//get the total score of a title
- (void)fetchTitleScore:(NSString *) title
        withBlock:(void(^)(NSNumber *, NSError *)) block{
  NSString * lowerCaseTitle = [self lowerCaseFilter:title];
  NSArray * words = [self splitByWhiteSpaceFilter:lowerCaseTitle];
  [self wordScoreSink:words withBlock:block];
}

//store the word from a title
- (void) saveTitleWord:(NSString *) title {
  NSString * lowerCaseTitle = [self lowerCaseFilter:title];
  NSArray * words = [self splitByWhiteSpaceFilter:lowerCaseTitle];
  [self saveWordSink:words];
}

@end
