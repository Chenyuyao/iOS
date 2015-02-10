#import "MCNewsDetailScrollView.h"

#import "MCDetailNewsTitleView.h"
#import "MCDetailNewsMetaDataView.h"
#import "MCDetailNewsBodyView.h"

static CGFloat kImageViewBottomInset      = 40.0f;
static CGFloat kImageViewTopInset         = 40.0f;
static CGFloat kImageViewOriginalHeight   = 230.0f;
static CGFloat kNewsTitleBottomIndex      = 10.0f;
static CGFloat kDescriptionViewTopMargin  = 150.0f;
static CGFloat kSmallFontSize             = 14.0f;
static CGFloat kLargeFontSize             = 16.0f;

@interface MCNewsDetailScrollView ()<UIScrollViewDelegate>
@end

@implementation MCNewsDetailScrollView {
  UIView *_contentView;
  UIImageView *_imageView;
  MCDetailNewsTitleView *_newsTitle;
  UIView *_descriptionView;
  MCDetailNewsMetaDataView *_metaDataView;
  MCDetailNewsBodyView *_mainBodyView;
  
  NSLayoutConstraint *_imageViewTopConstraint;
  NSLayoutConstraint *_imageViewHeightConstraint;
  NSLayoutConstraint *_newsTitleBottomConstraint;
  
  BOOL _inBiggerFont;
}

- (id) init {
  if (self = [super init]) {
    [self setupControls];
    [self setupSubviewsAndConstraints];
  }
  return self;
}

- (void)setMcDelegate:(id<MCNewsDetailScrollViewDelegate>)mcDelegate {
  _mcDelegate = mcDelegate;
  _metaDataView.delegate = mcDelegate;
  _mainBodyView.delegate = mcDelegate;
}

- (void)setupControls {
  self.scrollsToTop = YES;
}

- (void)setupSubviewsAndConstraints {
  //add a content/image views
  [self setBackgroundColor:[UIColor whiteColor]];
  self.delegate = self;
  
  //contentView: contains imageView, _newsTitle and _descriptionView
  _contentView = [[UIView alloc] init];
  [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _contentView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_contentView];
  
  //imageView
  _imageView = [[UIImageView alloc] init];
  [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [_contentView addSubview:_imageView];
  
  //newsTitleView
  _newsTitle = [[MCDetailNewsTitleView alloc] init];
  [_contentView addSubview:_newsTitle];

  //descriptionView: contains metaData and mainbody
  _descriptionView = [[UIView alloc] init];
  [_descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _descriptionView.backgroundColor = [UIColor whiteColor];
  [_contentView addSubview:_descriptionView];
  
  //metaDataView
  _metaDataView = [[MCDetailNewsMetaDataView alloc] init];
  [_descriptionView addSubview:_metaDataView];
  
  //mainBodyView
  _mainBodyView = [[MCDetailNewsBodyView alloc] init];
  [_descriptionView addSubview:_mainBodyView];
  
  NSDictionary *metrics = @{@"newsTitleMargin":@10, @"sourceViewMaxWidth":@200, @"mainBodyViewIndex":@10};
  NSDictionary *views = NSDictionaryOfVariableBindings(self, _contentView, _imageView, _newsTitle, _descriptionView,
      _metaDataView, _mainBodyView);

  //Constraints for contentView: pin to superView's top and bottom, same width as scrollView
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView(self)]|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  
  //Constraints for _imageView
  _imageViewTopConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_contentView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:-kImageViewBottomInset];
  [_contentView addConstraint:_imageViewTopConstraint];
  
  _imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:0
                                                             constant:kImageViewOriginalHeight];
  [_contentView addConstraint:_imageViewHeightConstraint];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
  
  //Constraints for newsTitleLabel: pin to left, right, bottom-kNewsTitleBottomIndex
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_newsTitle]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
  
  _newsTitleBottomConstraint = [NSLayoutConstraint constraintWithItem:_newsTitle
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_descriptionView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:-kNewsTitleBottomIndex];
  [_contentView addConstraint:_newsTitleBottomConstraint];

  //add constraints for _descriptionView, top, bottom, leading and width
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_contentView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:kDescriptionViewTopMargin]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_descriptionView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionView]|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
  //add constraints for _metaDataView, pin to top, left, right
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_metaDataView]|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_metaDataView][_mainBodyView]|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
  
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mainBodyView]|"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:views]];
  [self initTextFontSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat contentOffSetY = self.contentOffset.y;
  CGFloat imageVerticalInsets = kImageViewTopInset+kImageViewBottomInset;
  if (contentOffSetY < -(imageVerticalInsets)) {
    _imageViewTopConstraint.constant = contentOffSetY;
    _imageViewHeightConstraint.constant = kImageViewOriginalHeight + (-contentOffSetY-imageVerticalInsets);
  } else {
    _imageViewHeightConstraint.constant = kImageViewOriginalHeight;
    _imageViewTopConstraint.constant = -kImageViewTopInset - (-contentOffSetY)/2.0;
  }
}

- (void)initTextFontSize {
  [_metaDataView changeMetaDataFontSize:kSmallFontSize needsLayoutSubviews:NO];
  [_mainBodyView changeTextFontSize:kSmallFontSize needsLayoutSubviews:NO];
}

- (void)toggleTextFontSize {
  NSInteger size = _inBiggerFont ? kSmallFontSize : kLargeFontSize;
  [_metaDataView changeMetaDataFontSize:size needsLayoutSubviews:YES];
  [_mainBodyView changeTextFontSize:size needsLayoutSubviews:YES];
  _inBiggerFont = !_inBiggerFont;
}

- (void)setImage:(UIImage *)image {
  _imageView.image = image;
}

- (void)setNewsTitle:(NSString *)title {
  [_newsTitle setTitle:title];
}

- (void)setSource:(NSString *)source {
  [_metaDataView setSource:source];
}

- (void)setPublishDate:(NSDate *)pubDate {
  [_metaDataView setDate:pubDate];
}

- (void)setAuthor:(NSString *)author {
  [_metaDataView setAuthor:author];
}

- (void)setNewsMainBody:(NSArray *)bodyArray {
  [_mainBodyView setBodyContents:bodyArray];
}

@end