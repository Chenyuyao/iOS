#import "MCRSSService.h"
#import "MCRSSParser.h"
#import "MCSourceService.h"
#import "MCSource.h"
#import "MCParsedRSSItem.h"

static NSString * kFullTextRSSURL = @"http://fulltextrssfeed.com/";

@implementation MCRSSService {
  NSOperationQueue *_backgroundQueue;
}

+ (MCRSSService *)sharedInstance {
  static MCRSSService *service;
  if (!service) {
    service = [[MCRSSService alloc] init];
  }
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
             completionBlock:(void(^)(NSMutableArray *, NSError *))block{
  //get all MCSource related to category
  MCSourceService * sourceService = [[MCSourceService alloc] init];
  NSArray * sourceArray;
  
  [sourceService hardCodeSource];
  sourceArray = [sourceService getSourceByCategory:category];
  
  //initialize mutable variable
  __block NSUInteger counter = 0;
  __block NSMutableArray * rssItemArray = [NSMutableArray array];
  NSUInteger totalSource = [sourceArray count];
  
  for (MCSource * source in sourceArray) {
    //construct url of RSS link
    NSString * urlString;
    
    if ([source fullTextable]) {
      //if this source can be parsed by fulltextfeed
      urlString = [kFullTextRSSURL stringByAppendingString:[source link]];
    } else {
      urlString = [@"http://" stringByAppendingString:[source link]];
    }
    
    NSURL * url = [NSURL URLWithString:urlString];

    //callback function for sendAsynchronousRequest
    id completionBlock = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      if (!connectionError) {
        NSMutableArray * tmpItemArray;
        NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
        MCRSSParser * parserOperation = [[MCRSSParser alloc] init];
        [parser setDelegate:parserOperation];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        tmpItemArray = [parserOperation feeds];
        
        //Reprocess MCParsedRSSItem
        NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
        
        for (NSUInteger index = 0; index < [tmpItemArray count]; ++index) {
          MCParsedRSSItem * item = [tmpItemArray objectAtIndex:index];
          if ([[item pubDate] compare:since] != NSOrderedDescending) {
            //this item is earliar than or equal to since, mark it as to be discarded
            [discardedItems addIndex:index];
          } else {
            //add source, category and needParse to item
            [item setSource:[source source]
                   category:[source category]
                  needParse:[source needParse]];
          }
        }
        
        //Discard unused RSSItem
        [tmpItemArray removeObjectsAtIndexes:discardedItems];
        
        //add tmpItemArray to result
        [rssItemArray addObjectsFromArray:tmpItemArray];
        counter ++;
        
        if (counter == totalSource) {
          //ALL XML files are parsed complete
          //Sort rssItemArray by pubDate
          NSSortDescriptor *sortDescriptor =
          [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:TRUE];
          [rssItemArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
          
          //callback
          block(rssItemArray,nil);
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
}

@end

