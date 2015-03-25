#import "MCDictionaryService.h"

#import "MCCoreDataDictionaryWord.h"
#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"

static NSString *kStrDictionaryEntryname = @"MCDictionaryWord";

@implementation MCDictionaryService {
  NSArray *_categories;
}

+ (MCDictionaryService *)sharedInstance {
  static MCDictionaryService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCDictionaryService alloc] init];
  });
  return service;
}

- (void)import {
  NSError* err = nil;
  NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"json"];
  NSArray* dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                        options:kNilOptions
                                                          error:&err];
  NSMutableArray* dictionaryWords = [NSMutableArray new];
  for (NSDictionary *word in dictionary) {
    NSString *wordKey = [word objectForKey:@"word"];
    NSString *pos = [word objectForKey:@"pos"];
    if (wordKey && pos) {
      MCDictionaryWord *wordObject =
        [[MCDictionaryWord alloc] initWithWord:wordKey andPos:pos];
      [dictionaryWords addObject:wordObject];
    }
  }
  [self storeDictionary:dictionaryWords];
}

- (void)storeDictionary:(NSArray *)dictionary {
  id completionBlock = ^(NSError *error) {
    for (MCDictionaryWord *dictionaryWord in dictionary) {
      MCCoreDataDictionaryWord *object =
      (MCCoreDataDictionaryWord *)[[MCDatabaseManager defaultManager] createEntityWithName:kStrDictionaryEntryname];
      object.word = [dictionaryWord.word copy];
      object.pos = dictionaryWord.pos;
    }
    [[MCDatabaseManager defaultManager].context save:nil];
  };
  [[MCDatabaseManager defaultManager] deleteEntriesForEntityName:kStrDictionaryEntryname
                                                           async:YES
                                                     onPredicate:nil
                                                 completionBlock:completionBlock];
}

- (void)getDictionaryWordWithKey:(NSString *)key
                 completionBlock:(void (^)(MCDictionaryWord *word, NSError *error))block {
  id completionBlock = ^(NSArray *result, NSError *error) {
    MCDictionaryWord *dictionaryWord;
    if (!error) {
      MCCoreDataDictionaryWord *entity = [result objectAtIndex:0];
      dictionaryWord =
      [[MCDictionaryWord alloc] initWithWord:entity.word
                                      andPos:entity.pos];
    }
    block(dictionaryWord, error);
  };
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wordKey == %@", key];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrDictionaryEntryname
                                                          async:YES
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

@end
