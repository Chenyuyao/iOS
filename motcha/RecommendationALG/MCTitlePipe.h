#import <Foundation/Foundation.h>

//A pipeline to process RSS feed title
//MCTitlePipe is designed as Pipe and Filter Architecture
@interface MCTitlePipe: NSObject


//Methods there takes some time to excute and should be put in background queue
+ (NSDictionary*)getPosScore;
+ (MCTitlePipe *)sharedInstance;
- (NSNumber *) getTitleScore:(NSString *) title;
- (void) saveTitleWord:(NSString *) title;

@end
