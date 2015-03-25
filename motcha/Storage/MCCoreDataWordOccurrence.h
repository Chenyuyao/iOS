//
//  MCCoreDataWordOccurrence.h
//  motcha
//
//  Created by Kevin on 2015-03-25.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MCCoreDataWordOccurrence : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * word;

@end
