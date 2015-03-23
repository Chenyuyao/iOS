#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (NSString *)trimWhiteSpaceNewLineChars;
- (NSString *)trimWhiteSpaceChars;
- (NSString *)trimIllegalChars;
- (NSString *)trimNewLineChars;
- (NSString *)trimControlChars;

/*
 * Get a string where internal characters that are escaped for HTML are unescaped
 * For example, '&amp;' becomes '&'
 * Handles &#32; and &#x32; cases as well
 *
 * Adopted from: http://stackoverflow.com/a/1453142
 */
- (NSString *)stringByUnescapingFromHTML;

@end
