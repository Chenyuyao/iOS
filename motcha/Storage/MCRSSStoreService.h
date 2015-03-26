#import <Foundation/Foundation.h>
#import "MCParsedRSSItem.h"

@interface MCRSSStoreService : NSObject

+ (MCRSSStoreService *)sharedInstance;
- (void) saveRSSItem:(MCParsedRSSItem *)item;
@end
