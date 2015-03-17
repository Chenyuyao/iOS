#import "MCReadingPreferenceService.h"

#import "MCDatabaseManager.h"
#import "CategoryEntity.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrCategoryEntryName = @"category_entry";

@implementation MCReadingPreferenceService {
  MCDatabaseManager *_store;
}

+ (MCReadingPreferenceService *)sharedInstance {
  static MCReadingPreferenceService *service;
  if (!service) {
    service = [[MCReadingPreferenceService alloc] init];
  }
  return service;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSArray *entities = @[ [CategoryEntity descriptionWithName:kStrCategoryEntryName] ];
    _store = [[MCDatabaseManager alloc] initWithName:kStrStoreName
                                            entities:entities];
  }
  return self;
}

- (NSArray *)categories {
  NSArray *result = [_store fetchForEntitiesWithName:kStrCategoryEntryName onPredicate:nil];
  NSMutableArray *categories = [NSMutableArray array];
  for (CategoryEntity *entity in result) {
    [categories addObject:entity.category];
  }
  return categories;
}

- (void)setCategories:(NSArray *)categories {
  [_store deleteEntitiesWithName:kStrCategoryEntryName onPredicate:nil];
  for (NSString *category in categories) {
    CategoryEntity *object =
        (CategoryEntity *)[_store createEntityWithName:kStrCategoryEntryName];
    object.category = category;
    [_store.context save:nil];
  }
}


@end
