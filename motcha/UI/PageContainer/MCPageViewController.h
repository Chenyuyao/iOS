#import <UIKit/UIKit.h>

#import "MCPageView.h"

@class MCPageViewController;
@protocol MCPageViewControllerDelegate <NSObject>
@optional
// Remark: this method is called when a new page (viewController) is shown completely.
- (void)pageViewController:(MCPageViewController *)pageViewController
     pageDidFinishAnimated:(BOOL)animated
           withCurrentPage:(UIViewController *)viewController
                   atIndex:(NSUInteger)index;

// Remark: this method is called before addChildViewController:, i.e., before -loadView
// is called for the viewController.
- (void)pageViewController:(MCPageViewController *)pageViewController
    willLoadViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index;

// Remark: this method is called after addChildViewController: and before addSubview:, i.e., after
// the viewController's view has been loaded.
- (void)pageViewController:(MCPageViewController *)pageViewController
     didLoadViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index;
@end

/**
 * The container view controller that contains child view controllers, similar to UIPageViewController.
 */
@interface MCPageViewController : UIViewController
@property (weak, nonatomic) id<MCPageViewControllerDelegate> delegate;
@property (strong, nonatomic) MCPageView *pageView;
- (void)registerClass:(Class)pageViewItemClass;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
- (void)insertViewControllerAtIndex:(NSUInteger)index;
- (UIViewController *)removeViewControllerAtIndex:(NSUInteger)index;
- (void)moveViewControllerFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (NSUInteger)viewControllerCount;
- (void)reloadViewControllers;
@end
