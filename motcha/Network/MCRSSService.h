#import <Foundation/Foundation.h>

@interface MCRSSService : NSObject

+ (MCRSSService *)sharedInstance;

- (void)fetchNormalRSSWithCategory:(NSString *)category
                       since:(NSDate *)since
             completionBlock:(void(^)(NSMutableArray *rssItems, NSError *error))block;

@end
