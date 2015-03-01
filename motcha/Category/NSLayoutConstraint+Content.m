#import "NSLayoutConstraint+Content.h"

@implementation NSLayoutConstraint (Content)
+ (NSLayoutConstraint *)constraintBetweenItem:(UIView *)firstItem andItem:(UIView *)secondItem withConstant:(CGFloat)c {
  return [NSLayoutConstraint constraintWithItem:secondItem
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:firstItem
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:c];
}

+ (NSLayoutConstraint *)constraintBetweenContentView:(UIView *)contentView
                                        andFirstItem:(UIView *)firstItem
                                        withConstant:(CGFloat)c {
  return [NSLayoutConstraint constraintWithItem:firstItem
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:contentView
                                      attribute:NSLayoutAttributeLeading
                                     multiplier:1
                                       constant:c];
}

+ (NSLayoutConstraint *)constraintBetweenContentView:(UIView *)contentView
                                         andLastItem:(UIView *)lastItem
                                        withConstant:(CGFloat)c {
  return [NSLayoutConstraint constraintWithItem:contentView
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:lastItem
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:c];
}
@end
