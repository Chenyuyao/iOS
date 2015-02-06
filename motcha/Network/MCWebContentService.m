#import "MCWebContentService.h"

#import "MCNewsDetailsObject.h"
#import "MCWebContentParser.h"

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

- (void)fetchNewsDetailsWithURL:(NSURL *)url
                completionBlock:(void(^)(MCNewsDetailsObject *, NSError *))block {
  id completionBlock = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    // Parse html result here.
    if (!connectionError) {
      MCWebContentParser *parser = [[MCWebContentParser alloc] initWithHTMLData:data];
      [parser parse];
    }
  };
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
