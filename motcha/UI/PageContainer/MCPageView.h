#import <UIKit/UIKit.h>
#import "MCNewsItemConstraintsProtocol.h"

typedef UIView<MCNewsItemHorizontalConstraintsProtocol> ViewWithHConstraints;

@protocol MCPageViewDelegate <UIScrollViewDelegate>
@optional
- (void)scrollViewDidEndScrollingWithoutAnimation:(UIScrollView *)scrollView;
@end

@interface MCPageView : UIScrollView
- (void)insertPageViewItem:(ViewWithHConstraints *)viewItem atIndex:(NSUInteger)index;
- (ViewWithHConstraints *)removePageViewItem:(ViewWithHConstraints *)viewItem atIndex:(NSUInteger)index;
- (void)movePageViewItem:(ViewWithHConstraints *)viewItem fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
