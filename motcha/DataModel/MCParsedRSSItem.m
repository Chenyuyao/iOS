#import "MCParsedRSSItem.h"

@implementation MCParsedRSSItem

- (id)initWithProperty:(NSString *)title
                  link:(NSString *)link
               descrpt:(NSString *)descrpt
                imgSrc:(NSString *)imgSrc
               pubDate:(NSString *)pubDate
                author:(NSString *)author {
  self = [super init];
  if (self) {
    _title = title;
    _link = link;
    _descrpt = descrpt;
    _imgSrc = imgSrc;
    _pubDate = pubDate;
    _author = author;
    
  }
  return self;
}

//used for [item copy] message
- (id)copyWithZone:(NSZone *)zone
{
  id copy = [[[self class] alloc] initWithProperty:self.title
                                              link:self.link
                                           descrpt:self.descrpt
                                            imgSrc:self.imgSrc
                                           pubDate:self.pubDate
                                            author:self.author];
  
  return copy;
}

@end

