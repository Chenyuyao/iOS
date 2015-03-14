#import "MCKeyValuePair.h"

@implementation MCKeyValuePair
- (instancetype)initWithKey:(id)aKey andValue:(id)aValue {
  if ((self = [super init])) {
    _key   = aKey;
    _value = aValue;
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  MCKeyValuePair *copy = [[MCKeyValuePair allocWithZone:zone] init];
  copy.key = self.key;
  copy.value = self.value;
  return copy;
}

- (BOOL)isEqual:(id)anObject {
  BOOL ret;
  if (self == anObject) {
    ret = YES;
  } else if (![anObject isKindOfClass:[MCKeyValuePair class]]) {
    ret = NO;
  } else {
    ret = [_key isEqual:((MCKeyValuePair *)anObject).key] && [_value isEqual:((MCKeyValuePair *)anObject).value];
  }
  return ret;
}
@end
