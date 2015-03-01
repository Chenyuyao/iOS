#import "MCNewsListViewController.h"

#import "MCNewsListCollectionViewCell.h"
#import "MCNewsDetailViewController.h"
#import "MCNewsListCollectionViewLayout.h"
#import "MCNavigationController.h"

static NSString *kMCCollectionViewCellReuseId = @"MCCollectionViewCell";

@implementation MCNewsListViewController {
  NSArray *_thumbNails;
}

- (id)init {
  [self setTitle:@"News List"];
  MCNewsListCollectionViewLayout *layout = [[MCNewsListCollectionViewLayout alloc] init];
  layout.numberOfElementsInEachRow = 1;
  layout.spacing = 0;
  layout.margin = 0;
  layout.isFlexibleWidth = YES;
  layout.preferredElementSize = CGSizeMake(320, 100);
  return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.collectionView.scrollsToTop = NO;
  self.automaticallyAdjustsScrollViewInsets = NO;
  // Register cell classes
  [self.collectionView registerNib:[UINib nibWithNibName:@"MCNewsListCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:kMCCollectionViewCellReuseId];
  _thumbNails = [NSArray arrayWithObjects:
      @"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg",
      @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg",
      @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  MCNavigationBar *navigationBar = (MCNavigationBar *)self.navigationController.navigationBar;
  CGFloat navigationBarAppearanceHeight =
      navigationBar.backgroundHeight + navigationBar.auxiliaryView.frame.size.height;
  self.collectionView.contentInset = UIEdgeInsetsMake(navigationBarAppearanceHeight, 0, 0, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  // TODO: replace with real data
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  // TODO: replace with real data
  return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kMCCollectionViewCellReuseId forIndexPath:indexPath];
  // Configure the cell
  // TODO: pull real data and set the cell details
  return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MCNewsDetailViewController *detailViewController = [[MCNewsDetailViewController alloc] init];
  [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UIContentContainer
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  BOOL scrollViewAtTop = NO;
  if (self.collectionView.contentOffset.y <= -1*self.collectionView.contentInset.top) {
    scrollViewAtTop = YES;
  }
  MCNavigationBar *navigationBar = (MCNavigationBar *)self.navigationController.navigationBar;
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    CGFloat navigationBarAppearanceHeight = navigationBar.backgroundHeight;
    self.collectionView.contentInset = UIEdgeInsetsMake(navigationBarAppearanceHeight, 0, 0, 0);
    if (scrollViewAtTop) {
      [self.collectionView setContentOffset:CGPointMake(0, -1*self.collectionView.contentInset.top) animated:YES];
    }
  }];

}

@end