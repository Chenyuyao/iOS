#import "MCAppDelegate.h"

#import "MCNavigationController.h"
#import "MCIntroViewController.h"
#import "MCNewsListsContainerController.h"
#import "MCLocalStorageService.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"appHasLaunchedOnce"]) {
    UIViewController *rootViewController = [[MCIntroViewController alloc] initWithSelectedCategories:nil
                                                         superNavigationController:nil                                                                   isFirstTimeUser:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"appHasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    MCNavigationController *navigationController =
        [[MCNavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
  } else {
    [[MCLocalStorageService sharedInstance] fetchCategoriesWithBlock:^(NSArray *categories, NSError *error) {
        UIViewController *rootViewController =
            [[MCNewsListsContainerController alloc] initWithCategories:categories];
        MCNavigationController *navigationController =
            [[MCNavigationController alloc] initWithRootViewController:rootViewController];
        self.window.rootViewController = navigationController;
    }];
  }
  return YES;
}

@end
