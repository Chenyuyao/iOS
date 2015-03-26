#import <Foundation/Foundation.h>

@class HTMLNode;
@class MCNewsDetailsComponent;

// A wrapper class for HTMLNode that contains necessary information of a DOM element.
@interface MCParsedHTMLNode : NSObject

@property(nonatomic, readonly) NSString *content;
@property(nonatomic, readonly) NSString *rawContent;
@property(nonatomic, readonly) NSString *tag;
@property(nonatomic, readonly) NSString *source;
@property(nonatomic, readonly) NSArray *children;
@property(nonatomic, readonly) MCParsedHTMLNode *parent;
@property(nonatomic) NSInteger score;

- (instancetype)initWithHTMLNode:(HTMLNode *)node
                          parent:(MCParsedHTMLNode *)parent;

- (Class)type;

@end
