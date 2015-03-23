#import <UIKit/UIKit.h>
#import "MCNavigationController.h"

@protocol MCIntroViewControllerDelegate <NSObject>
@optional
- (void)introViewController:(UIViewController *)introViewController didSelectCategory:(NSString *)category;
- (void)introViewController:(UIViewController *)introViewController didDeselectCategory:(NSString *)category;
- (void)introViewController:(UIViewController *)introViewController didFinishChangingCategories:(NSArray *)categories;
@end

// The welcome view controller when user first launch our app.
@interface MCIntroViewController : UICollectionViewController
@property (strong, nonatomic) UINavigationController *superNavigationController;
@property (weak, nonatomic) id<MCIntroViewControllerDelegate>delegate;

- (instancetype)initWithSelectedCategories:(NSArray *)categories
                 superNavigationController:(UINavigationController *)navigationController
                           isFirstTimeUser:(BOOL)isFirstTimeUser;
@end
