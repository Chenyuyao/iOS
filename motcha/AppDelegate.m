#import "AppDelegate.h"
#import "MCIntroViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
  self.window.rootViewController =
      [[UINavigationController alloc] initWithRootViewController:introViewController];
  return YES;
}

@end
