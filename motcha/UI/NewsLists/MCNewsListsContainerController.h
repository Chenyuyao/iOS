#import <UIKit/UIKit.h>

#import "MCPageViewController.h"

@interface MCNewsListsContainerController : UIViewController
- (instancetype)initWithCategories:(NSArray *)categories;
@property (strong, nonatomic) MCPageViewController *pageViewController;
@end
