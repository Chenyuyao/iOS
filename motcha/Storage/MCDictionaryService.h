#import <Foundation/Foundation.h>

#import "MCDictionaryWord.h"
// This service can be called to import/fetch the dictionary data to/from coredata
@interface MCDictionaryService : NSObject

+ (MCDictionaryService *)sharedInstance;
- (void)import;
- (void)storeDictionary:(NSArray *)dictionaryWords;
- (void)getDictionaryWordWithKey:(NSString *)key
                 completionBlock:(void(^)(MCDictionaryWord *, NSError *))block;

@end
