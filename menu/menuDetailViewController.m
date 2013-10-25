//
//  menuDetailViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
/*
 File: DetailViewController.m
 Abstract: The table view controller responsible for displaying detailed information about a single book.  It also allows the user to edit information about a book, and supports undo for editing operations.
 
 When editing begins, the controller creates and set an undo manager to track edits. It then registers as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded. When editing ends, the controller de-registers from the notification center and removes the undo manager.
 */

#import "menuDetailViewController.h"
#import "addEditViewController.h"
#import "Drink.h"
@interface menuDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTV;
@property (strong, nonatomic) IBOutlet UIImageView *photoIV;
@property (nonatomic, strong) NSUndoManager *undoManager;

- (void)updateInterface;
- (void)updateRightBarButtonItemState;

@end

@implementation menuDetailViewController


#pragma mark - Managing the detail item

@synthesize undoManager;

#pragma mark - updating Form
- (void) setDrink:(Drink *)drink
{
    if(_drink!=drink)
    {
        _drink=drink;
        [self updateInterface];
    }
}

- (void)updateInterface {
    self.titleLabel.text = self.drink.name;
    self.price.text = [NSString stringWithFormat:@"%@", self.drink.price];
    self.descriptionTV.text = self.drink.about;
    self.photoIV.image = [UIImage imageWithData:self.drink.photo];
}


#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self class] == [menuDetailViewController class]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    // if the local changes behind our back, we need to be notified so we can update the date
    // format in the table view cells
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

#pragma mark - Split view



#pragma mark - Locale changes


- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self updateInterface];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    // When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
    // When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
    if (editing) {
        [self setUpUndoManager];
    }
    else {
        [self cleanUpUndoManager];
        // Save the changes.
        NSError *error;
        if (![self.drink.managedObjectContext save:&error]) {
            //     Replace this implementation with code to handle the error appropriately.
            //     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
//END FROM



- (void)updateRightBarButtonItemState {
#warning to be completed to enabled the save button in good condition (ex. form completed ..)  Conditionally enable the right bar button item -- it should only be enabled if the drink is in a valid state for saving.
  //  self.navigationItem.rightBarButtonItem.enabled = [self.drink validateForUpdate:NULL];
}

//FROM CDB
#pragma mark - Undo support

- (void)setUpUndoManager {
    //     If the book's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
    //     The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
    if (self.drink.managedObjectContext.undoManager == nil) {
        NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
        [anUndoManager setLevelsOfUndo:3];
        self.undoManager = anUndoManager;
        self.drink.managedObjectContext.undoManager = self.undoManager;
    }
    
    // Register as an observer of the drink's context's undo manager.
    NSUndoManager *drinkUndoManager = self.drink.managedObjectContext.undoManager;
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:drinkUndoManager];
    [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:drinkUndoManager];
}


- (void)cleanUpUndoManager {
    // Remove self as an observer.
    NSUndoManager *drinkUndoManager = self.drink.managedObjectContext.undoManager;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:drinkUndoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:drinkUndoManager];
    
    if (drinkUndoManager == self.undoManager) {
        self.drink.managedObjectContext.undoManager = nil;
        self.undoManager = nil;
    }
}


- (NSUndoManager *)undoManager {
    
    return self.drink.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}




// END FROM


//FROM CDB
#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"editDrink"]) {
        
        addEditViewController *controller = (addEditViewController *)[segue destinationViewController];
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        controller.drink = self.drink;
       /* switch (indexPath.row) {
            case 0: {
                controller.editedFieldKey = @"title";
                controller.editedFieldName = NSLocalizedString(@"title", @"display name for title");
            } break;
            case 1: {
                controller.editedFieldKey = @"author";
                controller.editedFieldName = NSLocalizedString(@"author", @"display name for author");
            } break;
            case 2: {
                controller.editedFieldKey = @"copyright";
                controller.editedFieldName = NSLocalizedString(@"copyright", @"display name for copyright");
            } break;
        }*/
    }
}
//END FROM

@end

/*
 
 #import "EditingViewController.h"

 

 

 




#pragma mark - UITableViewDelegate

 - (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Only allow selection if editing.
 if (self.editing) {
 return indexPath;
 }
 return nil;
 }

// Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing) {
        [self performSegueWithIdentifier:@"EditSelectedItem" sender:self];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}




#pragma mark - Date Formatter

- (NSDateFormatter *)dateFormatter {
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
}






@end



*/
