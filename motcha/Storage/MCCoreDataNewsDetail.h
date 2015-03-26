//
//  MCCoreDataNewsDetail.h
//  motcha
//
//  Created by Kevin on 2015-03-25.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCCoreDataNewsDetail : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleimage;
@property (nonatomic, retain) NSManagedObject *rssItem;

@end
