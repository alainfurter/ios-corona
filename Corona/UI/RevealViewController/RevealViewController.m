//
//  RevealViewController.m
//  Swiss Plates
//
//  Created by Alain on 07.09.17.
//  Copyright © 2017 Zone Zero Apps. All rights reserved.
//

#import "RevealViewController.h"

@interface RevealViewController () <SWRevealViewControllerDelegate>

@end

@implementation RevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.frontViewShadowOpacity = 1.0f;
    self.delegate = self;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position {
    //NSLog(@"RevealViewController, swrevealviewcontroller delegate, animatetoposition");
    if (position == FrontViewPositionLeft) {
        //NSLog(@"RevealViewController, swrevealviewcontroller delegate, animatetoposition, left");
    }
    if (position == FrontViewPositionRight) {
        //NSLog(@"RevealViewController, swrevealviewcontroller delegate, animatetoposition, right");
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    //NSLog(@"RevealViewController, swrevealviewcontroller delegate, willmovetoposition");
    if (position == FrontViewPositionLeft) {
        //NSLog(@"RevealViewController, swrevealviewcontroller delegate, willmovetoposition, left");
    }
    if (position == FrontViewPositionRight) {
        //NSLog(@"RevealViewController, swrevealviewcontroller delegate, willmovetoposition, right");
        UIView *snapshotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
        [snapshotView addGestureRecognizer:revealController.tapGestureRecognizer];
        [snapshotView addGestureRecognizer:revealController.panGestureRecognizer];
        [revealController.frontViewController.view addSubview:snapshotView];
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    //NSLog(@"RevealViewController, swrevealviewcontroller delegate, didmovetoposition");
    if (position == FrontViewPositionLeft) {
        UIView *snapshotView = [[revealController.frontViewController.view subviews] lastObject];
        for (UIGestureRecognizer *gesturerecognizer in snapshotView.gestureRecognizers)
            [snapshotView removeGestureRecognizer:gesturerecognizer];
        [snapshotView removeFromSuperview];
        [revealController setNeedsStatusBarAppearanceUpdate];
    }
    if (position == FrontViewPositionRight) {
        //NSLog(@"RevealViewController, swrevealviewcontroller delegate, didmovetoposition, right");
    }
}

 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //NSLog(@"RevealViewController, prepare for segue");
}

@end
