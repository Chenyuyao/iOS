#import "MCAppDelegate.h"

#import "MCIntroViewController.h"
#import "MCNewsListViewController.h"
#import "WXApi.h"

@interface MCAppDelegate ()<WXApiDelegate>
@end

@implementation MCAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // TODO: Use our own wechat app id.
  [WXApi registerApp:@"wxcefa411f34485347"];
  
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WXApi handleOpenURL:url delegate:self];
}
@end
