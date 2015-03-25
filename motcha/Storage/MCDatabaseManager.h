#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// A local storage manager that creates/deletes/fetches entities from a local database.
@interface MCDatabaseManager : NSObject

@property(nonatomic, readonly) NSManagedObjectContext *context;
@property(nonatomic, readonly) NSManagedObjectModel *model;

+ (MCDatabaseManager *)defaultManager;

- (NSManagedObject *)createEntityWithName:(NSString *)name;

- (void)fetchEntriesForEntityName:(NSString *)name
                            async:(BOOL)shouldExecuteAsync
                      onPredicate:(NSPredicate *)predicate
                           onSort:(NSArray *)sortDescriptors
                  completionBlock:(void(^)(NSArray *, NSError *))block;


- (void)deleteEntriesForEntityName:(NSString *)name
                             async:(BOOL)shouldExecuteAsync
                       onPredicate:(NSPredicate *)predicate
                   completionBlock:(void(^)(NSError *error))block;

@end
