#import "MCPageView.h"

#import "UIColor+Helpers.h"

@implementation MCPageView

- (instancetype)init {
  if (self = [super init]) {
    self.backgroundColor = [UIColor appMainColor];
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
  }
  return self;
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
  [super scrollRectToVisible:rect animated:animated];
  if (!animated) {
    [(id<MCPageViewDelegate>)self.delegate scrollViewDidEndScrollingWithoutAnimation:self];
  }
}

#pragma mark - MCPageViewItem operations
- (void)addPageViewItem:(UIView *)viewItem {
  [self addSubview:viewItem];
}

- (void)removePageViewItem:(UIView *)viewItem {
  [viewItem removeFromSuperview];
}

- (void)reloadViews {
    NSMutableString *visualFormatString = [NSMutableString stringWithString:@"H:|"];
    NSMutableDictionary *views = [NSMutableDictionary dictionaryWithObject:self forKey:@"self"];
    for (UIView *view in self.subviews) {
      NSString *viewString = [NSString stringWithFormat:@"view_%lu", (unsigned long)[self.subviews indexOfObject:view]];
      [visualFormatString appendString:[NSString stringWithFormat:@"[%@(self)]", viewString]];
      [views setObject:view forKey:viewString];
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(self)]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"view":view, @"self":self}]];
    }
    [visualFormatString appendString:@"|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views]];
}
@end
