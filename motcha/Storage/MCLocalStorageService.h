#import <Foundation/Foundation.h>

@class MCDictionaryWord;
// A service that provides local storage of user's reading preferences.
@interface MCLocalStorageService : NSObject

+ (MCLocalStorageService *)sharedInstance;

- (void)storeDictionary:(NSArray *)dictionaryWords;
- (MCDictionaryWord *)getDictionaryWordWithKey:(NSString *)key;

@end
