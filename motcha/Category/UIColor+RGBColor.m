#import "UIColor+RGBColor.h"

@implementation UIColor (RGBColor)

+ (UIColor *)colorWithR:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b andAlpha:(NSUInteger)a {
  return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

@end
