#import <UIKit/UIKit.h>

#import "MCNewsDetailScrollViewDelegate.h"

/**
 * A view presenting the meta data of the news, including the source, the publish date, and the author.
 */
@interface MCDetailNewsMetaDataView : UIView
@property (weak, nonatomic) id<MCNewsDetailScrollViewDelegate> delegate;
- (void)setSource:(NSString *)source;
- (void)setDate:(NSDate *)pubDate;
- (void)setAuthor:(NSString *)author;
- (void)changeMetaDataFontSize:(NSInteger)fontSize needsLayoutSubviews:(BOOL)needsLayoutSubviews;
@end
