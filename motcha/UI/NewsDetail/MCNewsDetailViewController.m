#import "MCNewsDetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "MBProgressHUD.h"

#import "MCNewsDetailsObject.h"
#import "MCNewsDetailScrollView.h"
#import "MCNavigationController.h"
#import "MCNavigationBarCustomizationDelegate.h"
#import "MCParsedRSSItem.h"
#import "MCWebContentService.h"

//static CGFloat kScrollViewContentBottomInset = 20.0f;

@interface MCNewsDetailViewController ()
<
  UIScrollViewDelegate,
  MCNewsDetailScrollViewDelegate,
  JTSImageViewControllerImageSavingDelegate,
  MBProgressHUDDelegate,
  MCNavigationBarCustomizationDelegate
>
@end

@implementation MCNewsDetailViewController {
  MCNewsDetailScrollView *_scrollView;
  MCParsedRSSItem *_item;
  MCNewsDetailsObject *_data;
}

- (instancetype)initWithRSSItem:(MCParsedRSSItem *)item {
  self = [super init];
  if (self) {
    _item = item;
  }
  return self;
}

- (void)loadView {
  _scrollView = [[MCNewsDetailScrollView alloc] init];
  self.view = _scrollView;
  //register self to MCNewsDetailScrollView delegate
  _scrollView.mcDelegate = self;
  _scrollView.delegate = self;
  //_scrollView.contentInset = UIEdgeInsetsMake(0,0,kScrollViewContentBottomInset,0);
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  //add right bar items: font and share item
  UIBarButtonItem *fontButton =
  [[UIBarButtonItem alloc] initWithTitle:@"Aa"
                                   style: UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(fontButtonPressed:)];
  UIBarButtonItem *shareButton =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                target:self
                                                action:@selector(shareButtonPressed:)];
  NSArray *actionBarItems = @[shareButton, fontButton];
  self.navigationItem.rightBarButtonItems = actionBarItems;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[MCWebContentService sharedInstance] fetchNewsDetailsWithItem:_item
                                                 completionBlock:^(MCNewsDetailsObject *data, NSError *error) {
    if (!error) {
      _data = data;
      __weak __typeof__(self) weakSelf = self;
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf reload];
      });
    } else {
      // TODO(shinfan): Handle error here.
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self notifyNavigationControllerWithScrollViewContentOffsetYAnimated:animated];
}

- (void)notifyNavigationControllerWithScrollViewContentOffsetYAnimated:(BOOL)animated {
  [(MCNavigationController *)self.navigationController notifyViewControllerWillAppearAnimated:animated];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self notifyNavigationControllerWithScrollViewContentOffsetYAnimated:NO];
}

#pragma mark - MCNewsDetailScrollViewDelegate methods
- (void)imageBlockTappedForImageView:(UIImageView *)imageView {
  JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
  imageInfo.image = imageView.image;
  imageInfo.referenceRect = imageView.frame;
  imageInfo.referenceView = imageView.superview;
  imageInfo.referenceContentMode = imageView.contentMode;
  imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
  JTSImageViewController *imageViewer =
      [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                   mode:JTSImageViewControllerMode_Image
                                        backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
  imageViewer.imageSavingDelegate = self;
  [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark - button press target actions
- (void)shareButtonPressed:(UIBarButtonItem *)sender {
  // TODO: get the actual url and text to share
  NSString *textToShare = @"Mocha is so good!";
  NSURL *website = [NSURL URLWithString:@"https://www.google.ca/"];
  NSArray *objectsToShare = @[textToShare, website];
  // TODO: add weixin activity SDK
  UIActivityViewController *activityVC =
      [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                        applicationActivities: nil];
  activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll, UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo, UIActivityTypeAirDrop];
  [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)fontButtonPressed:(UIBarButtonItem *)sender {
  [_scrollView toggleTextFontSize];
}

#pragma mark - JTSImageViewControllerImageSavingDelegate methods
- (void)image:(UIImage *)image didSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
  // TODO: (PhoebeLi) need refactoring wording stuff.
  NSLog(@"Cannot save image.");
  UIAlertView *failureAlert =[[UIAlertView alloc] initWithTitle:@" Unable to Save Image"
                                                        message:@"Motcha does not have permission to access your photos. Please go to Settings > Privacy > Photos, and turn on Motcha."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
  [failureAlert show];
}

- (void)image:(UIImage *)image didSavingWithSuccess:(NSError *)error
  contextInfo:(void *)contextInfo
       target:(JTSImageViewController *)viewController {
  // TODO: (PhoebeLi) need refactoring wording stuff.
  NSLog(@"image saved successfully.");
  MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:viewController.view];
  [viewController.view addSubview:progressHud];
  progressHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
  // Set custom view mode
  progressHud.mode = MBProgressHUDModeCustomView;
  progressHud.delegate = self;
  progressHud.labelText = @"Saved successfully";
  [progressHud show:YES];
  // Show the progress hud for one second and then hide.
  [progressHud hide:YES afterDelay:1.0f];
}

#pragma mark - MCNavigationBarCustomizationDelegate methods
@synthesize navigationBarBackgroundAlpha = _navigationBarBackgroundAlpha;

- (CGFloat)navigationBarBackgroundAlpha {
  return [self calculateNavigationBarBackgroundAlphaFromScrollViewContentOffsetY];
}

#pragma mark - Helpers
- (void)reload {
  // TODO: Use real image
  [_scrollView setImage:[UIImage imageNamed:@"Cherry-Blossom"]];
  [_scrollView setNewsTitle:_data.title];
  [_scrollView setSource:_data.source];
  [_scrollView setAuthor:_data.author];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  [_scrollView setPublishDate:[dateFormatter dateFromString:@"2014-12-11"]];
  [_scrollView setNewsMainBody:[_data content]];
}

- (CGFloat)calculateNavigationBarBackgroundAlphaFromScrollViewContentOffsetY {
  CGFloat contentOffsetBoundary =
      kTitleImageViewOriginalHeight - (kTitleImageViewTopInset + kTitleImageViewBottomInset);
  return MAX(0.0f, MIN(1.0f, _scrollView.contentOffset.y / contentOffsetBoundary));
}
@end
