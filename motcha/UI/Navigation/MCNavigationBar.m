#import "MCNavigationBar.h"

#import "MCNavigationBarAppearanceStrategy.h"
#import "MCNavigationBarAppearanceAuxiliaryView.h"
#import "MCNavigationBarAppearanceBackgroundAlpha.h"

static NSString * kNavigationBarBackgroundClassName = @"_UINavigationBarBackground";

@interface MCNavigationBar ()<MCNavigationBarAppearanceStrategyDataSource, MCNavigationBarAppearanceStrategyDelegate>
@end

@implementation MCNavigationBar {
  MCNavigationBarAppearanceStrategy*  _auxiliaryViewStrategy;
  MCNavigationBarAppearanceStrategy*  _backgroundAlphaStrategy;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.barTintColor = [UIColor whiteColor];
    for (UIView *view in [self subviews]) {
      if ([kNavigationBarBackgroundClassName isEqualToString:NSStringFromClass([view class])]) {
        _navigationBarBackgroundView = view;
        break;
      }
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isPortrait = (orientation == UIInterfaceOrientationPortrait);
    _navigationBarOffset = isPortrait ? kNavigationBarOffsetPortrait : kNavigationBarOffsetLandscape;
    _backgroundHeight = (isPortrait ? kNavigationBarDefaultHeightPortrait : kNavigationBarDefaultHeightLandscape) +
    _navigationBarOffset;
    MCNavigationBarAppearanceAuxiliaryView *navBarAppearanceAuxView = [MCNavigationBarAppearanceAuxiliaryView new];
    navBarAppearanceAuxView.delegate = self;
    navBarAppearanceAuxView.dataSource = self;
    _auxiliaryViewStrategy =
    [[MCNavigationBarAppearanceStrategy alloc] initWithNavigationBar:self appearanceStrategy:navBarAppearanceAuxView];
    MCNavigationBarAppearanceBackgroundAlpha *navBarAppearanceBgAlpha = [MCNavigationBarAppearanceBackgroundAlpha new];
    navBarAppearanceBgAlpha.delegate = self;
    navBarAppearanceBgAlpha.dataSource = self;
    _backgroundAlphaStrategy =
    [[MCNavigationBarAppearanceStrategy alloc] initWithNavigationBar:self appearanceStrategy:navBarAppearanceBgAlpha];
  }
  return self;
}

#pragma mark - AuxiliaryView
- (void)setAuxiliaryView:(UIView*)auxiliaryView animated:(BOOL)animated {
  _auxiliaryView = auxiliaryView;
  [_auxiliaryViewStrategy applyAppearanceAnimated:animated completionBlock:nil];
}

#pragma mark - BackgroundAlpha
- (void)setBackgroundAlpha:(CGFloat)alpha animated:(BOOL)animated {
  _backgroundAlpha = alpha;
  [_backgroundAlphaStrategy applyAppearanceAnimated:animated completionBlock:nil];
}

#pragma mark - MCNavigationBarAppearanceStrategyDataSource methods
- (NSDictionary*)appearanceStrategyDataForStrategyClass:(Class)strategyClass {
  NSDictionary *dataDict = [NSDictionary dictionary];
  if (strategyClass == [MCNavigationBarAppearanceAuxiliaryView class]) {
    dataDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:_navigationBarOffset],
        kNavigationBarOffsetKey, [NSNumber numberWithDouble:_backgroundHeight], kNavigationBarBackgroundHeightKey,
        _navigationBarBackgroundView, kNavigationBarBackgroundViewKey, _auxiliaryView, kAuxiliaryViewKey, nil];
  }
  if (strategyClass == [MCNavigationBarAppearanceBackgroundAlpha class]) {
    dataDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:_backgroundAlpha],
        kNavigationBarBackgroundAlphaKey, _navigationBarBackgroundView, kNavigationBarBackgroundViewKey,nil];
  }
  return dataDict;
}

#pragma mark - MCNavigationBarAppearanceStrategyDelegate methods
- (void)appearance:(NSObject *)appearance willAppearForStrategyClass:(Class)strategyClass state:(NSDictionary *)dict {
  if (strategyClass == [MCNavigationBarAppearanceAuxiliaryView class]) {
    UIView *currentAuxiliaryView = (UIView*)appearance;
    _auxiliaryView = currentAuxiliaryView;
  }
  if (strategyClass == [MCNavigationBarAppearanceBackgroundAlpha class]) {
    NSNumber *currentBackgroundAlpha = (NSNumber*)appearance;
    _backgroundAlpha = [currentBackgroundAlpha doubleValue];
  }
}

- (void)appearance:(NSObject *)appearance didAppearForStrategyClass:(Class)strategyClass state:(NSDictionary *)dict {
  if (strategyClass == [MCNavigationBarAppearanceAuxiliaryView class]) {
    NSNumber *finalBarHeight = [dict objectForKey:kNavigationBarBackgroundHeightKey];
    _backgroundHeight = [finalBarHeight doubleValue];
  }
}

#pragma mark - override hitTest:withEvent
// This overriden method enables the touch events being dispatched to the views that are out of the bounds of their
// superview.
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  CGPoint pointForTargetView = [_auxiliaryView convertPoint:point fromView:self];
  if (CGRectContainsPoint(_auxiliaryView.bounds, pointForTargetView)) {
    return [_auxiliaryView hitTest:pointForTargetView withEvent:event];
  }
  return [super hitTest:point withEvent:event];
}
@end
