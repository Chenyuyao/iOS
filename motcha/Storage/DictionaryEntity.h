#import <CoreData/CoreData.h>

@interface DictionaryEntity : NSManagedObject

@property(nonatomic) NSString *word;
@property(nonatomic) NSString *pos;

+ (NSEntityDescription *)descriptionWithName:(NSString *)name;

@end
