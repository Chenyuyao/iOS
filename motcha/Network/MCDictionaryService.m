#import "MCDictionaryService.h"
#import "MCLocalStorageService.h"

#import "MCDictionaryWord.h"

@implementation MCDictionaryService

+ (MCDictionaryService *)sharedInstance {
  static MCDictionaryService *service;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[MCDictionaryService alloc] init];
  });
  return service;
}

- (void)import {
  NSError* err = nil;
  NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"json"];
  NSArray* dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                        options:kNilOptions
                                                          error:&err];
  NSMutableArray* dictionaryWords = [NSMutableArray new];
  for (NSDictionary *word in dictionary) {
    NSString *wordKey = [word objectForKey:@"word"];
    NSString *pos = [word objectForKey:@"pos"];
    if (wordKey && pos) {
      MCDictionaryWord *wordObject =
        [[MCDictionaryWord alloc] initWithWord:wordKey andPos:pos];
      [dictionaryWords addObject:wordObject];
    }
  }
  [[MCLocalStorageService sharedInstance] storeDictionary:dictionaryWords];
}

@end
