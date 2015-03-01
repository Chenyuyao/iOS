#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Content)
+ (NSLayoutConstraint *)constraintBetweenItem:(UIView *)firstItem andItem:(UIView *)secondItem withConstant:(CGFloat)c;
+ (NSLayoutConstraint *)constraintBetweenContentView:(UIView *)contentView
                                        andFirstItem:(UIView *)firstItem
                                        withConstant:(CGFloat)c;
+ (NSLayoutConstraint *)constraintBetweenContentView:(UIView *)contentView
                                         andLastItem:(UIView *)lastItem
                                        withConstant:(CGFloat)c;
@end
