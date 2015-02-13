#import "MCDetailNewsBodyView.h"

#import "MCNewsImageBlock.h"
#import "MCNewsTextBlock.h"
#import "UIFont+DINFont.h"

static CGFloat kTextBlockMargin = 12.0f;
static CGFloat kImageBlockMargin = 15.0f;

@implementation MCDetailNewsBodyView {
  CGFloat _fontSize;
}

- (id)init {
  if (self = [super init]) {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

  }
  return self;
}

- (void)setupControls {
}

- (void)layoutSubviews {
  for (NSObject *view in self.subviews) {
    if ([view isKindOfClass:[MCNewsTextBlock class]]) {
      MCNewsTextBlock *textView = (MCNewsTextBlock*)view;
      if (textView.fontSize != _fontSize) {
        textView.fontSize = _fontSize;
      }
    }
  }
  [super layoutSubviews];
}

- (void)setBodyContents:(NSArray *)bodyContents {
  _bodyContents = bodyContents;
  NSObject *prevBlock;
  for (NSObject *bodyItem in bodyContents) {
    NSDictionary *metrics;
    NSObject *block;
    if ([bodyItem isKindOfClass:[NSString class]]) {
      MCNewsTextBlock *textBlock = [[MCNewsTextBlock alloc] init];
      textBlock.text = (NSString *)bodyItem;
      [textBlock setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:textBlock];
      metrics = @{@"blockMargin":[NSNumber numberWithDouble:kTextBlockMargin]};
      block = textBlock;
    } else if ([bodyItem isKindOfClass:[UIImage class]]) {
      MCNewsImageBlock *imageBlock = [[MCNewsImageBlock alloc] init];
      [imageBlock setTranslatesAutoresizingMaskIntoConstraints:NO];
      [imageBlock setNewsImage:(UIImage *)bodyItem];
      [imageBlock addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageBlockTapped:)]];
      [self addSubview:imageBlock];
      metrics = @{@"blockMargin":[NSNumber numberWithDouble:kImageBlockMargin]};
      block = imageBlock;
    }
    if (bodyItem == [bodyContents firstObject]) { // first one, pin to top
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[block]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"block":block}]];
    } else { // else, pin to previous
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevBlock][block]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"block":block, @"prevBlock":prevBlock}]];
      if (bodyItem == [bodyContents lastObject]) { //last one, pin to bottom
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[block]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"block":block}]];
      }
    }
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-blockMargin-[block]-blockMargin-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:@{@"block":block}]];
    prevBlock = block;
  }
}

- (void)changeTextFontSize:(NSInteger)fontSize needsLayoutSubviews:(BOOL)needsLayoutSubviews {
  _fontSize = fontSize;
  if (needsLayoutSubviews) {
    [self setNeedsLayout];
    [self layoutIfNeeded];
  }
}

#pragma mark - UIGestureRecognizer action
- (void)imageBlockTapped:(UIGestureRecognizer*)tapGestureRecognizer {
  if ([_delegate conformsToProtocol:@protocol(MCNewsDetailScrollViewDelegate)] &&
      [_delegate respondsToSelector:@selector(imageBlockTappedForImageView:)]) {
    [_delegate imageBlockTappedForImageView:(UIImageView*)tapGestureRecognizer.view];
  }
}
@end
