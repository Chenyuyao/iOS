#import "MCParsedRSSItem.h"

@implementation MCParsedRSSItem

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setTitle:self.title];
        [copy setLink:self.link];
        [copy setDescrpt:self.descrpt];
        [copy setPubDate:self.pubDate];
        [copy setImgSrc:self.imgSrc];
        [copy setAuthor:self.author];
    }
    
    return copy;
}

@end