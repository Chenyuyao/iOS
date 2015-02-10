#import <UIKit/UIKit.h>

#import "MCNewsDetailScrollViewDelegate.h"

@interface MCDetailNewsBodyView : UIView
@property (weak, nonatomic) id<MCNewsDetailScrollViewDelegate> delegate;
@property (strong, nonatomic) NSArray *bodyContents;
- (void)changeTextFontSize:(NSInteger)fontSize needsLayoutSubviews:(BOOL)needsLayoutSubviews;
@end
