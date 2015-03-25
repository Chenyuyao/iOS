#include "MCRecommendationService.h"

#include "MCCategorySourceService.h"
@implementation MCRecommendationService

+ (MCRecommendationService *)sharedInstance {
  static MCRecommendationService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCRecommendationService alloc] init];
  });
  return service;
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


- (NSArray *)getRecommendedCategory {
  NSMutableArray * categories = [[[MCCategorySourceService sharedInstance] getAllCategories] mutableCopy];
  
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
  
  return @[firstRecommendedCategory, secondRecommendedCategory, thirdRecommendedCategory];
}


@end