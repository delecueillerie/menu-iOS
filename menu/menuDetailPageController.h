//
//  menuDetailPageController.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuDetailPageController : UIViewController <UIPageViewControllerDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
