//
//  MainClient.m
//  MPOS
//
//  Created by shawal sapuan on 6/4/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MainClient.h"
#import "CarouselViewController.h"
#import "ProspectListing.h"
#import "Logout.h"
#import "GroupListing.h"
#import "SIMenuViewController.h"

@interface MainClient () {
    NSArray* viewControllers;
}

@end

@implementation MainClient
@synthesize indexNo,IndexTab;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
	
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"btn_home.png"] tag: 0];
    [controllersToAdd addObject:carouselPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    UIStoryboard *clientStoryboard = [UIStoryboard storyboardWithName:@"ProspectProfileStoryboard" bundle:Nil];
    ProspectListing* ProspectListingPage = [clientStoryboard instantiateViewControllerWithIdentifier:@"prospectProfile"];
	//ProspectListing* ProspectListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"newClientListing"];
    ProspectListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Client" image:[UIImage imageNamed:@"btn_prospect_off.png"] tag: 0];
    [controllersToAdd addObject:ProspectListingPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    GroupListing *groupPage = [self.storyboard instantiateViewControllerWithIdentifier:@"groupListing"];
    groupPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Group" image:[UIImage imageNamed:@"btn_prospect_off.png"] tag:0];
    [controllersToAdd addObject:groupPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"HLAWPStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainScreen *mainScreen= [cpStoryboard instantiateViewControllerWithIdentifier:@"Main"];
    mainScreen.tradOrEver = @"TRAD";
    mainScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    mainScreen.IndexTab = appdlg.NewSIIndex;
    mainScreen.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New SI" image:[UIImage imageNamed:@"btn_newSI_off.png"] tag:0];
    [controllersToAdd addObject:mainScreen];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    [self setViewControllers:viewControllers];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
    //self.tabBar.backgroundGradientColors = colors;
    [self.tabBar setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:175.0/255.0 blue:50.0/255.0 alpha:1.0]];
    
    if (self.IndexTab) {
        clickIndex = IndexTab;
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:IndexTab]);
        
    }
    else {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:2]);
    }
    
    colors = Nil, controllersToAdd = Nil, carouselPage = Nil, ProspectListingPage = Nil;
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

-(BOOL)tabBarController:(ClientTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewControllers indexOfObject:viewController] == 6) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
