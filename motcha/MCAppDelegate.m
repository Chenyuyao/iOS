#import "MCAppDelegate.h"

#import "MCNavigationController.h"
#import "MCIntroViewController.h"
#import "MCNewsListViewController.h"
#import "MCNewsListWrapperViewController.h"

@implementation MCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  //MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
//  MCNewsListViewController *newsListViewController = [[MCNewsListViewController alloc] init];
  MCNewsListWrapperViewController *newsListWrapperViewController = [[MCNewsListWrapperViewController alloc] init];
  MCNavigationController *navigationController = [[MCNavigationController alloc] init];
  [navigationController setViewControllers:@[newsListWrapperViewController] animated:NO];
  self.window.rootViewController = navigationController;
  return YES;
}
@end
