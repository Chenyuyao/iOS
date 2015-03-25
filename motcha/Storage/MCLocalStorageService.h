#import <Foundation/Foundation.h>

@class MCDictionaryWord;
// A service that provides local storage of user's reading preferences.
@interface MCLocalStorageService : NSObject

+ (MCLocalStorageService *)sharedInstance;

- (void)fetchCategoriesWithBlock:(void(^)(NSArray *, NSError *))block;
- (void)storeCategories:(NSArray *)categories withBlock:(void(^)(NSError *))block;
- (void)presetCategories:(NSArray *)categories;

- (void)storeDictionary:(NSArray *)dictionaryWords;
- (void)getDictionaryWordWithKey:(NSString *)key
                 completionBlock:(void(^)(MCDictionaryWord *, NSError *))block;

@end
