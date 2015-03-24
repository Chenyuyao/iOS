#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCCoreDataSource : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * fullTextable;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * needParse;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSManagedObject *category;

@end
