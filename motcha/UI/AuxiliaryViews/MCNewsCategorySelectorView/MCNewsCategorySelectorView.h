#import <UIKit/UIKit.h>
#import "MCNewsCategorySelectorScrollView.h"

static CGFloat kCategorySelectorViewHeight = 34.0f;

@protocol MCNewsCategorySelectorViewDelegate <NSObject>
@optional
- (void)addCategoriesButtonPressed;
@end

@interface MCNewsCategorySelectorView : UIView
@property (weak, nonatomic) id<MCNewsCategorySelectorViewDelegate> mcDelegate;
@property (strong, nonatomic) MCNewsCategorySelectorScrollView *categoryScrollView;
@end
