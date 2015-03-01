#import "MCNewsDetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "MBProgressHUD.h"

#import "MCNewsDetailScrollView.h"

//static CGFloat kScrollViewContentBottomInset = 20.0f;

@interface MCNewsDetailViewController ()
<
    MCNewsDetailScrollViewDelegate,
    JTSImageViewControllerImageSavingDelegate,
    MBProgressHUDDelegate
>
@end

@implementation MCNewsDetailViewController {
  MCNewsDetailScrollView *_scrollView;
  MBProgressHUD *_HUD;
}

- (void)loadView {
  _scrollView = [[MCNewsDetailScrollView alloc] init];
  self.view = _scrollView;
  //register self to MCNewsDetailScrollView delegate
  _scrollView.mcDelegate = self;
  //_scrollView.contentInset = UIEdgeInsetsMake(0,0,kScrollViewContentBottomInset,0);
  
  // TODO: delete the following after MCNavigationController is integrated.
  // The following is to transparentize the navigation bar.
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
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
  [self setFakeData];
}

// TODO: remove fake data
- (void)setFakeData {
  //fake data
  [_scrollView setImage:[UIImage imageNamed:@"Cherry-Blossom"]];
  [_scrollView setNewsTitle:@"This isn't the last we've heard of Samsung buying BlackBerry"];
  [_scrollView setSource:@"Rutos"];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  [_scrollView setPublishDate:[dateFormatter dateFromString:@"2014-12-11"]];
  
  [_scrollView setAuthor:@"Phoebe"];
  NSArray *contentArray = [NSArray arrayWithObjects: @"Although Adams seemed to have no trouble outlining the issues that led her to leave the party that, she noted, she had supported since she was just 14 years old, Adams bristled when reporters asked how her decision had gone over with her partner, Dimitri Soudas. The former senior aide and onetime communications director to Prime Minister Stephen Harper also served as director of the Conservative Party in 2013.", [UIImage imageNamed:@"Long_cat.jpg"], @"She also declined to address her well-publicized difficulties in securing a Conservative nomination in two separate ridings, which ultimately led her to announce that she would not be running for re-election. Both Adams and Soudas came under fire last year during her ill-fated campaign to win the Conservative nomination in Oakville Burlington-North. Last March, Soudas — who at the time was engaged to Adams — was forced out of his job as executive director of the Conservative Party over allegations that he had attempted to interfere in the race. Eventually, the party put the nomination contest on hold. Both Adams and rival candidate Natalia Lishchyna subsequently withdrew last fall.", [UIImage imageNamed:@"green_tea.jpg"], @"Eventually, the party put the nomination contest on hold. Both Adams and rival candidate Natalia Lishchyna subsequently withdrew last fall. Liberal MPs were briefed on their new caucus colleague via teleconference on Monday morning. During that call, they were told that Soudas brokered the deal with the party, CBC sources said. Adams said Monday her decision to join the Liberals is not about having a tough day at the office. Everybody has grumpy bosses from time to time. This is about the fact that my values simply don't align with this team. I'd like to consider serving Canadians, and I believe Justin Trudeau and the Liberal Party offer the most positive, hopeful leadership available.", [UIImage imageNamed:@"angry_birds_cake.jpg"],@"I informed her in writing on Jan. 29 that she would not be permitted to run for our party in the next election due to the misconduct from the Oakville North-Burlington nomination race", nil];
  [_scrollView setNewsMainBody:contentArray];
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

- (void)image:(UIImage *)image didSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
  //bring up an alertView showing the error msg to user
  NSLog(@"cannot save image.");
  UIAlertView *failureAlert =[[UIAlertView alloc] initWithTitle:@" Unable to Save Image"
                                                        message:@"Motcha does not have permission to access your photos. Please go to Settings > Privacy > Photos, and turn on Motcha."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
  [failureAlert show];
}
- (void)image:(UIImage *)image didSavingWithSuccess:(NSError *)error contextInfo:(void *)contextInfo target:(JTSImageViewController *)viewController {
  //bring up an HUD showing successful image
  NSLog(@"image saved successfully.");
  _HUD = [[MBProgressHUD alloc] initWithView:viewController.view];
  [viewController.view addSubview:_HUD];

  _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
  
  // Set custom view mode
  _HUD.mode = MBProgressHUDModeCustomView;
  
  _HUD.delegate = self;
  _HUD.labelText = @"Saved successfully";
  
  [_HUD show:YES];
  [_HUD hide:YES afterDelay:1];

}


- (void)fontButtonPressed:(UIBarButtonItem *)sender {
  [_scrollView toggleTextFontSize];
}

@end
