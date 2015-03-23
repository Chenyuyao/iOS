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

- (UIImage *)scaleToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode {
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  if (width <= size.width && height <= size.height) {
    return self;
  }
  CGFloat ratio = width / height;
  switch (contentMode) {
    case UIViewContentModeScaleAspectFit:
      if (ratio > 1) {
        return [self resizeToWidth:size.width height:size.width / ratio];
      } else {
        return [self resizeToWidth:size.height * ratio height:size.height];
      }
    case UIViewContentModeScaleAspectFill:
      if (ratio > 1) {
        return [self resizeToWidth:size.height * ratio height:size.height];
      } else {
        return [self resizeToWidth:size.width height:size.width / ratio];
      }
    default:
      return [self resizeToWidth:size.width height:size.height];
  }
}

@end
