#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

// Enlarge the hittable area for the UIButton by UIEdgeInsets
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
