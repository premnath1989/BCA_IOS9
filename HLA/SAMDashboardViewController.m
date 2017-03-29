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
#import "SAMNewNasabahViewController.h"
#import "AppDelegate.h"
#import "MainClient.h"

@interface SAMDashboardViewController ()

@end

int const ADD_NASABAH_ALERT_TAG = 100;

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Apakah Anda ingin menggunakan data nasabah yang ada?" delegate:self cancelButtonTitle:@"Ya" otherButtonTitles:@"Buat Baru", nil];
    [alert setTag:ADD_NASABAH_ALERT_TAG];
    [alert show];
    
}

-(IBAction)actionActivityLog:(id)sender{
    SAMActivityListViewController* viewController = [[SAMActivityListViewController alloc] initWithNibName:@"SAMActivityListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)actionActivityView {
    SAMActivityViewController* viewController = [[SAMActivityViewController alloc] initWithNibName:@"SAMActivityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -Delegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == ADD_NASABAH_ALERT_TAG) {
        if(buttonIndex == 0) {
            //TODO: Add call to create new nasabah vc
            
        } else {
            SAMNewNasabahViewController* viewController = [[SAMNewNasabahViewController alloc] initWithNibName:@"SAMNewNasabahViewController" bundle:nil];
            viewController.dashboardVC = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
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
