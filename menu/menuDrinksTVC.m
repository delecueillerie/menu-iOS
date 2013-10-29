//
//  menuMasterDetailTVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 22/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuDrinksTVC.h"
#import "menuMasterViewController.h"
#import "menuCoreDataController.h"
#import "Drink.h"
#import "menuMasterViewTBVCell.h"
#import "menuPageModel.h"

@interface menuDrinksTVC ()
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) menuCoreDataController *dataController;
@property (nonatomic, strong) NSString *entity;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation menuDrinksTVC
//
//@synthesize entity;

/////////////////////////////////////////////////////////////////////
// LAZY INSTANCIATION
/////////////////////////////////////////////////////////////////////
- (menuCoreDataController *) dataController {
    if (!_dataController) _dataController = [[menuCoreDataController alloc]init];
    return _dataController;
}

-(NSString *) entity {
    if(!_entity) _entity=@"Drink";
    return _entity;
}

//////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //MAJ OD
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //self.detailViewController = (menuDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
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



- (void) viewDidAppear:(BOOL)animated {
    [self loadRecordsFromCoreData];
    NSLog(@"Category %@",self.categoryDrink.label);
    NSLog(@"tabBar %@", [self tabBarForPredicate]);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    for (menuDrinksTVC * viewController in self.parentViewController.childViewControllers) {
        if (!(self == viewController)) viewController.categoryDrink = self.categoryDrink;
    }
}
- (void)viewDidUnload
{
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

//////////////////////////////////////////////////////////////////
//TABLE VIEW MANAGEMENT
//////////////////////////////////////////////////////////////////

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
    cell.titleProduct.text = drink.containing;
    cell.subtitleProduct.text = [NSString stringWithFormat:@"%@",drink.price];
    //cell.imageCell.image = [UIImage imageWithData:drink.photo];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // Display the authors' names as section headings.
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    menuMasterViewTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drink" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];

}


//////////////////////////////////////////////////////////////////
//FETCHED RESULT CONTROLLER
//////////////////////////////////////////////////////////////////
-(NSString *) tabBarForPredicate {
    UITabBarController * tbController = (UITabBarController *) self.parentViewController;
    if ([tbController.tabBar.selectedItem.title isEqualToString : @"Verre"]) {
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entity inManagedObjectContext:self.dataController.masterManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    NSPredicate * containingPredicate = [NSPredicate predicateWithFormat:@"(containing = %@) AND (type = %@)",[self tabBarForPredicate],self.categoryDrink.label];
    fetchRequest.predicate = containingPredicate;
    
    NSSortDescriptor *volumeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"volume" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = @[volumeDescriptor,nameDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.masterManagedObjectContext sectionNameKeyPath:@"name" cacheName:nil];
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

///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
///////////////////////////////////////////////////////////////////////////

- (void)loadRecordsFromCoreData {
    [self.dataController.masterManagedObjectContext performBlockAndWait:^{
        //[self.dataController.masterManagedObjectContext reset];
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    }];
}


//////////////////////////////////////////////////////////////////
//SEGUE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"fromCategoryToDrinks"]){
                if ([segue.destinationViewController respondsToSelector:@selector(loadRecordsFromCoreData)]) {
                    // segue.destinationViewController.productSelected =  setCategoryDrink:[self.fetchedResultsController objectAtIndexPath:indexPath]];
                }
            }
        }
    }
}




@end


