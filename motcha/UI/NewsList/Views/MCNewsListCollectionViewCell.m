#import "MCNewsListCollectionViewCell.h"

@implementation MCNewsListCollectionViewCell {
  __weak IBOutlet UIView *_bottomBorderView;
  __weak IBOutlet UIImageView *_thumbnailImageView;
  __weak IBOutlet UILabel *_titleLabel;
  __weak IBOutlet UILabel *_sourceLabel;
  __weak IBOutlet UILabel *_descriptLabel;
  __weak IBOutlet UILabel *_dateLabel;
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
