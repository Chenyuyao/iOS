#import <Foundation/Foundation.h>

// A wrapper class for Source
//This class may be changed to inherited from NSManagedObject to enable extracting data from CORE DATA
@interface MCSource : NSObject

@property(nonatomic, readonly) NSString *category;
@property(nonatomic, readonly) NSString *source;
@property(nonatomic, readonly) NSString *link;
@property(nonatomic) BOOL needParse;
@property(nonatomic) BOOL fullTextable;

- (instancetype)initWithCategory:(NSString *) category
                          source:(NSString *) source
                            link:(NSString *) link
                       needParse:(BOOL) needParse
                     fullTextale:(BOOL) fullTextable;


@end
