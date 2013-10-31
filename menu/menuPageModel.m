//
//  menuPageModel.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageModel.h"
#import "menuPageBig.h"
#import "menuPageSmall.h"

@interface menuPageModel()

@property (nonatomic) NSInteger index;

@end

@implementation menuPageModel

- (NSArray *) pageData {
    if(!_pageData) _pageData=[[NSArray alloc] init];
    return _pageData;
}

////////////////////////////////////////////////////////////////////////////
//PAGE CREATION
///////////////////////////////////////////////////////////////////////////
- (menuPageBig*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard withViewControllerId:(NSString *)viewControllerId
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    menuPageBig *dataViewController;
    // Create a new view controller and pass suitable data.
    if (viewControllerId){
        dataViewController  = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    } else {
        dataViewController = [[menuPageBig alloc]init];
    }
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(menuPageBig *)viewController
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
    self.index = [self indexOfViewController:(menuPageBig *)viewController];
    if ((self.index == 0) || (self.index == NSNotFound)) {
        return nil;
    }
    
    self.index--;
    return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageBig"];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(menuPageBig *)viewController];
    if (self.index == NSNotFound) {
        return nil;
    }
    self.index++;
    if (self.index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageBig"];
}

///////////////////////////////////////////////////////////////////////////
//PAGE CONTROL DELEGATE
///////////////////////////////////////////////////////////////////////////
- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.index;
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageData.count;
}



@end
