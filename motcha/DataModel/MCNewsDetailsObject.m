#import "MCNewsDetailsObject.h"

#import "MCParsedHTMLNode.h"

@implementation MCNewsDetailsComponent {
 @protected
  MCParsedHTMLNode *_node;
}

+ (instancetype)componentWithNode:(MCParsedHTMLNode *)node {
  if (node.content.length || [node type] == [MCNewsDetailsImage class]) {
    return [[[self class] alloc] initWithNode:node];
  } else {
    return nil;
  }
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
  return [NSURL URLWithString:[_node source]];
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
                         date:(NSDate *)date
                       author:(NSString *)author {
  self = [super init];
  if (self) {
    _date = date;
    _source = source;
    _content = [content copy];
    _titleImage = titleImage;
    _title = title;
    _author = author;
  }
  return self;
}

@end
