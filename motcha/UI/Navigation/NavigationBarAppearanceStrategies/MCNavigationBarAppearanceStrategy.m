#import "MCNavigationBarAppearanceStrategy.h"

#import "MCNavigationBarAppearanceBackgroundAlpha.h"
#import "MCNavigationBarAppearanceAuxiliaryView.h"

@implementation MCNavigationBarAppearanceStrategy {
  id<MCNavigationBarAppearanceStrategyProtocol> _appearanceStrategy;
  __weak UINavigationBar *_navigationBar;
}

- (instancetype)initWithNavigationBar:(UINavigationBar*)navigationBar
         appearanceStrategy:(id<MCNavigationBarAppearanceStrategyProtocol>)strategy {
  if (self = [super init]) {
    _appearanceStrategy = strategy;
    _navigationBar = navigationBar;
  }
  return self;
}

- (void)applyAppearanceAnimated:(BOOL)animated
                completionBlock:(void (^)(NSDictionary* dict))block {
  [_appearanceStrategy applyAppearanceToNavigationBar:_navigationBar
                                             animated:animated
                                      completionBlock:block];
}
@end
