#import "MCCategory.h"

@implementation MCCategory

- (instancetype)initWithCategory:(NSString *)category
                           count:(NSNumber *)count
                       lastFetch:(NSDate *)lastFetch
                        selected:(BOOL)selected {
  if (self = [super init]) {
    _category = category;
    _lastFetch = lastFetch;
    _count = count;
    _selected = selected;
  }
  
  return self;
}

//return the score of this category
- (NSNumber *)score {
  return [NSNumber numberWithInt: [_count intValue] * ((_selected == YES)? 2 : 0)];
}

@end
