#import <Foundation/Foundation.h>

@interface MCDictionaryService : NSObject

+ (MCDictionaryService *)sharedInstance;
- (void)import;

@end
