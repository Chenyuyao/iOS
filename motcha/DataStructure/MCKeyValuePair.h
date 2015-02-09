#import <Foundation/Foundation.h>

/**
 Objective-C does not natively provide a key-value-pair-like structure, so we implement one on our own,
 in case for future use.
 */
@interface MCKeyValuePair : NSObject<NSCopying>
@property (nonatomic, strong) id key;
@property (nonatomic, strong) id value;
- (id)initWithKey:(id)aKey andValue:(id)aValue;
@end
