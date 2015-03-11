#import "MCParsedHTMLNode.h"

#import "MCNewsDetailsObject.h"
#import "HTMLNode.h"

@implementation MCParsedHTMLNode

- (instancetype)initWithHTMLNode:(HTMLNode *)node parent:(MCParsedHTMLNode *)parent {
  self = [super init];
  if (self) {
    NSMutableArray *children = [NSMutableArray array];
    for (HTMLNode *child in node.children) {
      [children addObject:[[[self class] alloc] initWithHTMLNode:child
                                                          parent:self]];
    }
    _children = children;
    _content = node.allContents;
    _rawContent = node.rawContents;
    _parent = parent;
    _tag = node.tagName;
  }
  return self;
}

- (Class)type {
  if ([self.tag isEqualToString:@"p"]) {
    return [MCNewsDetailsParagraph class];
  } else if ([self.tag isEqualToString:@"h1"] || [self.tag isEqualToString:@"h2"] ||
      [self.tag isEqualToString:@"h3"]) {
    return [MCNewsDetailsTitle class];
  } else if ([self.tag isEqualToString:@"image"]) {
    return [MCNewsDetailsImage class];
  } else {
    return nil;
  }
}

@end
