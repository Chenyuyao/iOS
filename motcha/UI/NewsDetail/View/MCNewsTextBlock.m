#import "MCNewsTextBlock.h"

#import "UIFont+DINFont.h"
#import "UIColor+Helpers.h"

@implementation MCNewsTextBlock

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor appMainColor];
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
