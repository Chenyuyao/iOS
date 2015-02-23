#import "UIView+HorizontalConstraints.h"

#import <objc/runtime.h>

NSString const *kLeftKey  = @"com.motcha.key.horizontal.constraints.left";
NSString const *kRightKey = @"com.motcha.key.horizontal.constraints.right";

@implementation UIView (HorizontalConstraints)
- (NSLayoutConstraint *)constraintWithLeftItem {
  return objc_getAssociatedObject(self, &kLeftKey);
}

- (void)setConstraintWithLeftItem:(NSLayoutConstraint *)constraintWithLeftItem {
  objc_setAssociatedObject(self, &kLeftKey, constraintWithLeftItem, OBJC_ASSOCIATION_ASSIGN);
}

- (NSLayoutConstraint *)constraintWithRightItem {
  return objc_getAssociatedObject(self, &kRightKey);
}

- (void)setConstraintWithRightItem:(NSLayoutConstraint *)constraintWithRightItem {
  objc_setAssociatedObject(self, &kRightKey, constraintWithRightItem, OBJC_ASSOCIATION_ASSIGN);
}

@end
