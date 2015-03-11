#import "MCNewsTextBlock.h"

#import "UIFont+DINFont.h"

@implementation MCNewsTextBlock

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.editable = NO;
    self.scrollsToTop = NO;
  }
  return self;
}

- (void)setFontSize:(CGFloat)fontSize {
  _fontSize = fontSize;
  self.font = [UIFont dinRegularFontWithSize:fontSize];
}
@end
