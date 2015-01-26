#import "MCIntroViewController.h"

#import "MCIntroCollectionViewLayout.h"

static NSString *kIntroCellReuseId = @"cell";

@implementation MCIntroViewController

- (id)init {
  MCIntroCollectionViewLayout *layout = [[MCIntroCollectionViewLayout alloc] init];
  layout.preferredElementSize = CGSizeMake(100, 100);
  layout.numberOfElementsInEachRow = 3;
  layout.isFlexibleWidth = YES;
  layout.spacing = 8;
  return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:kIntroCellReuseId];
  self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [self.collectionView dequeueReusableCellWithReuseIdentifier:kIntroCellReuseId
                                                     forIndexPath:indexPath];
  cell.backgroundColor = [UIColor blackColor];
  return cell;
}

@end
