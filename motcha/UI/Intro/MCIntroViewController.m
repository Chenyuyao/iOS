#import "MCIntroViewController.h"
#import "MCIntroHeader.h"
#import "MCIntroCell.h"
#import "MCIntroFooter.h"
#import "MCIntroCollectionViewLayout.h"
#import "MCNewsListsContainerController.h"
#import "MCReadingPreferenceService.h"

static NSString * const reuseHeader = @"HeaderView";
static NSString * const reuseCell = @"Cell";
static NSString * const reuseFooter = @"FooterView";
static NSInteger minSelectedCategories = 3;

@implementation MCIntroViewController {
  NSMutableArray *_selectedCategories;
}

- (instancetype)init {
  MCIntroCollectionViewLayout *layout = [[MCIntroCollectionViewLayout alloc] init];
  layout.numberOfElementsInEachRow = 3;
  layout.spacing = 5.0f;
  layout.margin = 15.0f;
  layout.isFlexibleWidth = YES;
  layout.headerHeight = 135.0f;
  layout.footerHeight = 50.0f;
  layout.preferredElementSize = CGSizeMake(100, 100);
  _selectedCategories = [[NSMutableArray alloc] init];
  return [super initWithCollectionViewLayout:layout];
}

- (instancetype)initWithSelectedCategories:(NSArray *)categories {
  self = [self init];
  if (self) {
    _selectedCategories = [NSMutableArray arrayWithArray:categories];
    [_selectedCategories removeObject:@"Recommended"];
    ((MCIntroCollectionViewLayout *) self.collectionViewLayout).headerHeight = 80.0f;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.allowsMultipleSelection = YES;
  UINib *headerNib = [UINib nibWithNibName:@"MCIntroHeader" bundle:nil];
  [self.collectionView registerNib:headerNib
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:reuseHeader];
  
  self.collectionView.backgroundColor = [UIColor whiteColor];
  UINib *cellNib = [UINib nibWithNibName:@"MCIntroCell" bundle:nil];
  [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseCell];
  
  UINib *footerNib = [UINib nibWithNibName:@"MCIntroFooter" bundle:nil];
  [self.collectionView registerNib:footerNib
        forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
               withReuseIdentifier:reuseFooter];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
    viewForSupplementaryElementOfKind:(NSString *)kind
      atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableview = nil;
  
  if (kind == UICollectionElementKindSectionHeader) {
    MCIntroHeader *header =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:reuseHeader forIndexPath:indexPath];
    [self updateHeader:header forIndexPath:indexPath];
    reusableview = header;
  }
  
  if (kind == UICollectionElementKindSectionFooter) {
    MCIntroFooter *footer =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:reuseFooter forIndexPath:indexPath];
    [self updateFooter:footer forIndexPath:indexPath];
    reusableview = footer;
  }
  
  return reusableview;
}

- (void)updateHeader:(MCIntroHeader *)header forIndexPath:(NSIndexPath *)indexPath {
  if (!_selectedCategories.count) {
  header.title.text = @"Welcome to Motcha";
  header.instruction.text = @"For Motcha to better understand you,\nPlease select some categories to start.";
  } else {
    header.title.text = @"Please select categories";
  }
}

- (void)updateFooter:(MCIntroFooter *)footer forIndexPath:(NSIndexPath *)indexPath {
  footer.title.text = @"FINISH >";
  UITapGestureRecognizer *tapGestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishButtonTapped)];
  [footer addGestureRecognizer:tapGestureRecognizer];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [[[self class] categories] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MCIntroCell *cell =
  [collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
  [self updateCell:cell forIndexPath:indexPath];
  return cell;
}

- (void)updateCell:(MCIntroCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  NSString *category = [[self class] categories][indexPath.row];
  cell.imageView.image = [UIImage imageNamed:category];
  cell.title.text = category;
  if ([_selectedCategories containsObject:category]) {
    cell.selected = YES;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:0];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 [_selectedCategories addObject:[[self class] categories][indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  [_selectedCategories removeObject:[[self class] categories][indexPath.row]];
}

#pragma mark Private

- (void)finishButtonTapped {
  if ([_selectedCategories count] < minSelectedCategories) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Please select at least three categories to get started."
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
    [alert show];
  } else {
    MCNewsListsContainerController *newsListsController =
        [[MCNewsListsContainerController alloc] initWithCategories:_selectedCategories];
    [self.navigationController setViewControllers:@[newsListsController] animated:YES];
    [[MCReadingPreferenceService sharedInstance] setCategories:_selectedCategories];
  }
}

+ (NSArray *)categories {
  // TODO(sherry): Add more.
  static NSArray *categories;
  if (!categories) {
    categories = @[@"TECHNOLOGY", @"FINANCE", @"ARTS", @"INTERNATIONAL", @"SPORTS",
                   @"ENTERTAINMENT", @"FASHION", @"DESIGN", @"HEALTH"];
  }
  return categories;
}

@end