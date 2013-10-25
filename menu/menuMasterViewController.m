//
//  menuMasterViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuMasterViewController.h"
#import "menuCoreDataController.h"
#import "Drink.h"
#import "CategoryDrink.h"
#import "menuMasterViewTBVCell.h"

@interface menuMasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) CategoryDrink *categoryDrink;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) menuCoreDataController *dataController;
@property (nonatomic, strong) NSString *entityToFetch;
@property (nonatomic, strong) NSObject *productSelected;

@property (strong, nonatomic) IBOutlet UITabBarItem *glassIcon;
@property (strong, nonatomic) IBOutlet UITabBarItem *bottleIcon;
@property (strong, nonatomic) IBOutlet UITabBarItem *home;
@end

@implementation menuMasterViewController

///////////////////////////////////////////////////////////////////////////
//Lazy instanciation @ Synthesize
///////////////////////////////////////////////////////////////////////////

- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController = [[menuCoreDataController alloc]init];
    return _dataController;
}

-(NSString *) entityToFetch {
    if(!_entityToFetch) _entityToFetch = @"CategoryDrink";
    return _entityToFetch;
}

///////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
///////////////////////////////////////////////////////////////////////////
- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

///////////////////////////////////////////////////////////////////////////
//TABLE VIEW MANAGEMENT
///////////////////////////////////////////////////////////////////////////

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
    self.productSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell = (menuMasterViewTBVCell *) cell;

    if ([self.productSelected isKindOfClass:[CategoryDrink class]]) {
        CategoryDrink *categoryDrink = (CategoryDrink *) self.productSelected;
        cell.titleProduct.text = categoryDrink.label;
        cell.subtitleProduct.text = @"";
        cell.labelIcon1.text=@"";
        cell.labelIcon2.text=@"";
        self.entityToFetch = @"Drink";
    }
    else if ([self.productSelected isKindOfClass:[Drink class]]) {
        Drink *drink = (Drink *) self.productSelected;
        cell.titleProduct.text = drink.name;
        cell. labelIcon1.text = [NSString stringWithFormat:@"%@ E",drink.price];
        //cell.imageCell.image = [UIImage imageWithData:drink.photo];
    }

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
    if ([object isKindOfClass:[CategoryDrink class]]) self.categoryDrink = (CategoryDrink * ) object;
}

///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
///////////////////////////////////////////////////////////////////////////

//A COMPLETER
/*- (void)loadRecordsFromCoreData {
 [self.managedObjectContext performBlockAndWait:^{
 [self.managedObjectContext reset];
 NSError *error = nil;
 NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
 [request setSortDescriptors:[NSArray arrayWithObject:
 [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
 self.dates = [self.managedObjectContext executeFetchRequest:request error:&error];
 }];
 }*/

-(NSString *) tabBarForPredicate {
    if (self.glassIcon.enabled) return @"Glass";
    else if (self.bottleIcon.enabled) return @"Bottle";
    else return @"";
}

-(NSString *) descriptorFromEntity {
    NSString * descriptor;
    if ([self.entityToFetch isEqualToString:@"CategoryDrink"]) descriptor = @"label";
    else if ([self.entityToFetch isEqualToString:@"Drink"]) descriptor = @"name";
    else descriptor = @"";
    return descriptor;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityToFetch inManagedObjectContext:self.dataController.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    //We use the tab bar Item as filter
    NSPredicate * containingPredicate = [NSPredicate predicateWithFormat:@"containing = %@",[self tabBarForPredicate]];
    fetchRequest.predicate = containingPredicate;
    
    // Edit the sort key as appropriate
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey: [self descriptorFromEntity] ascending:YES];

    NSArray *sortDescriptors = @[nameDescriptor];
    
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







//////////////////////////////////////////////////////////////////
//SEGUE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
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



//////////////////////////////////////////////////////////////////
//SYNC MANAGEMENT
//////////////////////////////////////////////////////////////////

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


