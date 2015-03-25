#import "MCNewsListFooterView.h"

@implementation MCNewsListFooterView {
  __weak IBOutlet UIButton *_loadMoreButton;
  __weak IBOutlet UIActivityIndicatorView *_indicatorView;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.state = LoadingInit;
}

- (void)setState:(LoadMoreState)state {
  _state = state;
  switch (state) {
    case LoadingInit:
      _loadMoreButton.alpha = 0;
      _loadMoreButton.enabled = NO;
      break;
    case LoadingMore:
      _loadMoreButton.alpha = 0;
      [_indicatorView startAnimating];
      break;
    case LoadingDone:
      _loadMoreButton.alpha = 1;
      _loadMoreButton.enabled = YES;
      [_indicatorView stopAnimating];
      break;
    case LoadingNoMore:
      _loadMoreButton.alpha = 1;
      _loadMoreButton.enabled = NO;
      [_indicatorView stopAnimating];
      break;
  }
}

@end
