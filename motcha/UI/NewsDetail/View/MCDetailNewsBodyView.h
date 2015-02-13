#import <UIKit/UIKit.h>

#import "MCNewsDetailScrollViewDelegate.h"

/**
 * A view containing the MCNewsImageBlock's and MCNewsTextBlock's.
 */
@interface MCDetailNewsBodyView : UIView
@property (weak, nonatomic) id<MCNewsDetailScrollViewDelegate> delegate;
@property (strong, nonatomic) NSArray *bodyContents;
- (void)changeTextFontSize:(NSInteger)fontSize needsLayoutSubviews:(BOOL)needsLayoutSubviews;
@end
