#import "MCAppDelegate.h"

#import "MCIntroViewController.h"
#import "MCNewsListViewController.h"

@implementation MCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  //MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
  MCNewsListViewController *newsListViewController = [[MCNewsListViewController alloc] init];
  UINavigationController *navigationController =
      [[UINavigationController alloc] initWithRootViewController:newsListViewController];
  self.window.rootViewController = navigationController;
  return YES;
}
@end
