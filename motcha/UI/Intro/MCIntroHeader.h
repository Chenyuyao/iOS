#import <UIKit/UIKit.h>

// Header view used in intro screen
@interface MCIntroHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *instruction;

@end
