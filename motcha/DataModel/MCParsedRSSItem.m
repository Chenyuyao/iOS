#import "MCParsedRSSItem.h"

@implementation MCParsedRSSItem

- (instancetype)initWithTitle:(NSString *)title
                         link:(NSString *)link
                      descrpt:(NSString *)descrpt
                       imgSrc:(NSString *)imgSrc
                      pubDate:(NSString *)pubDate
                       author:(NSString *)author{
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

  return self;
}

- (void) addSource:(NSString *)source
          category:(NSString *)category
         needParse:(BOOL)needParse {
  _source = source;
  _category = category;
  _needParse = needParse;
}

@end

