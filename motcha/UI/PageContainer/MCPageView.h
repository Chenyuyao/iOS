#import <UIKit/UIKit.h>

@protocol MCPageViewDelegate <UIScrollViewDelegate>
@optional
/**
 * The delegate method that will be sent to the receiver when the scrollView is programmatically scrolled to a position
 * without animation.
 */
- (void)scrollViewDidEndScrollingWithoutAnimation:(UIScrollView *)scrollView;
@end

/**
 * The primary view for the page view controller that contains child view controllers.
 */
@interface MCPageView : UIScrollView
- (void)addPageViewItem:(UIView *)viewItem;
- (void)removePageViewItem:(UIView *)viewItem;
- (void)reloadViews;
@end
