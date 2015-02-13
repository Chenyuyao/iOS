#import "MCNewsImageBlock.h"

static CGFloat kMaxHeightWidthRatio = 1.5f;

@implementation MCNewsImageBlock {
  NSLayoutConstraint *_heightConstraint;
}

- (id)init {
  if (self = [super init]) {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (void)setAddHeightWidthRatioContraint:(CGFloat)heightWidthRatio {
  _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:heightWidthRatio
                                                    constant:0];
  [self addConstraint:_heightConstraint];
}

- (void)setupSubviewsAndConstraints {
  [self setAddHeightWidthRatioContraint:1.0f];
}

- (void)setNewsImage:(UIImage *)newsImage {
  self.image = newsImage;
  CGFloat ratio = self.image.size.height / self.image.size.width;
  ratio = MIN(kMaxHeightWidthRatio, ratio);
  [self removeConstraint:_heightConstraint];
  [self setAddHeightWidthRatioContraint:ratio];
}
@end
