#import <Foundation/Foundation.h>

@class MCNewsDetailsObject;
@class NSURL;

// The service that fetches and parses news from url.
@interface MCWebContentService : NSObject

+ (MCWebContentService *)sharedInstance;

- (void)fetchNewsDetailsWithURL:(NSURL *)url
                completionBlock:(void(^)(MCNewsDetailsObject *, NSError *))block;

@end
