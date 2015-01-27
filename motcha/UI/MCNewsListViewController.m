#import "MCNewsListViewController.h"
#import "MCNewsListDetailViewController.h"
#import "MCNewsListCollectionViewCell.h"

static NSString *kNewsListCellReuseId = @"MCCollectionViewCell";

@interface MCNewsListViewController ()

@end

@implementation MCNewsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"I am news list";
  // Register cell classes
  [self.collectionView registerNib:[UINib nibWithNibName:@"MCNewsListCollectionViewCell"
                                                  bundle:nil]
        forCellWithReuseIdentifier:kNewsListCellReuseId];
  
  // Do any additional setup after loading the view.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  // TODO: Incomplete method implementation -- Return the number of sections
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  // TODO: Incomplete method implementation -- Return the number of items in the section
  return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewsListCellReuseId
                                                                         forIndexPath:indexPath];
  // Configure the cell
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MCNewsListDetailViewController *detailView = [[MCNewsListDetailViewController alloc]
                                                initWithNibName:@"MCNewsListDetailViewController" bundle:nil];
  [self.navigationController pushViewController:detailView animated:YES];
}


@end
