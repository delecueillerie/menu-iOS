//
//  menuPageSmall.m
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageSmall.h"
#import "SquareMenuAd.h"

@interface menuPageSmall ()
@end

@implementation menuPageSmall

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.dataObject isKindOfClass:[SquareMenuAd class]]) {
        SquareMenuAd *menuAd = (SquareMenuAd *)self.dataObject;
        UIImage *image =[[UIImage alloc]initWithData:menuAd.media];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame=self.view.frame;
        [self.view addSubview:imageView];
    }
}

@end
