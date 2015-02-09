#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MCNavigationBarAppearanceStrategyProtocol.h"

@interface MCNavigationBarAppearanceAuxiliaryView : NSObject<MCNavigationBarAppearanceStrategyProtocol>
@property (nonatomic, weak) id<MCNavigationBarAppearanceStrategyDelegate> delegate;
@property (nonatomic, weak) id<MCNavigationBarAppearanceStrategyDataSource> dataSource;
@end
