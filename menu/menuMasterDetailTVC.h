//
//  menuMasterDetailTVC.h
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class menuDetailViewController;

#import <CoreData/CoreData.h>
#import "addEditViewController.h"
#import "SDSyncEngine.h"
#import "CategoryDrink.h"

@interface menuMasterDetailTVC : UITableViewController
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) menuDetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender;
- (void) setCategoryDrink: (CategoryDrink *) categoryDrink;
@end
