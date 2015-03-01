#import "MCWebContentParser.h"

#import <objc/runtime.h>

#import "HTMLNode.h"
#import "HTMLParser.h"
#import "MCNewsDetailsObject.h"
#import "MCParsedHTMLNode.h"

@implementation MCWebContentParser {
  NSMutableArray *_paragraphs;
  MCParsedHTMLNode *_topNode;
}

- (instancetype)initWithHTMLData:(NSData *)data {
  self = [super init];
  if (self) {
    _htmlData = data;
  }
  return self;
}

- (NSArray *)parse {
  NSString *htmlString =
      [[NSString alloc] initWithData:_htmlData encoding:NSASCIIStringEncoding];
  NSError *error;
  HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
  NSArray *components;
  if (parser && !error) {
    MCParsedHTMLNode *bodyNode =
        [[MCParsedHTMLNode alloc] initWithHTMLNode:[parser body] parent:nil];
    [self findAllParagraphsWithRoot:bodyNode];
    for (MCParsedHTMLNode *paragraph in _paragraphs) {
      MCParsedHTMLNode *parent = paragraph.parent;
      parent.score = parent.score + paragraph.content.length;
    }
    for (MCParsedHTMLNode *paragraph in _paragraphs) {
      if (paragraph.parent.score > _topNode.score) {
        _topNode = paragraph.parent;
      }
    }
    components = [self componentsWithNode:_topNode];
  }
  return components;
}

- (NSArray *)componentsWithNode:(MCParsedHTMLNode *)node {
  NSMutableArray *components = [NSMutableArray array];
  [self parseComponentsWithNode:node result:components];
  return components;
}

- (void)parseComponentsWithNode:(MCParsedHTMLNode *)node
                         result:(NSMutableArray *)result {
  if (!node) {
    return;
  }
  MCNewsDetailsComponent *component = [[node type] componentWithNode:node];
  if (component) {
    [result addObject:component];
  }
  for (MCParsedHTMLNode *child in node.children) {
    [self parseComponentsWithNode:child result:result];
  }
}

- (void)findAllParagraphsWithRoot:(MCParsedHTMLNode *)root {
  if (!_paragraphs) {
    _paragraphs = [NSMutableArray array];
  }
  if (!root) {
    return;
  }
  if ([root.tag isEqualToString:@"p"]) {
    [_paragraphs addObject:root];
  }
  for (MCParsedHTMLNode *child in root.children) {
    [self findAllParagraphsWithRoot:child];
  }
}

@end
