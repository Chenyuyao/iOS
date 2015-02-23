#import "MCNavigationBarAppearanceBackgroundAlpha.h"

@implementation MCNavigationBarAppearanceBackgroundAlpha {
  CGFloat _prevBackgroundAlpha;
}

- (void)applyAppearanceToNavigationBar:(UINavigationBar *)navigationBar
                              animated:(BOOL)animated
                       completionBlock:(void (^)(NSDictionary *dict))block {
  NSDictionary *data = [_dataSource appearanceStrategyDataForStrategyClass:[self class]];
  NSNumber *alphaNumber = [data objectForKey:kNavigationBarBackgroundAlphaKey];
  UIView *navigationBarBackgroundView = (UIView*)[data objectForKey:kNavigationBarBackgroundViewKey];
  
  // if the to-be-applied background alpha is the same as the previous one, then do nothing.
  if ([alphaNumber doubleValue] == _prevBackgroundAlpha) {
    return;
  }
  NSNumber *prevAlphaNumber = [NSNumber numberWithDouble:_prevBackgroundAlpha];
  if ([_delegate conformsToProtocol:@protocol(MCNavigationBarAppearanceStrategyDelegate)] &&
      [_delegate respondsToSelector:@selector(appearance:willAppearForStrategyClass:state:)]) {
    [_delegate appearance:prevAlphaNumber willAppearForStrategyClass:[self class] state:nil];
  }

  [UIView animateWithDuration:animated ? kNavigationBarAppearanceAnimationDuration:0
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
    navigationBarBackgroundView.alpha = [alphaNumber doubleValue];
  } completion:^(BOOL finished) {
    if (finished) {
      _prevBackgroundAlpha = [alphaNumber doubleValue];
      if (block) {
        block(nil);
      } else if ([_delegate conformsToProtocol:@protocol(MCNavigationBarAppearanceStrategyDelegate)] &&
                 [_delegate respondsToSelector:@selector(appearance:didAppearForStrategyClass:state:)]) {
        [_delegate appearance:alphaNumber didAppearForStrategyClass:[self class] state:nil];
      }
    }
  }];
}
@end
