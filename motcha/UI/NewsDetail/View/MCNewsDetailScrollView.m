#import "MCNewsDetailScrollView.h"

#import "MCDetailNewsTitleView.h"
#import "MCDetailNewsMetaDataView.h"
#import "MCDetailNewsBodyView.h"
#import "UIColor+Helpers.h"

static CGFloat kNewsTitleBottomIndex          = 10.0f;
static CGFloat kSmallFontSize                 = 14.0f;
static CGFloat kLargeFontSize                 = 16.0f;

static void *scrollViewContext = &scrollViewContext;

@implementation MCNewsDetailScrollView {
  UIView *_contentView;
  UIImageView *_loaderImageView;
  UIImageView *_titleImageView;
  MCDetailNewsTitleView *_newsTitle;
  UIView *_descriptionView;
  MCDetailNewsMetaDataView *_metaDataView;
  MCDetailNewsBodyView *_mainBodyView;
  
  NSLayoutConstraint *_imageViewTopConstraint;
  NSLayoutConstraint *_imageViewHeightConstraint;
  NSLayoutConstraint *_newsTitleBottomConstraint;
  
  BOOL _inBiggerFont;
}

- (instancetype)init {
  if (self = [super init]) {
    [self initContentViews];
    [self setupConstraints];
    [self addObserver:self
           forKeyPath:@"contentOffset"
              options:NSKeyValueObservingOptionNew
              context:scrollViewContext];
  }
  return self;
}

- (void)setMcDelegate:(id<MCNewsDetailScrollViewDelegate>)mcDelegate {
  _mcDelegate = mcDelegate;
  _metaDataView.delegate = mcDelegate;
  _mainBodyView.delegate = mcDelegate;
}


- (void)initContentViews {
  //add a content/image views
  self.backgroundColor = [UIColor appMainColor];
  
  //contentView: contains imageView, _newsTitle and _descriptionView
  _contentView = [[UIView alloc] init];
  [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _contentView.backgroundColor = [UIColor appMainColor];
  [self addSubview:_contentView];
  
  //title imageView
  _titleImageView = [[UIImageView alloc] init];
  [_titleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
  [_contentView addSubview:_titleImageView];
  
  //newsTitleView
  _newsTitle = [[MCDetailNewsTitleView alloc] init];
  [_contentView addSubview:_newsTitle];
  
  //descriptionView: contains MCDetailNewsMetaDataView and MCDetailNewsBodyView
  _descriptionView = [[UIView alloc] init];
  [_descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _descriptionView.backgroundColor = [UIColor appMainColor];
  [_contentView addSubview:_descriptionView];
  
  //metaDataView
  _metaDataView = [[MCDetailNewsMetaDataView alloc] init];
  [_descriptionView addSubview:_metaDataView];
  
  //mainBodyView
  _mainBodyView = [[MCDetailNewsBodyView alloc] init];
  [_descriptionView addSubview:_mainBodyView];
  
  //contentView placeholder
  _loaderImageView = [[UIImageView alloc] init];
  [_loaderImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  _loaderImageView.contentMode = UIViewContentModeScaleAspectFit;
  [_contentView addSubview:_loaderImageView];
  _loaderImageView.image = [UIImage imageNamed:@"placeholder-app-icon"]; // TODO: change to better image
}

- (void)setupConstraints {
  NSDictionary *views = NSDictionaryOfVariableBindings(self, _contentView, _titleImageView, _newsTitle, _descriptionView,
      _metaDataView, _mainBodyView, _loaderImageView);
  
  //Constraints for contentView: pin to superView's top and bottom, same width as scrollView
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView(>=self)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView(self)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  //constraints for placeholder
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_loaderImageView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_contentView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.f constant:0.f]];
  
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_loaderImageView
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_contentView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.f constant:0]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=50)-[_loaderImageView(40)]-(>=50)-|"
                                                                       options:NSLayoutFormatAlignAllCenterX | NSLayoutFormatAlignAllCenterY
                                                                       metrics:nil
                                                                         views:views]];


  //Constraints for contentView: pin to superView's top and bottom, same width as scrollView
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView(self)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  
  //Constraints for _imageView
  _imageViewTopConstraint = [NSLayoutConstraint constraintWithItem:_titleImageView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_contentView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:-kTitleImageViewBottomInset];
  [_contentView addConstraint:_imageViewTopConstraint];
  
  _imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_titleImageView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:0
                                                             constant:kTitleImageViewOriginalHeight];
  [_contentView addConstraint:_imageViewHeightConstraint];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleImageView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
  
  //Constraints for newsTitleLabel: pin to left, right, bottom-kNewsTitleBottomIndex
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_newsTitle]|"
                                                                       options:0
                                                                       metrics:nil
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
  CGFloat descriptionViewTopMargin =
      kTitleImageViewOriginalHeight - (kTitleImageViewTopInset + kTitleImageViewBottomInset);
  [_contentView addConstraint:
      [NSLayoutConstraint constraintWithItem:_descriptionView
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_contentView
                                   attribute:NSLayoutAttributeTop
                                  multiplier:1
                                    constant:descriptionViewTopMargin]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_descriptionView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descriptionView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
  //add constraints for _metaDataView, pin to top, left, right
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_metaDataView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_metaDataView][_mainBodyView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mainBodyView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [self initTextFontSize];
}

#pragma mark - Font size

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

#pragma mark - Content Settings

- (void)setImage:(UIImage *)image {
  _titleImageView.image = image;
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
  [_loaderImageView removeFromSuperview];
  _loaderImageView = nil;
}


#pragma mark - UIContentContainer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (context == scrollViewContext) {
    CGFloat contentOffSetY = self.contentOffset.y;
    CGFloat imageVerticalInsets = kTitleImageViewTopInset+kTitleImageViewBottomInset;
    if (contentOffSetY < -(imageVerticalInsets)) {
      _imageViewTopConstraint.constant = contentOffSetY;
      _imageViewHeightConstraint.constant = kTitleImageViewOriginalHeight + (-contentOffSetY-imageVerticalInsets);
    } else {
      _imageViewHeightConstraint.constant = kTitleImageViewOriginalHeight;
      _imageViewTopConstraint.constant = -kTitleImageViewTopInset - (-contentOffSetY)/2.0;
    }
  }
}

#pragma mark - dealloc
- (void)dealloc {
  [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end