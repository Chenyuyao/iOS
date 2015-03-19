#import "MCNewsListViewController.h"

#import "MCParsedRSSItem.h"
#import "MCNewsListTableViewCell.h"
#import "MCNewsDetailViewController.h"
#import "MCNavigationController.h"
#import "MCRSSService.h"

static NSString *kMCTableViewCellReuseId = @"MCTableViewCell";
static CGFloat kCellHeight = 141.0f;

@implementation MCNewsListViewController {
  NSArray *_thumbNails;
  BOOL _viewAppeared;
  NSMutableArray *_rssItems;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.scrollsToTop = NO;
  self.tableView.rowHeight = kCellHeight;
  self.automaticallyAdjustsScrollViewInsets = NO;
  // Register cell classes
  [self.tableView registerNib:[UINib nibWithNibName:@"MCNewsListTableViewCell" bundle:nil]
       forCellReuseIdentifier:kMCTableViewCellReuseId];

  id block = ^(NSMutableArray *feeds, NSError *parseError) {
    NSLog(@"In total there are %lu feeds on %@", (unsigned long)[feeds count], [self category]);
  };
  [[MCRSSService sharedInstance]
   fetchRSSWithCategory:self.category
   since:[NSDate dateWithTimeIntervalSince1970:0]
   completionBlock:block];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  MCNavigationBar *navigationBar = (MCNavigationBar *)self.navigationController.navigationBar;
  CGFloat navigationBarAppearanceHeight =
      navigationBar.backgroundHeight + navigationBar.auxiliaryView.frame.size.height;
  self.tableView.contentInset = UIEdgeInsetsMake(navigationBarAppearanceHeight, 0, 0, 0);
  self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  _viewAppeared = YES;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!_viewAppeared) {
    // This resolves the issue where the scroll view is not scrolled to top on page appeared, after a custom
    // cell height is applied.
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // TODO(Frank): Incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // TODO(Frank): Incomplete method implementation.
  // Return the number of rows in the section.
  return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMCTableViewCellReuseId forIndexPath:indexPath];
  
  // TODO(Frank): Configure the cell...
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MCParsedRSSItem *item = [[MCParsedRSSItem alloc]
      initWithTitle:@"Lonnie Johnson, the rocket scientist and Super Soaker inventor"
               link:@"http://www.engadget.com/2015/02/27/lonnie-johnson-the-rocket-scientist-and-super-soaker-inventor/"
            descrpt:@""
             imgSrc:@"http://o.aolcdn.com/hss/storage/midas/"
                           "cc4aee7d63afc7913790b8c38ab27566/201625613/gs6lead.jpg"
            pubDate:nil
             author:@"Unknown"];
  MCNewsDetailViewController *detailViewController =
      [[MCNewsDetailViewController alloc] initWithRSSItem:item];
  [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UIContentContainer
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  BOOL scrollViewAtTop = NO;
  if (self.tableView.contentOffset.y <= -1*self.tableView.contentInset.top) {
    scrollViewAtTop = YES;
  }
  MCNavigationBar *navigationBar = (MCNavigationBar *)self.navigationController.navigationBar;
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    CGFloat navigationBarAppearanceHeight = navigationBar.backgroundHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(navigationBarAppearanceHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    if (scrollViewAtTop) {
      [self.tableView setContentOffset:CGPointMake(0, -1*self.tableView.contentInset.top) animated:YES];
    }
  }];
}

@end
