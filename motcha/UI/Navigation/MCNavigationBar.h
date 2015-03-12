#import <UIKit/UIKit.h>

static CGFloat kNavigationBarOffsetPortrait         = 20.0f;
static CGFloat kNavigationBarOffsetLandscape        = 0;
static CGFloat kNavigationBarDefaultHeightPortrait  = 44.0f;
static CGFloat kNavigationBarDefaultHeightLandscape = 32.0f;

@interface MCNavigationBar : UINavigationBar
@property (nonatomic)                   CGFloat backgroundHeight;
@property (readonly, nonatomic, weak)   UIView* navigationBarBackgroundView;
@property (readonly, nonatomic)         CGFloat backgroundAlpha;
@property (readonly, nonatomic, weak)   UIView* auxiliaryView;
@property (nonatomic)                   CGFloat navigationBarOffset;

// Since the shadow applied to the layer of a UIView will be seen through the UIView if the its alpha value is not 1.0,
// which is ugly, so we apply the shadow only if its alpha is exactly 1.0. Otherwise we just remove (hide) the shadow.

// Remark: -applyDropShadow will be called when a view has finished appearing, that is, when viewDidAppear:animated: is
// called in the view's viewController, and -removeDropShadow will be called when a view is about to disappear,
// that is, when viewWillDisappear:animated is called in the view's viewController. This is done because there is a
// chance that while the viewControllers are being transitioned by the navigationController, the navigation bar
// background alpha changes from, say, 0.0 to 1.0. So in such cases, we also want to hide the shadow to prevent the
// ugly appearance during transitioning.
- (void)applyDropShadow;
- (void)removeDropShadow;

#pragma mark - AuxiliaryView
- (void)setAuxiliaryView:(UIView*)auxiliaryView animated:(BOOL)animated;

#pragma mark - BackgroundAlpha
- (void)setBackgroundAlpha:(CGFloat)alpha animated:(BOOL)animated;
@end
