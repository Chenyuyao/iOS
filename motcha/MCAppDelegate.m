#import "MCAppDelegate.h"

#import "MCNavigationController.h"
#import "MCIntroViewController.h"
#import "MCNewsListViewController.h"
#import "MCNewsListsContainerController.h"
#import "MCWebContentService.h"

@implementation MCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  //MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
//  MCNewsListViewController *newsListViewController = [[MCNewsListViewController alloc] init];
  MCNewsListsContainerController *newsListsContainerController = [[MCNewsListsContainerController alloc] init];
  MCNavigationController *navigationController =
      [[MCNavigationController alloc] initWithRootViewController:newsListsContainerController];
  self.window.rootViewController = navigationController;
  return YES;
}
@end
