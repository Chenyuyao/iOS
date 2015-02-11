#import "MCNewsListCollectionViewCell.h"

static CGFloat kImageViewMargin = 10.0f;

@implementation MCNewsListCollectionViewCell {
  __weak IBOutlet UIView *_bottomBorderView;
  __weak IBOutlet UIImageView *_thumbnailImageView;
  __weak IBOutlet UILabel *_titleLabel;
  __weak IBOutlet UILabel *_sourceLabel;
  __weak IBOutlet UILabel *_descriptLabel;
  __weak IBOutlet UILabel *_dateLabel;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  NSDictionary *metrics = @{@"imageViewMargin":[NSNumber numberWithDouble:kImageViewMargin]};
  NSDictionary *views = NSDictionaryOfVariableBindings(_thumbnailImageView);
  // TODO: investigate a better way of setting _thumbnailImageView's
  // setTranslatesAutoresizingMaskIntoConstraints to NO before adding it to
  // the cell's subviews.
  [_thumbnailImageView removeFromSuperview];
  [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [self addSubview:_thumbnailImageView];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageViewMargin-[_thumbnailImageView]-imageViewMargin-|"
                                              options:0
                                              metrics:metrics
                                                views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thumbnailImageView]-imageViewMargin-|"
                                                               options:0
                                                               metrics:metrics
                                                                 views:views]];
  [_thumbnailImageView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailImageView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_thumbnailImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.2
                                                                   constant:0]];
  
  
}

- (void)setImage:(UIImage *)image {
  _thumbnailImageView.image = image;
}

- (void)setTitle:(NSString *)title {
  _titleLabel.text = title;
}

- (void)setSource:(NSString *)source {
  _sourceLabel.text = source;
}

- (void)setPublishDate:(NSDate *)pubDate {
  // TODO: replace with time ago
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = @"yyyy-MM-dd";
  _dateLabel.text = [NSString stringWithFormat:@" - %@", [dateFormatter stringFromDate:pubDate]];
}

- (void)setDescription:(NSString *)descript {
  _descriptLabel.text = descript;
}
@end
