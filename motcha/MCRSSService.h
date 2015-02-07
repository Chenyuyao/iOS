#import <Foundation/Foundation.h>

@class NSMutableArray;
@interface MCRSSService : NSObject

+ (MCRSSService *)sharedInstance;

- (void)fetchRSSWithURL:(NSURL *)url
        completionBlock:(void(^)(NSMutableArray *, NSError *))block;

@end
