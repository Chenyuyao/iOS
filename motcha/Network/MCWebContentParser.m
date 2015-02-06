#import "MCWebContentParser.h"

#import <objc/runtime.h>

#import "HTMLNode.h"
#import "HTMLParser.h"
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

- (void)parse {
  [self parseArticle];
}

- (void)parseArticle {
  NSString *htmlString =
      [[NSString alloc] initWithData:_htmlData encoding:NSASCIIStringEncoding];
  NSError *error;
  HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
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
