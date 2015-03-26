#import "MCRSSStoreService.h"

#import "MCCoreDataRSSItem.h"
#import "MCDatabaseManager.h"

static NSString *kStrRSSItemEntityName = @"MCCoreDataRSSItem";

@implementation MCRSSStoreService

+(MCRSSStoreService *)sharedInstance {
  static MCRSSStoreService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCRSSStoreService alloc] init];
  });
  return service;
}

-(void)fetchRSSItemWithCategory:(NSString *)categoryName
                         source:(NSString *)sourceName
                          title:(NSString *)title
                          async:(BOOL)shouldFetchAsync
                      withBlock:(void(^)(MCParsedRSSItem *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    if (!error) {
      if ([entities count] > 0) {
        MCParsedRSSItem * coreDataRSSItem = (MCParsedRSSItem *)[entities objectAtIndex:0];
        block(coreDataRSSItem,nil);
      } else {
        block(nil,nil);
      }
    } else {
      block(nil,error);
    }
  };
  
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(%K == %@) AND (%K == %@) AND (%K == %@)",
                             @"category", categoryName, @"source", sourceName, @"title", title];
  
  [[MCDatabaseManager defaultManager] fetchEntriesForEntityName:kStrRSSItemEntityName
                                                          async:shouldFetchAsync
                                                    onPredicate:predicate
                                                         onSort:nil
                                                completionBlock:completionBlock];
}

-(void)saveRSSItem:(MCParsedRSSItem *)item {
  id completionBlock = ^(MCParsedRSSItem *resItem, NSError *error) {
    if (!resItem) {
      MCCoreDataRSSItem * coreDataRSSItem = (MCCoreDataRSSItem *)[[MCDatabaseManager defaultManager]
                                             createEntityWithName:kStrRSSItemEntityName];
      [coreDataRSSItem setCategory:[resItem category]];
      [coreDataRSSItem setAuthor:[resItem author]];
      [coreDataRSSItem setDescrpt:[resItem descrpt]];
      [coreDataRSSItem setImgSrc:[resItem imgSrc]];
      [coreDataRSSItem setLink:[resItem link]];
      [coreDataRSSItem setNeedParse:[NSNumber numberWithBool:[resItem needParse]]];
      [coreDataRSSItem setPubDate:[resItem pubDate]];
      [coreDataRSSItem setSource:[resItem source]];
      [coreDataRSSItem setTitle:[resItem title]];
      [coreDataRSSItem setIsRead:@NO];
      [coreDataRSSItem setRecommendId:@0];
      
      [[coreDataRSSItem managedObjectContext] save:nil];
    }
  };
  
  [self fetchRSSItemWithCategory:[item category]
                          source:[item source]
                           title:[item title]
                           async:YES
                       withBlock:completionBlock];
}

@end
