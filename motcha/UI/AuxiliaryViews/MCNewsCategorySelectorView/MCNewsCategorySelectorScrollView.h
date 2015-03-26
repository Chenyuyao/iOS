#import <UIKit/UIKit.h>

#import "MCCategoryButton.h"

@protocol MCNewsCategorySelectorScrollViewDelegate <NSObject>
@optional
- (void)categoryButtonPressed:(MCCategoryButton *)button atIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)didInsertCategoryButton:(MCCategoryButton *)button atIndex:(NSUInteger)index;
- (void)didRemoveCategoryButton:(MCCategoryButton *)button atIndex:(NSUInteger)index;
- (void)didMoveCategoryButton:(MCCategoryButton *)button fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)didReloadCategoryButtons;
@end

@protocol MCNewsCategorySelectorScrollViewDataSource <NSObject>
- (UIScrollView *)backingScrollView;
@end

@interface MCNewsCategorySelectorScrollView : UIScrollView
@property (weak, nonatomic) id<MCNewsCategorySelectorScrollViewDelegate> mcDelegate;
@property (weak, nonatomic) id<MCNewsCategorySelectorScrollViewDataSource> mcDataSource;
// Programmatically tap the selected button. If there is no selected button, tap the button at index 0.
- (void)tapSelectedButtonAnimated:(BOOL)animated;
// Programmatically select a category button. This method needs to be called inside of viewDidAppear:animated:
// to ensure functionality.
- (void)selectButtonAtIndex:(NSUInteger)index animated:(BOOL)animated;
// Add an array of categories to the end. This method can be called multiple times with different categories
// being passed in.
- (void)addCategories:(NSArray *)categories; // Array of NSString *
// Add a category to the end
- (void)addCategory:(NSString *)category;
// Add a category at an index
- (void)insertCategory:(NSString *)category atIndex:(NSUInteger)index;
// Remove a specific category specified by category name.
- (MCCategoryButton *)removeCategory:(NSString *)category;
// Remove a category at a specific index
- (MCCategoryButton *)removeCategoryAtIndex:(NSUInteger)index;
// Remove all categories
- (void)removeAllCategories;
// Move a category button from fromIndex to toIndex
- (void)moveCategoryFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
// Exchange two category buttons at index1 and index2
- (void)exchangeCategoryButtonAtIndex:(NSUInteger)index1 withCategoryButtonAtIndex:(NSUInteger)index2;
// Return the number of categories
- (NSUInteger)categoryCount;
// Adjust the position of the selected category button so that it is visible to the user.
- (void)adjustCategoryButtonPositionAnimated:(BOOL)animated;
// Reload the category buttons.
- (void)reloadCategoryButtons;
@end
