//
//  menuAppDelegate.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
///////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////
#import "menuAppDelegate.h"
#import "menuMasterViewController.h"
#import "menuCoreDataController.h"
#import "SDSyncEngine.h"
#import "menuPage.h"
#import "Drink.h"
#import "SquareMenuAd.h"
@interface menuAppDelegate()

@property (nonatomic, strong) menuCoreDataController * dataController;

@end



@implementation menuAppDelegate

- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController=[[menuCoreDataController alloc]init];
    return _dataController;
}

///////////////////////////////////////////////////////////////////
// DETAIL AND MASTER VIEW MANAGEMENT FOR SPLITVIEW CONTROLLER
// FIRST CALL TO SYNCENGINE
///////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    menuPage *pageController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)pageController;

    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Drink class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[CategoryDrink class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[SquareMenuAd class]];

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[SDSyncEngine sharedEngine] startSync];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.dataController saveMasterContext];
}


@end
