#import "MCWebContentService.h"

#import "MCNewsDetailsObject.h"
#import "MCWebContentParser.h"
#import "MCParsedRSSItem.h"

@implementation MCWebContentService {
  NSOperationQueue *_backgroundQueue;
}

+ (MCWebContentService *)sharedInstance {
  static MCWebContentService *service;
  if (!service) {
    service = [[MCWebContentService alloc] init];
  }
  return service;
}

- (void)fetchNewsDetailsWithItem:(MCParsedRSSItem *)item
                completionBlock:(void(^)(MCNewsDetailsObject *, NSError *))block {
  id completionBlock = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    // Parse html result here.
    if (!connectionError) {
      MCWebContentParser *parser = [[MCWebContentParser alloc] initWithHTMLData:data];
      NSArray *content = [parser parse];
      MCNewsDetailsObject *object =
          [[MCNewsDetailsObject alloc] initWithTitle:item.title
                                              source:nil
                                          titleImage:[NSURL URLWithString:item.imgSrc]
                                             content:content
                                                date:nil
                                              author:item.author];
      block(object, nil);
    }
  };
  NSURL *url = [NSURL URLWithString:item.link];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:_backgroundQueue
                         completionHandler:completionBlock];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _backgroundQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

@end
