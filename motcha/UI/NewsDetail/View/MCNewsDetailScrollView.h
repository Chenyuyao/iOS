#import <UIKit/UIKit.h>

#import "MCNewsDetailScrollViewDelegate.h"

static CGFloat kTitleImageViewBottomInset     = 40.0f;
static CGFloat kTitleImageViewTopInset        = 40.0f;
static CGFloat kTitleImageViewOriginalHeight  = 230.0f;

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
