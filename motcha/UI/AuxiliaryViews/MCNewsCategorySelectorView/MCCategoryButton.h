#import <UIKit/UIKit.h>

@interface MCCategoryButton : UIButton
@property (strong, nonatomic) NSString *category;
// The designated initializer.
- (instancetype)initWithCategory:(NSString *)category;
@end
