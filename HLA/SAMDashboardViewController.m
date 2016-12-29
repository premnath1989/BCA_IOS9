//
//  SAMDashboardViewController.m
//  BLESS
//
//  Created by Basvi on 12/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMDashboardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SAMActivityViewController.h"
#import "SAMActivityListViewController.h"
#import "AppDelegate.h"
#import "MainClient.h"

@interface SAMDashboardViewController ()

@end

@implementation SAMDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCircleAndBorderView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCircleAndBorderView{
    viewCircleOutside.layer.cornerRadius = viewCircleOutside.bounds.size.width/2;
    viewCircleInnerSide.layer.cornerRadius = viewCircleInnerSide.bounds.size.width/2;
    
    viewUpcomingAppointments.layer.borderWidth = 1.0;
    viewUpcomingAppointments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    viewSubmitted.layer.borderWidth = 1.0;
    viewSubmitted.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

-(IBAction)actionDataNasabah:(id)sender{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainClient *mainClient = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainClient"];
    mainClient.modalPresentationStyle = UIModalPresentationFullScreen;
    mainClient.IndexTab = appdlg.ProspectListingIndex;
    [delegate setIsFromSAM:1];
    UIImage *image = [UIImage imageNamed:@"btn_prospect_off.png"];
    mainClient.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Client" image:image selectedImage:image];
    [self presentViewController:mainClient animated:NO completion:Nil];
}

-(IBAction)actionDataReferral:(id)sender{
    SAMActivityViewController* viewController = [[SAMActivityViewController alloc] initWithNibName:@"SAMActivityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)actionActivityLog:(id)sender{
    SAMActivityListViewController* viewController = [[SAMActivityListViewController alloc] initWithNibName:@"SAMActivityListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
