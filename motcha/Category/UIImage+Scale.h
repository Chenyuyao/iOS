#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage *)resizeToWidth:(float)width height:(float)height;
- (UIImage *)scaleToMaxWidth:(float) maxWidth maxHeight:(float) maxHeight;
@end
