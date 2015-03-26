#import "MCDatabaseManager.h"

static NSString *const kContextKey = @"context";
static NSString *const kDataModelFileName = @"Motcha";
static NSString *const kStrStoreName = @"store";

// TODO(shinfan): Finish this.
@implementation MCDatabaseManager {
  NSManagedObjectModel *_model;
  NSString *_storePath;
  NSPersistentStore *_store;
  NSPersistentStoreCoordinator *_coordinator;
  dispatch_queue_t _queue;
}

+ (MCDatabaseManager *)defaultManager {
  static MCDatabaseManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[MCDatabaseManager alloc] initWithName:kStrStoreName];
  });
  return manager;
}

#pragma mark - the core data stack
- (NSManagedObjectModel *)model {
  if (_model != nil) {
    return _model;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDataModelFileName withExtension:@"momd"];
  _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _model;
}

- (NSPersistentStoreCoordinator *)coordinator {
  if (!_coordinator) {
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
  }
  return _coordinator;
}

- (NSManagedObjectContext *)context {
  NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
  NSManagedObjectContext *context = [dictionary objectForKey:kContextKey];
  if (!context) {
    context = [[NSManagedObjectContext alloc] init];
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [context setPersistentStoreCoordinator:self.coordinator];
    [dictionary setObject:context forKey:kContextKey];
  }
  return context;
}

- (NSManagedObject *)createEntityWithName:(NSString *)name {
  NSEntityDescription * entity = [NSEntityDescription entityForName:name
                                             inManagedObjectContext:self.context];
  return [[NSManagedObject alloc] initWithEntity:entity
                  insertIntoManagedObjectContext:self.context];
}

#pragma mark - fetch/delete entries for a given entity name (a)synchronously.
- (void)fetchEntriesForEntityName:(NSString *)name
                            async:(BOOL)shouldExecuteAsync
                           onPredicate:(NSPredicate *)predicate
                                onSort:(NSArray *)sortDescriptors
                       completionBlock:(void(^)(NSArray *, NSError *))block {
  if (shouldExecuteAsync) {
    dispatch_async(_queue, ^{
      NSError *error = nil;
      NSArray *array = [self fetchEntriesForEntityName:name
                                           onPredicate:predicate
                                                onSort:sortDescriptors
                                                 error:&error];
      dispatch_async(dispatch_get_main_queue(), ^{
        block(array, error);
      });
    });
  } else {
    NSError *error = nil;
    NSArray *array = [self fetchEntriesForEntityName:name
                                         onPredicate:predicate
                                              onSort:sortDescriptors
                                               error:&error];
    block(array, error);
  }
}

- (void)fetchEntriesForEntityName:(NSString *)name
                            async:(BOOL)shouldExecuteAsync
                      onPredicate:(NSPredicate *)predicate
                           onSort:(NSArray *)sortDescriptors
                            limit:(NSUInteger)limit
                  completionBlock:(void(^)(NSArray *, NSError *))block {
  if (shouldExecuteAsync) {
    dispatch_async(_queue, ^{
      NSError *error = nil;
      NSArray *array = [self fetchEntriesForEntityName:name
                                           onPredicate:predicate
                                                onSort:sortDescriptors
                                                 limit:limit
                                                 error:&error];
      dispatch_async(dispatch_get_main_queue(), ^{
        block(array, error);
      });
    });
  } else {
    NSError *error = nil;
    NSArray *array = [self fetchEntriesForEntityName:name
                                         onPredicate:predicate
                                              onSort:sortDescriptors
                                               limit:limit
                                               error:&error];
    block(array, error);
  }
}


- (void)deleteEntriesForEntityName:(NSString *)name
                             async:(BOOL)shouldExecuteAsync
                            onPredicate:(NSPredicate *)predicate
                        completionBlock:(void(^)(NSError *error))block {
  if (shouldExecuteAsync) {
    dispatch_async(_queue, ^{
      NSError *error;
      [self deleteEntriesForEntityName:name onPredicate:predicate error:&error];
      dispatch_async(dispatch_get_main_queue(), ^{
        block(error);
      });
    });
  } else {
    NSError *error;
    [self deleteEntriesForEntityName:name onPredicate:predicate error:&error];
    block(error);
  }
}

#pragma mark - private

- (void)preloadDatabaseWithName:(NSString *)name {
  NSURL *storeURL = [[self applicationDocumentsDirectory]
                          URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
  if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
    NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"sqlite"]];
    NSError* err;
    if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
      NSLog(@"could not copy preloaded data!");
    }
  }
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (instancetype)initWithName:(NSString *)name {
  if (self = [super init]) {
    [self preloadDatabaseWithName:name];
    NSArray *potentialPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    _storePath = [[[potentialPaths objectAtIndex:0]
                   stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]] copy];
    // init store
    NSURL *url = [NSURL fileURLWithPath:_storePath];
    NSError *error = nil;
    [self deleteStoreIfIncompatible:NSSQLiteStoreType];
    _store = [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:url
                                              options:nil
                                                error:&error];
    _queue = dispatch_queue_create("motcha.datastore", NULL);
  }
  return self;
}

- (void)deleteStoreIfIncompatible:(NSString *)storeType {
  if (![[NSFileManager defaultManager] fileExistsAtPath:_storePath]) {
    return;
  }
  NSURL *url = [NSURL fileURLWithPath:_storePath];
  NSError *error = nil;
  NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator
                                  metadataForPersistentStoreOfType:storeType
                                  URL:url
                                  error:&error];
  BOOL compatible = [self.model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
  if (!compatible) {
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
  }
}

- (NSArray *)fetchEntriesForEntityName:(NSString *)name
                           onPredicate:(NSPredicate *)predicate
                                onSort:(NSArray *)sortDescriptors
                                 limit:(NSUInteger)limit
                                 error:(NSError **)error {
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:limit];
  if (sortDescriptors != nil) {
    [fetchRequest setSortDescriptors:sortDescriptors];
  }
  return [self.context executeFetchRequest:fetchRequest error:error];
}

- (NSArray *)fetchEntriesForEntityName:(NSString *)name
                           onPredicate:(NSPredicate *)predicate
                                onSort:(NSArray *)sortDescriptors
                                 error:(NSError **)error {
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
  [fetchRequest setPredicate:predicate];
  if (sortDescriptors != nil) {
    [fetchRequest setSortDescriptors:sortDescriptors];
  }
  return [self.context executeFetchRequest:fetchRequest error:error];
}

- (void)deleteEntriesForEntityName:(NSString *)name
                       onPredicate:(NSPredicate *)predicate
                             error:(NSError **)error {
  if ([[_model entitiesByName] objectForKey:name]) {
    NSArray *array = [self fetchEntriesForEntityName:name
                                         onPredicate:predicate
                                              onSort:nil
                                               error:error];
    for (NSManagedObject *object in array) {
      [self.context deleteObject:object];
    }
  }
  [self.context save:nil];
}
@end
