#import <UIKit/UIKit.h>

#import "MCPageViewController.h"

@interface MCNewsListsContainerController : UIViewController
- (instancetype)initWithCategories:(NSArray *)categories;
@property (strong, nonatomic) MCPageViewController *pageViewController;
@property (strong, nonatomic, readonly) NSMutableArray *categories; // array of NSString *
- (void)addCategory:(NSString *)category;
- (void)removeCategory:(NSString *)category;
@end
