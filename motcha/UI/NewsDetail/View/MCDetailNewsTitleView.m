#import "MCDetailNewsTitleView.h"

#import "UIFont+DINFont.h"

static CGFloat kNewsTitleMargin = 20.0f;
static CGFloat kNewsTitleFontSize = 18.0f;

@implementation MCDetailNewsTitleView {
  UILabel *_newsTitle;
}

- (id)init {
  if (self = [super init]) {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupSubviewsAndConstraints];
  }
  return self;
}

- (void)setupSubviewsAndConstraints {
  _newsTitle = [UILabel new];
  _newsTitle.textAlignment = NSTextAlignmentLeft;
  _newsTitle.textColor = [UIColor whiteColor];
  _newsTitle.font = [UIFont dinRegularFontWithSize:kNewsTitleFontSize];
  [_newsTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  _newsTitle.numberOfLines = 0;
  [self addSubview:_newsTitle];
  
  NSDictionary *metrics = @{@"newsTitleMargin":[NSNumber numberWithDouble:kNewsTitleMargin]};
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:@{@"title":_newsTitle}]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-newsTitleMargin-[title]-newsTitleMargin-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:@{@"title":_newsTitle}]];
}

- (void)setTitle:(NSString *)title {
  _newsTitle.text = title;
}
@end
