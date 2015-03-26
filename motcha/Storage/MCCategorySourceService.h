#import <Foundation/Foundation.h>
#import "MCCategory.h"
#import "MCSource.h"

static NSString * const recommendedCategory = @"RECOMMENDED";

@interface MCCategorySourceService : NSObject

+ (MCCategorySourceService *)sharedInstance;

- (void)importCategories;

//get/set user selected categories. Returns an array of NSString * in block.
- (void)fetchSelectedCategoriesAsync:(BOOL)shouldFetchAsync
                           withBlock:(void(^)(NSArray *, NSError *))block;

// Takes an array of NSString * categories.
- (void)storeSelectedCategories:(NSArray *)categories
                          async:(BOOL)shouldFetchAsync
                      withBlock:(void(^)(NSError *))block;

//Given a category name, return an array of MCSource Object corresponding to this category
- (void)fetchSourceByCategory:(NSString *)categoryName
                        async:(BOOL)shouldFetchAsync
                    withBlock:(void(^)(NSArray *, NSError *))block;

//Given a category name, return an MCCategory Object corresponding to this category
- (void)fetchCategory:(NSString *)categoryName
                async:(BOOL)shouldFetchAsync
            withBlock:(void(^)(MCCategory *, NSError *))block;

//Given a source name, return an MCSource Object corresponding to this category
- (void)fetchSource:(NSString *)sourceName
       categoryName:(NSString *)categoryName
              async:(BOOL)shouldFetchAsync
          withBlock:(void(^)(MCSource *, NSError *))block;

//Get an array of MCCategory for all categories
- (void)fetchAllCategoriesAsync:(BOOL)shouldFetchAsync
                       withBlock:(void(^)(NSArray *, NSError *))block;

//Increment count of category / source
- (void)incrementCategoryCount:(NSString *) categoryName;
- (void)incrementSourceCount:(NSString *) sourceName;

//Record fetch time of category
- (void)recordCategoryFetchTime:(NSString *) categoryName;
@end
