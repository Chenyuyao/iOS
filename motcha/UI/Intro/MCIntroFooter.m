#import "MCIntroFooter.h"

@implementation MCIntroFooter

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
  self.layer.masksToBounds = NO;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
  self.layer.shadowOpacity = 0.8f;
  self.layer.shadowPath = shadowPath.CGPath;
  self.layer.shadowRadius = 2.0f;
}

@end
