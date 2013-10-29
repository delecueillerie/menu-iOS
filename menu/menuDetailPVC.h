//
//  menuDetailPVC.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuDetailPVC : UIViewController <UIPageViewControllerDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
