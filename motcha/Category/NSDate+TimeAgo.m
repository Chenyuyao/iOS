#import "NSDate+TimeAgo.h"

static NSString *kSecondString  = @"second";
static NSString *kMinuteString  = @"minute";
static NSString *kHourString    = @"hour";
static NSString *kDayString     = @"day";
static NSString *kWeekString    = @"week";
static NSString *kMonthString   = @"month";
static NSString *kYearString    = @"year";
static NSString *kJustNowString = @"Just now";

@implementation NSDate (TimeAgo)

- (NSString *)timeAgo {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate * now = [NSDate date];
  NSDateComponents *components = [calendar components:
                                  NSCalendarUnitYear|
                                  NSCalendarUnitMonth|
                                  NSCalendarUnitWeekOfYear|
                                  NSCalendarUnitDay|
                                  NSCalendarUnitHour|
                                  NSCalendarUnitMinute|
                                  NSCalendarUnitSecond
                                             fromDate:self
                                               toDate:now
                                              options:0];
  
  if (components.year >= 1) {
    return [self constructTimeAgoStringForUnit:kYearString count:components.year];
  } else if (components.month >= 1) {
    return [self constructTimeAgoStringForUnit:kMonthString count:components.month];
  } else if (components.weekOfYear >= 1) {
    return [self constructTimeAgoStringForUnit:kWeekString count:components.weekday];
  } else if (components.day >= 1){
    return [self constructTimeAgoStringForUnit:kDayString count:components.day];
  } else if (components.hour >= 1){
    return [self constructTimeAgoStringForUnit:kHourString count:components.hour];
  } else if (components.minute >= 1) {
    return [self constructTimeAgoStringForUnit:kMinuteString count:components.minute];
  } else {
    if (components.second < 5) {
      return kJustNowString;
    }
    return [self constructTimeAgoStringForUnit:kSecondString count:components.second];
  }
}

- (NSString *)constructTimeAgoStringForUnit:(NSString *)unit count:(NSUInteger)count {
  if (count == 1) {
    return [NSString stringWithFormat:@"1 %@ ago", unit];
  } else {
    return [NSString stringWithFormat:@"%lu %@s ago", count, unit];
  }
}

@end
