//
//  SDSyncEngine.h
//  menu
//
//  Created by Olivier Delecueillerie on 15/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDSyncEngine : NSObject

+ (SDSyncEngine *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;
@property (atomic, readonly) BOOL syncInProgress;

typedef enum {
    SDObjectSynced = 0,
    SDObjectCreated,
    SDObjectDeleted,
} SDObjectSyncStatus;

@end
