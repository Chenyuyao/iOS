#import "AppDelegate.h"

#import "MCIntroViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:introViewController];
  self.window.rootViewController = navigationController;
  return YES;
}

@end
