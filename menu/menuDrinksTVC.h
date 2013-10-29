//
//  menuMasterDetailTVC.h
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Drink.h"
#import "CategoryDrink.h"

@interface menuDrinksTVC : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Drink * drink;
//the categoryDrink will be used by segue management to fetch the category requested
@property (strong, nonatomic) CategoryDrink *categoryDrink;
@end
