#import <Foundation/Foundation.h>

@class NSMutableArray;
@interface MCRSSService : NSObject

+ (MCRSSService *)sharedInstance;

- (void)fetchRSSWithCategory:(NSString *)category
                                   since:(NSDate *)since
                         completionBlock:(void(^)(NSMutableArray *, NSError *))block;

@end

