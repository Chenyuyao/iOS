#import "MCLabel.h"

@implementation MCLabel {
  NSLayoutConstraint *_heightConstraint;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
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
  // Auto-adjust the content size of the label view.
  self.preferredMaxLayoutWidth = self.frame.size.width;
  if (_heightConstraint.constant != self.intrinsicContentSize.height) {
    _heightConstraint.constant = self.intrinsicContentSize.height;
  }
}

@end
