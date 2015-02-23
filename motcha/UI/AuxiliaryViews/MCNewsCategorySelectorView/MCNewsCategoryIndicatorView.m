#import "MCNewsCategoryIndicatorView.h"
#import "UIColor+HexColor.h"

static NSUInteger kBackgroundColor  = 0x252525;

@implementation MCNewsCategoryIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor colorWithHexValue:kBackgroundColor andAlpha:1];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0
                                                                        constant:0];
    [self addConstraint:widthConstraint];
    _widthConstraint = widthConstraint;
  }
  return self;
}
@end
