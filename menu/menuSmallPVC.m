//
//  menuSmallPVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 25/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuSmallPVC.h"
#import "menuAdPage.h"
#import "menuPageSmall.h"


@interface menuSmallPVC ()
@property (readonly, strong, nonatomic) menuAdPage *modelController;
// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, retain) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (strong, nonatomic) UIPopoverController *navigationPopoverController;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) NSInteger index;
@end

@implementation menuSmallPVC

@synthesize modelController = _modelController;


////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    menuPageSmall *startingViewController = (menuPageSmall *)[self.modelController viewControllerAtIndex:0 storyboard:self.storyboard withViewControllerId:@"menuPageSmall"];
    if (!startingViewController) startingViewController =[[menuPageSmall alloc] init];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Set the page view controller's bounds.
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    [self pageControlInit];
    [self createTimer];
    self.index = self.modelController.pageData.count;
}

- (menuPageModel *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[menuAdPage alloc] init];
    }
    return _modelController;
}
////////////////////////////////////////////////////////////////////////
//PAGE CONTROL MANAGEMENT
////////////////////////////////////////////////////////////////////////

- (UIPageControl *) pageControlInit {
    
    UIPageControl * pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = [self.modelController presentationCountForPageViewController:self.pageViewController];
    pageControl.currentPage = [self.modelController presentationIndexForPageViewController:self.pageViewController];
    return pageControl;
}

////////////////////////////////////////////////////////////////////////
//UIPageViewController DELEGATE METHOD
////////////////////////////////////////////////////////////////////////

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}


////////////////////////////////////////////////////////////////////////
//TIMER MANAGEMENT
////////////////////////////////////////////////////////////////////////
- (void) nextPage {
    self.index ++;
    NSUInteger i =self.index % self.modelController.pageData.count;
    menuPageSmall *viewController = [self.modelController viewControllerAtIndex:(i) storyboard:self.storyboard];
    NSArray *viewControllers =@[viewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

@end
