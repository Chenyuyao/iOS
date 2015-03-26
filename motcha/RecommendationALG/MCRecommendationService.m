#include "MCRecommendationService.h"

#include "MCCategorySourceService.h"
#include "MCTitlePipe.h"
#include "MCCoreDataRSSItem.h"

@implementation MCRecommendationService

+ (MCRecommendationService *)sharedInstance {
  static MCRecommendationService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCRecommendationService alloc] init];
  });
  return service;
}

+ (NSArray *)getFetchedNumbers {
  static NSArray *fetchedNumber = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    fetchedNumber = @[@6,@3,@1];
  });
  return fetchedNumber;
}

//generate a random integer between from and to
-(int)getRandomNumberBetween:(int)from to:(int)to {
  return from + arc4random() % (to - from +1);
}

//random select a category with uniform probability or probability scaled to their score
- (int)getRandomCategory:(NSArray *)categories uniform:(BOOL)uniform {
  if (!uniform) {
    int sumScore = 0;
    for (MCCategory * category in categories) {
      sumScore += [[category score] intValue];
    }

    int randomInt = [self getRandomNumberBetween:1 to:sumScore];
    for (int i = 0; i < [categories count]; i++) {
      MCCategory * category = [categories objectAtIndex:i];
      if (randomInt <= [[category score] intValue]) {
        return i;
      } else {
        randomInt -= [[category score] intValue];
      }
    }
    
    //Should not reach here
    NSLog(@"Error generating random category");
  }
  return [self getRandomNumberBetween:0 to:(int)[categories count]];
}


- (void)getRecommendedCategoryWithBlock:(void(^)(NSArray *, NSError *))block {
  id completionBlock = ^(NSArray *entities, NSError *error) {
    NSMutableArray * categories = [entities mutableCopy];
    
    //get first Recommended Category
    int firstRecommendedCategoryIndex = [self getRandomCategory:categories uniform:NO];
    MCCategory * firstRecommendedCategory = [categories objectAtIndex:firstRecommendedCategoryIndex];
    [categories removeObjectAtIndex:firstRecommendedCategoryIndex];
    
    //get second Recommended Category
    int secondRecommendedCategoryIndex = [self getRandomCategory:categories uniform:NO];
    MCCategory * secondRecommendedCategory = [categories objectAtIndex:secondRecommendedCategoryIndex];
    [categories removeObjectAtIndex:secondRecommendedCategoryIndex];
    
    //get third Recommended Category
    int thirdRecommendedCategoryIndex = [self getRandomCategory:categories uniform:YES];
    MCCategory * thirdRecommendedCategory = [categories objectAtIndex:thirdRecommendedCategoryIndex];
    block(@[firstRecommendedCategory, secondRecommendedCategory, thirdRecommendedCategory],nil);
  };
  
  [[MCCategorySourceService sharedInstance] fetchAllCategoriesAsync:YES withBlock:completionBlock];
}

- (void)incrementCount:(MCParsedRSSItem *) item {
  NSString * categoryString = [item category];
  NSString * sourceString = [item source];
  NSString * titleString = [item title];
  
  [[MCCategorySourceService sharedInstance] incrementCategoryCount:categoryString];
  [[MCCategorySourceService sharedInstance] incrementSourceCount:sourceString];
  [[MCTitlePipe sharedInstance] saveTitleWord:titleString];
}

-(void)fetchRSSItemScore:(MCParsedRSSItem *)item withBlock:(void (^)(MCParsedRSSItem *, NSError *))block{
  id sourceBlock = ^(MCSource * source, NSError * error){
    NSNumber * sourceCount = [source count];
    NSString * title = [item title];
    
    id scoreBlock = ^(NSNumber * titleScore, NSError * titleError) {
      //calculate item score (source count + title score)
      NSNumber * itemScore = [NSNumber numberWithFloat:[sourceCount floatValue] + [titleScore floatValue]];
      block([[MCParsedRSSItem alloc] initWithAnotherRSSItem:item score:itemScore], nil);
    };
    
    [[MCTitlePipe sharedInstance] fetchTitleScore:title withBlock:scoreBlock];
  };
  [[MCCategorySourceService sharedInstance] fetchSource:[item source]
                                           categoryName:[item category]
                                                  async:NO
                                              withBlock:sourceBlock];
}

-(void)recommendRSSItems:(MCCategory *)category
             fetchNumber:(NSNumber *)fetchNumber
         withBlock:(void (^)(NSArray *, NSError *))block {
  id completionBlock = ^(NSArray * entities, NSError * error) {
    if (!error) {
      for (MCCoreDataRSSItem * coreDataRSSItems in entities) {
        MCParsedRSSItem * item = [[MCParsedRSSItem alloc] initWithCoreDataRSSItem:coreDataRSSItems];
        
      }
    } else {
      block(nil,error);
    }
  };
}

@end
