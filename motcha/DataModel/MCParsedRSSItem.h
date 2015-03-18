#import <Foundation/Foundation.h>

// A wrapper class for RSS that contains necessary information of a RSS item.
@interface MCParsedRSSItem : NSObject

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *link;
@property(nonatomic, readonly) NSString *descrpt; //this is the description tag of item
@property(nonatomic, readonly) NSString *imgSrc;
@property(nonatomic, readonly) NSDate   *pubDate;
@property(nonatomic, readonly) NSString *author;
@property(nonatomic, readonly) NSString *source;
@property(nonatomic, readonly) BOOL needParse;

- (instancetype)initWithTitle:(NSString *)title
                         link:(NSString *)link
                      descrpt:(NSString *)descrpt
                       imgSrc:(NSString *)imgSrc
                      pubDate:(NSString *)pubDate
                       author:(NSString *)author;

- (void) addSource:(NSString *)source
         needParse:(BOOL)needParse;
@end

