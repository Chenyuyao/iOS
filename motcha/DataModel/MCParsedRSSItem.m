#import "MCParsedRSSItem.h"

@implementation MCParsedRSSItem

- (id)initWithTitle:(NSString *)title
               link:(NSString *)link
            descrpt:(NSString *)descrpt
             imgSrc:(NSString *)imgSrc
            pubDate:(NSString *)pubDate
             author:(NSString *)author {
  if (self = [super init]) {
    _title = title;
    _link = link;
    _descrpt = descrpt;
    _imgSrc = imgSrc;
    _author = author;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    _pubDate = [dateFormat dateFromString:pubDate];    
  }
  
  //TODO:extract RSS source
  return self;
}

@end

