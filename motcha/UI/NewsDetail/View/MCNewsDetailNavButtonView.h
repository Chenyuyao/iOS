#import <UIKit/UIKit.h>

@interface MCNewsDetailNavButtonView : UIView
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic) UIInterfaceOrientation buttonOrientation;
@end

@interface MCNewsDetailBackButtonView : MCNewsDetailNavButtonView
@end

@interface MCNewsDetailFontButtonView : MCNewsDetailNavButtonView
@end

@interface MCNewsDetailShareButtonView : MCNewsDetailNavButtonView
@end
