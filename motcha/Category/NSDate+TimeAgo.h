#import <Foundation/Foundation.h>

@interface NSDate (TimeAgo)

// Returns "{value} {unit} ago" strings, or "Just now" if <= 5 seconds ago
- (NSString *)timeAgo;

@end
