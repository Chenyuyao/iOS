#import <UIKit/UIKit.h>

#import "MCNavigationBar.h"

#import "MCNavigationBarCustomizationDelegate.h"

@interface MCNavigationController : UINavigationController
@property (weak, nonatomic) id<MCNavigationBarCustomizationDelegate> customizationDelegate;
- (void)notifyViewWillAppearAnimated:(BOOL)animated;
- (void)notifyViewWillDisappearAnimated:(BOOL)animated;
- (void)notifyViewDidAppearAnimated:(BOOL)animated;
#pragma mark - NavigationBarAuxiliaryView
- (void)setNavigationBarAuxiliaryView:(UIView*)auxiliaryView animated:(BOOL)animated;
#pragma mark - NavigationBarBackgroundAlpha
- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha animated:(BOOL)animated;
@end
