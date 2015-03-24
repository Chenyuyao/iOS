#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MCCoreDataSource;

@interface MCCoreDataCategory : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * lastFetch;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSSet *source;
@end

@interface MCCoreDataCategory (CoreDataGeneratedAccessors)

- (void)addSourceObject:(MCCoreDataSource *)value;
- (void)removeSourceObject:(MCCoreDataSource *)value;
- (void)addSource:(NSSet *)values;
- (void)removeSource:(NSSet *)values;

@end
