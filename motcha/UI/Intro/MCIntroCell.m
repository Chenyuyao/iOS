#import "MCIntroCell.h"

@implementation MCIntroCell

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
  self.layer.masksToBounds = NO;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
  self.layer.shadowOpacity = 0.7f;
  self.layer.shadowPath = shadowPath.CGPath;
  self.layer.shadowRadius = 1.5f;
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  _cover.hidden = !selected;
  _check.hidden = !selected;
  _title.textColor =
      selected ? [UIColor blackColor] : [UIColor whiteColor];
  // Fade in effect
  CATransition *transition = [CATransition animation];
  transition.duration = 0.25;
  transition.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
  transition.delegate = self;
  [self.layer addAnimation:transition forKey:nil];
}

@end
