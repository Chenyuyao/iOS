#import <Foundation/Foundation.h>

#import "MCParsedRSSItem.h"

// MCRSSParserDelegate is implemented to tell XMLParser how to parser a RSS file
@interface MCRSSParserDelegate : NSObject <NSXMLParserDelegate> {
    //temporary variable used while reading/parsing
    MCParsedRSSItem *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSMutableString * pubDate;
    NSMutableString * imgSrc;
    NSMutableString * author;
    NSString *element; //indicate current tag
}

@property NSMutableArray *feeds;

@end
