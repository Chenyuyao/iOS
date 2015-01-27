#import <UIKit/UIKit.h>

// A subclass of UICollectionViewLayout that is used by MCIntroViewController.
@interface MCIntroCollectionViewLayout : UICollectionViewLayout

@property(nonatomic) NSUInteger numberOfElementsInEachRow;
@property(nonatomic) CGFloat spacing;
@property(nonatomic) CGFloat margin;
@property(nonatomic) CGSize preferredElementSize;
@property(nonatomic) BOOL isFlexibleWidth;
@property(nonatomic) CGFloat headerHeight;
@property(nonatomic) CGFloat footerHeight;

@end
