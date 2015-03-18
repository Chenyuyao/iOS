#import "MCAppDelegate.h"

#import "MCNavigationController.h"
#import "MCIntroViewController.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
  MCNavigationController *navigationController =
      [[MCNavigationController alloc] initWithRootViewController:introViewController];
  self.window.rootViewController = navigationController;
  return YES;
}

@end
