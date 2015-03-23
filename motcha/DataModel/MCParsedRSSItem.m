#import "MCParsedRSSItem.h"
#import "NSString+Trim.h"

@implementation MCParsedRSSItem

- (instancetype) initWithTitle:(NSString *)title
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
    _pubDate = [self parseDateString:pubDate];
  }
  return self;
}

//parse an dateString to NSDate
- (NSDate *) parseDateString:(NSString *) dateString {
  NSDate *date = nil;
  if (dateString) {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    @synchronized(dateFormat) {
      if ([dateString rangeOfString:@","].location != NSNotFound) {
        if (!date) {
          [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
          date = [dateFormat dateFromString:dateString];
        }
      } else {
        if (!date) {
          [dateFormat setDateFormat:@"d MMM yyyy HH:mm"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"d MMM yyyy HH:mm:ss"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"d MMM yyyy HH:mm zzz"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"d MMM yyyy HH:mm:ss zzz"];
          date = [dateFormat dateFromString:dateString];
        }
        if (!date) {
          [dateFormat setDateFormat:@"d MMM yyyy HH:mm:ss Z"];
          date = [dateFormat dateFromString:dateString];
        }
      }
      if (!date) {
        //Could not parse date, set date to 1970
        date = [NSDate dateWithTimeIntervalSince1970:0];
      }
    }
  }
  return date;
}

- (void) setSource:(NSString *)source
          category:(NSString *)category
         needParse:(BOOL)needParse {
  _source = source;
  _category = category;
  _needParse = needParse;
}

@end

