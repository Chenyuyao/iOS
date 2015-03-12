#import "MCNavigationController.h"

@implementation MCNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
  if (self = [super initWithNavigationBarClass:[MCNavigationBar class] toolbarClass:nil]) {
    [self setViewControllers:@[rootViewController]];
    return self;
  }
  return [super initWithRootViewController:rootViewController];
}

- (void)notifyViewWillAppearAnimated:(BOOL)animated {
  id<MCNavigationBarCustomizationDelegate>topViewController =
  (id<MCNavigationBarCustomizationDelegate>)self.topViewController;
  if ([topViewController conformsToProtocol:@protocol(MCNavigationBarCustomizationDelegate)]) {
    _customizationDelegate = topViewController;
  } else {
    _customizationDelegate = nil;
  }
  UIView* auxiliaryView;
  if ([_customizationDelegate conformsToProtocol:@protocol(MCNavigationBarCustomizationDelegate)] &&
      [_customizationDelegate respondsToSelector:@selector(navigationBarAuxiliaryView)]) {
    auxiliaryView = [_customizationDelegate navigationBarAuxiliaryView];
  } else {
    auxiliaryView = [UIView new];
  }
  [self setNavigationBarAuxiliaryView:auxiliaryView animated:animated];
  
  CGFloat backgroundAlpha;
  if ([_customizationDelegate conformsToProtocol:@protocol(MCNavigationBarCustomizationDelegate)] &&
      [_customizationDelegate respondsToSelector:@selector(navigationBarBackgroundAlpha)])  {
    backgroundAlpha = [_customizationDelegate navigationBarBackgroundAlpha];
  } else {
    backgroundAlpha = 1.0f;
  }
  [self setNavigationBarBackgroundAlpha:backgroundAlpha animated:animated];
}

- (void)notifyViewWillDisappearAnimated:(BOOL)animated {
  MCNavigationBar *navigationBar = (MCNavigationBar*)self.navigationBar;
  [navigationBar removeDropShadow];
}

- (void)notifyViewDidAppearAnimated:(BOOL)animated {
  MCNavigationBar *navigationBar = (MCNavigationBar*)self.navigationBar;
  [navigationBar applyDropShadow];
}

#pragma mark - NavigationBarAuxiliaryView operations
- (void)setNavigationBarAuxiliaryView:(UIView*)auxiliaryView animated:(BOOL)animated {
  MCNavigationBar *navigationBar = (MCNavigationBar*)self.navigationBar;
  [navigationBar setAuxiliaryView:auxiliaryView animated:animated];
}

#pragma mark - NavigationBarBackgroundAlpha operations
- (void)setNavigationBarBackgroundAlpha:(CGFloat)alpha animated:(BOOL)animated {
  MCNavigationBar *navigationBar = (MCNavigationBar*)self.navigationBar;
  [navigationBar setBackgroundAlpha:alpha animated:animated];
}

#pragma mark - UIContentContainer methods
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  MCNavigationBar* navigationBar = (MCNavigationBar*)self.navigationBar;
  CGRect auxFrame = navigationBar.auxiliaryView.frame;
  BOOL toLandScape = (size.width / size.height > 1.0f);
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    UIView *containerView = [context containerView];
    if (toLandScape) {
      // -kNavigationBarOffsetLandscape is because when in portrait mode, the top of the background view is above that
      // of the navigation bar by kNavigationBarOffsetLandscape (0) pts.
      navigationBar.navigationBarBackgroundView.frame =
      CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y - kNavigationBarOffsetLandscape,
                 size.width, navigationBar.frame.size.height + kNavigationBarOffsetLandscape + auxFrame.size.height);
      navigationBar.auxiliaryView.frame =
      CGRectMake(auxFrame.origin.x, navigationBar.frame.size.height + kNavigationBarOffsetLandscape, size.width,
                 auxFrame.size.height);
    } else {
      // -kNavigationBarOffsetPortrait is because when in portrait mode, the top of the background view is above that of
      // the navigation bar by kNavigationBarOffsetPortrait (20) pts.
      navigationBar.navigationBarBackgroundView.frame =
      CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y - kNavigationBarOffsetPortrait,
                 size.width, navigationBar.frame.size.height + kNavigationBarOffsetPortrait + auxFrame.size.height);
      navigationBar.auxiliaryView.frame =
      CGRectMake(auxFrame.origin.x, navigationBar.frame.size.height + kNavigationBarOffsetPortrait, size.width,
                 auxFrame.size.height);
    }
  } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    if (toLandScape) {
      navigationBar.navigationBarOffset = kNavigationBarOffsetLandscape;
      navigationBar.backgroundHeight = navigationBar.auxiliaryView.frame.size.height + kNavigationBarOffsetLandscape +
      kNavigationBarDefaultHeightLandscape;
    } else {
      navigationBar.navigationBarOffset = kNavigationBarOffsetPortrait;
      navigationBar.backgroundHeight = navigationBar.auxiliaryView.frame.size.height + kNavigationBarOffsetPortrait +
      kNavigationBarDefaultHeightPortrait;
    }
  }];
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
