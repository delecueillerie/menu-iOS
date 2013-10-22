//
//  Meal.h
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meal : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;

@end
