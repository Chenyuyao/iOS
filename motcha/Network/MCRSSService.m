#import "MCRSSService.h"
#import "MCRSSParser.h"
#import "MCCategorySourceService.h"
#import "MCSource.h"
#import "MCParsedRSSItem.h"

static NSString *kFullTextRSSURL = @"http://fulltextrssfeed.com/";

@implementation MCRSSService {
  NSOperationQueue *_backgroundQueue;
}

+ (MCRSSService *)sharedInstance {
  static MCRSSService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCRSSService alloc] init];
  });
  return service;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _backgroundQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)fetchRSSWithCategory:(NSString *)category
                       since:(NSDate *)since
             completionBlock:(void(^)(NSMutableArray *rssItems, NSError *error))block {
  
  // Get all MCSource related to category
  id sourceBlock = ^(NSArray * sourceArray, NSError * error) {
    // Initialize mutable variable
    __block NSUInteger counter = 0;
    __block NSMutableArray * rssItems = [NSMutableArray array];
    NSUInteger totalSource = [sourceArray count];
    
    for (MCSource * source in sourceArray) {
      // Construct url of RSS link
      NSString * urlString;
      
      if ([source fullTextable]) {
        //if this source can be parsed by fulltextfeed
        urlString = [kFullTextRSSURL stringByAppendingString:[source link]];
      } else {
        urlString = [@"http://" stringByAppendingString:[source link]];
      }
      
      NSURL * url = [NSURL URLWithString:urlString];
      
      id completionBlock = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
          NSMutableArray * rssItemsFromOneSource;
          NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
          MCRSSParser * parserOperation = [[MCRSSParser alloc] init];
          [parser setDelegate:parserOperation];
          [parser setShouldResolveExternalEntities:NO];
          [parser parse];
          
          // After parse returns, the parsed results will be in the NSXMLParser's delegate, and we
          // can now extract it from there.
          rssItemsFromOneSource = [parserOperation feeds];
          
          // Reprocess MCParsedRSSItem
          NSMutableIndexSet *discardedItemIndexes = [NSMutableIndexSet indexSet];
          
          for (NSUInteger index = 0; index < [rssItemsFromOneSource count]; ++index) {
            MCParsedRSSItem * item = [rssItemsFromOneSource objectAtIndex:index];
            if ([[item pubDate] compare:since] != NSOrderedDescending) {
              // This item is earliar than or equal to since, mark it as to be discarded
              [discardedItemIndexes addIndex:index];
            } else {
              // Add source, category and needParse to item
              [item setSource:[source source]
                     category:[source category]
                    needParse:[source needParse]];
            }
          }
          
          // Discard out-dated RSSItem
          [rssItemsFromOneSource removeObjectsAtIndexes:discardedItemIndexes];
          
          // Add rssItemsFromOneSource to result
          [rssItems addObjectsFromArray:rssItemsFromOneSource];
          counter++;
          
          // The barrier. block is only evaluated after all sources have been parsed.
          if (counter == totalSource) {
            //ALL XML files are parsed complete
            //Sort rssItemArray by pubDate
            NSSortDescriptor *sortDescriptor =
            [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
            [rssItems sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            //callback
            block(rssItems,nil);
          }
        } else {
          block(nil, connectionError);
        }
      };
      
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
      [NSURLConnection sendAsynchronousRequest:request
                                         queue:_backgroundQueue
                             completionHandler:completionBlock];
    }
  };
  
  [[MCCategorySourceService sharedInstance] fetchSourceByCategory:category async:YES withBlock:sourceBlock];
  
}

@end

