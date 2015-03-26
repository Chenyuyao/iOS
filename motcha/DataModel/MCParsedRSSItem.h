#import <Foundation/Foundation.h>
#import "MCCoreDataRSSItem.h"

// A wrapper class for RSS that contains necessary information of a RSS item.
@interface MCParsedRSSItem : NSObject

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *link;
@property(nonatomic, readonly) NSString *descrpt; //this is the description tag of item
@property(nonatomic, readonly) NSString *imgSrc;
@property(nonatomic, readonly) NSDate   *pubDate;
@property(nonatomic, readonly) NSString *author;
@property(nonatomic, readonly) NSString *category;
@property(nonatomic, readonly) NSString *source;
@property(nonatomic, readonly) NSNumber *score;
@property(nonatomic, readonly) BOOL needParse;

- (instancetype)initWithTitle:(NSString *)title
                         link:(NSString *)link
                      descrpt:(NSString *)descrpt
                       imgSrc:(NSString *)imgSrc
                      pubDate:(NSString *)pubDate
                       author:(NSString *)author;

- (instancetype)initWithCoreDataRSSItem:(MCCoreDataRSSItem *) coreDataRSSItem;

- (instancetype)initWithAnotherRSSItem:(MCParsedRSSItem *) item score:(NSNumber *)score;

- (void) setSource:(NSString *)source
          category:(NSString *)category
         needParse:(BOOL)needParse;
@end
