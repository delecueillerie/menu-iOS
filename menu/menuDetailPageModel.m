//
//  menuDetailPageModel.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuDetailPageModel.h"
#import "menuDetailPageVC.h"

@interface menuDetailPageModel()

@property (readonly, strong, nonatomic) NSArray *pageData;
@property (nonatomic) NSInteger index;
@end

@implementation menuDetailPageModel

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}

- (menuDetailPageVC*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    menuDetailPageVC *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"drinkPage"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(menuDetailPageVC *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

////////////////////////////////////////////////////////////////////////////
//Page View Controller Data Source DELEGATE
///////////////////////////////////////////////////////////////////////////

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(menuDetailPageVC *)viewController];
    if ((self.index == 0) || (self.index == NSNotFound)) {
        return nil;
    }
    
    self.index--;
    return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(menuDetailPageVC *)viewController];
    if (self.index == NSNotFound) {
        return nil;
    }
    
    self.index++;
    if (self.index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard];
}


- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.index;
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageData.count;
}
@end
