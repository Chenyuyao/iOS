#import <UIKit/UIKit.h>

@interface UIColor (Helpers)
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue andAlpha:(NSUInteger)alpha;
+ (UIColor *)colorWithR:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b andAlpha:(NSUInteger)a;
@end
