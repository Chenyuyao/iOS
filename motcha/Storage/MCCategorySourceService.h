#import <Foundation/Foundation.h>
#import "MCCategory.h"

static NSString * const recommendedCategory = @"RECOMMENDED";

@interface MCCategorySourceService : NSObject

+ (MCCategorySourceService *)sharedInstance;

- (void)importCategories;

//get / set user selected categories
- (void)fetchSelectedCategoriesWithBlock:(void(^)(NSArray *, NSError *))block;
- (void)storeSelectedCategories:(NSArray *)categories withBlock:(void(^)(NSError *))block;

//Given a category name, return an array of MCSource Object belongs to this category
- (void)fetchSourceByCategory:(NSString *)categoryName withBlock:(void(^)(NSArray *, NSError *))block;

//Given a category name, return a MCCategory Object belongs to this category
- (void)fetchCategory:(NSString *)categoryName withBlock:(void(^)(MCCategory *, NSError *))block;

//Get an array of MCCategory for all categories
- (void) fetchAllCategoriesWithBlock:(void(^)(NSArray *, NSError *))block;

@end
