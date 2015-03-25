#import "MCLocalStorageService.h"

#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataDictionaryWord.h"
#import "MCDictionaryWord.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrDictionaryEntryname = @"MCDictionaryWord";


@implementation MCLocalStorageService {
  MCDatabaseManager *_store;
}

+ (MCLocalStorageService *)sharedInstance {
  static MCLocalStorageService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCLocalStorageService alloc] init];
  });
  return service;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _store = [[MCDatabaseManager alloc] initWithName:kStrStoreName];
  }
  return self;
}

- (void)storeDictionary:(NSArray *)dictionary {
  [_store deleteEntitiesWithName:kStrDictionaryEntryname onPredicate:nil];
  for (MCDictionaryWord *dictionaryWord in dictionary) {
    MCCoreDataDictionaryWord *object =
        (MCCoreDataDictionaryWord *)[_store createEntityWithName:kStrDictionaryEntryname];
    object.word = [dictionaryWord.word copy];
    object.pos = dictionaryWord.pos;
  }
  [_store.context save:nil];
}

- (MCDictionaryWord *)getDictionaryWordWithKey:(NSString *)key {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wordKey == %@", key];
  NSArray *result = [_store fetchForEntitiesWithName:kStrDictionaryEntryname
                                         onPredicate:predicate
                                              onSort:nil];
  if ([result count] > 0) {
    MCCoreDataDictionaryWord *entity = [result objectAtIndex:0];
    MCDictionaryWord *dictionaryWord = [[MCDictionaryWord alloc] initWithWord:entity.word andPos:entity.pos];
    return dictionaryWord;
  } else {
    return nil;
  }
}

@end
