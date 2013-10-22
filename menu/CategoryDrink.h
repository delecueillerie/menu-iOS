//
//  CategoryDrink.h
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CategoryDrink : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * containing;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * syncStatus;
@property (nonatomic, retain) NSData * thumbnail;

@end
