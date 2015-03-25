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
  NSArray *_categories;
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

- (void)fetchCategoriesWithBlock:(void(^)(NSArray *, NSError *))block {
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"selected", @YES];
  id completionBlock = ^(NSArray *entities, NSError *error) {
    NSMutableArray *categories = [NSMutableArray array];
    for (MCCoreDataCategory *entity in entities) {
      [categories addObject:entity.category];
    }
    [categories removeObject:recommendedCategory];
    [categories insertObject:recommendedCategory atIndex:0];
    block(categories, error);
  };
  
  [_store fetchForEntitiesWithName:kStrCategoryEntryName
                       onPredicate:predicate
                            onSort:nil
                   completionBlock:completionBlock];
}

- (void)storeCategories:(NSArray *)categories withBlock:(void (^)(NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
      if (!error) {
        for (MCCoreDataCategory *entity in entities) {
          NSString * category = entity.category;
          if ([categories containsObject:category]) {
            [entity setSelected:@YES];
          } else {
            [entity setSelected:@NO];
          }
        }
        [_store.context save:nil];
      }
      block(error);
  };
  
  [_store fetchForEntitiesWithName:kStrCategoryEntryName
                       onPredicate:nil
                            onSort:nil
                   completionBlock:completionBlock];
}

- (void)storeDictionary:(NSArray *)dictionary {
  [_store deleteEntitiesWithName:kStrDictionaryEntryname onPredicate:nil completionBlock:^(NSError *error) {
      for (MCDictionaryWord *dictionaryWord in dictionary) {
        MCCoreDataDictionaryWord *object =
        (MCCoreDataDictionaryWord *)[_store createEntityWithName:kStrDictionaryEntryname];
        object.word = [dictionaryWord.word copy];
        object.pos = dictionaryWord.pos;
      }
      [_store.context save:nil];
  }];
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
  [_store fetchForEntitiesWithName:kStrDictionaryEntryname
                                         onPredicate:predicate
                                              onSort:nil
                     completionBlock:completionBlock];
}

@end
