//
//  menuAppDelegate.h
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;


// FROM MULTIPLE DETAIL VIEWS SAMPLE
// @interface AppDelegate : NSObject <UIApplicationDelegate> // include in template
// @property (nonatomic, retain) UIWindow *window; // include in template
/// Things for IB
//?@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
// DetailViewManager is assigned as the Split View Controller's delegate.
// However, UISplitViewController maintains only a weak reference to its
// delegate.  Someone must hold a strong reference to DetailViewManager
// or it will be deallocated after the interface is finished unarchieving.
//.@property (nonatomic, retain) IBOutlet DetailViewManager *detailViewManager;


// END FROM
@end
