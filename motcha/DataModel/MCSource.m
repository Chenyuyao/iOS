#import "MCSource.h"

@implementation MCSource

- (instancetype)initWithCategory:(NSString *)category
                          source:(NSString *)source
                            link:(NSString *)link
                       needParse:(BOOL)needParse
                     fullTextale:(BOOL) fullTextable {
  if (self = [super init]) {
    _category = category;
    _source = source;
    _link = link;
    _needParse = needParse;
    _fullTextable = fullTextable;
  }
  
  return self;

}

@end