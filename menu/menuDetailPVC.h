//
//  menuDetailPVC.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "menuPageBig.h"

@interface menuDetailPVC : UIViewController <UIPageViewControllerDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *drinkList;

// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (strong, nonatomic) UIPopoverController *navigationPopoverController;

@end
