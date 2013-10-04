//
//  menuMasterViewController.h
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class menuDetailViewController;

#import <CoreData/CoreData.h>

@interface menuMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) menuDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
