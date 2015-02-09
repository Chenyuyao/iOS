#import <Foundation/Foundation.h>
#import "MCParsedRSSItem.h"

// MCRSSParserDelegate is implemented to tell XMLParser how to parser a RSS file
@interface MCRSSParser : NSObject <NSXMLParserDelegate>

@property NSMutableArray *feeds;

@end

