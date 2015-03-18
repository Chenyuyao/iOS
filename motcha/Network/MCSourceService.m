#import "MCSourceService.h"
#import "MCSource.h"

@implementation MCSourceService

- (void) hardCodeSource {
  //Hardcoded MCSource
  MCSource * technologySource1 =
  [[MCSource alloc] initWithCategory:@"technology"
                              source:@"cnet"
                                link:@"www.cnet.com/rss/news/"
                           needParse:NO
                         fullTextale:YES];
  
  MCSource * technologySource2 =
  [[MCSource alloc] initWithCategory:@"technology"
                              source:@"engadget"
                                link:@"www.engadget.com/rss.xml/"
                           needParse:NO
                         fullTextale:YES];
  [_sources setValue:@[technologySource1, technologySource2] forKey:@"technology"];
  
  MCSource * financeSource =
  [[MCSource alloc] initWithCategory:@"finance"
                              source:@"economist"
                                link:@"www.economist.com/sections/business-finance/rss.xml"
                           needParse:NO
                         fullTextale:YES];
  [_sources setValue:@[financeSource] forKey:@"finance"];
  
  MCSource * artsSource =
  [[MCSource alloc] initWithCategory:@"arts"
                              source:@"artnews"
                                link:@"www.artnews.com/feed/"
                           needParse:NO
                         fullTextale:YES];
  [_sources setValue:@[artsSource] forKey:@"arts"];
  
}

- (NSArray *)getSourceWithCategory:(NSString *)category {
  NSArray * result = [_sources objectForKey:category];
  if (result == nil) {
    result = [_sources objectForKey:@"technology"];
  }
  return result;
}

@end