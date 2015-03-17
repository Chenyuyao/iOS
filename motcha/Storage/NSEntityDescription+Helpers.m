#import "NSEntityDescription+Helpers.h"

@implementation NSAttributeDescription (Helpers)

+ (NSAttributeDescription *)attributeWithName:(NSString *)name
                                         type:(NSAttributeType)type
                                      indexed:(BOOL)indexed {
  NSAttributeDescription *attribute =
  [[NSAttributeDescription alloc] init];
  [attribute setName:name];
  [attribute setAttributeType:type];
  [attribute setIndexed:indexed];
  return attribute;
}

@end

@implementation NSEntityDescription (Helpers)

+ (NSEntityDescription *)descriptionWithClass:(Class)class
                                         name:(NSString *)name
                                   attributes:(NSArray *)attributes {
  NSEntityDescription *entityDescription = [[NSEntityDescription alloc] init];
  [entityDescription setName:name];
  [entityDescription
   setManagedObjectClassName:NSStringFromClass(class)];
  [entityDescription setProperties:attributes];
  return entityDescription;
}

@end
