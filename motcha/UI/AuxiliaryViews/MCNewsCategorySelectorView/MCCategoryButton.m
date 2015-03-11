#import "MCCategoryButton.h"
#import "UIColor+Helpers.h"
#import "UIFont+DINFont.h"

static CGFloat kFontSize              = 17.0f;
static CGFloat kLeftRightInset        = 0.0f;
static NSUInteger kNormalStateColor   = 0x707070;
static NSUInteger kSelectedStateColor = 0x242424;

@implementation MCCategoryButton

// The designated initializer.
- (instancetype)initWithCategory:(NSString *)category {
  if (self = [super initWithFrame:CGRectZero]) {
    self.contentEdgeInsets = UIEdgeInsetsMake(0, kLeftRightInset, 0, kLeftRightInset);
    self.category = category;
    [self setTitleColor:[UIColor colorWithHexValue:kNormalStateColor andAlpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexValue:kSelectedStateColor andAlpha:1] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont dinRegularFontWithSize:kFontSize];
    self.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (void)setCategory:(NSString *)category {
  _category = category;
  [self setTitle:[category uppercaseString] forState:UIControlStateNormal];
  [self sizeToFit];
}

- (BOOL)isEqual:(id)anObject {
  BOOL ret;
  if (self == anObject) {
    ret = YES;
  } else if (![anObject isKindOfClass:[MCCategoryButton class]]) {
    ret = NO;
  } else {
    ret = [self.titleLabel.text isEqualToString:((MCCategoryButton *)anObject).titleLabel.text];
  }
  return ret;
}
@end
