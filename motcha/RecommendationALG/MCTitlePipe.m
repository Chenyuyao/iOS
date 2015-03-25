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

+ (NSArray *)getFunctionWords {
  static NSArray *functionWords = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    functionWords = @[
                 @"preposition",
                 @"indefinite-article",
                 @"definite-article",
                 @"conjunction",
                 @"auxiliary-verb",
                 @"interjection",
                 @"phrase",
                 @"pronoun"
                 ];
  });
  return functionWords;
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

//remove all function words
- (NSArray *)removeFunctionWordFilter:(NSArray *) wordArray {
  
  //Remove function words
  NSMutableArray *contentWordArray = [NSMutableArray arrayWithArray:wordArray];
  NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
  
  
  for (NSUInteger index = 0; index < [contentWordArray count]; index++)
  {
    NSString* currentWord = [contentWordArray objectAtIndex:index];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"word", currentWord];
    NSArray * dictionaryWords = [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrDictionaryEntityName onPredicate:predicate onSort:nil error:nil];
    if ([dictionaryWords count] == 1) {
      MCCoreDataDictionaryWord * coreDataDictionaryWord =
      (MCCoreDataDictionaryWord *)[dictionaryWords objectAtIndex:0];
      if ([[MCTitlePipe getFunctionWords] containsObject:[coreDataDictionaryWord pos]]) {
        [discardedItems addIndex:index];
      }
    }
  }
  
  [contentWordArray removeObjectsAtIndexes:discardedItems];
  return contentWordArray;
}

- (NSNumber *) getWordScore:(NSString *) word {
  //Get the score of this word according to the part-of-speech
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"word", word];
  NSArray * dictionaryWords =
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrDictionaryEntityName
                                                    onPredicate:predicate
                                                         onSort:nil
                                                          error:nil];
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
  NSNumber * occurrence = @0;
  NSDate * lastModified;
  
  //Fetch Request to find the target word
  NSError * error = nil;
  NSArray *wordOccurrences =
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrWordOccurrenceEntityName
                                                    onPredicate:predicate
                                                          onSort:nil
                                                          error:nil];
  if (!error) {
    if ([wordOccurrences count] > 0) {
      MCCoreDataWordOccurrence * wordOccurrence =
      (MCCoreDataWordOccurrence *)[wordOccurrences objectAtIndex:0];
      occurrence = [wordOccurrence count];
      lastModified = [wordOccurrence lastModified];
    }
  } else {
    NSLog(@"Error fetch word occurrence in MCTitlePipe.getWordScore");
    NSLog(@"%@ %@", error, error.localizedDescription);
  }
  
  //Calculate the total word score by multiply wordScore and occurrence
  //TODO: calculate totalScore considering lastModified
  
  //Word score calculation ALG start
  double wordScoreDoubleValue = [wordScore doubleValue];
  double occurrenceDoubleValue = [occurrence doubleValue];
  double totalScoreDoubleValue = wordScoreDoubleValue * occurrenceDoubleValue;
  //Word score calculation ALG end
  
  NSNumber * totalScore = [NSNumber numberWithDouble:totalScoreDoubleValue];
  
  return totalScore;
}

//Store word in MCWordOccurrence Data Model
- (void) saveWord:(NSString *) word {
  //Find word through Core Data
  //Fetch Request to find the target word
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"word", word];
  NSError * error = nil;
  NSArray *wordOccurrences =
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrWordOccurrenceEntityName
                                                    onPredicate:predicate
                                                         onSort:nil
                                                          error:nil];
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
    NSLog(@"Error fetch word occurrence in MCTitlePipe.getWordScore");
    NSLog(@"%@ %@", error, error.localizedDescription);
  }

}

//Return the Recommended ALG Score for an array of words
- (NSNumber *) wordScoreSink:(NSArray *) contentwordArray {
  double sum = 0.0;
  for (NSString * word in contentwordArray) {
    double wordScoreDoubleValue = [[self getWordScore:word] doubleValue];
    sum += wordScoreDoubleValue;
  }
  
  return [NSNumber numberWithDouble:sum];
}

//Save all word in array into Core Data
- (void) saveWordSink:(NSArray *) contentwordArray {
  for (NSString * word in contentwordArray) {
    [self saveWord:word];
  }
}

//get the total score of a title
- (NSNumber *) getTitleScore:(NSString *) title {
  NSString * lowerCaseTitle = [self lowerCaseFilter:title];
  NSArray * words = [self splitByWhiteSpaceFilter:lowerCaseTitle];
  NSArray * contentWords = [self removeFunctionWordFilter:words];
  return [self wordScoreSink:contentWords];
}

//store the word from a title
- (void) saveTitleWord:(NSString *) title {
  NSString * lowerCaseTitle = [self lowerCaseFilter:title];
  NSArray * words = [self splitByWhiteSpaceFilter:lowerCaseTitle];
  NSArray * contentWords = [self removeFunctionWordFilter:words];
  [self saveWordSink:contentWords];
}

@end
