#import "UIFont+DINFont.h"

@implementation UIFont (DINFont)
+ (UIFont *) dinRegularFontWithSize:(CGFloat)fontSize {
  return [[self class] fontWithName:@"DINPro-Regular" size:fontSize];
}

+ (UIFont *) dinBoldFontWithSize:(CGFloat)fontSize {
  return [[self class] fontWithName:@"DINPro-Bold" size:fontSize];
}
@end
