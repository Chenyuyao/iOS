#import <Foundation/Foundation.h>
#import "MCParsedRSSItem.h"
#import "MCCategory.h"

@interface MCRecommendationService : NSObject

+ (MCRecommendationService *)sharedInstance;
+ (NSArray *)getFetchedNumbers;

- (void)getRecommendedCategoryWithBlock:(void(^)(NSArray *, NSError *))block;
- (void)fetchRSSItemScore:(MCParsedRSSItem *) item
                withBlock:(void(^)(MCParsedRSSItem *, NSError *))block;
- (void)incrementCount:(MCParsedRSSItem *) item;
- (void)recommendRSSItems:(MCCategory *)category
              fetchNumber:(NSNumber *)fetchNumber
          withBlock:(void(^)(NSArray *, NSError *))block;
@end
