#import <Foundation/Foundation.h>

@interface MCCategory : NSObject

@property (nonatomic, readonly) NSString *category;
@property (nonatomic, readonly) NSNumber * count;
@property (nonatomic, readonly) NSDate * lastFetch;
@property (nonatomic, readonly) NSNumber * score;
@property (nonatomic, readonly) BOOL selected;

- (instancetype)initWithCategory:(NSString *) category
                           count:(NSNumber *) count
                       lastFetch:(NSDate *) lastFetch
                        selected:(BOOL) selected;

@end
