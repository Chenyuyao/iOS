#import "MCPageView.h"

#import "NSLayoutConstraint+Content.h"

@implementation MCPageView

- (instancetype)init {
  if (self = [super init]) {
    self.backgroundColor = [UIColor whiteColor];
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
- (void)insertPageViewItem:(UIView<MCNewsItemHorizontalConstraintsProtocol> *)viewItem atIndex:(NSUInteger)index {
  if (!viewItem) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"page view item cannot be nil."
                                 userInfo:nil];
  }
  if (index > [self.subviews count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"index out of bound." userInfo:nil];
  }
  
  UIView<MCNewsItemHorizontalConstraintsProtocol> *prevViewItem, *currentViewItem;
  @try { prevViewItem = [self.subviews objectAtIndex:index-1]; } @catch (...) {}
  @try { currentViewItem = [self.subviews objectAtIndex:index]; } @catch (...) {}
  [self insertSubview:viewItem atIndex:index];
  
  if (!prevViewItem) { // the new button is to be inserted at the beginning
    NSLayoutConstraint *leadingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:self andFirstItem:viewItem withConstant:0];
    [self addConstraint:leadingConstraint];
    viewItem.constraintWithLeftItem = leadingConstraint;
  } else {
    [self removeConstraint:prevViewItem.constraintWithRightItem];
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:prevViewItem andItem:viewItem withConstant:0];
    [self addConstraint:leadingTrailingConstraint];
    viewItem.constraintWithLeftItem = leadingTrailingConstraint;
    prevViewItem.constraintWithRightItem = leadingTrailingConstraint;
  }
  
  if (!currentViewItem) { // the new button is to be inserted at the end
    NSLayoutConstraint *trailingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:self andLastItem:viewItem withConstant:0];
    [self addConstraint:trailingConstraint];
    viewItem.constraintWithRightItem = trailingConstraint;
  } else {
    [self removeConstraint:currentViewItem.constraintWithLeftItem];
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:viewItem andItem:currentViewItem withConstant:0];
    [self addConstraint:leadingTrailingConstraint];
    viewItem.constraintWithRightItem = leadingTrailingConstraint;
    currentViewItem.constraintWithLeftItem = leadingTrailingConstraint;
  }
  NSDictionary *views = NSDictionaryOfVariableBindings(viewItem, self);
  [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewItem(self)]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:viewItem
                                                   attribute:NSLayoutAttributeWidth
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeWidth
                                                  multiplier:1
                                                    constant:0]];
}

- (ViewWithHConstraints *)removePageViewItem:(ViewWithHConstraints *)viewItem atIndex:(NSUInteger)index {
  if (index >= [self.subviews count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"index out of bound." userInfo:nil];
  }
  ViewWithHConstraints *theViewItem = [self.subviews objectAtIndex:index];
  NSAssert(viewItem == theViewItem, nil);
  UIView<MCNewsItemHorizontalConstraintsProtocol> *prevViewItem, *nextViewItem;
  @try { prevViewItem = [self.subviews objectAtIndex:index-1]; } @catch (...) {}
  @try { nextViewItem = [self.subviews objectAtIndex:index+1]; } @catch (...) {}
  [theViewItem removeFromSuperview];
  if (prevViewItem && nextViewItem) {
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:prevViewItem andItem:nextViewItem withConstant:0];
    [self addConstraint:leadingTrailingConstraint];
    prevViewItem.constraintWithRightItem = leadingTrailingConstraint;
    nextViewItem.constraintWithLeftItem = leadingTrailingConstraint;
  } else if (prevViewItem) {
    NSLayoutConstraint *trailingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:self andLastItem:prevViewItem withConstant:0];
    [self addConstraint:trailingConstraint];
    prevViewItem.constraintWithRightItem = trailingConstraint;
  } else if (nextViewItem) {
    NSLayoutConstraint *leadingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:self andFirstItem:nextViewItem withConstant:0];
    [self addConstraint:leadingConstraint];
    nextViewItem.constraintWithLeftItem = leadingConstraint;
  }
  return theViewItem;
}

- (void)movePageViewItem:(ViewWithHConstraints *)viewItem fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  if (!viewItem) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"page view item cannot be nil."
                                 userInfo:nil];
  }
  if (fromIndex > [self.subviews count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"fromIndex out of bound." userInfo:nil];
  }
  if (toIndex > [self.subviews count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"toIndex out of bound." userInfo:nil];
  }
  ViewWithHConstraints *view = [self removePageViewItem:viewItem atIndex:fromIndex];
  [self insertPageViewItem:view atIndex:toIndex];
}
@end
