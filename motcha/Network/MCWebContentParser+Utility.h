#import "MCWebContentParser.h"

@class TFHppleElement;

@interface MCWebContentParser (Utility)

- (BOOL)IsElement:(TFHppleElement *)element hasClasses:(NSString *)classes;

@end
