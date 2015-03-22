#import "MCNewsCategoryAddView.h"

static CGFloat kShadowRadius = 2.0f;
static CGFloat kShadowOpacity = 0.8f;

@implementation MCNewsCategoryAddView {
  __weak IBOutlet UIView *_edgeView;
  __weak IBOutlet UIButton *_plus;
  BOOL _backgroundGradientEnabled;
  dispatch_once_t _onceToken;
}

- (void)awakeFromNib {
  _edgeView.layer.shadowColor = [UIColor blackColor].CGColor;
  _edgeView.layer.shadowOpacity = kShadowOpacity;
  _edgeView.layer.shadowRadius = kShadowRadius;
  _edgeView.layer.shadowOffset = CGSizeMake(0.0, -1.0);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  dispatch_once(&_onceToken, ^{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0
                                                                        constant:kAddViewWidth];
    [self addConstraint:widthConstraint];
    
    // Add a gradient background color (white -> transparent)
    CGRect frame = self.frame;
    CGFloat alpha = 1.0f;
    for (NSInteger i = 0; i < frame.size.width; ++i) {
      alpha -= 1.0f / (frame.size.width / 2.0f);
      UIView *view =
          [[UIView alloc] initWithFrame:CGRectMake(i, -kShadowRadius*2, 1.0f, frame.size.height+kShadowRadius*2)];
      view.backgroundColor = [UIColor colorWithWhite:1.0f alpha:alpha];
      [self addSubview:view];
    }
    [self bringSubviewToFront:_plus];
  });
}

@end
