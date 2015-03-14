#import <Foundation/Foundation.h>

@class MCParsedHTMLNode;

// Base class of the component that contains news details data.
@interface MCNewsDetailsComponent : NSObject 
+ (instancetype)componentWithNode:(MCParsedHTMLNode *)node;
@end

// A subclass of MCNewsDetailsComponent that contains title.
@interface MCNewsDetailsTitle : MCNewsDetailsComponent
@property(nonatomic, readonly) NSString *text;
@end

// A subclass of MCNewsDetailsComponent that contains image.
@interface MCNewsDetailsImage : MCNewsDetailsComponent
@property(nonatomic, readonly) NSURL *source;
@end

// A subclass of MCNewsDetailsComponent that contains paragraph.
@interface MCNewsDetailsParagraph : MCNewsDetailsComponent
@property(nonatomic, readonly) NSString *text;
@end

// The class represents the date needed for news details page.
@interface MCNewsDetailsObject : NSObject

@property(nonatomic, readonly) NSDate *date;

@property(nonatomic, readonly) NSString *author;

@property(nonatomic, readonly) NSString *source;

@property(nonatomic, readonly) NSString *title;

@property(nonatomic, readonly) NSURL *titleImage;

// Contains an array of MCNewsDetailsComponent that represents the main content
// of the article.
@property(nonatomic, readonly) NSArray *content;

- (instancetype)initWithTitle:(NSString *)title
                       source:(NSString *)source
                   titleImage:(NSURL *)titleImage
                      content:(NSArray *)content
                         date:(NSDate *)date
                       author:(NSString *)author;
@end
