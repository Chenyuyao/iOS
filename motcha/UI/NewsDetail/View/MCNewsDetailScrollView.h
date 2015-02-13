#import <UIKit/UIKit.h>

#import "MCNewsDetailScrollViewDelegate.h"

/**
 * the primary scroll view of MCNewsDetailViewController
 */
@interface MCNewsDetailScrollView : UIScrollView
@property (weak, nonatomic) id<MCNewsDetailScrollViewDelegate> mcDelegate;
- (void)toggleTextFontSize;
- (void)setImage:(UIImage *)image;
- (void)setNewsTitle:(NSString *)title;
- (void)setSource:(NSString *)source;
- (void)setPublishDate:(NSDate *)pubDate;
- (void)setAuthor:(NSString *)author;
- (void)setNewsMainBody:(NSArray *)bodyArray;
@end
