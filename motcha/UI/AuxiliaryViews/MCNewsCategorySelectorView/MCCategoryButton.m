#import "MCCategoryButton.h"
#import "UIColor+HexColor.h"
#import "UIFont+DINFont.h"

static CGFloat kFontSize              = 17.0f;
static CGFloat kLeftRightInset        = 0.0f;
static NSUInteger kNormalStateColor   = 0x707070;
static NSUInteger kSelectedStateColor = 0x242424;

@implementation MCCategoryButton {
  NSLayoutConstraint *_widthConstraint;
}

// The designated initializer.
- (instancetype)initWithCategory:(NSString *)category {
  if (self = [super initWithFrame:CGRectZero]) {
    [self setupSelfWithCategory:category];
    [self setupSubviewsAndConstraints];
  }
  return self;
}

- (void)setupSelfWithCategory:(NSString *)category {
  self.contentEdgeInsets = UIEdgeInsetsMake(0, kLeftRightInset, 0, kLeftRightInset);
  _category = category;
  [self setTitle:[category uppercaseString] forState:UIControlStateNormal];
  [self setTitleColor:[UIColor colorWithHexValue:kNormalStateColor andAlpha:1] forState:UIControlStateNormal];
  [self setTitleColor:[UIColor colorWithHexValue:kSelectedStateColor andAlpha:1] forState:UIControlStateSelected];
  self.titleLabel.font = [UIFont dinRegularFontWithSize:kFontSize];
  self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupSubviewsAndConstraints {
  _widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:nil
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:0
                                                    constant:0];
  [self addConstraint:_widthConstraint];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  // Auto-adjust the content size of the view.
  _widthConstraint.constant = self.intrinsicContentSize.width;
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
