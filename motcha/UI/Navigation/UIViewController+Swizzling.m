#import "UIViewController+Swizzling.h"

#import <objc/runtime.h>

@implementation UIViewController (Swizzling)
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(override_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
      class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),
          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

#pragma mark - Method Swizzling
#pragma GCC diagnostic ignored "-Wundeclared-selector"
- (void)override_viewWillAppear:(BOOL)animated {
  [self override_viewWillAppear:animated];
  SEL selector = @selector(notifyViewControllerWillAppearAnimated:);
  if ([self.navigationController respondsToSelector:selector]) {
    // we use NSInvocation instead of performSelector:withObject: because we need to pass a primitive type BOOL
    // instead of an object, and we do not want to modify the target implementation just because of this.
    NSMethodSignature *signature = [[self.navigationController class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.navigationController];
    [invocation setSelector:@selector( notifyViewControllerWillAppearAnimated:)];
    [invocation setArgument:&animated atIndex:2];
    [invocation invoke];
  }
}
@end
