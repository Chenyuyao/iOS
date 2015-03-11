#import "MCDetailNewsMetaDataView.h"

#import "UIFont+DINFont.h"

static NSString *kDateFormat       = @"yyyy-MM-dd";
static CGFloat kMetaDataViewMargin = 14.0f;

@implementation MCDetailNewsMetaDataView {
  UIView *_sourceDateView;
  UILabel *_sourceLabel;
  UILabel *_pubDateLabel;
  UILabel *_authorLabel;
  CGFloat _fontSize;
  NSLayoutConstraint *_pubDateWidthConstraint;
}
@synthesize delegate = _delegate;

- (instancetype)init {
  if (self = [super init]) {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupSubviewsAndConstraints];
  }
  return self;
}

- (void)layoutSubviews {
  _authorLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _pubDateLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _sourceLabel.font = [UIFont dinRegularFontWithSize:_fontSize];
  _pubDateWidthConstraint.constant = _pubDateLabel.intrinsicContentSize.width;
  [super layoutSubviews];
}

- (void)setupSubviewsAndConstraints {
  //sourceDateView
  _sourceDateView = [[UIView alloc] init];
  [_sourceDateView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:_sourceDateView];
  
  //source label
  _sourceLabel = [[UILabel alloc] init];
  [_sourceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  _sourceLabel.textAlignment = NSTextAlignmentRight;
  [_sourceDateView addSubview:_sourceLabel];
  
  //pubDate label
  _pubDateLabel = [[UILabel alloc] init];
  [_pubDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_pubDateLabel sizeToFit];
  _pubDateWidthConstraint = [NSLayoutConstraint constraintWithItem:_pubDateLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:0
                                                          constant:0];
  [_pubDateLabel addConstraint:_pubDateWidthConstraint];
  [_sourceDateView addSubview:_pubDateLabel];
  
  //author label
  _authorLabel = [[UILabel alloc] init];
  [_authorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:_authorLabel];
  
  NSDictionary *metrics = @{@"margin":[NSNumber numberWithDouble:kMetaDataViewMargin]};
  NSDictionary *views = NSDictionaryOfVariableBindings(_sourceDateView, _sourceLabel, _pubDateLabel, _authorLabel);
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sourceDateView][_authorLabel]|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_sourceDateView]-margin-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=margin)-[_authorLabel]-margin-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sourceLabel][_pubDateLabel]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
  [_sourceDateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sourceLabel]|"
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
  _pubDateLabel.text = [NSString stringWithFormat:@" - %@", [dateFormatter stringFromDate:pubDate]];
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
