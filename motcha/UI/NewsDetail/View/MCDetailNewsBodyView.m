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
  if (self == [super init]) {
    [self setupControls];
  }
  return self;
}

- (void)setupControls {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  self.backgroundColor = [UIColor whiteColor];
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
  NSObject *curBodyItem = nil;
  NSObject *prevBlock = nil;
  NSInteger last = _bodyContents.count-1;
  
  for (NSUInteger i = 0; i < _bodyContents.count; ++i) {
    curBodyItem = _bodyContents[i];
    NSDictionary *metrics;
    NSObject *block;
    if ([curBodyItem isKindOfClass:[NSString class]]) {
      MCNewsTextBlock *textBlock = [[MCNewsTextBlock alloc] init];
      textBlock.text = (NSString *)curBodyItem;
      [textBlock setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self addSubview:textBlock];
      metrics = @{@"blockMargin":[NSNumber numberWithDouble:kTextBlockMargin]};
      block = textBlock;
    } else if ([curBodyItem isKindOfClass:[UIImage class]]) {
      MCNewsImageBlock *imageBlock = [[MCNewsImageBlock alloc] init];
      [imageBlock setTranslatesAutoresizingMaskIntoConstraints:NO];
      [imageBlock setNewsImage:(UIImage *)curBodyItem];
      [imageBlock addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageBlockTapped:)]];
      [self addSubview:imageBlock];
      metrics = @{@"blockMargin":[NSNumber numberWithDouble:kImageBlockMargin]};
      block = imageBlock;
    }
    if (i == 0) { // first one, pin to top
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[block]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"block":block}]];
    }
    if (i == last) { //last one, pin to bottom
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[block]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"block":block}]];
    }
    if (i > 0 && i <= last) { // else, pin to previous
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevBlock][block]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"block":block, @"prevBlock":prevBlock}]];
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
