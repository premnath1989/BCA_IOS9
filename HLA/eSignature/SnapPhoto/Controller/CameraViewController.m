//
//  CameraViewController.m
//  MPOS
//
//  Created by Emi on 26/8/15.
//  Copyright (c) 2015 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"frame %@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"frame top %@",NSStringFromCGRect(self.topViewController.view.bounds));
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
