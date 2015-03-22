#import "DictionaryEntity.h"

#import "NSEntityDescription+Helpers.h"

static NSString *kStrDictionaryWord = @"wordKey";
static NSString *kStrDictionaryPos = @"posKey";

@implementation DictionaryEntity

+ (NSEntityDescription *)descriptionWithName:(NSString *)name {
  NSArray *attributes =  @[
                           [NSAttributeDescription attributeWithName:kStrDictionaryWord
                                                                type:NSStringAttributeType
                                                             indexed:YES],
                           [NSAttributeDescription attributeWithName:kStrDictionaryPos
                                                                type:NSStringAttributeType
                                                             indexed:YES]
                           ];
  return [NSEntityDescription descriptionWithClass:[self class]
                                              name:name
                                        attributes:attributes];
}

- (void)setWord:(NSString *)word {
  [self setValue:word forKey:kStrDictionaryWord];
}

- (void)setPos:(NSString *)pos {
  [self setValue:pos forKey:kStrDictionaryPos];
}

- (NSString *)word {
  return [self valueForKey:kStrDictionaryWord];
}

- (NSString *)pos {
  return [self valueForKey:kStrDictionaryPos];
}

@end
