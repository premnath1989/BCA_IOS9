//
//  MainCustomer.m
//  MPOS
//
//  Created by shawal sapuan on 6/11/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MainCustomer.h"
#import "CarouselViewController.h"
#import "CustomerProfile.h"
#import "CFFListingViewController.h"
#import "Logout.h"
#import "MasterMenuCFF.h"

@interface MainCustomer () {
    NSArray* viewControllers;
}

@end

@implementation MainCustomer
@synthesize indexNo,IndexTab;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
    self.delegate = self;
	
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    UIStoryboard *newStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
    //UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"CFFStoryboard" bundle:Nil];
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"CFFListingStoryboard" bundle:Nil];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    
    CarouselViewController* carouselPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"btn_home.png"] tag: 0];
    [controllersToAdd addObject:carouselPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    //CustomerProfile *CFFListingPage = [secondStoryboard instantiateViewControllerWithIdentifier:@"customerProfile"];
    CFFListingViewController *CFFListingPage = [secondStoryboard instantiateViewControllerWithIdentifier:@"CFFRootVC"];
    //CFFListingViewController *CFFListingPage = [[CFFListingViewController alloc]initWithNibName:@"CFFListingViewController" bundle:nil];
    CFFListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Listing" image:[UIImage imageNamed:@"btn_SIlisting_off.png"] selectedImage:[UIImage imageNamed:@"btn_SIlisting_off.png"]];
    [controllersToAdd addObject:CFFListingPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];

    [self setViewControllers:viewControllers];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
    //self.tabBar.backgroundGradientColors = colors;
    [self.tabBar setBackgroundColor:[UIColor colorWithRed:0/255.0 green:102.0/255.0 blue:179.0/255.0 alpha:1.0]];
    
    if (self.IndexTab) {
        clickIndex = IndexTab;
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:IndexTab]);
        
    }
    else {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:1]);
    }
    
    colors = Nil, controllersToAdd = Nil, carouselPage = Nil, CFFListingPage = Nil, newStoryboard = nil;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    

}

-(void)hideKeyboard{
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(BOOL)tabBarController:(CFFTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewControllers indexOfObject:viewController] == 6) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
