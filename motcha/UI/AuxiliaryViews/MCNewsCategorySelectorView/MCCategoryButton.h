#import <UIKit/UIKit.h>

#import "MCNewsItemConstraintsProtocol.h"
#import "UIView+HorizontalConstraints.h"

@interface MCCategoryButton : UIButton
@property (strong, nonatomic, readonly) NSString *category;
// The designated initializer.
- (instancetype)initWithCategory:(NSString *)category;
@end
