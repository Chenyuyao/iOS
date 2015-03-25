#import <UIKit/UIKit.h>

typedef enum {
  LoadingInit,
  LoadingMore,
  LoadingDone,
  LoadingNoMore
} LoadMoreState;

@interface MCNewsListFooterView : UIView
@property (nonatomic) LoadMoreState state;
@end
