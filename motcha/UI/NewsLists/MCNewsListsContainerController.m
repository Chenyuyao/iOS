#import "MCNewsListsContainerController.h"

#import "MCNavigationBarCustomizationDelegate.h"
#import "MCNewsCategorySelectorView.h"
#import "MCNewsListViewController.h"
#import "MCNavigationController.h"
#import "UIFont+DINFont.h"
#import "MCIntroViewController.h"

static CGFloat kLogoFontSize = 25.0f;

static NSString *kRecommendedCategory = @"Recommended";

@interface MCNewsListsContainerController ()
<
  MCNavigationBarCustomizationDelegate,
  MCNewsCategorySelectorViewDelegate,
  MCNewsCategorySelectorScrollViewDelegate,
  MCNewsCategorySelectorScrollViewDataSource,
  MCPageViewControllerDelegate
>
@end

@implementation MCNewsListsContainerController {
  NSMutableArray *_categories; // array of NSString *
  MCNewsCategorySelectorView *_newsCategoryView;
}

- (instancetype)initWithCategories:(NSArray *)categories {
  if (self = [super init]) {
    _categories = [NSMutableArray arrayWithObject:kRecommendedCategory];
    [_categories addObjectsFromArray:categories];
    _pageViewController = [[MCPageViewController alloc] init];
    _pageViewController.delegate = self;
    [_pageViewController registerClass:[MCNewsListViewController class]];
  }
  return self;
}

- (void)loadView {
  self.navigationController.navigationBarHidden = NO;
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
  // Add logo button
  UIButton *logoButton = [[UIButton alloc] init];
  [logoButton setTitle:@"Motcha" forState:UIControlStateNormal];
  [logoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  logoButton.titleLabel.font = [UIFont dinBoldFontWithSize:kLogoFontSize];
  [logoButton sizeToFit];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoButton];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _newsCategoryView = [[MCNewsCategorySelectorView alloc] init];
  _newsCategoryView.mcDelegate = self;
  _newsCategoryView.categoryScrollView.mcDelegate = self;
  _newsCategoryView.categoryScrollView.mcDataSource = self;
  [_newsCategoryView.categoryScrollView addCategories:_categories];
  [_newsCategoryView.categoryScrollView reloadCategoryButtons];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [(MCNavigationController *)self.navigationController notifyViewWillAppearAnimated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // set the initial showing page here. Default is index 0.
  /* [_newsCategoryView selectButtonAtIndex:2 animated:YES]; */
}

#pragma mark - MCNewsCategorySelectorScrollViewDataSource methods
- (UIScrollView *)backingScrollView {
  return (UIScrollView *)self.pageViewController.view;
}

#pragma mark - MCNewsCategorySelectorViewDelegate methods
- (void) addCategoriesButtonPressed {
  NSLog(@"pressed!");
  MCIntroViewController *introViewController =
      [[MCIntroViewController alloc] initWithSelectedCategories:_categories];
  [self.navigationController setViewControllers:@[introViewController] animated:YES];
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

- (void)didReloadCategoryButtons {
  [_pageViewController reloadViewControllers];
  [_newsCategoryView.categoryScrollView tapSelectedButtonAnimated:NO];
}

#pragma mark - MCPageViewControllerDelegate methods
- (void)pageViewController:(MCPageViewController *)pageViewController
     pageDidFinishAnimated:(BOOL)animated
           withCurrentPage:(UIViewController *)viewController
                   atIndex:(NSUInteger)index {
  for (NSInteger i = 0; i < [self.pageViewController viewControllerCount]; ++i) {
    MCNewsListViewController *viewController =
        (MCNewsListViewController *)[self.pageViewController viewControllerAtIndex:i];
    viewController.tableView.scrollsToTop = NO;
    
  }
  MCNewsListViewController *newsListViewController = (MCNewsListViewController *)viewController;
  newsListViewController.tableView.scrollsToTop = YES;
  // TODO(Frank): Reload the current view controller.
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
@end
