#import <UIKit/UIKit.h>

#import "MCTextView.h"

/**
 * A text view containing the text in the news detail
 * Automatically grows the size of the UITextView according to its text content.
 * Remark: Please do not add height constraint to MCTextView instance by yourself.
 */
@interface MCNewsTextBlock : MCTextView
@property (nonatomic) CGFloat fontSize;
@end
