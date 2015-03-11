#import "MCTextView.h"

@implementation MCTextView {
  NSLayoutConstraint *_heightConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0
                                                      constant:0];
    [self addConstraint:_heightConstraint];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  // Auto-adjust the content size of the text view.
  _heightConstraint.constant = self.intrinsicContentSize.height;
}

- (CGSize)intrinsicContentSize {
  CGSize intrinsicContentSize = self.contentSize;
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    intrinsicContentSize.width += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0f;
    intrinsicContentSize.height += (self.textContainerInset.top + self.textContainerInset.bottom) / 2.0f;
  }
  return intrinsicContentSize;
}

@end
