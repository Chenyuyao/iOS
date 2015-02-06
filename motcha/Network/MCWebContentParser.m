#import "HTMLParser.h"
#import "HTMLNode.h"
#import "MCParsedHTMLNode.h"

#import <objc/runtime.h>

#import "MCWebContentParser.h"
#import "MCWebContentParser+Utility.h"

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

//    for (TFHppleElement *element in elements) {
//    if (![element.tagName isEqualToString:@"p"]) {
//      continue;
//    }
//    if ([self IsElement:element
//             hasClasses:@"comment|meta|footer|footnote"]) {
//      element.score -= 50;
//    } else if ([self IsElement:element hasClasses:@"(^|\\s)(post|hentry|entry[-]?\
//        (content|text|body)?|article[-]?(content|text|body)?)(\\s|$)"]) {
//      element.score += 25;
//    }
//    for (TFHppleElement *child in element.children) {
//      element.score += child.content.length;
//    }
//    if (element.score > 0) {
//      NSLog(@"%@", element);
//    }
//    if (element.score > topElement.score) {
//      topElement = element;
//    }
//  }
//
//- (void)findTopNodeWithRoot:(HTMLNode *)root {
//  if (!root) {
//    return;
//  }
//  if (root.score > _topNode.score) {
//    _topNode = root;
//  }
//  for (HTMLNode *child in root.children) {
//    [self findTopNodeWithRoot:child];
//  }
//}

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
