#import "MCDatabaseManager.h"

static NSString *const kContextKey = @"context";

// TODO(shinfan): Finish this.
@implementation MCDatabaseManager {
  NSManagedObjectModel *_model;
  NSString *_storePath;
  NSPersistentStore *_store;
  NSPersistentStoreCoordinator *_coordinator;
}

- (instancetype)initWithName:(NSString *)name entities:(NSArray *)entities {
  self = [super init];
  if (self) {
    [self preloadDatabaseWithName:name];
    NSArray *potentialPaths =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
    _storePath = [[[potentialPaths objectAtIndex:0]
        stringByAppendingPathComponent:name] copy];
    _model = [[NSManagedObjectModel alloc] init];
    _model.entities = [entities copy];
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
  }
  return self;
}

- (NSManagedObject *)createEntityWithName:(NSString *)name {
  return [NSEntityDescription insertNewObjectForEntityForName:name
                                       inManagedObjectContext:self.context];
}

- (NSArray *)fetchForEntitiesWithName:(NSString *)name
                         onPredicate:(NSPredicate *)predicate {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[[_model entitiesByName] objectForKey:name]];
  [request setPredicate:predicate];
  NSError *error = nil;
  NSArray *array = [self.context executeFetchRequest:request error:&error];
  return array;
}

- (void)deleteEntitiesWithName:(NSString *)name
                   onPredicate:(NSPredicate *)predicate {
  if ([[_model entitiesByName] objectForKey:name]) {
    NSArray *array = [self fetchForEntitiesWithName:name onPredicate:predicate];
    for (NSManagedObject *object in array) {
      [self.context deleteObject:object];
    }
    [self.context save:nil];
  }
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


@end
