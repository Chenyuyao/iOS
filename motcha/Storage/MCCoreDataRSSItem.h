//
//  MCCoreDataRSSItem.h
//  motcha
//
//  Created by Kevin on 2015-03-25.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MCCoreDataNewsDetail;

@interface MCCoreDataRSSItem : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * descrpt;
@property (nonatomic, retain) NSString * imgSrc;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * needParse;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSNumber * recommendId;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MCCoreDataNewsDetail *detailedItem;

@end
