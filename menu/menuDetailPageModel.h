//
//  menuDetailPageModel.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class menuDetailPageVC;

@interface menuDetailPageModel : NSObject <UIPageViewControllerDataSource>
- (menuDetailPageVC *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(menuDetailPageVC *)viewController;
- (void)createCurrentPage:(NSObject *)product;
@end
