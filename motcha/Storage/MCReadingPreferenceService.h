#import <Foundation/Foundation.h>

@class MCDictionaryWord;
// A service that provides local storage of user's reading preferences.
@interface MCReadingPreferenceService : NSObject

@property(nonatomic) NSArray *categories;

+ (MCReadingPreferenceService *)sharedInstance;

- (void)storeDictionary:(NSArray *)dictionaryWords;
- (MCDictionaryWord *)getDictionaryWordWithKey:(NSString *)key;

@end
