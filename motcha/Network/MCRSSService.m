#import "MCRSSService.h"

#import "MCRSSParser.h"

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
  MCRSSParser *parserOperation = [[MCRSSParser alloc] init];
  [parser setDelegate:parserOperation];
  [parser setShouldResolveExternalEntities:NO];
  [parser parse];
  
  //Retrieve parsed result from parserDelegate.feeds
}

@end

