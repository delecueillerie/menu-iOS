//
//  menuPageModel.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageModel.h"
#import "menuPage.h"
#import "menuPageBig.h"
#import "menuPageSmall.h"

@interface menuPageModel()

@property (nonatomic) NSInteger index;
@end

@implementation menuPageModel

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

- (menuPage*)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard withViewControllerId:(NSString *)viewControllerId
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    menuPage *dataViewController;
    // Create a new view controller and pass suitable data.
    if (viewControllerId){
        dataViewController  = [storyboard instantiateViewControllerWithIdentifier:viewControllerId];
    } else {
        dataViewController = [[menuPage alloc]init];
    }
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(menuPage *)viewController
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
    self.index = [self indexOfViewController:(menuPage *)viewController];
    if ((self.index == 0) || (self.index == NSNotFound)) {
        return nil;
    }
    
    self.index--;
    if ([viewController isKindOfClass:[menuPageBig class]]) {
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageBig"];
    } else if ([viewController isKindOfClass:[menuPageSmall class]]) {
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageSmall"];
    } else
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.index = [self indexOfViewController:(menuPage *)viewController];
    if (self.index == NSNotFound) {
        return nil;
    }
    
    self.index++;
    if (self.index == [self.pageData count]) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[menuPageBig class]]) {
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageBig"];
    } else if ([viewController isKindOfClass:[menuPageSmall class]]) {
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:@"menuPageSmall"];
    } else
        return [self viewControllerAtIndex:self.index storyboard:viewController.storyboard withViewControllerId:nil];

}



///////////////////////////////////////////////////////////////////////////
//FOR PAGE CONTROL
///////////////////////////////////////////////////////////////////////////
- (NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.index;
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageData.count;
}



@end
