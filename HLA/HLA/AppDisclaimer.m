//
//  PasswordTips.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 11/20/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AppDisclaimer.h"
#import "CarouselViewController.h"

@interface AppDisclaimer ()

@end

@implementation AppDisclaimer
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (IBAction)approve:(id)sender {
    CarouselViewController *carouselMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselMenu.getInternet = @"No";
    [self presentViewController:carouselMenu animated:YES completion:Nil];
    [_delegate CloseWindow];
    
}
@end