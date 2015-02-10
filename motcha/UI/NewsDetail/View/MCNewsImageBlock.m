#import "MCNewsImageBlock.h"

static CGFloat kMaxHeightWidthRatio = 1.5f;

@implementation MCNewsImageBlock {
  NSLayoutConstraint *_heightConstraint;
}

- (id)init {
  if (self == [super init]) {
    [self setupControls];
  }
  return self;
}

- (void)setupControls {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  self.contentMode = UIViewContentModeScaleAspectFit;
  self.userInteractionEnabled = YES;
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

- (CGFloat)imageHeightWidthRatio:(UIImage *)image  {
  return image.size.height / image.size.width;
}

- (void)setNewsImage:(UIImage *)newsImage {
  self.image = newsImage;
  CGFloat ratio = [self imageHeightWidthRatio:self.image];
  ratio = MIN(kMaxHeightWidthRatio, ratio);
  [self removeConstraint:_heightConstraint];
  [self setAddHeightWidthRatioContraint:ratio];
}
@end
