//
//  menuEditingTV.m
//  menu
//
//  Created by Olivier Delecueillerie on 25/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuEditingTV.h"

@interface menuEditingTV ()

@end

@implementation menuEditingTV

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


//////////////////////////////////////////////////////////////////
//ADD DELETE CONTROLLER DELEGATE
//////////////////////////////////////////////////////////////////

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
        
//        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
    }
    
    // Dismiss the modal view to return to the main list
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
//        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
//        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
//        self.rightBarButtonItem = nil;
    }
}

//////////////////////////////////////////////////////////////////
//SEGUE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    /*if ([[segue identifier] isEqualToString:@"addDrinkSegue"])
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
        
        aeVC.managedObjectContext = addingContext;*/
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
