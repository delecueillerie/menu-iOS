//
//  addEditViewController.h
//  menu
//
//  Created by Olivier Delecueillerie on 07/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
/*
 IMPORT FROM COREDATABOOKS SAMPLE"
 File: AddViewController.h
Abstract: The table view controller responsible managing addition of a new book to the application.
When editing ends, the controller sends a message to its delegate (in this case, the root view controller) to tell it that it finished editing and whether the user saved their changes. It's up to the delegate to actually commit the changes.
The view controller needs a strong reference to the managed object context to make sure it doesn't disappear while being used (a managed object doesn't have a strong reference to its context).
*/


#import "menuDetailViewController.h"

@protocol addEditViewControllerDelegate;

@interface addEditViewController : menuDetailViewController <NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id <addEditViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSManagedObject *editedObject;
@property (nonatomic, strong) Drink *drink;
@property (nonatomic, strong) NSString *editedFieldKey;
@property (nonatomic, strong) NSString *editedFieldName;

@end

@protocol addEditViewControllerDelegate
- (void)addEditViewController:(addEditViewController *)controller didFinishWithSave:(BOOL)save;
@end




