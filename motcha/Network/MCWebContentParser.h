#import <Foundation/Foundation.h>

// A HTML parser used to parse content HTML data and then create MCNewDetailsObject.
@interface MCWebContentParser : NSObject

@property(nonatomic) NSData *htmlData;

- (instancetype)initWithHTMLData:(NSData *)data;

// Parse the article and returns an array of MCNewDetailsComponents.
- (NSArray *)parse;

@end
