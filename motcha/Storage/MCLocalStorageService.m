#import "MCLocalStorageService.h"

#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataDictionaryWord.h"
#import "MCDictionaryWord.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrCategoryEntryName = @"MCCoreDataCategory";
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

- (NSArray *)categories {
  NSArray *result = [_store fetchForEntitiesWithName:kStrCategoryEntryName
                                         onPredicate:nil
                                              onSort:nil];
  NSMutableArray *categories = [NSMutableArray array];
  for (MCCoreDataCategory *entity in result) {
    [categories addObject:entity.category];
  }
  return categories;
}

- (void)setCategories:(NSArray *)categories {
  [_store deleteEntitiesWithName:kStrCategoryEntryName onPredicate:nil];
  for (NSString *category in categories) {
    MCCoreDataCategory *object =
        (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntryName];
    object.category = category;
  }
  [_store.context save:nil];
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
