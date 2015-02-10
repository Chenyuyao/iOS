#import <UIKit/UIKit.h>

/*
 * Automatically grow the size of the UITextView according to its text content.
 * Remark: Please do not add height constraint to MCTextView instance by yourself.
 */
@interface MCNewsTextBlock : UITextView
@property (nonatomic) CGFloat fontSize;
@end
