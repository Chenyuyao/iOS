#import <UIKit/UIKit.h>

@class MCParsedRSSItem;

@interface MCNewsDetailViewController : UIViewController

- (instancetype)initWithRSSItem:(MCParsedRSSItem *)item;

@end
