#import "MCParsedRSSItem.h"
#import "MCWebContentParser.h"
#import "MCNewsDetailsObject.h"

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
    _descrpt = [self parseDescription:descrpt];
    _imgSrc = imgSrc;
    _author = author;
    _pubDate = [self parseDateString:pubDate];
  }
  return self;
}

- (instancetype)initWithCoreDataRSSItem:(MCCoreDataRSSItem *) coreDataRSSItem {
  if (self = [super init]) {
    _title = [coreDataRSSItem title];
    _link = [coreDataRSSItem link];
    _descrpt = [coreDataRSSItem descrpt];
    _imgSrc = [coreDataRSSItem imgSrc];
    _pubDate = [coreDataRSSItem pubDate];
    _author = [coreDataRSSItem author];
    _category = [coreDataRSSItem category];
    _source = [coreDataRSSItem source];
    _needParse = [[coreDataRSSItem needParse] boolValue];
  }
  return self;
}

-(instancetype)initWithAnotherRSSItem:(MCParsedRSSItem *)item score:(NSNumber *)score {
  if (self = [super init]) {
    _title = [item title];
    _link = [item link];
    _descrpt = [item descrpt];
    _imgSrc = [item imgSrc];
    _pubDate = [item pubDate];
    _author = [item author];
    _category = [item category];
    _source = [item source];
    _needParse = [item needParse];
    _score = score;
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

- (NSString *)parseDescription:(NSString *) descrpt {
  NSData* description = [descrpt dataUsingEncoding:NSUTF8StringEncoding];
  MCWebContentParser *webContentParser = [[MCWebContentParser alloc] initWithHTMLData:description];
  NSArray *parsedData = webContentParser.parse;
  return ((MCNewsDetailsParagraph *)parsedData.firstObject).text;
}

- (void) setSource:(NSString *)source
          category:(NSString *)category
         needParse:(BOOL)needParse {
  _source = source;
  _category = category;
  _needParse = needParse;
}

@end
