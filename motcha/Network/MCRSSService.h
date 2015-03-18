#import <Foundation/Foundation.h>

@class NSMutableArray;
@interface MCRSSService : NSObject

+ (MCRSSService *)sharedInstance;

- (NSMutableArray *)fetchRSSWithCategory:(NSString *)category since:(NSDate *)since;

@end

