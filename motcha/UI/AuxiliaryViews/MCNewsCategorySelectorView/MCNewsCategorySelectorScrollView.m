#import "MCNewsCategorySelectorScrollView.h"

#import "MCNewsCategoryIndicatorView.h"
#import "NSLayoutConstraint+Content.h"

static void *scrollViewContext = &scrollViewContext;

static CGFloat kCategoryIndicatorHeight             = 4.0f;
static CGFloat kCategoryButtonGroupLeftRightMargin  = 13.0f;
static CGFloat kCategoryButtonSpacing               = 15.0f;

typedef UIView<MCNewsItemHorizontalConstraintsProtocol> * ViewWithHConstraints;

@implementation MCNewsCategorySelectorScrollView {
  UIView *_contentView;
  UIView *_buttonsWrapperView;
  UIView *_indicatorWrapperView;
  MCNewsCategoryIndicatorView *_indicatorView;
  NSMutableArray *_categories;
  MCCategoryButton *_selectedButton;
  
  dispatch_once_t _onceToken; // For initializing the indicator view
  dispatch_once_t _onceToken2; // For initializing the static contentOffsetX
}

- (instancetype)initWithDelegate:(id<MCNewsCategorySelectorScrollViewDelegate>)delegate
                      dataSource:(id<MCNewsCategorySelectorScrollViewDataSource>)dataSource {
  if (self = [super initWithFrame:CGRectMake(0, 0, 0, kCategorySelectorViewHeight)]) {
    _categories = [NSMutableArray array];
    _mcDelegate = delegate;
    _mcDataSource = dataSource;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    [self initContentView];
    [self initButtonsWrapperViewAndIndicatorWrapperView];
  }
  return self;
}

- (void)initContentView {
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_contentView];
  NSDictionary *views = NSDictionaryOfVariableBindings(self, _contentView);
  // Constraints for contentView: pin to superView's left and right, same height as scrollView
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView(self)]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
}

- (void)initButtonsWrapperViewAndIndicatorWrapperView {
  _buttonsWrapperView = [[UIView alloc] init];
  _buttonsWrapperView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_buttonsWrapperView];

  
  _indicatorWrapperView = [[UIView alloc] init];
  _indicatorWrapperView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_indicatorWrapperView];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(_buttonsWrapperView, _indicatorWrapperView);
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonsWrapperView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_indicatorWrapperView]|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views]];
  [self addConstraints:
      [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_buttonsWrapperView][_indicatorWrapperView(indicatorHeight)]|"
                              options:0
                              metrics:@{@"indicatorHeight":[NSNumber numberWithDouble:kCategoryIndicatorHeight]}
                                views:views]];
}

- (void)initIndicatorView {
  if (!_indicatorView) {
    // We force the layout of the buttons because we need to ensure that the buttons' frames are available before
    // setting up the indicator view.
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _indicatorView = [[MCNewsCategoryIndicatorView alloc] init];
    [_indicatorWrapperView addSubview:_indicatorView];
    [_indicatorWrapperView addConstraints:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|[_indicatorView]|"
                                           options:0
                                           metrics:nil
                                           views:@{@"_indicatorView":_indicatorView}]];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_indicatorView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_indicatorWrapperView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:0];
    [_indicatorWrapperView addConstraint:leadingConstraint];
    _indicatorView.leadingConstraint = leadingConstraint;
  }
}

- (void)observeScrollViewContentOffset {
  dispatch_once(&_onceToken, ^{
    [[_mcDataSource backingScrollView] addObserver:self
                                        forKeyPath:@"contentOffset"
                                           options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                           context:scrollViewContext];
  });
}

- (NSUInteger)categoryCount {
  return [_categories count];
}

- (void)adjustCategoryButtonPositionAnimated:(BOOL)animated {
  CGRect frame = _selectedButton.frame;
  frame.origin.x -= kCategoryButtonGroupLeftRightMargin;
  frame.size.width += 2*kCategoryButtonGroupLeftRightMargin;
  [self scrollRectToVisible:frame animated:animated];
  
}

- (void)addCategories:(NSArray *)categories { // array of NSString *
  if (!categories) {
    return;
  }
  for (NSString *category in categories) {
    [self addCategory:category];
  }
  [self initIndicatorView];
  [self observeScrollViewContentOffset];
}

- (void)selectButtonAtIndex:(NSUInteger)index animated:(BOOL)animated {
  if (index >= [_categories count]) {
    return;
  }
  MCCategoryButton *button = [_buttonsWrapperView.subviews objectAtIndex:index];
  [self buttonTapped:button animated:animated];
}

#pragma mark - category operations
- (void)addCategory:(NSString *)category {
  [self insertCategory:category atIndex:[_categories count]];
}

- (void)insertCategory:(NSString *)category atIndex:(NSUInteger)index {
  if (!category) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"category cannot be nil." userInfo:nil];
  }
  if (index > [_categories count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"index out of bound." userInfo:nil];
  }
  MCCategoryButton *newButton = [self createCategoryButtonForCategory:category];  
  [self insertCategoryButton:newButton atIndex:index callDelegate:YES];
}

- (void)insertCategoryButton:(MCCategoryButton *)newButton atIndex:(NSUInteger)index callDelegate:(BOOL)callDelegate {
  // Sanity check
  if (!newButton) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"category button cannot be nil."
                                 userInfo:nil];
  }
  if (index > [_categories count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"index out of bound." userInfo:nil];
  }
  // insert new category
  NSString *category = newButton.category;
  [_categories insertObject:category atIndex:index];
  
  MCCategoryButton *prevButton, *curButton;
  @try { prevButton = [_buttonsWrapperView.subviews objectAtIndex:index-1]; } @catch (...) {}
  @try { curButton = [_buttonsWrapperView.subviews objectAtIndex:index]; } @catch (...) {}
  
  [_buttonsWrapperView insertSubview:newButton atIndex:index];
  
  if (!prevButton) { // the new button is to be inserted at the beginning
    NSLayoutConstraint *leadingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:_buttonsWrapperView
                                            andFirstItem:newButton
                                            withConstant:kCategoryButtonGroupLeftRightMargin];
    [_buttonsWrapperView addConstraint:leadingConstraint];
    newButton.constraintWithLeftItem = leadingConstraint;
  } else {
    [_buttonsWrapperView removeConstraint:prevButton.constraintWithRightItem];
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:prevButton
                                          andItem:newButton
                                     withConstant:kCategoryButtonSpacing];
    [_buttonsWrapperView addConstraint:leadingTrailingConstraint];
    newButton.constraintWithLeftItem = leadingTrailingConstraint;
    prevButton.constraintWithRightItem = leadingTrailingConstraint;
  }
  
  if (!curButton) { // the new button is to be inserted at the end
    NSLayoutConstraint *trailingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:_buttonsWrapperView
                                             andLastItem:newButton
                                            withConstant:kCategoryButtonGroupLeftRightMargin];
    [_buttonsWrapperView addConstraint:trailingConstraint];
    newButton.constraintWithRightItem = trailingConstraint;
  } else {
    [_buttonsWrapperView removeConstraint:curButton.constraintWithLeftItem];
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:newButton
                                          andItem:curButton
                                     withConstant:kCategoryButtonSpacing];
    [_buttonsWrapperView addConstraint:leadingTrailingConstraint];
    newButton.constraintWithRightItem = leadingTrailingConstraint;
    curButton.constraintWithLeftItem = leadingTrailingConstraint;
  }
  NSDictionary *views = NSDictionaryOfVariableBindings(newButton);
  [_buttonsWrapperView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newButton]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
  if (callDelegate && [_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didInsertCategoryButton:atIndex:)]) {
    [_mcDelegate didInsertCategoryButton:newButton atIndex:index];
  }
}

- (MCCategoryButton *)removeCategoryAtIndex:(NSUInteger)index {
  MCCategoryButton *button = [_buttonsWrapperView.subviews objectAtIndex:index];
  if (button == _selectedButton) {
    [self buttonTapped:[_buttonsWrapperView.subviews objectAtIndex:0] animated:NO];
  }
  return [self removeCategoryAtIndex:index callDelegate:YES];
}

- (MCCategoryButton *)removeCategoryAtIndex:(NSUInteger)index callDelegate:(BOOL)callDelegate {
  if (index >= [_categories count]) {
    @throw [NSException exceptionWithName:NSRangeException reason:@"index out of bound." userInfo:nil];
  }
  MCCategoryButton *button = [_buttonsWrapperView.subviews objectAtIndex:index];
  MCCategoryButton *prevButton, *nextButton;
  
  @try { prevButton = [_buttonsWrapperView.subviews objectAtIndex:index-1]; } @catch (...) {}
  @try { nextButton = [_buttonsWrapperView.subviews objectAtIndex:index+1]; } @catch (...) {}
  
  [button removeFromSuperview];
  
  if (prevButton && nextButton) {
    NSLayoutConstraint *leadingTrailingConstraint =
        [NSLayoutConstraint constraintBetweenItem:prevButton andItem:nextButton withConstant:kCategoryButtonSpacing];
    [_buttonsWrapperView addConstraint:leadingTrailingConstraint];
    prevButton.constraintWithRightItem = leadingTrailingConstraint;
    nextButton.constraintWithLeftItem = leadingTrailingConstraint;
  } else if (prevButton) {
    NSLayoutConstraint *trailingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:_buttonsWrapperView
                                             andLastItem:prevButton
                                            withConstant:kCategoryButtonGroupLeftRightMargin];
    [_buttonsWrapperView addConstraint:trailingConstraint];
    prevButton.constraintWithRightItem = trailingConstraint;
  } else if (nextButton) {
    NSLayoutConstraint *leadingConstraint =
        [NSLayoutConstraint constraintBetweenContentView:_buttonsWrapperView
                                            andFirstItem:nextButton
                                            withConstant:kCategoryButtonGroupLeftRightMargin];
    [_buttonsWrapperView addConstraint:leadingConstraint];
    nextButton.constraintWithLeftItem = leadingConstraint;
  }
  
  [_categories removeObjectAtIndex:index];
  if (callDelegate && [_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didRemoveCategoryButton:atIndex:)]) {
    [_mcDelegate didRemoveCategoryButton:button atIndex:index];
  }
  return button;
}

- (void)moveCategoryFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  MCCategoryButton *button = [self removeCategoryAtIndex:fromIndex callDelegate:NO];
  [self insertCategoryButton:button atIndex:toIndex callDelegate:NO];
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didMoveCategoryButton:fromIndex:toIndex:)]) {
    [_mcDelegate didMoveCategoryButton:button fromIndex:fromIndex toIndex:toIndex];
  }
  if (button == _selectedButton) {
    [self buttonTapped:button animated:NO];
  }
}

- (void)exchangeCategoryButtonAtIndex:(NSUInteger)index1 withCategoryButtonAtIndex:(NSUInteger)index2 {
  [self moveCategoryFromIndex:index1 toIndex:index2];
  [self moveCategoryFromIndex:index2+(index1 < index2 ? -1 : 1) toIndex:index1];
}

#pragma mark - NSKeyValueObserving methods
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (context == scrollViewContext) {
    CGFloat contentOffsetX = [(NSValue*)[change objectForKey:@"new"] CGPointValue].x;
    CGFloat pageOffset = contentOffsetX / [_mcDataSource backingScrollView].frame.size.width;
    pageOffset = MIN([_buttonsWrapperView.subviews count]-1, MAX(0, pageOffset));
    // Calculate the direction of moving
    static CGFloat sContentOffsetX;
    dispatch_once(&_onceToken2, ^{
      sContentOffsetX = contentOffsetX;
    });
    CGFloat delta = contentOffsetX - sContentOffsetX;
    sContentOffsetX = contentOffsetX;
    // Calculate the current button index and next-to-appear button index
    CGFloat pageTransitionPercent = pageOffset - (NSUInteger)pageOffset;
    NSUInteger currentButtonIndex;
    NSUInteger nextButtonIndex;
    if (delta >= 0) { // scroll right, get the next page index
      nextButtonIndex = ceil(pageOffset);
      currentButtonIndex = floor(pageOffset);
    } else if (delta < 0) { // scroll left, get the previous page index
      nextButtonIndex = floor(pageOffset);
      currentButtonIndex = ceil(pageOffset);
      pageTransitionPercent = 1.0f - pageTransitionPercent;
    }
    nextButtonIndex = MAX(0, MIN([_buttonsWrapperView.subviews count]-1, nextButtonIndex));
    MCCategoryButton *nextButton = [_buttonsWrapperView.subviews objectAtIndex:nextButtonIndex];
    MCCategoryButton *currentButton = [_buttonsWrapperView.subviews objectAtIndex:currentButtonIndex];
    CGFloat deltaX = nextButton.frame.origin.x - currentButton.frame.origin.x;
    CGFloat deltaWidth = nextButton.frame.size.width - currentButton.frame.size.width;
    // Change the constraints of the indicator view
    _indicatorView.leadingConstraint.constant = currentButton.frame.origin.x + deltaX * pageTransitionPercent;
    _indicatorView.widthConstraint.constant = currentButton.frame.size.width + deltaWidth * pageTransitionPercent;
    if (nextButtonIndex == pageOffset) {
      // when the next or prev page is reached, or the default initial page is shown, currentButtonIndex is equal
      // to nextButtonIndex, and we activate the current button.
      _selectedButton.selected = NO;
      currentButton.selected = YES;
      _selectedButton = currentButton;
    }
  }
}

#pragma mark - Private methods
- (MCCategoryButton *)createCategoryButtonForCategory:(NSString *)category {
  MCCategoryButton *button = [[MCCategoryButton alloc] initWithCategory:category];
  [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (void)buttonTapped:(MCCategoryButton *)sender {
  [self buttonTapped:sender animated:YES];
}

- (void)buttonTapped:(MCCategoryButton *)sender animated:(BOOL)animated {
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(categoryButtonPressed:atIndex:animated:)]) {
    [_mcDelegate categoryButtonPressed:sender
                               atIndex:[_buttonsWrapperView.subviews indexOfObject:sender]
                              animated:animated];
  }
}
@end
