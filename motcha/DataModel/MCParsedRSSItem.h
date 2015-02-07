#import <Foundation/Foundation.h>


// A wrapper class for RSS that contains necessary information of a RSS item.
@interface MCParsedRSSItem : NSObject <NSCopying>

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *link;
@property(nonatomic, readonly) NSString *descrpt; //this is the description tag of item
@property(nonatomic, readonly) NSString *imgSrc;
@property(nonatomic, readonly) NSString *pubDate;
@property(nonatomic, readonly) NSString *author;

- (instancetype)initWithProperty:(NSString *)title
                            link:(NSString *)link
                         descrpt:(NSString *)descrpt
                          imgSrc:(NSString *)imgSrc
                         pubDate:(NSString *)pubDate
                          author:(NSString *)author;


@end

