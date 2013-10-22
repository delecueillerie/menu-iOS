//
//  menuMasterViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuMasterViewController.h"
#import "menuDetailViewController.h"
#import "menuCoreDataController.h"
#import "Drink.h"
#import "CategoryDrink.h"
#import "menuMasterViewTBVCell.h"

@interface menuMasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) CategoryDrink *categoryDrink;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) menuCoreDataController *dataController;
@end

@implementation menuMasterViewController


//@synthesize entityName;
//@synthesize refreshButton;
//@synthesize dates;

# pragma mark - Lazy instanciation @ Synthesize

- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController = [[menuCoreDataController alloc]init];
    return _dataController;
}


# pragma mark - View Life Cycle

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //MAJ OD
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIViewController *pageViewController = [self.splitViewController.viewControllers lastObject];
    //self.detailViewController = (menuDetailViewController *)pageViewController.childViewControllers.firstObject;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
}

- (void)viewWillAppear {
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
//delete        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (void)viewDidUnload
{
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*#pragma mark - Sync data
- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(menuMasterViewTBVCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //Drink *drink = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CategoryDrink *categoryDrink = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell = (menuMasterViewTBVCell *) cell;
    cell.textLabel.text = categoryDrink.label;
    //cell.priceCell.text = [NSString stringWithFormat:@"%@",drink.price];
    cell.imageCell.image = [UIImage imageWithData:categoryDrink.thumbnail];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    menuMasterViewTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
#warning prefere check the kindofclass
    self.categoryDrink = (CategoryDrink * ) object;
   // self.detailViewController.drink = (Drink*) object;
}

#pragma mark - Fetched results controller

-(NSString *) tabBarForPredicate {
    NSLog(self.parentViewController.tabBarItem.title);
    if ([self.parentViewController.tabBarItem.title isEqualToString : @"Verre"]) {
        return @"Glass";}
    else {
        return @"Bottle";}
    }


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drink" inManagedObjectContext:self.dataController.masterManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryDrink" inManagedObjectContext:self.dataController.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    
    
    
    //NSString * containingString = @"Bottle";
    NSPredicate * containingPredicate = [NSPredicate predicateWithFormat:@"containing = %@",[self tabBarForPredicate]];
    fetchRequest.predicate = containingPredicate;
    
    // Edit the sort key as appropriate.
    //NSSortDescriptor *typeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    //NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];

    NSArray *sortDescriptors = @[nameDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.masterManagedObjectContext sectionNameKeyPath:@"type" cacheName:nil];
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




- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}




- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.rightBarButtonItem = nil;
    }
}



#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"addDrinkSegue"])
    {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        addEditViewController *aeVC = (addEditViewController *) [navController topViewController];
        aeVC.delegate = self;
        
        // Create a new managed object context for the new book; set its parent to the fetched results controller's context.
        NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];

        Drink *newDrink = (Drink *)[NSEntityDescription insertNewObjectForEntityForName:@"Drink" inManagedObjectContext:addingContext];
        aeVC.managedObjectContext = addingContext;
        aeVC.drink = newDrink;
        
        aeVC.managedObjectContext = addingContext;
    }
    
    else if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"showDetailTV"]){
                if ([segue.destinationViewController respondsToSelector:@selector(setCategoryDrink:)]) {
                    [segue.destinationViewController setCategoryDrink:[self.fetchedResultsController objectAtIndexPath:indexPath]];

                }
            }
        }
    }
}





#pragma mark - Add controller delegate

/*
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)addEditViewController:(addEditViewController *)controller didFinishWithSave:(BOOL)save {
    
    if (save) {
        /*
         The new book is associated with the add controller's managed object context.
         This means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad. Saving changes to that context, though, only push changes to the fetched results controller's context. To save the changes to the persistent store, you have to save the fetch results controller's context as well.
         */
        NSError *error;
        NSManagedObjectContext *addingManagedObjectContext = [controller managedObjectContext];
        if (![addingManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sync 
- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender {
    [[SDSyncEngine sharedEngine] startSync];
}

- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButton];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButton {
    self.navigationItem.leftBarButtonItem = self.refreshButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}

@end


