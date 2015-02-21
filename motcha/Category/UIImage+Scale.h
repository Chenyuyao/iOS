#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)scaleToMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
@end
