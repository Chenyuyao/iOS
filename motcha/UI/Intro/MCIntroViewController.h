#import <UIKit/UIKit.h>

// The welcome view controller when user first launch our app.
@interface MCIntroViewController : UICollectionViewController
- (instancetype)initWithSelectedCategories:(NSMutableArray *)categories;
@end
