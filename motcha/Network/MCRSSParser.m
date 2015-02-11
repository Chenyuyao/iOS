#import "MCRSSParser.h"

//Regex for extracting img src
static NSString * kImgSrcRegex = @"(<img\\s[\\s\\S]*?src=['\"](.*?)['\"][\\s\\S]*?>)+?";

@implementation MCRSSParser {
  //temporary variable used while reading/parsing
  MCParsedRSSItem * _item;
  NSMutableString * _title;
  NSMutableString * _link;
  NSMutableString * _description;
  NSMutableString * _pubDate;
  NSMutableString * _imgSrc;
  NSMutableString * _author;
  NSString        * _element; //indicate current tag
}

#pragma mark - NSXMLParserDelegate methods
- (void) parserDidStartDocument:(NSXMLParser *)parser {
  _feeds = [[NSMutableArray alloc] init];
}

#pragma mark - NSXMLParserDelegate methods
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
  _element = elementName;
  
  //Only parse item element
  if ([_element isEqualToString:@"item"]) {
    _title       = [[NSMutableString alloc] init];
    _link        = [[NSMutableString alloc] init];
    _description = [[NSMutableString alloc] init];
    _pubDate     = [[NSMutableString alloc] init];
    _imgSrc      = [[NSMutableString alloc] init];
    _author      = [[NSMutableString alloc] init];
  }
}

#pragma mark - NSXMLParserDelegate methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if ([_element isEqualToString:@"title"]) {
    [_title appendString:string];
  } else if ([_element isEqualToString:@"link"]) {
    [_link appendString:string];
  } else if ([_element isEqualToString:@"description"]) {
    [_description appendString:string];
    
    //Set image url
    if (_description != nil && [string length] > 8 && [_imgSrc length] == 0) {
      NSError *error = NULL;
      NSRegularExpression *regex =
      [NSRegularExpression regularExpressionWithPattern:kImgSrcRegex
                                                options:NSRegularExpressionCaseInsensitive
                                                  error:&error];
      
      NSArray *matches = [regex matchesInString:_description
                                        options:0
                                          range:NSMakeRange(0, [_description length])];
      
      if ([matches count] > 0) {
        NSString *img = [_description substringWithRange:[matches[0] rangeAtIndex:2]];
        [_imgSrc appendString:img];
      }
    }
  } else if ([_element isEqualToString:@"pubDate"]) {
    [_pubDate appendString:string];
  } else if ([_element isEqualToString:@"author"]) {
    [_author appendString:string];
  }
  
}

#pragma mark - NSXMLParserDelegate methods
- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
  //After parse one item, put this item into feeds
  if ([elementName isEqualToString:@"item"]) {
    _item = [[MCParsedRSSItem alloc] initWithProperty:_title
                                                 link:_link
                                              descrpt:_description
                                               imgSrc:_imgSrc
                                              pubDate:_pubDate
                                               author:_author];
    [_feeds addObject:_item];
  }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
  //TODO: output feeds(maybe)
}

@end

