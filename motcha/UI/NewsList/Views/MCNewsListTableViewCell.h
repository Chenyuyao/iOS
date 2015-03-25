#import <UIKit/UIKit.h>

@interface MCNewsListTableViewCell : UITableViewCell
@property (nonatomic) BOOL isRead;
- (void)setImageWithUrl:(NSURL *)imageURL;
- (void)setTitle:(NSString *)title;
- (void)setSource:(NSString *)source;
- (void)setPublishDate:(NSDate *)pubDate;
- (void)setDescription:(NSString *)descript;
@end
