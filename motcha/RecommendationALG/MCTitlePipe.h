#import <Foundation/Foundation.h>

//A pipeline to process RSS feed title
//MCTitlePipe is designed as Pipe and Filter Architecture
@interface MCTitlePipe: NSObject

+ (NSDictionary*)getPosScore;
+ (MCTitlePipe *)sharedInstance;
- (NSNumber *) getTitleScore:(NSString *) title;
- (void) saveTitleWord:(NSString *) title;

@end
