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

#pragma mark - AuxiliaryView
- (void)setAuxiliaryView:(UIView*)auxiliaryView animated:(BOOL)animated;

#pragma mark - BackgroundAlpha
- (void)setBackgroundAlpha:(CGFloat)alpha animated:(BOOL)animated;
@end
