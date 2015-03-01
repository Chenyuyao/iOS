#import "MCNewsDetailsObject.h"

#import "MCParsedHTMLNode.h"

@implementation MCNewsDetailsComponent {
 @protected
  MCParsedHTMLNode *_node;
}

+ (instancetype)componentWithNode:(MCParsedHTMLNode *)node {
  return [[[self class] alloc] initWithNode:node];
}

- (instancetype)initWithNode:(MCParsedHTMLNode *)node {
  self = [super init];
  if (self) {
    _node = node;
  }
  return self;
}

@end

@implementation MCNewsDetailsTitle

- (NSString *)text {
  return [_node content];
}

@end

@implementation MCNewsDetailsImage

- (NSURL *)source {
  // TODO(shinfan): implement this.
  return nil;
}

@end

@implementation MCNewsDetailsParagraph

- (NSString *)text {
  return [_node content];
}

@end

@implementation MCNewsDetailsObject

- (instancetype)initWithTitle:(NSString *)title
                       source:(NSString *)source
                   titleImage:(NSURL *)titleImage
                      content:(NSArray *)content
                         date:(NSDate *)date {
  self = [super init];
  if (self) {
    _date = date;
    _source = source;
    _content = [content copy];
    _titleImage = titleImage;
    _title = title;
  }
  return self;
}

@end
