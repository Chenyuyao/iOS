#import <Foundation/Foundation.h>

#import "MCNavigationBarAppearanceStrategyProtocol.h"

@interface MCNavigationBarAppearanceStrategy : NSObject
- (instancetype)initWithNavigationBar:(UINavigationBar*)navigationBar
         appearanceStrategy:(id<MCNavigationBarAppearanceStrategyProtocol>)strategy;
- (void)applyAppearanceAnimated:(BOOL)animated
                completionBlock:(void (^)(NSDictionary* dict))block;
@end
