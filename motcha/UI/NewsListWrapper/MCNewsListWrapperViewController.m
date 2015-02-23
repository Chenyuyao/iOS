#import "MCNewsListWrapperViewController.h"

#import "MCNavigationBarCustomizationDelegate.h"
#import "MCNewsCategorySelectorScrollView.h"
#import "MCNewsListViewController.h"
#import "MCNavigationController.h"

@interface MCNewsListWrapperViewController ()<MCNavigationBarCustomizationDelegate,
    MCNewsCategorySelectorScrollViewDelegate, MCNewsCategorySelectorScrollViewDataSource,
    MCPageViewControllerDelegate>
@end

@implementation MCNewsListWrapperViewController {
  NSMutableArray *_categories; // array of NSString *
  MCNewsCategorySelectorScrollView *_newsCategoryView;
}

- (instancetype)init {
  if (self = [super init]) {
    _categories = [NSMutableArray array];
    _pageViewController = [[MCPageViewController alloc] init];
    _pageViewController.delegate = self;
    [_pageViewController registerClass:[MCNewsListViewController class]];
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  [self addChildViewController:self.pageViewController];
  UIView *pageView = self.pageViewController.view;
  [self.view addSubview:pageView];
  NSDictionary *viewDict = NSDictionaryOfVariableBindings(pageView);
  [self.view addConstraints:
       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView]|"
                                               options:0
                                               metrics:nil
                                                 views:viewDict]];
  [self.view addConstraints:
       [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView]|"
                                               options:0
                                               metrics:nil
                                                 views:viewDict]];
  [self.pageViewController didMoveToParentViewController:self];
  self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _newsCategoryView = [[MCNewsCategorySelectorScrollView alloc] initWithDelegate:self dataSource:self];
  // TODO: replace the fake data with the server call
  [_categories addObjectsFromArray:
      @[@"Recommended", @"Popular", @"Technology", @"Kitchener", @"International", @"Car", @"Food"]];
  [_newsCategoryView addCategories:_categories];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [(MCNavigationController *)self.navigationController notifyViewControllerWillAppearAnimated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // set the initial showing page here. Default is index 0.
  [_newsCategoryView selectButtonAtIndex:2 animated:YES];
}

#pragma mark - MCNewsCategorySelectorScrollViewDataSource methods
- (UIScrollView *)backingScrollView {
  return (UIScrollView *)self.pageViewController.view;
}

#pragma mark - MCNewsCategorySelectorScrollViewDelegate methods
- (void)moreCategoriesButtonPressed {
  // TODO: The "+" button to be implemented.
}

- (void)categoryButtonPressed:(MCCategoryButton *)button atIndex:(NSUInteger)index animated:(BOOL)animated {
  UIViewController *viewController = [self.pageViewController viewControllerAtIndex:index];
  [self.pageViewController.pageView scrollRectToVisible:viewController.view.frame animated:animated];
}

- (void)didInsertCategoryButton:(MCCategoryButton *)button atIndex:(NSUInteger)index {
  [self.pageViewController insertViewControllerAtIndex:index];
}

- (void)didRemoveCategoryButton:(MCCategoryButton *)button atIndex:(NSUInteger)index {
  [self.pageViewController removeViewControllerAtIndex:index];
}

- (void)didMoveCategoryButton:(MCCategoryButton *)button fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  [self.pageViewController moveViewControllerFromIndex:fromIndex toIndex:toIndex];
}

#pragma mark - MCPageViewControllerDelegate methods
- (void)pageViewController:(MCPageViewController *)pageViewController
     pageDidFinishAnimated:(BOOL)animated
           withCurrentPage:(UIViewController *)viewController
                   atIndex:(NSUInteger)index {
  [_newsCategoryView adjustCategoryButtonPositionAnimated:animated];
  // TODO: update the current page
  for (NSInteger i = 0; i < [self.pageViewController viewControllerCount]; ++i) {
    MCNewsListViewController *viewController =
        (MCNewsListViewController *)[self.pageViewController viewControllerAtIndex:i];
    viewController.collectionView.scrollsToTop = NO;
    
  }
  MCNewsListViewController *newsListViewController = (MCNewsListViewController *)viewController;
  newsListViewController.collectionView.scrollsToTop = YES;
}

- (void)pageViewController:(MCPageViewController *)pageViewController
    willLoadViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index {
  MCNewsListViewController *theViewController = (MCNewsListViewController *)viewController;
  theViewController.category = [_categories objectAtIndex:index];
}

- (void)pageViewController:(MCPageViewController *)pageViewController
     didLoadViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index {

}

#pragma mark - MCNavigationBarCustomizationDelegate methods
@synthesize navigationBarAuxiliaryView = _navigationBarAuxiliaryView;

- (UIView*)navigationBarAuxiliaryView {
  if (!_navigationBarAuxiliaryView) {
    _navigationBarAuxiliaryView = _newsCategoryView;
  }
  return _navigationBarAuxiliaryView;
}

#pragma mark - UIContentContainer methods
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    [_newsCategoryView adjustCategoryButtonPositionAnimated:YES];
  } completion:nil];
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
