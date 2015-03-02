#import <Foundation/Foundation.h>

@class MCNewsDetailsObject;
@class NSURL;
@class MCParsedRSSItem;

// The service that fetches and parses news from url.
@interface MCWebContentService : NSObject

+ (MCWebContentService *)sharedInstance;

- (void)fetchNewsDetailsWithItem:(MCParsedRSSItem *)item
                 completionBlock:(void(^)(MCNewsDetailsObject *, NSError *))block;

@end
