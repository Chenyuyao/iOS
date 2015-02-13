#import <UIKit/UIKit.h>

@interface MCNewsListCollectionViewCell : UICollectionViewCell
- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setSource:(NSString *)source;
- (void)setPublishDate:(NSDate *)pubDate;
- (void)setDescription:(NSString *)descript;
@end
