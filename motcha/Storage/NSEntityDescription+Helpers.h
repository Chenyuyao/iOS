#import <CoreData/CoreData.h>

@interface NSAttributeDescription (Helpers)

+ (NSAttributeDescription *)attributeWithName:(NSString *)name
                                         type:(NSAttributeType)type
                                      indexed:(BOOL)indexed;

@end

@interface NSEntityDescription (Helpers)

+ (NSEntityDescription *)descriptionWithClass:(Class)class
                                         name:(NSString *)name
                                   attributes:(NSArray *)attributes;

@end
