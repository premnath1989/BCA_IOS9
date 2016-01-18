//
//  ViewController.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ViewController.h"
#import "Login.h"
#import "CarouselViewController.h"
#import "MainScreen.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize Login = _Login;
@synthesize CVC = _CVC;
@synthesize sss;


- (void)viewDidLoad
{	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.	
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

-(void)viewDidAppear:(BOOL)animated
{	
	if (sss != 1) {
		self.Login = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
		_Login.delegate = self;
		
		_Login.modalPresentationStyle = UIModalPresentationFullScreen;
		_Login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:_Login animated:NO completion:nil];
	}
	
}

-(void)Dismiss:(NSString *)ViewToBePresented{
	
	sss = 1;
	self.CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"carouselView"];
	_CVC.delegate = self;
	
	_CVC.modalPresentationStyle = UIModalPresentationFullScreen;
	_CVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
    [self presentViewController:_CVC animated:NO completion:nil];
}

-(void)PresentMain{
	sss = 1;
	MainScreen *MS = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
	MS.modalPresentationStyle = UIModalPresentationPageSheet;
	MS.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
    [self presentViewController:MS animated:NO completion:nil];
}

@end
