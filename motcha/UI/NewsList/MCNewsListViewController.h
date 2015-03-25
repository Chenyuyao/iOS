#import <UIKit/UIKit.h>

@interface MCNewsListViewController : UITableViewController
@property (strong, nonatomic) NSString *category;
- (void)reloadWithCompletionHandler:(void(^)(NSError *))completionHandler;
@end
