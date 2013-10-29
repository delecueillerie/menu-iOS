//
//  menuAdPage.m
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuAdPage.h"
#import "menuCoreDataController.h"

@interface menuAdPage ()
@property (nonatomic, strong) menuCoreDataController *dataController;
@property (nonatomic) NSInteger index;

@end

@implementation menuAdPage





- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        self.pageData = [self fetchedResultsController].fetchedObjects;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////
//Lazy instanciation @ Synthesize
///////////////////////////////////////////////////////////////////////////

- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController = [[menuCoreDataController alloc]init];
    return _dataController;
}


///////////////////////////////////////////////////////////////////////////
//OO
///////////////////////////////////////////////////////////////////////////
- (menuPageSmall*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    menuPageSmall *dataViewController  = [storyboard instantiateViewControllerWithIdentifier:@"menuPageSmall"];

    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
///////////////////////////////////////////////////////////////////////////


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SquareMenuAd" inManagedObjectContext:self.dataController.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.masterManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}





@end
