#import "MCCategorySourceService.h"
#import "MCDatabaseManager.h"
#import "MCCoreDataCategory.h"
#import "MCCoreDataSource.h"

static NSString *kStrCategoryEntityName = @"MCCoreDataCategory";
static NSString *kStrSourceEntityName = @"MCCoreDataSource";

@implementation MCCategorySourceService {
  __block NSArray *_cachedAllCategories; // an array of MCCategories
  __block NSArray *_cachedSelectedCategories; // an array of NSString
}

+ (MCCategorySourceService *)sharedInstance {
  static MCCategorySourceService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCCategorySourceService alloc] init];
  });
  return service;
}

- (void)removeAllCategories {
  [[MCDatabaseManager defaultManager] deleteEntriesForEntityName:kStrCategoryEntityName
                                                           async:NO onPredicate:nil
                                                 completionBlock:nil];
}

- (void)importCategories {
  NSError* err = nil;
  NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"json"];
  
  NSArray* jsonCategories =
      [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                      options:kNilOptions
                                        error:&err];
  for (NSDictionary * jsonCategory in jsonCategories) {
    MCCoreDataCategory * coreDataCategory =
        (MCCoreDataCategory *)[[MCDatabaseManager defaultManager] createEntityWithName:kStrCategoryEntityName];
    [coreDataCategory setCategory:[jsonCategory objectForKey:@"category"]];
    [coreDataCategory setCount:@1];
    [coreDataCategory setSelected:@NO];
    [coreDataCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];

    NSArray *jsonSources = [jsonCategory objectForKey:@"array"];
    for (NSDictionary * jsonSource in jsonSources) {
      MCCoreDataSource * coreDataSource =
      (MCCoreDataSource *)[[MCDatabaseManager defaultManager] createEntityWithName:kStrSourceEntityName];
      [coreDataSource setSource:[jsonSource objectForKey:@"source"]];
      [coreDataSource setLink:[jsonSource objectForKey:@"link"]];
      [coreDataSource setNeedParse:[jsonSource objectForKey:@"needParse"]];
      [coreDataSource setFullTextable:[jsonSource objectForKey:@"fullTextable"]];
      [coreDataSource setCount:@1];
      [coreDataSource setCategory:coreDataCategory];
    }
  }
  
  MCCoreDataCategory * recommendCategory =
      (MCCoreDataCategory *)[[MCDatabaseManager defaultManager] createEntityWithName:kStrCategoryEntityName];
  [recommendCategory setCategory:recommendedCategory];
  [recommendCategory setCount:@1];
  [recommendCategory setSelected:@YES];
  [recommendCategory setLastFetch:[NSDate dateWithTimeIntervalSince1970:0]];
  [[MCDatabaseManager defaultManager].context save:nil];
}

- (void)fetchSelectedCategoriesAsync:(BOOL)shouldFetchAsync withBlock:(void(^)(NSArray *, NSError *))block {
  if (_cachedSelectedCategories) {
    block(_cachedSelectedCategories, nil);
    return;
  }
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"selected", @YES];
  id completionBlock = ^(NSArray *entities, NSError *error) {
    NSMutableArray *categories = [NSMutableArray array];
    for (MCCoreDataCategory *entity in entities) {
      [categories addObject:[entity.category uppercaseString]];
    }
    _cachedSelectedCategories = [categories copy];
    block(categories, error);
  };
  
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                   onPredicate:predicate
                                                        onSort:nil
                                               completionBlock:completionBlock];
}


- (void)storeSelectedCategories:(NSArray *)categories
                          async:(BOOL)shouldFetchAsync
                      withBlock:(void (^)(NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      for (MCCoreDataCategory *entity in entities) {
        NSString * category = [entity category];
        if ([categories containsObject:category]) {
          [entity setSelected:@YES];
        } else {
          [entity setSelected:@NO];
        }
        [[entity managedObjectContext] save:nil];
      }
      // invalidate the caches.
      _cachedSelectedCategories = nil;
      _cachedAllCategories = nil;
    }
    block(error);
  };
  
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                    onPredicate:nil
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

- (void)fetchSourceByCategory:(NSString *)categoryName
                        async:(BOOL)shouldFetchAsync
                    withBlock:(void (^)(NSArray *, NSError *))block {
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
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                   onPredicate:predicate
                                                        onSort:nil
                                               completionBlock:completionBlock];
}

- (void)fetchCategory:(NSString *)categoryName
                async:(BOOL)shouldFetchAsync
            withBlock:(void (^)(MCCategory *, NSError *))block {
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
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                   onPredicate:predicate
                                                        onSort:nil
                                               completionBlock:completionBlock];
}

-(void)fetchSource:(NSString *)sourceName
      categoryName:(NSString *)categoryName
             async:(BOOL)shouldFetchAsync
         withBlock:(void (^)(MCSource *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      MCSource * source = nil;
      if ([entities count] == 1) {
        MCCoreDataSource * sourceCoreData = [entities objectAtIndex:0];
        source = [[MCSource alloc] initWithCategory:categoryName
                                             source:[sourceCoreData source]
                                               link:[sourceCoreData link]
                                              count:[sourceCoreData count]
                                          needParse:[[sourceCoreData needParse] boolValue]
                                        fullTextale:[[sourceCoreData fullTextable] boolValue]];
        block(source,error);
      } else {
        NSLog(@"Error fetch category: %@", sourceName);
        block(nil, error);
      }
    }else {
      block(nil, error);
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(%K == %@) AND (%K == %@)",
                             @"source", sourceName, @"category", categoryName];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

- (void) fetchAllCategoriesAsync:(BOOL)shouldFetchAsync withBlock:(void(^)(NSArray *, NSError *))block {
  if (_cachedAllCategories) {
    block(_cachedAllCategories, nil);
    return;
  }
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      NSMutableArray * categories = [NSMutableArray array];
      for (MCCoreDataCategory * coreDataCategory in entities) {
        MCCategory *category =
            [[MCCategory alloc] initWithCategory:[coreDataCategory category]
                                           count:[coreDataCategory count]
                                       lastFetch:[coreDataCategory lastFetch]
                                        selected:[(NSNumber *)[coreDataCategory selected] boolValue]];
        [categories addObject:category];
      }
      _cachedAllCategories = [categories copy];
      block(categories, error);
    } else {
      block(nil, error);
    }
  };
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:shouldFetchAsync
                                                   onPredicate:nil
                                                        onSort:nil
                                               completionBlock:completionBlock];
}

-(void)incrementCategoryCount:(NSString *)categoryName {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      if ([entities count] == 1) {
        MCCoreDataCategory * categoryCoreData = [entities objectAtIndex:0];
        [categoryCoreData setCount:[NSNumber numberWithInt:([[categoryCoreData count] intValue] + 1)]];
        [[categoryCoreData managedObjectContext] save:nil];
      } else {
        NSLog(@"Error increment category: %@", categoryName);
      }
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:NO
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

-(void)incrementSourceCount:(NSString *)sourceName {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      if ([entities count] == 1) {
        MCCoreDataSource * sourceCoreData = [entities objectAtIndex:0];
        [sourceCoreData setCount:[NSNumber numberWithInt:([[sourceCoreData count] intValue] + 1)]];
        [[sourceCoreData managedObjectContext] save:nil];
      } else {
        NSLog(@"Error increment source: %@", sourceName);
      }
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"source", sourceName];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrSourceEntityName
                                                          async:NO
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

- (void) recordCategoryFetchTime:(NSString *) categoryName {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      if ([entities count] == 1) {
        MCCoreDataCategory * categoryCoreData = [entities objectAtIndex:0];
        [categoryCoreData setLastFetch:[NSDate date]];
        [[categoryCoreData managedObjectContext] save:nil];
      } else {
        NSLog(@"Error record category fetchtime: %@", categoryName);
      }
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"category", categoryName];
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrCategoryEntityName
                                                          async:NO
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

@end
