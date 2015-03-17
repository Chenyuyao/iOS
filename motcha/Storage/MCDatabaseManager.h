#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// A local storage manager that creates/deletes/fetches entities from a local database.
@interface MCDatabaseManager : NSObject

@property(nonatomic, readonly) NSManagedObjectContext *context;

- (instancetype)initWithName:(NSString *)name entities:(NSArray *)entities;

- (NSManagedObject *)createEntityWithName:(NSString *)name;

- (NSArray *)fetchForEntitiesWithName:(NSString *)name
                          onPredicate:(NSPredicate *)predicate;

- (void)deleteEntitiesWithName:(NSString *)name
                   onPredicate:(NSPredicate *)predicate;

@end
