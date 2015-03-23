#import "MCDictionaryWord.h"

@implementation MCDictionaryWord

- (instancetype)initWithWord:(NSString *)word andPos:(NSString *)pos {
  self = [super init];
  if (self) {
    _word = word;
    _pos = pos;
  }
  return self;
}

@end
