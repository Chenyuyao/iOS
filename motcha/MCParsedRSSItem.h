#import <Foundation/Foundation.h>


// A wrapper class for RSS that contains necessary information of a RSS item.
@interface MCParsedRSSItem : NSObject <NSCopying>

@property NSMutableString *title;
@property NSMutableString *link;
@property NSMutableString *descrpt; //this is the description tag of item
@property NSMutableString *imgSrc;
@property NSMutableString *pubDate;
@property NSMutableString *author;


@end
