#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat kNavigationBarAppearanceAnimationDuration  = 0.3f;
static CGFloat kNavigationBarAuxiliaryViewStartingAlpha   = 0.0f;
static CGFloat kNavigationBarBackgroundDefaultAlpha       = 1.0f;

static NSString *kAuxiliaryViewKey                  = @"auxiliaryViewKey";
static NSString *kNavigationBarOffsetKey            = @"navigationBarOffsetKey";
static NSString *kNavigationBarBackgroundViewKey    = @"navigationBarBackgroundViewKey";
static NSString *kNavigationBarBackgroundHeightKey  = @"navigationBarBackgroundHeightKey";

@protocol MCNavigationBarAppearanceStrategyProtocol <NSObject>
- (void)applyAppearanceToNavigationBar:(UINavigationBar*)navigationBar
                              animated:(BOOL)animated
                       completionBlock:(void (^)(NSDictionary* dict))block;
@end

@protocol MCNavigationBarAppearanceStrategyDataSource <NSObject>
- (NSDictionary*)appearanceStrategyDataForStrategyClass:(Class)strategyClass;
@end

@protocol MCNavigationBarAppearanceStrategyDelegate <NSObject>
@optional
- (void)appearance:(NSObject*)appearance willAppearForStrategyClass:(Class)strategyClass state:(NSDictionary *)dict;
- (void)appearance:(NSObject*)appearance didAppearForStrategyClass:(Class)strategyClass state:(NSDictionary*)dict;
@end
