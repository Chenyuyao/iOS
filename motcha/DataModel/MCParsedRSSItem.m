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
    
    NSString * escapedPubDate = [pubDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    _pubDate = [dateFormat dateFromString:escapedPubDate];    
  }

  return self;
}

- (void) setSource:(NSString *)source
          category:(NSString *)category
         needParse:(BOOL)needParse {
  _source = source;
  _category = category;
  _needParse = needParse;
}

@end

