#import "NSMutableArray+Manipulation.h"

@implementation NSMutableArray (Manipulation)
- (void)moveObjectFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  id object = [self objectAtIndex:fromIndex];
  [self removeObjectAtIndex:fromIndex];
  [self insertObject:object atIndex:toIndex];
}
@end
