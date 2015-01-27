#import <UIKit/UIKit.h>

// Footer view used in intro screen.
@interface MCIntroFooter : UICollectionReusableView
// TODO(sherry): Switch this into a UIButton.
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
