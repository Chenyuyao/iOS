#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MCNavigationBarAppearanceStrategyProtocol.h"

static NSString *kNavigationBarBackgroundAlphaKey = @"navigationBarBackgroundAlphaKey";

@interface MCNavigationBarAppearanceBackgroundAlpha : NSObject<MCNavigationBarAppearanceStrategyProtocol>
@property (nonatomic, weak) id<MCNavigationBarAppearanceStrategyDelegate> delegate;
@property (nonatomic, weak) id<MCNavigationBarAppearanceStrategyDataSource> dataSource;
@end
