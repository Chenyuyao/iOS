#import "MCNewsListTableViewCell.h"

#import "MCLabel.h"
#import "UIColor+Helpers.h"
#import "NSDate+TimeAgo.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Scale.h"

static NSUInteger kSelectedBackgroundViewColor = 0xEEEEEE;
static NSString *kPlaceholderImageName = @"placeholder";

@implementation MCNewsListTableViewCell {
  __weak IBOutlet UIImageView *_thumbnailImageView;
  __weak IBOutlet MCLabel *_titleLabel;
  __weak IBOutlet UILabel *_sourceLabel;
  __weak IBOutlet UILabel *_descriptLabel;
  __weak IBOutlet UILabel *_dateLabel;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.backgroundColor = [UIColor appMainColor];
}

- (void)setImageWithUrl:(NSURL *)imageURL {
  UIImage *placeholder = [UIImage imageNamed:kPlaceholderImageName];
  NSString *extension = [[imageURL path] pathExtension];
  if (![extension isEqualToString:@"gif"]) {
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:60];
    __weak UIImageView *weakThumbnailImageView = _thumbnailImageView;
    id successBlock = ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
      weakThumbnailImageView.image = [image scaleToSize:weakThumbnailImageView.frame.size
                                            contentMode:weakThumbnailImageView.contentMode];
    };
    [_thumbnailImageView setImageWithURLRequest:request
                               placeholderImage:placeholder
                                        success:successBlock
                                        failure:nil];
  } else {
    [_thumbnailImageView setImage:[UIImage imageNamed:kPlaceholderImageName]];
  }
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
