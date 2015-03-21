#import "MCNewsListTableViewCell.h"

#import "MCLabel.h"
#import "UIColor+Helpers.h"
#import "NSDate+TimeAgo.h"
#import "UIImageView+AFNetworking.h"

static NSUInteger kSelectedBackgroundViewColor = 0xEEEEEE;

@implementation MCNewsListTableViewCell {
  __weak IBOutlet UIImageView *_thumbnailImageView;
  __weak IBOutlet MCLabel *_titleLabel;
  __weak IBOutlet UILabel *_sourceLabel;
  __weak IBOutlet UILabel *_descriptLabel;
  __weak IBOutlet UILabel *_dateLabel;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
}

- (void)setImageWithUrl:(NSURL *)imageURL {
  [_thumbnailImageView setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
  _titleLabel.text = title;
}

- (void)setSource:(NSString *)source {
  _sourceLabel.text = source;
}

- (void)setPublishDate:(NSDate *)pubDate {
  _dateLabel.text = [pubDate timeAgo];
}

- (void)setDescription:(NSString *)descript {
  _descriptLabel.text = descript;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  UIView * selectedBackgroundView = [[UIView alloc] init];
  [selectedBackgroundView setBackgroundColor:[UIColor colorWithHexValue:kSelectedBackgroundViewColor andAlpha:1.0f]];
  [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
