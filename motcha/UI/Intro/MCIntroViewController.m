#import "MCIntroViewController.h"

#import "MCIntroHeader.h"
#import "MCIntroCell.h"
#import "MCIntroFooter.h"
#import "MCIntroCollectionViewLayout.h"
#import "MCNewsListsContainerController.h"
#import "MCNavigationController.h"
#import "UIColor+Helpers.h"
#import "MCNewsCategorySelectorView.h"
#import "MCCategorySourceService.h"

static NSString * const reuseHeader = @"HeaderView";
static NSString * const reuseCell = @"Cell";
static NSString * const reuseFooter = @"FooterView";
static NSString * const minSelectedMsg = @"Please select at least three categories to get started.";
static NSInteger minSelectedCategories = 4;

@implementation MCIntroViewController {
  __block NSMutableArray *_selectedCategories; // an array of NSString *
  BOOL _isFirstTimeUser;
  __block NSMutableArray *_allCategories; // an array of MCCategory *
  NSArray *_categoriesToIgnore;
  MCIntroHeader *_header;
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
  return [super initWithCollectionViewLayout:layout];
}

- (instancetype)initWithSuperNavigationController:(UINavigationController *)navigationController
                                  isFirstTimeUser:(BOOL)isFirstTimeUser {
  if (self = [self init]) {
    _superNavigationController = navigationController;
    _isFirstTimeUser = isFirstTimeUser;
    _selectedCategories = [NSMutableArray array];
    _categoriesToIgnore = @[recommendedCategory]; // For now, only RECOMMENDED is ignored.
    UIBarButtonItem *completeButton =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                    target:self
                                                    action:@selector(finishButtonTapped)];
    self.navigationItem.rightBarButtonItem = completeButton;
    if (!_isFirstTimeUser) {
      self.navigationItem.title = @"Select Categories";
      ((MCIntroCollectionViewLayout *) self.collectionViewLayout).headerHeight = 20.0f;
      ((MCIntroCollectionViewLayout *) self.collectionViewLayout).footerHeight = 0.0f;
    } else {
      // Import all available categories into the local datastore.
      [[MCCategorySourceService sharedInstance] importCategories];
    }
    
    id fetchAllBlock = ^(NSArray *categories, NSError *error) {
      if (!error) {
        _allCategories = [categories mutableCopy];
      } else {
        NSLog(@"ERROR: Fetching all categories error: %@", error);
      }
    };
    id fetchSelectedBlock = ^(NSArray *selectedCategories, NSError *error) {
      if (!error) {
        for (NSString *category in selectedCategories) {
          [_selectedCategories addObject:category];
        }
        for (MCCategory *category in _allCategories) {
          if ([category.category isEqualToString:recommendedCategory]) {
            [_allCategories removeObject:category];
            break;
          }
        }
      }
    };
    [[MCCategorySourceService sharedInstance] fetchAllCategoriesAsync:NO withBlock:fetchAllBlock];
    [[MCCategorySourceService sharedInstance] fetchSelectedCategoriesAsync:NO withBlock:fetchSelectedBlock];
  }
  return self;
}

- (void) loadView {
  [super loadView];
  if (_isFirstTimeUser) {
    self.navigationController.navigationBarHidden = YES;
  } else {
    self.navigationController.navigationBarHidden = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (_isFirstTimeUser) {
    self.collectionView.contentInset =
        UIEdgeInsetsMake(0, 0, ((MCIntroCollectionViewLayout *) self.collectionViewLayout).footerHeight, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.allowsMultipleSelection = YES;
  UINib *headerNib = [UINib nibWithNibName:@"MCIntroHeader" bundle:nil];
  [self.collectionView registerNib:headerNib
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:reuseHeader];
  
  self.collectionView.backgroundColor = [UIColor appMainColor];
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
                                 atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *reusableview = nil;
  
  if (kind == UICollectionElementKindSectionHeader) {
    _header =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:reuseHeader
                                                  forIndexPath:indexPath];
    [self updateHeader:_header forIndexPath:indexPath];
    reusableview = _header;
  }
  
  if (kind == UICollectionElementKindSectionFooter) {
    MCIntroFooter *footer =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:reuseFooter
                                              forIndexPath:indexPath];
    [self updateFooter:footer forIndexPath:indexPath];
    reusableview = footer;
  }
  
  return reusableview;
}

- (void)updateHeader:(MCIntroHeader *)header forIndexPath:(NSIndexPath *)indexPath {
  if (_isFirstTimeUser) {
    header.title.text = @"Welcome to Motcha";
    header.instruction.text = @"For Motcha to better understand you,\nPlease select some categories to start.";
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
  return [_allCategories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MCIntroCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
  [self updateCell:cell forIndexPath:indexPath];
  return cell;
}

- (void)updateCell:(MCIntroCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  MCCategory *category = [_allCategories objectAtIndex:indexPath.row];
  cell.imageView.image = [UIImage imageNamed:category.category];
  cell.title.text = category.category;
  if (category.selected) {
    cell.selected = YES;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:0];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  MCCategory *category = [_allCategories objectAtIndex:indexPath.row];
  [_selectedCategories addObject:category.category];
  if ([_delegate conformsToProtocol:@protocol(MCIntroViewControllerDelegate)] &&
      [_delegate respondsToSelector:@selector(introViewController:didSelectCategory:)]) {
    [_delegate introViewController:self didSelectCategory:category.category];
  }
}

- (void)collectionView:(UICollectionView *)collectionView
    didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  MCCategory *category = [_allCategories objectAtIndex:indexPath.row];
  [_selectedCategories removeObject:category.category];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (_header) {
    CGFloat offset = self.collectionView.contentOffset.y;
    _header.alpha = MAX(1 - offset / 75, 0);
  }
}

#pragma mark Private

- (void)finishButtonTapped {
  [self completeSelecting];
}

- (void)completeSelecting {
  if ([_selectedCategories count] < minSelectedCategories) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:minSelectedMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
  } else {
    __block NSArray *originalSelectedCategories;
    [[MCCategorySourceService sharedInstance] fetchSelectedCategoriesAsync:NO withBlock:^(NSArray *categories, NSError *error) {
      if (!error) {
        originalSelectedCategories = categories;
      }
    }];
    BOOL changed = (![originalSelectedCategories isEqualToArray:_selectedCategories]);
    if ([_delegate
        respondsToSelector:@selector(introViewController:didFinishChangingCategories:changed:)]) {
      [_delegate introViewController:self didFinishChangingCategories:_selectedCategories changed:changed];
    }
    if (!changed) {
      [self dismissViewControllerAnimated:YES completion:nil];
      return;
    }
    id block = ^(NSError *error) {
        if (_isFirstTimeUser) {
          MCNewsListsContainerController *newsListsController =
              [[MCNewsListsContainerController alloc] initWithCategories:_selectedCategories];
          [self.navigationController setViewControllers:@[ newsListsController ] animated:YES];
        } else {
          [self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [[MCCategorySourceService sharedInstance] storeSelectedCategories:_selectedCategories async:NO withBlock:block];
  }
}

@end