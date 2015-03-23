#import <Foundation/Foundation.h>

// This service can be called to import the dictionary to coredata
@interface MCDictionaryService : NSObject

+ (MCDictionaryService *)sharedInstance;
- (void)import;

@end
