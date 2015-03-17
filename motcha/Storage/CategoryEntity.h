#import <CoreData/CoreData.h>

@interface CategoryEntity : NSManagedObject

@property(nonatomic) NSString *category;

+ (NSEntityDescription *)descriptionWithName:(NSString *)name;

@end
