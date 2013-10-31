//
//  menuDetailPVC.m
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuDetailPVC.h"
#import "menuPageModel.h"
#import "Drink.h"
#import <MediaPlayer/MediaPlayer.h>

@interface menuDetailPVC ()
@property (readonly, strong, nonatomic) menuPageModel *modelController;

@end

@implementation menuDetailPVC

@synthesize modelController = _modelController;

////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    /*menuPageBig *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard withViewControllerId:@"menuPageBig" ];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];*/
    [self firstPageInit];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    // Set the page view controller's bounds.
    self.pageViewController.view.frame = self.view.bounds;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    //Add the page control view
    [self pageControlInit];
    
    //Add the Notification for drink selected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drinkSelected:)
                                                 name:@"drinkSelected"
                                               object:nil];
    
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
    barButtonItem.title = @"Afficher le menu";
   // [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //self.navigationPopoverController = popoverController;
    // Tell the detail view controller to show the navigation button.
   // self.barButtonItem = barButtonItem;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"splitVCWillHideVC" object:barButtonItem];
    
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    //[self.navigationItem setLeftBarButtonItem:nil animated:YES];
   // self.navigationPopoverController = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"splitVCWillShowVC" object:barButtonItem];
}


////////////////////////////////////////////////////////////////////////
//NOTIFICATION DRINK SELECTED MANAGEMENT
////////////////////////////////////////////////////////////////////////

-(void) drinkSelected :(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[Drink class]]){
        Drink * drinkSelected = (Drink *)notification.object;
        self.modelController.pageData = [NSArray arrayWithObject:drinkSelected];
        menuPageBig *viewController;
        if ([drinkSelected.containing isEqualToString:@"Bottle"]) {
            viewController = (menuPageBig *)[self.modelController viewControllerAtIndex:(0) storyboard:self.storyboard withViewControllerId:@"menuPageBottle"];
        } else {
            viewController = (menuPageBig *)[self.modelController viewControllerAtIndex:(0) storyboard:self.storyboard withViewControllerId:@"menuPageGlass"];
        }
        NSArray *viewControllers =@[viewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

////////////////////////////////////////////////////////////////////////
//SET THE FIRST PAGE
////////////////////////////////////////////////////////////////////////
- (void) firstPageInit {
    
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[self localMovieURL]];
    self.modelController.pageData = [NSArray arrayWithObject:player];
    menuPageBig *movieVC = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard withViewControllerId:@"menuMovie" ];
    NSArray *viewControllers = @[movieVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}

/* Returns a URL to a local movie in the app bundle. */
-(NSURL *)localMovieURL
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:@"club1810" ofType:@"mov"];
		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}

//////////////////////////////////////////////////////////////////////////
//SIZING VIEWS
//////////////////////////////////////////////////////////////////////////




@end
