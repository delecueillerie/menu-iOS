//
//  menuPageBig.m
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageBig.h"
#import "Drink.h"
#import <MediaPlayer/MediaPlayer.h>

@interface menuPageBig ()
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
@property (strong, nonatomic) IBOutlet UILabel *volume;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *about;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@end

@implementation menuPageBig

/////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
/////////////////////////////////////////////////////////////////////////////////

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitVCWillHideVC:) name:@"splitVCWillHideVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splitVCWillShowVC:) name:@"splitVCWillShowVC" object:nil];
    
    if ([self.dataObject isKindOfClass:[Drink class]]) {
        Drink * drink = (Drink *) self.dataObject;
        self.mainTitle.text = drink.name;
        self.price.text = [NSString stringWithFormat:@"%@ €",drink.price];
        self.volume.text = [NSString stringWithFormat:@"%@ cl",drink.volume];
        self.image.image =  [UIImage imageWithData:drink.photo];
        self.about.text = drink.about;
    }
    else if ([self.dataObject isKindOfClass:[MPMoviePlayerController class]]) {
        MPMoviePlayerController * movie = (MPMoviePlayerController *) self.dataObject;
        [self playMovie:movie];
    }
    
}
- (void) viewDidAppear:(BOOL)animated {
    [self resizingVC:[UIApplication sharedApplication].statusBarOrientation];
}
- (void) viewDidDisappear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"splitVCWillHideVC" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"splitVCWillShowVC" object:nil];
}
/////////////////////////////////////////////////////////////////////////////////
//TOLLBAR MANAGEMENT
/////////////////////////////////////////////////////////////////////////////////

- (void) splitVCWillHideVC :(NSNotification *)notification {
    self.toolBar.hidden = NO;
    [self.toolBar setItems:[NSArray arrayWithObject:notification.object]];
    //[self resizingVC:[UIApplication sharedApplication].statusBarOrientation];
}

- (void) splitVCWillShowVC :(NSNotification *)notification {
    self.toolBar.hidden = YES;
    //[self resizingVC:[UIApplication sharedApplication].statusBarOrientation];
}

//////////////////////////////////////////////////////////////////
//SIZE MANAGEMENT & ORIENTATION MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void) resizingVC :(UIInterfaceOrientation) orientation {
    
    CGRect portraitFullscreenRect = CGRectMake(0, 0, 768, 1024);
    CGRect portraitWithLeftRect = CGRectMake(320, 0, 448, 1024);
    CGRect landscape = CGRectMake(0, 0, 704, 724);
    if (orientation == UIDeviceOrientationPortrait||
        orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        if(self.toolBar.hidden) {
            self.view.frame = portraitWithLeftRect;
        } else {
            self.view.frame = portraitFullscreenRect;
        }
    } else {
        self.view.frame = landscape;
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Update ToolBar hidden property before resizing
    if (toInterfaceOrientation == UIDeviceOrientationPortrait) self.toolBar.hidden=NO;
    else self.toolBar.hidden=YES;
    [self resizingVC:toInterfaceOrientation];
}


//////////////////////////////////////////////////////////////////
//MOVIE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)playMovie:(MPMoviePlayerController *)player {
    [player prepareToPlay];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: player.view];
    [player play];
}





@end
