#import <UIKit/UIKit.h>

/**
 * A text view containing the text in the news detail
 * Automatically grows the size of the UITextView according to its text content.
 * Remark: Please do not add height constraint to MCTextView instance by yourself.
 */
@interface MCNewsTextBlock : UITextView
@property (nonatomic) CGFloat fontSize;
@end
