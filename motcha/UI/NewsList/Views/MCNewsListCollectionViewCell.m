#import "MCNewsListCollectionViewCell.h"

static CGFloat kImageViewMargin = 10.0f;

@implementation MCNewsListCollectionViewCell {
  __weak IBOutlet UIView *_bottomBorderView;
  __weak IBOutlet UIImageView *_thumbnailImageView;
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
@end
