//
//  MainScreen.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MainScreen.h"
#import "FSVerticalTabBarController.h"
#import "ProspectViewController.h"
#import "ProspectListing.h"
#import "Logout.h"
#import "SIListing.h"
#import "SIMenuViewController.h"
#import "CarouselViewController.h"

#import "ReportViewController.h"
#import "NewLAViewController.h"
#import "EverSeriesMasterViewController.h"

@interface MainScreen (){
     NSArray* viewControllers;
}
@end

@implementation MainScreen
@synthesize indexNo, showQuotation;
@synthesize userRequest,EAPPorSI;
@synthesize IndexTab,mainBH,mainPH,mainLa2ndH, tradOrEver;;


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
    self.delegate = self;
    
    //Create view controllers
    NSMutableArray* controllersToAdd = [[NSMutableArray alloc] init];
    
    UIImage *image;
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselPage = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    image = [UIImage imageNamed:@"btn_home.png"];
    carouselPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"btn_home.png"] selectedImage:[UIImage imageNamed:@"btn_home.png"]];
    [controllersToAdd addObject:carouselPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    /*UIStoryboard *clientStoryboard = [UIStoryboard storyboardWithName:@"ProspectProfileStoryboard" bundle:Nil];
    ProspectListing* ProspectListingPage = [clientStoryboard instantiateViewControllerWithIdentifier:@"prospectProfile"];
    image = [UIImage imageNamed:@"btn_prospect_off.png"];
    ProspectListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Client" image:image selectedImage:image];

    [controllersToAdd addObject:ProspectListingPage];*/
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainClient *mainClient = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainClient"];
    mainClient.modalPresentationStyle = UIModalPresentationFullScreen;
    mainClient.IndexTab = appdlg.ProspectListingIndex;
    image = [UIImage imageNamed:@"btn_prospect_off.png"];
    mainClient.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Client" image:image selectedImage:image];
    [controllersToAdd addObject:mainClient];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    SIListing* SIListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIListing"];
	SIListingPage.TradOrEver = tradOrEver;
    image = [UIImage imageNamed:@"btn_SIlisting_off.png"];
	SIListingPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"SI Listing" image:image selectedImage:image];
    [controllersToAdd addObject:SIListingPage];
    viewControllers = [NSArray arrayWithArray:controllersToAdd];
    
    if ([tradOrEver isEqualToString:@"TRAD"]) {
        SIMenuViewController *menuSIPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SIPageView"];
		menuSIPage.requestSINo = [self.requestSINo description];
		menuSIPage.SIshowQuotation = showQuotation;
        menuSIPage.EAPPorSI = [self.EAPPorSI description];
        image = [UIImage imageNamed:@"btn_newSI_off.png"];
		menuSIPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New SI" image:image selectedImage:image];
        [controllersToAdd addObject:menuSIPage];
        viewControllers = [NSArray arrayWithArray:controllersToAdd];
	} else{
        EverSeriesMasterViewController *EverPage = [self.storyboard instantiateViewControllerWithIdentifier:@"EverSeriesMaster"];
		
        image = [UIImage imageNamed:@"btn_newSI_off.png"];
		EverPage.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"New SI" image:image selectedImage:image];
		EverPage.requestSINo = [self.requestSINo description];
		EverPage.EAPPorSI = [self.EAPPorSI description];
		[controllersToAdd addObject:EverPage];
		viewControllers = [NSArray arrayWithArray:controllersToAdd];
	}


    //set the view controllers of the the tab bar controller
    [self setViewControllers:viewControllers];
    
    //set the background color to a texture
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor, nil];
//    self.tabBar.backgroundGradientColors = colors;
    self.tabBar.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    if (self.IndexTab) {
        clickIndex = IndexTab;
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:IndexTab]);
    
    }
    else {
        self.selectedViewController = ((UIViewController*)[viewControllers objectAtIndex:1]);
    }
    
    colors = Nil,  carouselPage = Nil/*, ProspectListingPage = Nil*/;
    
}

- (void)viewDidUnload
{
    userRequest = Nil;
    mainBH = Nil;
    mainLa2ndH = Nil;
    mainPH = Nil;
    showQuotation = Nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    
}

-(BOOL)shouldProceedToSelectedViewControllerSave:(UIViewController*)viewController
{
    if ([[viewControllers objectAtIndex:3] isKindOfClass:[SIMenuViewController class]])
    {
        SIMenuViewController * simenu = [viewControllers objectAtIndex:3];
		BOOL temp = [simenu performSaveSI:YES];
        return temp;
        
    }
    else if  ([[viewControllers objectAtIndex:3] isKindOfClass:[EverSeriesMasterViewController class]])
    {
		EverSeriesMasterViewController* Eversimenu = [viewControllers objectAtIndex:3];
		BOOL temp = [Eversimenu performSaveSI:YES];
        return temp;
    }
	
    return YES;
}

-(BOOL)shouldProceedToSelectedViewControllerDiscard:(UIViewController*)viewController
{
    if ([[viewControllers objectAtIndex:3] isKindOfClass:[SIMenuViewController class]])
    {
        SIMenuViewController * simenu = [viewControllers objectAtIndex:3];
        return[simenu performSaveSI:NO];
    }
    else if  ([[viewControllers objectAtIndex:3] isKindOfClass:[EverSeriesMasterViewController class]])
    {
		EverSeriesMasterViewController* Eversimenu = [viewControllers objectAtIndex:3];
		return[Eversimenu performSaveSI:NO];
    }
    return YES;
}

-(BOOL)RevertBackSIStatus:(UIViewController*)viewController //to revert the status if there are no changes to SI
{
    if ([[viewControllers objectAtIndex:3] isKindOfClass:[SIMenuViewController class]])
    {
        SIMenuViewController * simenu = [viewControllers objectAtIndex:3];
        return[simenu RevertSIStatus];
    }
    return YES;
}

-(BOOL)tabBarController:(FSVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewControllers indexOfObject:viewController] == 6) {
        return NO;
    }
    else {
        return YES;
    }

}

@end
