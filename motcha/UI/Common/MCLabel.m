#import "MCLabel.h"

@implementation MCLabel {
  NSLayoutConstraint *_heightConstraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeHeight
                                                  multiplier:0
                                                    constant:0];
  [self addConstraint:_heightConstraint];
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
