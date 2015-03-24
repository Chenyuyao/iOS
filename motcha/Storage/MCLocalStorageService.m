#import "MCLocalStorageService.h"

#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataDictionaryWord.h"
#import "MCDictionaryWord.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrCategoryEntryName = @"MCCoreDataCategory";
static NSString *kStrDictionaryEntryname = @"MCDictionaryWord";
static NSString * const recommendedCategory = @"RECOMMENDED";

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

- (void)presetCategories:(NSArray *)categories {
  for (NSString * category in categories) {
    MCCoreDataCategory * coreDataCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntryName];
    [coreDataCategory setCategory:category];
    [coreDataCategory setCount:@1];
    [coreDataCategory setSelected:@NO];
    [coreDataCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
  }
  MCCoreDataCategory * recommendCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntryName];
  [recommendCategory setCategory:recommendedCategory];
  [recommendCategory setCount:@1];
  [recommendCategory setSelected:@NO];
  [recommendCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];

  
}

- (NSArray *)categories {
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"selected", @YES];
  NSArray *result = [_store fetchForEntitiesWithName:kStrCategoryEntryName
                                         onPredicate:predicate
                                              onSort:nil];
  NSMutableArray *categories = [NSMutableArray array];
  for (MCCoreDataCategory *entity in result) {
    [categories addObject:entity.category];
  }
  [categories removeObject:recommendedCategory];
  [categories insertObject:recommendedCategory atIndex:0];
  return categories;
}

- (void)setCategories:(NSArray *)categories {
  NSArray *result = [_store fetchForEntitiesWithName:kStrCategoryEntryName
                                         onPredicate:nil
                                              onSort:nil];
  for (MCCoreDataCategory *entity in result) {
    NSString * category = entity.category;
    if ([categories containsObject:category]) {
      [entity setSelected:@YES];
    } else {
      [entity setSelected:@NO];
    }
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
