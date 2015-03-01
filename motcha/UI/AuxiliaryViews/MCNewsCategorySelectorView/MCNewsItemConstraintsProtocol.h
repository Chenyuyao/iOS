#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCNewsItemHorizontalConstraintsProtocol <NSObject>
@property (weak, nonatomic) NSLayoutConstraint *constraintWithLeftItem;
@property (weak, nonatomic) NSLayoutConstraint *constraintWithRightItem;
@end
