#import <Foundation/Foundation.h>
#import "MCParsedRSSItem.h"

@interface MCRecommendationService : NSObject

+ (MCRecommendationService *)sharedInstance;

- (void)getRecommendedCategoryWithBlock:(void(^)(NSArray *, NSError *))block;
- (NSNumber *)getRSSItemScore:(MCParsedRSSItem *) item;



@end
