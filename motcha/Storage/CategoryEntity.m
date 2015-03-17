#import "CategoryEntity.h"

#import "NSEntityDescription+Helpers.h"

static NSString *kStrCategoryEntityAttribute = @"categoryKey";

@implementation CategoryEntity

+ (NSEntityDescription *)descriptionWithName:(NSString *)name {
  NSArray *attributes =  @[
      [NSAttributeDescription attributeWithName:kStrCategoryEntityAttribute
                                           type:NSStringAttributeType
                                        indexed:YES]
  ];
  return [NSEntityDescription descriptionWithClass:[self class]
                                              name:name
                                        attributes:attributes];
}

- (void)setCategory:(NSString *)category {
  [super setValue:category forKey:kStrCategoryEntityAttribute];
}

- (NSString *)category {
  return [super valueForKey:kStrCategoryEntityAttribute];
}

@end
