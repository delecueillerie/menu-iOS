//
//  menuCoreDataController.h
//  menu
//
//  Created by Olivier Delecueillerie on 15/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuCoreDataController : NSObject

+ (id)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
