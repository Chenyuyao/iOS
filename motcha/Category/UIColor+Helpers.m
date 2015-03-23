#import "UIColor+Helpers.h"

static NSUInteger kAppMainStyleColor = 0xFAF9FA;

@implementation UIColor (Helpers)

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue andAlpha:(NSUInteger)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithR:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b andAlpha:(NSUInteger)a {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor *)appMainColor {
  return [UIColor colorWithHexValue:kAppMainStyleColor andAlpha:1.0f];
}
@end
