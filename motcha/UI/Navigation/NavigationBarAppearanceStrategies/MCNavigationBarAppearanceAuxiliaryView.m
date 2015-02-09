#import "MCNavigationBarAppearanceAuxiliaryView.h"

@implementation MCNavigationBarAppearanceAuxiliaryView {
  __weak UIView *_prevAuxiliaryView;
}

- (void)applyAppearanceToNavigationBar:(UINavigationBar*)navigationBar
                              animated:(BOOL)animated
                       completionBlock:(void (^)(NSDictionary *dict))block {

  NSDictionary *data = [_dataSource appearanceStrategyDataForStrategyClass:[self class]];
  CGFloat navigationBarOffset = [(NSNumber*)[data objectForKey:kNavigationBarOffsetKey] doubleValue];
  UIView *navigationBarBackgroundView = (UIView*)[data objectForKey:kNavigationBarBackgroundViewKey];
  CGFloat navBarBackgroundHeight = [(NSNumber*)[data objectForKey:kNavigationBarBackgroundHeightKey] doubleValue];
  UIView *auxiliaryView = [data objectForKey:kAuxiliaryViewKey];
  
  if ([_delegate conformsToProtocol:@protocol(MCNavigationBarAppearanceStrategyDelegate)] &&
      [_delegate respondsToSelector:@selector(appearance:willAppearForStrategyClass:state:)]) {
    NSDictionary *stateDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:navBarBackgroundHeight]
                                                          forKey:kNavigationBarBackgroundHeightKey];
    [_delegate appearance:auxiliaryView willAppearForStrategyClass:[self class] state:stateDict];
  }
  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
  if (_prevAuxiliaryView) {
    // fade out the previous aux view
    CGRect prevAuxFrame = _prevAuxiliaryView.frame;
    CGFloat prevAuxAlpha = _prevAuxiliaryView.alpha;
    [UIView animateWithDuration:animated?kNavigationBarAppearanceAnimationDuration:0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
      _prevAuxiliaryView.frame = CGRectMake(prevAuxFrame.origin.x, navigationBar.frame.size.height + navigationBarOffset +
        auxiliaryView.frame.size.height - _prevAuxiliaryView.frame.size.height, prevAuxFrame.size.width, prevAuxFrame.size.height);
      _prevAuxiliaryView.alpha = kNavigationBarAuxiliaryViewStartingAlpha;
    } completion:^(BOOL finished) {
      if (finished) {
        [_prevAuxiliaryView removeFromSuperview];
        _prevAuxiliaryView.alpha = prevAuxAlpha;
        dispatch_semaphore_signal(sema);
      }
    }];
  } else {
    dispatch_semaphore_signal(sema);
  }
  // fade in the current aux view
  CGFloat curAuxViewFinalAlpha = auxiliaryView.alpha;
  auxiliaryView.alpha = kNavigationBarAuxiliaryViewStartingAlpha;
  CGFloat navBarFinalHeight = navigationBar.frame.size.height + navigationBarOffset + auxiliaryView.frame.size.height;
  CGRect navBarBackgroundFrame = navigationBarBackgroundView.frame;
  auxiliaryView.frame = CGRectMake(navigationBar.frame.origin.x, navBarBackgroundHeight - auxiliaryView.frame.size.height,
      navigationBar.frame.size.width, auxiliaryView.frame.size.height);
  CGRect curAuxFrame = auxiliaryView.frame;
  [navigationBarBackgroundView addSubview:auxiliaryView];
  [UIView animateWithDuration:animated?kNavigationBarAppearanceAnimationDuration:0
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
    auxiliaryView.frame = CGRectMake(curAuxFrame.origin.x, navigationBar.frame.size.height + navigationBarOffset,
        curAuxFrame.size.width, curAuxFrame.size.height);
    auxiliaryView.alpha = curAuxViewFinalAlpha;
    navigationBarBackgroundView.frame = CGRectMake(navBarBackgroundFrame.origin.x, navBarBackgroundFrame.origin.y,
        navBarBackgroundFrame.size.width, navBarFinalHeight);
  } completion:^(BOOL finished) {
    if (finished) {
      dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
      _prevAuxiliaryView = auxiliaryView;
      NSDictionary *stateDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:navBarFinalHeight]
                                                                 forKey:kNavigationBarBackgroundHeightKey];
      if (block) {
        block(stateDict);
      } else if ([_delegate conformsToProtocol:@protocol(MCNavigationBarAppearanceStrategyDelegate)] &&
                 [_delegate respondsToSelector:@selector(appearance:didAppearForStrategyClass:state:)]) {
        [_delegate appearance:auxiliaryView didAppearForStrategyClass:[self class] state:stateDict];
      }
    }
  }];
}
@end
