//
//  menuPageModel.h
//  menu
//
//  Created by Olivier Delecueillerie on 24/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class menuPage;

@interface menuPageModel : NSObject <UIPageViewControllerDataSource>
- (menuPage *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard withViewControllerId:(NSString *)viewControllerId;
- (NSUInteger)indexOfViewController:(menuPage *)viewController;
@property (strong, nonatomic) NSArray *pageData;

@end
