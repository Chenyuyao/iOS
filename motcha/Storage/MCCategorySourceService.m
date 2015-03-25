#import "MCCategorySourceService.h"
#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataSource.h"
#import "MCSource.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrMCCategoryEntityName = @"MCCoreDataCategory";
static NSString *kStrMCSourceEntityName = @"MCCoreDataSource";

@implementation MCCategorySourceService {
  MCDatabaseManager *_store;
}

+ (MCCategorySourceService *)sharedInstance {
  static MCCategorySourceService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCCategorySourceService alloc] init];
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

- (void)hardCodeSource {
  MCCoreDataSource * technologySource1 = (MCCoreDataSource *)[_store createEntityWithName:kStrMCSourceEntityName];
  [technologySource1 setSource:@"cnet"];
  [technologySource1 setLink:@"www.cnet.com/rss/news/"];
  [technologySource1 setNeedParse:@NO];
  [technologySource1 setFullTextable:@YES];
  [technologySource1 setCount:@1];
  
  MCCoreDataSource * technologySource2 = (MCCoreDataSource *)[_store createEntityWithName:kStrMCSourceEntityName];
  [technologySource2 setSource:@"engadget"];
  [technologySource2 setLink:@"www.engadget.com/rss.xml/"];
  [technologySource2 setNeedParse:@NO];
  [technologySource2 setFullTextable:@YES];
  [technologySource2 setCount:@1];
  
  NSPredicate *technologyPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"TECHNOLOGY"];
  MCCoreDataCategory * technology =
  (MCCoreDataCategory *)[[_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                              onPredicate:technologyPredicate
                                                   onSort:nil] objectAtIndex:0];
  [technologySource1 setCategory:technology];
  [technologySource2 setCategory:technology];
  //  [technology addSourceObject:technologySource1];
  //  [technology addSourceObject:technologySource2];
  
  MCCoreDataSource * financeSource = (MCCoreDataSource *)[_store createEntityWithName:kStrMCSourceEntityName];
  [financeSource setSource:@"economist"];
  [financeSource setLink:@"www.economist.com/sections/business-finance/rss.xml/"];
  [financeSource setNeedParse:@NO];
  [financeSource setFullTextable:@YES];
  [financeSource setCount:@1];
  
  NSPredicate *financePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"FINANCE"];
  MCCoreDataCategory * finance =
  (MCCoreDataCategory *)[[_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                              onPredicate:financePredicate
                                                   onSort:nil] objectAtIndex:0];
  [finance addSourceObject:financeSource];
  
  MCCoreDataSource * artsSource = (MCCoreDataSource *)[_store createEntityWithName:kStrMCSourceEntityName];
  [artsSource setSource:@"artnews"];
  [artsSource setLink:@"www.artnews.com/feed/"];
  [artsSource setNeedParse:@NO];
  [artsSource setFullTextable:@YES];
  [artsSource setCount:@1];
  
  NSPredicate *artsPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"ARTS"];
  MCCoreDataCategory * arts =
  (MCCoreDataCategory *)[[_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                              onPredicate:artsPredicate
                                                   onSort:nil] objectAtIndex:0];
  [arts addSourceObject:artsSource];
  
  [_store.context save:nil];
}


- (void)presetCategories:(NSArray *)categories {
  for (NSString * category in categories) {
    MCCoreDataCategory * coreDataCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrMCCategoryEntityName];
    [coreDataCategory setCategory:category];
    [coreDataCategory setCount:@1];
    [coreDataCategory setSelected:@NO];
    [coreDataCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
  }
  MCCoreDataCategory * recommendCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrMCCategoryEntityName];
  [recommendCategory setCategory:recommendedCategory];
  [recommendCategory setCount:@1];
  [recommendCategory setSelected:@NO];
  [recommendCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
  
  
}

- (NSArray *) selectedCategories {
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"selected", @YES];
  NSArray *result = [_store fetchForEntitiesWithName:kStrMCCategoryEntityName
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

- (void) selectCategories:(NSArray *)categories {
  NSArray *result = [_store fetchForEntitiesWithName:kStrMCCategoryEntityName
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

- (NSArray *)getSourceByCategory:(NSString *)categoryName {
  NSMutableArray * sources = [NSMutableArray array];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  NSArray * categoryArray = [_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                                 onPredicate:predicate
                                                      onSort:nil];
  if ([categoryArray count] == 1) {
    NSSet * coreDataSources = [[categoryArray objectAtIndex:0] source];
    for (MCCoreDataSource * coreDataSource in coreDataSources) {
      MCSource * source =
      [[MCSource alloc] initWithCategory:categoryName
                                  source:[coreDataSource source]
                                    link:[coreDataSource link]
                                   count:[coreDataSource count]
                               needParse:[[coreDataSource needParse] boolValue]
                             fullTextale:[[coreDataSource fullTextable] boolValue]];
      [sources addObject:source];
    }
  } else {
    NSLog(@"Error fetch category: %@", categoryName);
  }
  return sources;
}

- (MCCategory *)getCategory:(NSString *)categoryName {
  MCCategory * category = nil;
  categoryName = [categoryName lowercaseString];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  NSArray * coreDataCategoryArray = [_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                                         onPredicate:predicate
                                                              onSort:nil];
  if ([coreDataCategoryArray count] == 1) {
    MCCoreDataCategory * categoryCoreData = [coreDataCategoryArray objectAtIndex:0];
    category = [[MCCategory alloc] initWithCategory:[categoryCoreData category]
                                              count:[categoryCoreData count]
                                          lastFetch:[categoryCoreData lastFetch]
                                           selected:[[categoryCoreData selected] boolValue]];
  } else {
    NSLog(@"Error fetch category: %@", categoryName);
  }
  return category;
}

- (NSArray *) getAllCategories {
  NSMutableArray * categories = [NSMutableArray array];
  NSArray * coreDataCategoryArray = [_store fetchForEntitiesWithName:kStrMCCategoryEntityName
                                                         onPredicate:nil
                                                              onSort:nil];
  for (MCCoreDataCategory * coreDataCategory in coreDataCategoryArray) {
    if ([[coreDataCategory category] isEqual:recommendedCategory]) {
      MCCategory *category = [[MCCategory alloc] initWithCategory:[coreDataCategory category]
                                                            count:[coreDataCategory count]
                                                        lastFetch:[coreDataCategory lastFetch]
                                                         selected:[coreDataCategory selected]];
      [categories addObject:category];
    }
  }
  return categories;
}
@end