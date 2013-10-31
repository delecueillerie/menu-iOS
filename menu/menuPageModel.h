//
//  menuPageModel.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "menuPageBig.h"

@interface menuPageModel : NSObject <UIPageViewControllerDataSource>
- (menuPageBig *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard withViewControllerId:(NSString *)viewControllerId;
- (NSUInteger)indexOfViewController:(menuPageBig *)viewController;
@property (strong, nonatomic) NSArray *pageData;

@end
