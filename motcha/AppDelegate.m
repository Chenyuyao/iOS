#import "AppDelegate.h"
#import "MCIntroViewController.h"
#import "MCWebContentService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  MCIntroViewController *introViewController = [[MCIntroViewController alloc] init];
  self.window.rootViewController =
      [[UINavigationController alloc] initWithRootViewController:introViewController];
  
  NSURL *url = [NSURL URLWithString:@"http://www.economist.com/blogs/freeexchange/2015/02/americas-budget-2016?fsrc=rss"];
  [[MCWebContentService sharedInstance] fetchNewsDetailsWithURL:url completionBlock:nil];
  return YES;
}

@end
