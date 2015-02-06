#import <Foundation/Foundation.h>

@interface MCWebContentParser : NSObject

@property(nonatomic) NSData *htmlData;

- (instancetype)initWithHTMLData:(NSData *)data;
- (void)parse;

@end
