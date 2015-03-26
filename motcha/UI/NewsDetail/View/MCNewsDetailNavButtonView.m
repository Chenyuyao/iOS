#import "MCNewsDetailNavButtonView.h"

#import "UIButton+Extensions.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat kButtonSizePortrait  = 36.0f;
static CGFloat kButtonSizeLandscape = 30.0f;
static CGFloat kHitTestEdgeInset    = 15.0f;

@implementation MCNewsDetailNavButtonView {
  @protected
  __weak IBOutlet UIView *_backdrop;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  UIEdgeInsets edgeInsets =
      UIEdgeInsetsMake(-kHitTestEdgeInset, -kHitTestEdgeInset, -kHitTestEdgeInset, -kHitTestEdgeInset);
  [_button setHitTestEdgeInsets:edgeInsets];
}

- (void)setButtonOrientation:(UIInterfaceOrientation)buttonOrientation {
  _buttonOrientation = buttonOrientation;
  CGRect buttonFrame = self.frame;

  switch (buttonOrientation) {
    case UIInterfaceOrientationPortrait:
    case UIInterfaceOrientationPortraitUpsideDown:
      self.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, kButtonSizePortrait, kButtonSizePortrait);
      _backdrop.layer.cornerRadius = kButtonSizePortrait/2;
      break;
    case UIInterfaceOrientationLandscapeLeft:
    case UIInterfaceOrientationLandscapeRight:
      self.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, kButtonSizeLandscape, kButtonSizeLandscape);
      _backdrop.layer.cornerRadius = kButtonSizeLandscape/2;
      break;
    default:
      break;
  }
}

@end

@implementation MCNewsDetailBackButtonView
@end

@implementation MCNewsDetailFontButtonView
@end

@implementation MCNewsDetailShareButtonView
@end
