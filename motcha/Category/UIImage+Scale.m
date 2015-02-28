#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
  CGImageRef imgRef = self.CGImage;
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, self.scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextScaleCTM(context, width / self.size.width, -height / self.size.height);
  CGContextTranslateCTM(context, 0, -self.size.height);
  CGContextConcatCTM(context, transform);
  CGContextSetAllowsAntialiasing(context, true);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), imgRef);
  
  UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return imageCopy;
}

- (UIImage *)scaleToMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  if (width <= maxWidth && height <= maxHeight) {
    return self;
  }
  CGSize bounds = CGSizeMake(width, height);
  CGFloat ratio = width / height;
  if (ratio > 1) {
    bounds.width = maxWidth;
    bounds.height = bounds.width / ratio;
  } else {
    bounds.height = maxHeight;
    bounds.width = bounds.height * ratio;
  }
  return [self resizeToWidth:bounds.width height:bounds.height];
}
@end
