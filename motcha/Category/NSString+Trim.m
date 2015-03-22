#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString *)trimWhiteSpaceNewLineChars {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimWhiteSpaceChars {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimIllegalChars {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
}

- (NSString *)trimNewLineChars {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)trimControlChars {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
}

@end
