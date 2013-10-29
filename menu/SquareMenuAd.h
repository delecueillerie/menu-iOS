//
//  SquareMenuAd.h
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SquareMenuAd : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSData * media;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * order;

@end
