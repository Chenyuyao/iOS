#import "UIViewController+Swizzling.h"

#import <objc/runtime.h>

#pragma GCC diagnostic ignored "-Wundeclared-selector"

@implementation UIViewController (Swizzling)
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [[self class] swizzleSelector:@selector(viewWillDisappear:) forSelector:@selector(override_viewWillDisappear:)];
    [[self class] swizzleSelector:@selector(viewDidAppear:) forSelector:@selector(override_viewDidAppear:)];
  });
}

#pragma mark - Method Swizzling

- (void)override_viewWillDisappear:(BOOL)animated {
  [self override_viewWillDisappear:animated];
  SEL selector = @selector(notifyViewWillDisappearAnimated:);
  if ([self.navigationController respondsToSelector:selector]) {
    [self invokeSelector:selector animated:animated];
  }
}

- (void)override_viewDidAppear:(BOOL)animated {
  [self override_viewDidAppear:animated];
  SEL selector = @selector(notifyViewDidAppearAnimated:);
  if ([self.navigationController respondsToSelector:selector]) {
    [self invokeSelector:selector animated:animated];
  }
}

#pragma mark - Helpers
+ (void)swizzleSelector:(SEL)originalSelector forSelector:(SEL)swizzledSelector {
  Class class = [self class];
  
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
}

- (void)invokeSelector:(SEL)selector animated:(BOOL)animated {
  // we use NSInvocation instead of performSelector:withObject: because we need to pass a primitive type BOOL
  // instead of an object, and we do not want to modify the target implementation just because of this.
  NSMethodSignature *signature = [[self.navigationController class] instanceMethodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation setTarget:self.navigationController];
  [invocation setSelector:selector];
  [invocation setArgument:&animated atIndex:2];
  [invocation invoke];
}

@end
