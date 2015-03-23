#import <Foundation/Foundation.h>

@interface MCDictionaryWord : NSObject

@property(nonatomic) NSString *word;
@property(nonatomic) NSString *pos;

- (instancetype)initWithWord:(NSString *)word andPos:(NSString *)pos;

@end