#import "MCNewsListViewController.h"

#import "MCParsedRSSItem.h"
#import "MCNewsListTableViewCell.h"
#import "MCNewsDetailViewController.h"
#import "MCNavigationController.h"
#import "MCRSSService.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Helpers.h"

static NSString *kMCTableViewCellReuseId = @"MCTableViewCell";
static CGFloat kCellHeight = 141.0f;
static CGFloat kNewsUpdateIntervalInSeconds = 60 * 60;

@implementation MCNewsListViewController {
  NSArray *_thumbNails;
  BOOL _viewAppeared;
  NSMutableArray *_rssItems;
  NSDate *_lastUpdateTime;
  // TODO(Frank): Should be set to the latest item's pubDate stored in the local cache, if any.
  NSDate *_lastRetrievedNewsPubDate;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:0];
    _lastRetrievedNewsPubDate = [NSDate dateWithTimeIntervalSince1970:0];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor appMainColor];
  self.tableView.scrollsToTop = NO;
  self.tableView.rowHeight = kCellHeight;
  self.automaticallyAdjustsScrollViewInsets = NO;
  // This will remove extra separators from tableview
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  // Register cell classes
  [self.tableView registerNib:[UINib nibWithNibName:@"MCNewsListTableViewCell" bundle:nil]
       forCellReuseIdentifier:kMCTableViewCellReuseId];

  id completionBlock = ^(NSMutableArray *feeds, NSError *parseError) {
    _rssItems = [feeds copy];
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableView reloadData];
    });
  };
  [[MCRSSService sharedInstance] fetchRSSWithCategory:self.category
                                                since:[NSDate dateWithTimeIntervalSince1970:0]
                                      completionBlock:completionBlock];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  MCNavigationBar *navigationBar = (MCNavigationBar *)self.navigationController.navigationBar;
  CGFloat navigationBarAppearanceHeight = navigationBar.backgroundHeight;
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
  // Assuming we have only one section.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_rssItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MCNewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMCTableViewCellReuseId
                                                                  forIndexPath:indexPath];
  MCParsedRSSItem *item = [_rssItems objectAtIndex:indexPath.row];
  [cell setTitle:item.title];
  [cell setDescription:item.descrpt];
  [cell setPublishDate:item.pubDate];
  [cell setSource:item.source];
  [cell setImageWithUrl:[NSURL URLWithString:item.imgSrc]];
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

#pragma mark - Helpers
- (void)reloadWithCompletionHandler:(void(^)(NSError *))completionHandler {
  if (fabs([_lastUpdateTime timeIntervalSinceNow]) < kNewsUpdateIntervalInSeconds) {
    if (completionHandler) {
      completionHandler(nil);
    }
    return;
  }
  _lastUpdateTime = [NSDate date];
  
}

@end
