#import <Foundation/Foundation.h>

@class HTMLNode;

@interface MCParsedHTMLNode : NSObject

@property(nonatomic, readonly) NSString *content;
@property(nonatomic, readonly) NSString *rawContent;
@property(nonatomic, readonly) NSString *tag;
@property(nonatomic) NSInteger score;
@property(nonatomic, readonly) NSArray *children;
@property(nonatomic, readonly) MCParsedHTMLNode *parent;

- (instancetype)initWithHTMLNode:(HTMLNode *)node
                          parent:(MCParsedHTMLNode *)parent;

@end
