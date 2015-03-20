#import "MCAppDelegate.h"

#import "MCNavigationController.h"
#import "MCIntroViewController.h"
#import "MCNewsListsContainerController.h"
#import "MCReadingPreferenceService.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  UIViewController *rootViewController;
  NSArray *categories = [[MCReadingPreferenceService sharedInstance] categories];
  if ([categories count]) {
    rootViewController = [[MCNewsListsContainerController alloc] initWithCategories:categories];
  } else {
    rootViewController = [[MCIntroViewController alloc] init];
  }
  MCNavigationController *navigationController =
      [[MCNavigationController alloc] initWithRootViewController:rootViewController];
  self.window.rootViewController = navigationController;
  return YES;
}

@end
