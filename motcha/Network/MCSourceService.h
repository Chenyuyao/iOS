#import <Foundation/Foundation.h>

//A service to return manage MCSource
//Right now we hardcode every MCSource object
//TODO: Should change to extracting source info from CORE DATA
@interface MCSourceService : NSObject

@property(nonatomic, readonly) NSMutableDictionary *sources;

- (NSArray *) getSourceByCategory:(NSString *) category;
- (void) hardCodeSource;

@end
