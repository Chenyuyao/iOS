#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCNewsDetailScrollViewDelegate <NSObject>
@optional
- (void)imageBlockTappedForImageView:(UIImageView*)imageView;
@end
