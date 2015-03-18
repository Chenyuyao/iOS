#import "MCRSSService.h"
#import "MCRSSParser.h"
#import "MCSourceService.h"
#import "MCSource.h"
#import "MCParsedRSSItem.h"

static NSString * kFullTextRSSURL = @"http://fulltextrssfeed.com/";

@implementation MCRSSService

+ (MCRSSService *)sharedInstance {
  static MCRSSService *service;
  if (!service) {
    service = [[MCRSSService alloc] init];
  }
  return service;
}


- (NSMutableArray *)fetchRSSWithCategory:(NSString *)category
                                   since:(NSDate *)since {
  //get all MCSource related to category
  MCSourceService * sourceService = [[MCSourceService alloc] init];
  NSArray * sourceArray;
  NSMutableArray * rssItemArray = [NSMutableArray array];
  
  [sourceService hardCodeSource];
  sourceArray = [sourceService getSourceWithCategory:category];
  
  for (MCSource * source in sourceArray) {
    //create a tmpItemArray for every source
    NSMutableArray * tmpItemArray;
    
    //construct url of RSS link
    NSString * urlString;
    
    if ([source fullTextable]) {
      //if this source can be parsed by fulltextfeed
      urlString = [kFullTextRSSURL stringByAppendingString:[source link]];
    } else {
      urlString = [@"http://" stringByAppendingString:[source link]];
    }
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    //use RSSParser to fetch an array of MCParsedRSSItem
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    MCRSSParser *parserOperation = [[MCRSSParser alloc] init];
    [parser setDelegate:parserOperation];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    tmpItemArray = [parserOperation feeds];
    
    //Reprocess MCParsedRSSItem
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;
    
    for (MCParsedRSSItem * item in tmpItemArray ) {
      if ([[item pubDate] compare:since] != NSOrderedDescending) {
        //this item is earliar than or equal to since, mark it as to be discarded
        [discardedItems addIndex:index];
      } else {
        //add source, category and needParse to item
        [item addSource:[source source]
               category:[source category]
              needParse:[source needParse]];
      }
      index++;
    }
    
    //Discard unused RSSItem
    [tmpItemArray removeObjectsAtIndexes:discardedItems];
    
    //add tmpItemArray to result
    [rssItemArray addObjectsFromArray:tmpItemArray];
  }
  
  //Sort rssItemArray by pubDate
  NSSortDescriptor *sortDescriptor =
  [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:TRUE];
  [rssItemArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
  return rssItemArray;
}

@end

