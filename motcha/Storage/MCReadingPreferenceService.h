#import <Foundation/Foundation.h>

// A service that provides local storage of user's reading preferences.
@interface MCReadingPreferenceService : NSObject

@property(nonatomic) NSArray *categories;

+ (MCReadingPreferenceService *)sharedInstance;

@end
