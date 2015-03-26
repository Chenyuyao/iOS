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
#import "MCNewsDetailNavButtonView.h"

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
  MCNewsDetailBackButtonView *_backButtonView;
  MCNewsDetailFontButtonView *_fontButtonView;
  MCNewsDetailShareButtonView *_shareButtonView;
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
  [self setupNavigationBarItems];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIActivityIndicatorView *indicator =
      [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self.view addSubview:indicator];
  indicator.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f constant:-40]];
  [self.view bringSubviewToFront:indicator];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
  [indicator startAnimating];
  [[MCWebContentService sharedInstance] fetchNewsDetailsWithItem:_item
                                                 completionBlock:^(MCNewsDetailsObject *data, NSError *error) {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
  if (!error) {
      _data = data;
      __weak __typeof__(self) weakSelf = self;
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf loadData];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
      });
    } else {
      // TODO(shinfan): Handle error here.
    }
  }];
  
  // Set the initial orientation status for the nav buttons
  _backButtonView.buttonOrientation = [UIApplication sharedApplication].statusBarOrientation;
  _fontButtonView.buttonOrientation = [UIApplication sharedApplication].statusBarOrientation;
  _shareButtonView.buttonOrientation = [UIApplication sharedApplication].statusBarOrientation;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [(MCNavigationController *)self.navigationController notifyViewWillAppearAnimated:animated];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [(MCNavigationController *)self.navigationController notifyViewWillAppearAnimated:NO];
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

#pragma mark - JTSImageViewControllerImageSavingDelegate methods
- (void)image:(UIImage *)image didSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
  // TODO: (PhoebeLi) need refactoring wording stuff.
  NSLog(@"Cannot save image.");
  UIAlertView *failureAlert =[[UIAlertView alloc] initWithTitle:@" Unable to Save Image"
                                                        message:@"Motcha does not have permission to access your"
                              " photos. Please go to Settings > Privacy > Photos, and turn on Motcha."
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

#pragma mark - navigation button handlers
- (void)backButtonTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)fontButtonTapped:(id)sender {
  [_scrollView toggleTextFontSize];
}

- (void)shareButtonTapped:(id)sender {
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

#pragma mark - UIContentContainer methods
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    if (size.width > size.height) { // Landscape
      _backButtonView.buttonOrientation = UIInterfaceOrientationLandscapeLeft;
      _fontButtonView.buttonOrientation = UIInterfaceOrientationLandscapeLeft;
      _shareButtonView.buttonOrientation = UIInterfaceOrientationLandscapeLeft;
    } else { // Portrait
      _backButtonView.buttonOrientation = UIInterfaceOrientationPortrait;
      _fontButtonView.buttonOrientation = UIInterfaceOrientationPortrait;
      _shareButtonView.buttonOrientation = UIInterfaceOrientationPortrait;
    }
  } completion:nil];
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Helpers
- (void)loadData {
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

- (void)setupNavigationBarItems {
  //add right bar items: font and share item
  NSArray *buttons = [[NSBundle mainBundle] loadNibNamed:@"MCNewsDetailNavButtonView" owner:nil options:nil];
  
  for (UIView *buttonView in buttons) {
    if ([buttonView isKindOfClass:[MCNewsDetailBackButtonView class]]) {
      _backButtonView = (MCNewsDetailBackButtonView *)buttonView;
    } else if ([buttonView isKindOfClass:[MCNewsDetailFontButtonView class]]) {
      _fontButtonView = (MCNewsDetailFontButtonView *)buttonView;
    } else if ([buttonView isKindOfClass:[MCNewsDetailShareButtonView class]]) {
      _shareButtonView = (MCNewsDetailShareButtonView *)buttonView;
    }
  }
  
  [_backButtonView.button addTarget:self
                             action:@selector(backButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButtonView];
  
  [_fontButtonView.button addTarget:self
                             action:@selector(fontButtonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *fontButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_fontButtonView];
  
  [_shareButtonView.button addTarget:self
                              action:@selector(shareButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButtonView];
  
  UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:nil
                                                                             action:nil];
  fixedItem.width = 20.0f; // spacing between two navigation items
  NSArray *actionBarItems = @[shareButtonItem, fixedItem, fontButtonItem];
  self.navigationItem.rightBarButtonItems = actionBarItems;
  // Re-enable the swipe-to-pop gesture.
  self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
  [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

@end
