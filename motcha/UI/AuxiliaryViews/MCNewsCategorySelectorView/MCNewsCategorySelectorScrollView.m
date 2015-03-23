#import "MCNewsCategorySelectorScrollView.h"

#import "MCNewsCategoryIndicatorView.h"
#import "NSMutableArray+Manipulation.h"

static void *scrollViewContext = &scrollViewContext;

static CGFloat kCategoryIndicatorHeight             = 4.0f;
static CGFloat kCategoryButtonGroupLeftRightMargin  = 13.0f;
static CGFloat kCategoryButtonSpacing               = 15.0f;

@implementation MCNewsCategorySelectorScrollView {
  UIView *_contentView;
  UIView *_buttonsWrapperView;
  UIView *_indicatorWrapperView;
  MCNewsCategoryIndicatorView *_indicatorView;
  NSMutableArray *_categoriesButtons; // an array of MCCategoryButton*
  __weak MCCategoryButton *_selectedButton;
  __weak MCCategoryButton *_nextButton;
  // Strongly reference to the data source backing scroll view in order to ensure it is not deallocated before the
  // current object is deallocated.
  UIScrollView *_dataSourceScrollView;
  BOOL _observingDataSourceScrollView;
  dispatch_once_t _onceToken;
}

- (instancetype)init {
  if (self = [super init]) {
    _categoriesButtons = [NSMutableArray array];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.canCancelContentTouches = YES;
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

- (NSUInteger)categoryCount {
  return [_categoriesButtons count];
}

- (void)adjustCategoryButtonPositionAnimated:(BOOL)animated {
  CGRect frame = _nextButton.frame;
  frame.origin.x -= kCategoryButtonGroupLeftRightMargin;
  frame.size.width += 2*kCategoryButtonGroupLeftRightMargin;
  // if the button is partially or completely out of view, scroll it to be visible.
  if (![self buttonFrameWithinViewport:frame]) {
    [self setContentOffset:CGPointMake(MIN(frame.origin.x, _contentView.frame.size.width - self.frame.size.width),
                                       self.contentOffset.y)
                  animated:animated];
  }
}

- (void)tapSelectedButtonAnimated:(BOOL)animated {
  if (_selectedButton) {
    [self selectButtonAtIndex:[_categoriesButtons indexOfObject:_selectedButton] animated:animated];
  } else {
    [self selectButtonAtIndex:0 animated:animated];
  }
}

- (void)selectButtonAtIndex:(NSUInteger)index animated:(BOOL)animated {
  if (index >= [_categoriesButtons count]) {
    return;
  }
  MCCategoryButton *button = [_categoriesButtons objectAtIndex:index];
  [self buttonTapped:button animated:animated];
}

#pragma mark - category operations
- (void)addCategories:(NSArray *)categories { // array of NSString *
  if (!categories) {
    return;
  }
  for (NSString *category in categories) {
    [self addCategory:category];
  }
  _dataSourceScrollView = [_mcDataSource backingScrollView];
  [self initIndicatorView];
}

- (void)addCategory:(NSString *)category {
  [self insertCategory:category atIndex:[_categoriesButtons count]];
}

- (void)insertCategory:(NSString *)category atIndex:(NSUInteger)index {
  if (!category) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"category cannot be nil." userInfo:nil];
  }
  MCCategoryButton *newButton = [self createCategoryButtonForCategory:category];
  [self insertCategoryButton:newButton atIndex:index];
}

- (void)insertCategoryButton:(MCCategoryButton *)newButton atIndex:(NSUInteger)index {
  // Sanity check
  if (!newButton) {
    @throw [NSException exceptionWithName:NSInvalidArgumentException
                                   reason:@"category button cannot be nil."
                                 userInfo:nil];
  }
  [_categoriesButtons insertObject:newButton atIndex:index];
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didInsertCategoryButton:atIndex:)]) {
    [_mcDelegate didInsertCategoryButton:newButton atIndex:index];
  }
}

- (MCCategoryButton *)removeCategory:(NSString *)category {
  for (MCCategoryButton *button in _categoriesButtons) {
    NSString *buttonCategory = button.category;
    if ([buttonCategory isEqualToString:category]) {
      NSUInteger index = [_categoriesButtons indexOfObject:button];
      return [self removeCategoryAtIndex:index];
    }
  }
  return nil;
}

- (MCCategoryButton *)removeCategoryAtIndex:(NSUInteger)index {
  MCCategoryButton *button = [_categoriesButtons objectAtIndex:index];
  [self removeCategoryButton:button];
  return button;
}

- (void)removeCategoryButton:(MCCategoryButton *)button {
  NSUInteger index = [_categoriesButtons indexOfObject:button];
  [_categoriesButtons removeObject:button];
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didRemoveCategoryButton:atIndex:)]) {
    [_mcDelegate didRemoveCategoryButton:button atIndex:index];
  }
}

- (void)moveCategoryFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  MCCategoryButton *button = [_categoriesButtons objectAtIndex:fromIndex];
  [_categoriesButtons moveObjectFromIndex:fromIndex toIndex:toIndex];
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didMoveCategoryButton:fromIndex:toIndex:)]) {
    [_mcDelegate didMoveCategoryButton:button fromIndex:fromIndex toIndex:toIndex];
  }
}

- (void)exchangeCategoryButtonAtIndex:(NSUInteger)index1 withCategoryButtonAtIndex:(NSUInteger)index2 {
  [self moveCategoryFromIndex:index1 toIndex:index2];
  [self moveCategoryFromIndex:index2+(index1 < index2 ? -1 : 1) toIndex:index1];
}

- (void)reloadCategoryButtons {
  /*
   1. remove observer if observing
   2. remove buttons from super view
   3. add buttons according to array
   4. add observer
   5. force layout
   */
  [self deobserveScrollViewContentOffset];
  for (MCCategoryButton *button in _buttonsWrapperView.subviews) {
    [button removeFromSuperview];
  }
  NSMutableString *visualFormatString = [NSMutableString stringWithString:@"H:|"];
  NSMutableDictionary *views = [NSMutableDictionary dictionary];
  NSNumber *spacing = [NSNumber numberWithDouble:kCategoryButtonSpacing];
  NSNumber *group_spacing = [NSNumber numberWithDouble:kCategoryButtonGroupLeftRightMargin];
  NSDictionary *metrics = NSDictionaryOfVariableBindings(spacing, group_spacing);
  for (MCCategoryButton *button in _categoriesButtons) {
    [_buttonsWrapperView addSubview:button];
    NSString *viewString =
        [NSString stringWithFormat:@"button_%lu", (unsigned long)[_categoriesButtons indexOfObject:button]];
    if (button == [_categoriesButtons firstObject]) {
      [visualFormatString appendString:[NSString stringWithFormat:@"-(group_spacing)-[%@]", viewString]];
    } else if (button == [_categoriesButtons lastObject]) {
      [visualFormatString appendString:[NSString stringWithFormat:@"-(spacing)-[%@]-(group_spacing)-", viewString]];
    } else {
      [visualFormatString appendString:[NSString stringWithFormat:@"-(spacing)-[%@]", viewString]];
    }
    [views setObject:button forKey:viewString];
    [_buttonsWrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"button":button}]];
  }
  [visualFormatString appendString:@"|"];
  [_buttonsWrapperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
  
  [self observeScrollViewContentOffset];
  [self setNeedsLayout];
  [self layoutIfNeeded];
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(didReloadCategoryButtons)]) {
    [_mcDelegate didReloadCategoryButtons];
  }
}

#pragma mark - NSKeyValueObserving methods
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (context == scrollViewContext) {
    CGFloat contentOffsetX = [(NSValue*)[change objectForKey:@"new"] CGPointValue].x;
    CGFloat pageOffset = contentOffsetX / _dataSourceScrollView.frame.size.width;
    pageOffset = MIN([_categoriesButtons count]-1, MAX(0, pageOffset));
    // The page offset that will be transitioned to.
    CGFloat transitionToPageOffset = round(pageOffset);
    // Get the button that is to be selected during scrollview scrolling.
    MCCategoryButton *buttonToBeSelected = [_categoriesButtons objectAtIndex:transitionToPageOffset];
    if (_selectedButton != buttonToBeSelected) {
      _selectedButton.selected = NO;
      buttonToBeSelected.selected = YES;
      _selectedButton = buttonToBeSelected;
    }
    // Calculate the direction of moving
    static CGFloat sContentOffsetX;
    dispatch_once(&_onceToken, ^{
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
    nextButtonIndex = MAX(0, MIN([_categoriesButtons count]-1, nextButtonIndex));
    MCCategoryButton *nextButton = [_categoriesButtons objectAtIndex:nextButtonIndex];
    MCCategoryButton *currentButton = [_categoriesButtons objectAtIndex:currentButtonIndex];
    if (_nextButton != nextButton) {
      _nextButton = nextButton;
      if (delta != 0) {
        // the scrollview is actually scrolled either manually or programmatically, rather than being caused by
        // orientation change.
        [self adjustCategoryButtonPositionAnimated:YES];
      }
    }
    CGFloat deltaX = nextButton.frame.origin.x - currentButton.frame.origin.x;
    CGFloat deltaWidth = nextButton.frame.size.width - currentButton.frame.size.width;
    // Change the constraints of the indicator view
    _indicatorView.leadingConstraint.constant = currentButton.frame.origin.x + deltaX * pageTransitionPercent;
    _indicatorView.widthConstraint.constant = currentButton.frame.size.width + deltaWidth * pageTransitionPercent;
  }
}

// Enables the scrollview to scroll even when the content view is user-interaction-enabled.
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
  return YES;
}

#pragma mark - Private methods
- (MCCategoryButton *)createCategoryButtonForCategory:(NSString *)category {
  MCCategoryButton *button = [[MCCategoryButton alloc] initWithCategory:category];
  [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (void)buttonTapped:(MCCategoryButton *)sender {
  if (labs([_categoriesButtons indexOfObject:sender] -
           [_categoriesButtons indexOfObject:_selectedButton]) <= [[self visibleButtons] count]) {
    [self buttonTapped:sender animated:YES];
  } else {
    [self buttonTapped:sender animated:NO];
  }
}

- (void)buttonTapped:(MCCategoryButton *)sender animated:(BOOL)animated {
  if (!sender) {
    return;
  }
  if ([_mcDelegate conformsToProtocol:@protocol(MCNewsCategorySelectorScrollViewDelegate)] &&
      [_mcDelegate respondsToSelector:@selector(categoryButtonPressed:atIndex:animated:)]) {
    [_mcDelegate categoryButtonPressed:sender
                               atIndex:[_categoriesButtons indexOfObject:sender]
                              animated:animated];
  }
}

- (NSArray *)visibleButtons {
  NSMutableArray *visibleButtons = [NSMutableArray array];
  for (MCCategoryButton *button in _categoriesButtons) {
    if ([self buttonFrameWithinViewport:button.frame]) {
      [visibleButtons addObject:button];
    }
  }
  return [NSArray arrayWithArray:visibleButtons];
}

- (BOOL)buttonFrameWithinViewport:(CGRect)buttonFrame {
  return (buttonFrame.origin.x + buttonFrame.size.width - self.contentOffset.x <= self.frame.size.width &&
          buttonFrame.origin.x - self.contentOffset.x > 0);
}

- (void)observeScrollViewContentOffset {
  if (!_observingDataSourceScrollView) {
    [_dataSourceScrollView addObserver:self
                            forKeyPath:@"contentOffset"
                               options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                               context:scrollViewContext];
    _observingDataSourceScrollView = YES;
  }
}

- (void)deobserveScrollViewContentOffset {
  if (_observingDataSourceScrollView) {
    [_dataSourceScrollView removeObserver:self forKeyPath:@"contentOffset"];
    _observingDataSourceScrollView = NO;
  }
}

#pragma mark - dealloc
- (void)dealloc {
  [self deobserveScrollViewContentOffset];
}
@end
