#import "MCParsedRSSItem.h"

@implementation MCParsedRSSItem

- (id)initWithProperty:(NSString *)title
                  link:(NSString *)link
               descrpt:(NSString *)descrpt
                imgSrc:(NSString *)imgSrc
               pubDate:(NSString *)pubDate
                author:(NSString *)author {
  if ([super init]) {
    _title = title;
    _link = link;
    _descrpt = descrpt;
    _imgSrc = imgSrc;
    _pubDate = pubDate;
    _author = author;
    
  }
  return self;
}

@end

