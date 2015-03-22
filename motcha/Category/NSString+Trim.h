#import <Foundation/Foundation.h>

@interface NSString (Trim)

- (NSString *)trimWhiteSpaceNewLineChars;
- (NSString *)trimWhiteSpaceChars;
- (NSString *)trimIllegalChars;
- (NSString *)trimNewLineChars;
- (NSString *)trimControlChars;

@end
