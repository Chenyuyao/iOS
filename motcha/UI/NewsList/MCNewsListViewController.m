#import "MCNewsListViewController.h"

#import "MCParsedRSSItem.h"
#import "MCNewsListTableViewCell.h"
#import "MCNewsDetailViewController.h"
#import "MCNavigationController.h"
#import "MCRSSService.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+Helpers.h"
#import "BMYCircularProgressPullToRefresh.h"
#import "MCNewsListFooterView.h"

static NSString *kMCTableViewCellReuseId  = @"MCTableViewCell";
static CGFloat kNewsItemCellHeight        = 141.0f;
// For the pull to refresh control.
static NSString *kMIcon               = @"micon";
static NSString *kBackCircle          = @"light_circle";
static NSString *kFrontCircle         = @"dark_circle";
static CGFloat kRefreshControlSize    = 25.0f;
static CGFloat kRefreshControlHeight  = 45.0f;

@implementation MCNewsListViewController {
  NSMutableArray *_rssItems; // an array of MCParsedRSSItem *
  NSDate *_lastRetrievedNewsPubDate; // TODO: need to store this in the local cache.
  IBOutlet MCNewsListFooterView *_loadMoreView;
  // Since this view controller may be added/removed from its parent view controller multiple times,
  // viewDidLoad may be called multiple times within the lifetime of this view controller object,
  // so we need to guarantee that the setup work will be done only once throughout the entire lifetime
  // of the current object.
  dispatch_once_t _onceTokenViewDidLoad;
  dispatch_once_t _onceTokenViewDidAppear;
  // The completion handler for handling reloading completion.
  __weak void(^_reloadCompletionBlock)(NSError *error);
  BOOL _viewAppeared;
  BOOL _reloading;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // TODO(Frank): retrieve the _lastRetrievedNewsPubDate from local store, if there is one.
    _lastRetrievedNewsPubDate = [NSDate dateWithTimeIntervalSince1970:0];
    _rssItems = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  dispatch_once(&_onceTokenViewDidLoad, ^{
    self.tableView.backgroundColor = [UIColor appMainColor];
    self.tableView.scrollsToTop = NO;
    self.tableView.rowHeight = kNewsItemCellHeight;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Register cell classes
    [self.tableView registerNib:[UINib nibWithNibName:@"MCNewsListTableViewCell" bundle:nil]
         forCellReuseIdentifier:kMCTableViewCellReuseId];
    // Setup the footer view.
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"MCNewsListFooterView"
                                                  owner:self
                                                options:nil] firstObject];
    self.tableView.tableFooterView = view;
    [self setupPullToRefresh];
  });
}

- (void)setupPullToRefresh {
  BMYCircularProgressView *progressView =
      [[BMYCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, kRefreshControlSize, kRefreshControlSize)
                                                logo:[UIImage imageNamed:kMIcon]
                                     backCircleImage:[UIImage imageNamed:kBackCircle]
                                    frontCircleImage:[UIImage imageNamed:kFrontCircle]];
  __weak typeof(self) weakSelf = self;
  id actionHandler = ^(BMYPullToRefreshView *pullToRefreshView) {
    id completionBlock = ^(NSMutableArray *feeds, NSError *parseError) {
      [_rssItems replaceObjectsInRange:NSMakeRange(0, 0) withObjectsFromArray:feeds];
      // TODO: trim the data array to like 20 items, and set the state of the footer view to LoadDone.
      // If the data array has less than 20 items (for example, a failed retrieval results in 0 data count),
      // retrieve some from the local store to make up 20.
      // Don't forget to update the fetch offset.
      
      // TODO: Update the _lastRetrievedNewsPubDate to be the pubDate of the latest news item
      // in the current category, if retrieval succeeds.
      dispatch_async(dispatch_get_main_queue(), ^{
        _loadMoreView.state = LoadingDone;
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [weakSelf.tableView reloadData];
      });
      if (_reloadCompletionBlock) {
        _reloadCompletionBlock(nil);
      }
      _reloading = NO;
    };
    [[MCRSSService sharedInstance] fetchRSSWithCategory:self.category
                                                  since:_lastRetrievedNewsPubDate
                                        completionBlock:completionBlock];
  };
  [self.tableView setPullToRefreshWithHeight:kRefreshControlHeight actionHandler:actionHandler];
  [self.tableView.pullToRefreshView setPreserveContentInset:NO];
  [self.tableView.pullToRefreshView setProgressView:progressView];
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
  dispatch_once(&_onceTokenViewDidAppear, ^{
    [self reloadWithCompletionHandler:nil];
  });
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
  // TODO(Frank): Remove the fake data
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
  MCNewsListTableViewCell *cell = (MCNewsListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  cell.isRead = YES;
  // TODO(Frank): set the current news item to "read" status in local cache.
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

#pragma mark - Load More
- (IBAction)loadMoreButtonTapped:(id)sender {
  // TODO(Frank): Actually load more data from the local cache, and update the fetch offset.
  _loadMoreView.state = LoadingMore;
  int64_t delayInSeconds = 3;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^{
    // Simulate the local cache finish loading data callback.
    // TODO(Frank): Remove the fake data.
    MCParsedRSSItem *item1 = [[MCParsedRSSItem alloc] initWithTitle:@"More 1"
                                                               link:@"www.google.com"
                                                            descrpt:@"Description 1"
                                                             imgSrc:@"www.test.com/test.png"
                                                            pubDate:@"Fri, 20 Mar 2015 21:07:17 +0000"
                                                             author:@"Frank"];
    MCParsedRSSItem *item2 = [[MCParsedRSSItem alloc] initWithTitle:@"More 2"
                                                               link:@"www.google.com"
                                                            descrpt:@"Description 2"
                                                             imgSrc:@"www.test.com/test.png"
                                                            pubDate:@"Fri, 20 Mar 2015 22:07:17 +0000"
                                                             author:@"Frank"];
    MCParsedRSSItem *item3 = [[MCParsedRSSItem alloc] initWithTitle:@"More 3"
                                                               link:@"www.google.com"
                                                            descrpt:@"Description 3"
                                                             imgSrc:@"www.test.com/test.png"
                                                            pubDate:@"Fri, 20 Mar 2015 23:07:17 +0000"
                                                             author:@"Frank"];
    NSArray *retrievedData = @[item1, item2, item3];
    if ([retrievedData count]) {
      NSMutableArray *indexPaths = [NSMutableArray array];
      for (NSUInteger i = [_rssItems count]; i < [_rssItems count] + [retrievedData count]; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
      }
      [_rssItems addObjectsFromArray:retrievedData];
      [self.tableView beginUpdates];
      [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView endUpdates];
      int64_t delayInSeconds = 1;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
      dispatch_after(popTime, dispatch_get_main_queue(), ^{
        _loadMoreView.state = LoadingDone;
      });
    } else {
      _loadMoreView.state = LoadingNoMore;
    }
  });
}

#pragma mark - Helpers
- (void)reloadWithCompletionHandler:(void(^)(NSError *))completionHandler {
  if (_reloading) {
    return;
  }
  _reloading = YES;
  _reloadCompletionBlock = completionHandler;
  [self.tableView.pullToRefreshView startAnimating];
}

#pragma mark - dealloc
- (void)dealloc {
  [self.tableView tearDownPullToRefresh];
}

@end
