#import <Foundation/Foundation.h>
#import "MCCategory.h"

static NSString * const recommendedCategory = @"RECOMMENDED";

@interface MCCategorySourceService : NSObject

+ (MCCategorySourceService *)sharedInstance;

- (void) hardCodeSource;
- (void) presetCategories:(NSArray *)categories;

//get / set user selected categories
- (NSArray *) selectedCategories;
- (void) selectCategories:(NSArray *)categories;

//Given a category name, return an array of MCSource Object belongs to this category
- (NSArray *) getSourceByCategory:(NSString *) categoryName;

//Given a category name, return a MCCategory Object belongs to this category
- (MCCategory *) getCategory:(NSString *) categoryName;

//Get an array of MCCategory for all categories
- (NSArray *) getAllCategories;

@end