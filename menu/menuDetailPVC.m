//
//  menuDetailPVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuDetailPVC.h"
#import "menuPageModel.h"
#import "menuPage.h"

@interface menuDetailPVC ()
@property (readonly, strong, nonatomic) menuPageModel *modelController;
// Holds a reference to the split view controller's bar button item
// if the button should be shown (the device is in portrait).
// Will be nil otherwise.
@property (nonatomic, retain) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (strong, nonatomic) UIPopoverController *navigationPopoverController;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation menuDetailPVC

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    menuPage *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard withViewControllerId:@"menuPageBig" ];
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
}

- (menuPageModel *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[menuPageModel alloc] init];
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
//SPLIT VIEW CONTROLLER DELEGATE MANAGEMENT
////////////////////////////////////////////////////////////////////////
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.navigationPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.navigationPopoverController = nil;
    [self detailViewFrameForLandscapeOrientation:YES];
}

- (void)detailViewFrameForLandscapeOrientation:(BOOL) landscapeOrientation {
    if (landscapeOrientation){
        for (UIViewController *viewController in self.pageViewController.viewControllers){
            CGRect rectFrame1 = CGRectMake (320,0, 704, 768);
            CGRect rectFrame2 = CGRectMake (320,0, 704, 700);
            viewController.view.frame = rectFrame1;
            UIView *mainView = [viewController.view.subviews firstObject];
            mainView.frame = rectFrame2;
            }
        }
}

@end
