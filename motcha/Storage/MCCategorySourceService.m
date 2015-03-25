#import "MCCategorySourceService.h"
#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataSource.h"
#import "MCSource.h"

static NSString *kStrStoreName = @"store";
static NSString *kStrCategoryEntityName = @"MCCoreDataCategory";
static NSString *kStrSourceEntityName = @"MCCoreDataSource";

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
/*
- (void)hardCodeSource {
  NSPredicate *technologyPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"TECHNOLOGY"];
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:technologyPredicate
                            onSort:nil
                   completionBlock:^(NSArray *entities, NSError *error) {
                     MCCoreDataCategory * technology = (MCCoreDataCategory *)[entities objectAtIndex:0];
                     
                     [_store.context save:nil];
                   }];
  
  
  NSPredicate *financePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"FINANCE"];
  
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:financePredicate
                            onSort:nil
                   completionBlock:^(NSArray *entities, NSError *error) {
                     MCCoreDataCategory * finance = (MCCoreDataCategory *)[entities objectAtIndex:0];
                     
                     
                     [_store.context save:nil];
                   }];
  
  
  
  
  NSPredicate *artsPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", @"ARTS"];
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:artsPredicate
                            onSort:nil
                   completionBlock:^(NSArray *entities, NSError *error) {
                     MCCoreDataCategory * arts = (MCCoreDataCategory *)[entities objectAtIndex:0];
                     
                     
                     [_store.context save:nil];
                   }];
  
  
}*/


- (void)presetCategories:(NSArray *)categories {
  for (NSString * category in categories) {
    MCCoreDataCategory * coreDataCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntityName];
    [coreDataCategory setCategory:category];
    [coreDataCategory setCount:@1];
    [coreDataCategory setSelected:@NO];
    [coreDataCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
    
    if ([category isEqual:@"TECHNOLOGY"]) {
      MCCoreDataSource * technologySource1 = (MCCoreDataSource *)[_store createEntityWithName:kStrSourceEntityName];
      [technologySource1 setSource:@"cnet"];
      [technologySource1 setLink:@"www.cnet.com/rss/news/"];
      [technologySource1 setNeedParse:@NO];
      [technologySource1 setFullTextable:@YES];
      [technologySource1 setCount:@1];
      [technologySource1 setCategory:coreDataCategory];
      
      MCCoreDataSource * technologySource2 = (MCCoreDataSource *)[_store createEntityWithName:kStrSourceEntityName];
      [technologySource2 setSource:@"engadget"];
      [technologySource2 setLink:@"www.engadget.com/rss.xml/"];
      [technologySource2 setNeedParse:@NO];
      [technologySource2 setFullTextable:@YES];
      [technologySource2 setCount:@1];
      [technologySource2 setCategory:coreDataCategory];

    } else if ([category isEqual:@"FINANCE"]){
      MCCoreDataSource * financeSource = (MCCoreDataSource *)[_store createEntityWithName:kStrSourceEntityName];
      [financeSource setSource:@"economist"];
      [financeSource setLink:@"www.economist.com/sections/business-finance/rss.xml/"];
      [financeSource setNeedParse:@NO];
      [financeSource setFullTextable:@YES];
      [financeSource setCount:@1];
      [financeSource setCategory:coreDataCategory];
    } else if ([category isEqual:@"ARTS"]){
      MCCoreDataSource * artsSource = (MCCoreDataSource *)[_store createEntityWithName:kStrSourceEntityName];
      [artsSource setSource:@"artnews"];
      [artsSource setLink:@"www.artnews.com/feed/"];
      [artsSource setNeedParse:@NO];
      [artsSource setFullTextable:@YES];
      [artsSource setCount:@1];
      [artsSource setCategory:coreDataCategory];
    }
  }
  MCCoreDataCategory * recommendCategory = (MCCoreDataCategory *)[_store createEntityWithName:kStrCategoryEntityName];
  [recommendCategory setCategory:recommendedCategory];
  [recommendCategory setCount:@1];
  [recommendCategory setSelected:@NO];
  [recommendCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
  
  [_store.context save:nil];
}



- (void)fetchSelectedCategoriesWithBlock:(void(^)(NSArray *, NSError *))block {
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
  
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:predicate
                            onSort:nil
                   completionBlock:completionBlock];
}


- (void)storeSelectedCategories:(NSArray *)categories withBlock:(void (^)(NSError *))block {
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
  
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:nil
                            onSort:nil
                   completionBlock:completionBlock];
}

- (void)fetchSourceByCategory:(NSString *)categoryName withBlock:(void(^)(NSArray *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      NSMutableArray * sources = [NSMutableArray array];
      if ([entities count] == 1) {
        NSSet * coreDataSources = [[entities objectAtIndex:0] source];
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
      block(sources, error);
    } else {
      block(nil, error);
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:predicate
                            onSort:nil
                   completionBlock:completionBlock];
}

- (void)fetchCategory:(NSString *)categoryName withBlock:(void(^)(MCCategory *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      MCCategory * category = nil;
      if ([entities count] == 1) {
        MCCoreDataCategory * categoryCoreData = [entities objectAtIndex:0];
        category = [[MCCategory alloc] initWithCategory:[categoryCoreData category]
                                                  count:[categoryCoreData count]
                                              lastFetch:[categoryCoreData lastFetch]
                                               selected:[[categoryCoreData selected] boolValue]];
        block(category,error);
      } else {
        NSLog(@"Error fetch category: %@", categoryName);
        block(nil, error);
      }
    }else {
      block(nil, error);
    }
  };
  
  categoryName = [categoryName lowercaseString];
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:predicate
                            onSort:nil
                   completionBlock:completionBlock];
  
}

- (void) fetchAllCategoriesWithBlock:(void(^)(NSArray *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      NSMutableArray * categories = [NSMutableArray array];
      for (MCCoreDataCategory * coreDataCategory in entities) {
        if ([[coreDataCategory category] isEqual:recommendedCategory]) {
          MCCategory *category = [[MCCategory alloc] initWithCategory:[coreDataCategory category]
                                                                count:[coreDataCategory count]
                                                            lastFetch:[coreDataCategory lastFetch]
                                                             selected:[coreDataCategory selected]];
          [categories addObject:category];
        }
      }
      block(categories, error);
    } else {
      block(nil, error);
    }
  };
  [_store fetchForEntitiesWithName:kStrCategoryEntityName
                       onPredicate:nil
                            onSort:nil
                   completionBlock:completionBlock];
}
@end