#import <Foundation/Foundation.h>
#import "MCParsedRSSItem.h"

@interface MCRecommendationService : NSObject

+ (MCRecommendationService *)sharedInstance;

- (NSArray *)getRecommendedCategory;
- (NSNumber *)getRSSItemScore:(MCParsedRSSItem *) item;



@end