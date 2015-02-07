#import "MCRSSService.h"

#import "MCRSSParserDelegate.h"

@implementation MCRSSService

+ (MCRSSService *)sharedInstance {
    static MCRSSService *service;
    if (!service) {
        service = [[MCRSSService alloc] init];
    }
    return service;
}


- (void)fetchRSSWithURL:(NSURL *)url
        completionBlock:(void(^)(NSMutableArray *, NSError *))block{
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    MCRSSParserDelegate *parserDelegate = [[MCRSSParserDelegate alloc] init];
    [parser setDelegate:parserDelegate];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    //Retrieve parsed result from parserDelegate.feeds
}

@end
