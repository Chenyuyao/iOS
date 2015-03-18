#import <UIKit/UIKit.h>

@interface MCNewsListTableViewCell : UITableViewCell
- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setSource:(NSString *)source;
- (void)setPublishDate:(NSDate *)pubDate;
- (void)setDescription:(NSString *)descript;
@end
