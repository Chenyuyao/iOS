#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCNavigationBarCustomizationDelegate <NSObject>
@optional
@property (nonatomic, strong) UIView *navigationBarAuxiliaryView;
@property (nonatomic) CGFloat navigationBarBackgroundAlpha;
@end
