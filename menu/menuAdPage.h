//
//  menuAdPage.h
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageModel.h"
#import "menuPageSmall.h"

@interface menuAdPage : menuPageModel <NSFetchedResultsControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *pageData;
- (menuPageSmall*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(menuPageSmall *)viewController;
@end
