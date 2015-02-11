#import <Foundation/Foundation.h>

@class MCNewsDetailsObject;
@class NSURL;

@interface MCWebContentService : NSObject

+ (MCWebContentService *)sharedInstance;

- (void)fetchNewsDetailsWithURL:(NSURL *)url
                completionBlock:(void(^)(MCNewsDetailsObject *, NSError *))block;

@end