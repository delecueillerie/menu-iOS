//
//  menuMasterDetailTVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuMasterDetailTVC.h"
#import "menuMasterViewController.h"
#import "menuDetailViewController.h"
#import "menuCoreDataController.h"
#import "Drink.h"
#import "CategoryDrink.h"
#import "menuMasterViewTBVCell.h"

@interface menuMasterDetailTVC ()
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) menuCoreDataController *dataController;
@property (nonatomic, strong) CategoryDrink *categoryDrink;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation menuMasterDetailTVC
//
//  menuMasterViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//




@synthesize entityName;
//@synthesize refreshButton;
@synthesize dates;

# pragma mark - Lazy instanciation @ Synthesize

- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController = [[menuCoreDataController alloc]init];
    return _dataController;
}

- (void) setCategoryDrink:(CategoryDrink *)categoryDrink {
    _categoryDrink = categoryDrink;
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
    self.detailViewController = (menuDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
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
    Drink *drink = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell = (menuMasterViewTBVCell *) cell;

    
    cell.nameCell.text = drink.name;
    cell.priceCell.text = [NSString stringWithFormat:@"%@",drink.price];
    cell.imageCell.image = [UIImage imageWithData:drink.photo];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    menuMasterViewTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDrink" forIndexPath:indexPath];
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
    self.detailViewController.drink = (Drink*) object;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drink" inManagedObjectContext:self.dataController.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    
    
    
    //NSString * containingString = @"Bottle";
 /*   CategoryDrink * categoryDrink;
    if ([self.parentViewController isKindOfClass: [menuMasterViewController class]]) {
        menuMasterViewController *parentController = (menuMasterViewController *)self.parentViewController;
        categoryDrink = parentController.categoryDrink;
    }*/
//    NSPredicate * containingPredicate = [NSPredicate predicateWithFormat:@"(type = %@)",self.categoryDrink.label];
    NSPredicate * containingPredicate = [NSPredicate predicateWithFormat:@"(containing = %@) AND (type = %@)",self.categoryDrink.containing,self.categoryDrink.label];
    fetchRequest.predicate = containingPredicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *volumeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"volume" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = @[volumeDescriptor,nameDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.masterManagedObjectContext sectionNameKeyPath:@"volume" cacheName:nil];
   // aFetchedResultsController.delegate = self;
    
    
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








@end


