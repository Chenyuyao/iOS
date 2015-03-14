#import "MCNewsCategoryAddView.h"

static CGFloat kShadowRadius = 2.0f;
static CGFloat kShadowOpacity = 0.8f;

@implementation MCNewsCategoryAddView

- (void)awakeFromNib {
  NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0
                                                                      constant:kAddViewWidth];
  [self addConstraint:widthConstraint];
}

@end
