#import <Foundation/Foundation.h>

//A service to return manage MCSource
//Right now we hardcode every MCSource object
//TODO: Should change to extracting source info from CORE DATA
@interface MCSourceService : NSObject

@property(nonatomic, readonly) NSDictionary *sources;

- (NSArray *) getSourceWithCategory:(NSString *) category;
- (void) hardCodeSource;

@end
