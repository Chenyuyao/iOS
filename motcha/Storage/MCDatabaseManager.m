#import "MCDatabaseManager.h"

static NSString *const kContextKey = @"context";
static NSString *const kDataModelFileName = @"Motcha";

// TODO(shinfan): Finish this.
@implementation MCDatabaseManager {
  NSManagedObjectModel *_model;
  NSString *_storePath;
  NSPersistentStore *_store;
  NSPersistentStoreCoordinator *_coordinator;
  dispatch_queue_t _queue;
}

- (instancetype)initWithName:(NSString *)name{
  self = [super init];
  if (self) {
    [self preloadDatabaseWithName:name];
    NSArray *potentialPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    _storePath = [[[potentialPaths objectAtIndex:0]
                   stringByAppendingPathComponent:name] copy];
    _model = self.model;
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    // init store
    NSURL *url = [NSURL fileURLWithPath:_storePath];
    NSError *error = nil;
    [self deleteStoreIfIncompatible:NSSQLiteStoreType];
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:url
                                              options:nil
                                                error:&error];
    _queue = dispatch_queue_create("motcha.datastore", NULL);
  }
  return self;
}

- (NSManagedObject *)createEntityWithName:(NSString *)name {
  NSEntityDescription * entity = [NSEntityDescription entityForName:name
                                             inManagedObjectContext:self.context];
  return [[NSManagedObject alloc] initWithEntity:entity
                  insertIntoManagedObjectContext:self.context];
}

- (void)fetchForEntitiesWithName:(NSString *)name
                          onPredicate:(NSPredicate *)predicate
                               onSort:(NSArray *)sortDescriptors
                      completionBlock:(void(^)(NSArray *, NSError *))block {
  dispatch_async(_queue, ^{
      NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
      [fetchRequest setPredicate:predicate];
      if (sortDescriptors != nil) {
        [fetchRequest setSortDescriptors:sortDescriptors];
      }
      NSError *error = nil;
      NSArray *array = [self fetchForEntitiesWithName:name
                                          onPredicate:predicate
                                               onSort:sortDescriptors
                                                error:&error];
      dispatch_async(dispatch_get_main_queue(), ^{
          block(array, error);
      });
  });
}

- (void)deleteEntitiesWithName:(NSString *)name
                   onPredicate:(NSPredicate *)predicate
               completionBlock:(void(^)(NSError *error))block {
  dispatch_async(_queue, ^{
      NSError *error;
      if ([[_model entitiesByName] objectForKey:name]) {
        NSArray *array = [self fetchForEntitiesWithName:name
                                            onPredicate:predicate
                                                 onSort:nil
                                                  error:&error];
        for (NSManagedObject *object in array) {
          [self.context deleteObject:object];
        }
      }
      [self.context save:nil];
      dispatch_async(dispatch_get_main_queue(), ^{
          block(error);
      });
  });
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
  BOOL compatible = [_model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
  if (!compatible) {
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
  }
}

- (NSManagedObjectModel *)model {
  if (_model != nil) {
    return _model;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDataModelFileName withExtension:@"momd"];
  _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _model;
}

- (NSManagedObjectContext *)context {
  NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
  NSManagedObjectContext *context = [dictionary objectForKey:kContextKey];
  if (!context) {
    context = [[NSManagedObjectContext alloc] init];
    [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [context setPersistentStoreCoordinator:_coordinator];
    [dictionary setObject:context forKey:kContextKey];
  }
  return context;
}

#pragma mark - private

- (void)preloadDatabaseWithName:(NSString *)name {
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
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

- (NSArray *)fetchForEntitiesWithName:(NSString *)name
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


@end
