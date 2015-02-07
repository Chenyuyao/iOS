#import "MCRSSParserDelegate.h"

@implementation MCRSSParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    _feeds = [[NSMutableArray alloc] init];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    //Only parse item element
    if ([element isEqualToString:@"item"]) {
        item        = [[MCParsedRSSItem alloc] init];
        title       = [[NSMutableString alloc] init];
        link        = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        pubDate     = [[NSMutableString alloc] init];
        imgSrc      = [[NSMutableString alloc] init];
        author      = [[NSMutableString alloc] init];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
        
        //Set image url
        if (description != nil && [string length] > 8 && [imgSrc length] == 0) {
            NSError *error = NULL;
            NSRegularExpression *regex =
            [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src=['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
            
            NSArray *matches = [regex matchesInString:description
                                              options:0
                                                range:NSMakeRange(0, [description length])];
            
            if ([matches count] > 0) {
                NSString *img = [description substringWithRange:[matches[0] rangeAtIndex:2]];
                [imgSrc appendString:img];
            }
        }
    } else if ([element isEqualToString:@"pubDate"]) {
        [pubDate appendString:string];
    } else if ([element isEqualToString:@"author"]) {
        [author appendString:string];
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //After parse one item, put this item into feeds
    if ([elementName isEqualToString:@"item"]) {
        [item setTitle:title];
        [item setLink:link];
        [item setDescrpt:description];
        [item setPubDate:pubDate];
        [item setImgSrc:imgSrc];
        [item setAuthor:author];
        [_feeds addObject:[item copy]];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
}
@end

