//
//  addEditViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 07/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "addEditViewController.h"

@interface addEditViewController ()

@property (nonatomic, weak) IBOutlet UITextField *drinkName; //
@property (strong, nonatomic) IBOutlet UITextView *drinkDescription;
@property (strong, nonatomic) IBOutlet UIImageView *drinkPhoto;
@property (strong, nonatomic) IBOutlet UITextField *price;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)takePhoto:(UIButton *)sender;

@end

@implementation addEditViewController




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set up the undo manager and set editing state to YES.
    [self setUpUndoManager];
    self.editing = YES;}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.drinkName becomeFirstResponder];
}

- (void)dealloc
{
    [self cleanUpUndoManager];
}


#pragma mark - Actions
- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

#pragma warning check the code below
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    else [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.drinkPhoto.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}






#pragma mark - Save and cancel operations
//Save button in the add&edit form.
- (IBAction)save:(UIButton *)sender
 {
     // Set the action name for the undo operation.
     NSUndoManager * undoManager = [[self.drink managedObjectContext] undoManager];
     [undoManager setActionName:[NSString stringWithFormat:@"%@", self.editedFieldName]];
 
     // Pass current value to the edited object, then pop.
     self.drink.name = self.drinkName.text;
     self.drink.updatedAt = [NSDate date];
     self.drink.about=self.drinkDescription.text;
//#warning include JPG format
     self.drink.photo = UIImagePNGRepresentation(self.drinkPhoto.image);
     self.drink.price=[NSDecimalNumber decimalNumberWithString:self.price.text];
     [self.delegate addEditViewController:self didFinishWithSave:YES];

     [self.navigationController popViewControllerAnimated:YES];
 }
 
 
 - (IBAction)cancel:(UIButton *)sender
 {
     [self.delegate addEditViewController:self didFinishWithSave:NO];
     // Don't pass current value to the edited object, just pop.
     [self.navigationController popViewControllerAnimated:YES];
 }
 
@end