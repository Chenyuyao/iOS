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

- (void)fetchCategoriesWithBlock:(void(^)(NSArray *, NSError *))block {
  [_store fetchForEntitiesWithName:kStrCategoryEntryName
                       onPredicate:nil
                            onSort:nil
                   completionBlock:^(NSArray *entities, NSError *error) {
                       NSMutableArray *categories = [NSMutableArray array];
                       for (MCCoreDataCategory *entity in entities) {
                         [categories addObject:entity.category];
                       }
                       block(categories, error);
                    }];
}

- (void)storeCategories:(NSArray *)categories withBlock:(void (^)(NSError *))block {
  id completionBlock = ^(NSError *error) {
      if (!error) {
        for (NSString *category in categories) {
          MCCoreDataCategory *object =
          (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntryName];
          object.category = category;
        }
        [_store.context save:nil];
      }
      block(error);
  };
  [_store deleteEntitiesWithName:kStrCategoryEntryName
                     onPredicate:nil
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
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wordKey == %@", key];
  [_store fetchForEntitiesWithName:kStrDictionaryEntryname
                                         onPredicate:predicate
                                              onSort:nil
                     completionBlock:^(NSArray *result, NSError *error) {
                         MCDictionaryWord *dictionaryWord;
                         if (!error) {
                           MCCoreDataDictionaryWord *entity = [result objectAtIndex:0];
                           dictionaryWord =
                               [[MCDictionaryWord alloc] initWithWord:entity.word
                                                               andPos:entity.pos];
                         }
                         block(dictionaryWord, error);
                     }];
}

@end
