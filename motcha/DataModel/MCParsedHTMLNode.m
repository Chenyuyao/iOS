#import "MCParsedHTMLNode.h"

#import "HTMLNode.h"

@implementation MCParsedHTMLNode {
  NSString *_textContent;
}

- (id)initWithHTMLNode:(HTMLNode *)node parent:(MCParsedHTMLNode *)parent {
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


@end
