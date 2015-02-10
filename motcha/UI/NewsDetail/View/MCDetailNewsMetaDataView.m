#import "MCDetailNewsMetaDataView.h"

#import "UIFont+DINFont.h"

static CGFloat kSourceViewMaxWidth = 200.0f;
static NSString *kDateFormat       = @"yyyy-MM-dd";

@implementation MCDetailNewsMetaDataView {
  UIView *_sourceDateView;
  UILabel *_sourceLabel;
  UILabel *_dashLabel;
  UILabel *_pubDateLabel;
  UILabel *_authorLabel;
  CGFloat _fontSize;
}
@synthesize delegate = _delegate;

- (id)init {
  if (self= [super init]) {
    [self setupControls];
    [self setupSubviewsAndConstraints];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _dashLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _authorLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _pubDateLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _sourceLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
}

- (void)setupControls {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self sizeToFit];
  self.backgroundColor = [UIColor whiteColor];
}

- (void)setupSubviewsAndConstraints {
  //sourceDateView
  _sourceDateView = [[UIView alloc] init];
  [_sourceDateView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:_sourceDateView];
  
  //source label
  _sourceLabel = [[UILabel alloc] init];
  [_sourceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_sourceDateView addSubview:_sourceLabel];
  
  //dash label
  _dashLabel = [[UILabel alloc] init];
  [_dashLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  _dashLabel.text = @"-";
  [_sourceDateView addSubview:_dashLabel];
  
  //pubDate label
  _pubDateLabel = [[UILabel alloc] init];
  [_pubDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_sourceDateView addSubview:_pubDateLabel];
  
  //author label
  _authorLabel = [[UILabel alloc] init];
  [_authorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:_authorLabel];
  
  NSDictionary *metrics = @{@"sourceViewMaxWidth":[NSNumber numberWithDouble:kSourceViewMaxWidth]};
  NSDictionary *views =
      NSDictionaryOfVariableBindings(_sourceDateView, _sourceLabel, _dashLabel, _pubDateLabel, _authorLabel);
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sourceDateView][_authorLabel]|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_sourceDateView]-14-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=14)-[_authorLabel]-14-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
      @"H:|-(>=14)-[_sourceLabel(<=sourceViewMaxWidth)][_dashLabel][_pubDateLabel]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sourceLabel]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dashLabel]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pubDateLabel]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
}

- (void)setSource:(NSString *)source {
  _sourceLabel.text = source;
}

- (void)setDate:(NSDate *)pubDate {
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = kDateFormat;
  _pubDateLabel.text = [dateFormatter stringFromDate:pubDate];
}

- (void)setAuthor:(NSString *)author {
  _authorLabel.text = author;
}

- (void)changeMetaDataFontSize:(NSInteger)fontSize needsLayoutSubviews:(BOOL)needsLayoutSubviews {
  _fontSize = fontSize;
  if (needsLayoutSubviews) {
    [self setNeedsLayout];
    [self layoutIfNeeded];
  }
}
@end
