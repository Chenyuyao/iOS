#import <UIKit/UIKit.h>

@interface MCNewsListCollectionViewLayout : UICollectionViewLayout
@property(nonatomic) NSUInteger numberOfElementsInEachRow;
@property(nonatomic) CGFloat spacing;
@property(nonatomic) CGFloat margin;
@property(nonatomic) CGSize preferredElementSize;
@property(nonatomic) BOOL isFlexibleWidth;
@end
