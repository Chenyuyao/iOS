#import <Foundation/Foundation.h>

@interface MCKeyValuePair : NSObject<NSCopying>
@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;
- (id)initWithKey:(id)aKey andValue:(id)aValue;
@end
