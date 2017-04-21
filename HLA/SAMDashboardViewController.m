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
#import "SAMMeetingScheduleViewController.h"
#import "SAMTableViewMeetingScheduleListCell.h"
#import "AppDelegate.h"
#import "MainClient.h"
#import "ProspectListing.h"
#import "SAMDBHelper.h"

@interface SAMDashboardViewController ()

@end

int const ADD_NASABAH_ALERT_TAG = 100;
int const CONTINUE_ALERT_TAG = 101;

NSMutableArray *schedules;
SAMDBHelper *dbHelper;
UIAlertView *newNasabahAlertView;

@implementation SAMDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCircleAndBorderView];
    // Do any additional setup after loading the view.
    dbHelper = [[SAMDBHelper alloc] init];
    schedules = [[NSMutableArray alloc] init];
    schedules = [dbHelper ReadAllSchedule];
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

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [schedules count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SAMTableViewMeetingScheduleListCell *cellSAMList = (SAMTableViewMeetingScheduleListCell *)[tableView dequeueReusableCellWithIdentifier:@"SAMTableViewMeetingScheduleListCell"];
    
    if (cellSAMList == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SAMTableViewMeetingScheduleListCell" owner:self options:nil];
        cellSAMList = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }

    SAMModel *sam = [schedules objectAtIndex:indexPath.row];
    NSArray *dateAndTimeString = [[NSArray alloc] init];
    if(![sam.dateNextMeeting isEqualToString:@""]) {
        dateAndTimeString = [sam.dateNextMeeting componentsSeparatedByString:@" "];
        
        // Set the field value;
        [cellSAMList.labelName setText:sam.customerName];
        [cellSAMList.labelDate setText:[dateAndTimeString objectAtIndex:0]];
        [cellSAMList.labelTime setText:[dateAndTimeString objectAtIndex:1]];
    }
    
    return cellSAMList;
}

#pragma mark - Action

-(IBAction)actionDataNasabah:(id)sender{
//    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
//    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:Nil];
//    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
//    MainClient *mainClient = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainClient"];
//    mainClient.modalPresentationStyle = UIModalPresentationFullScreen;
//    mainClient.IndexTab = appdlg.ProspectListingIndex;
//    [delegate setIsFromSAM:1];
//    UIImage *image = [UIImage imageNamed:@"btn_prospect_off.png"];
//    mainClient.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Client" image:image selectedImage:image];
//    [self presentViewController:mainClient animated:NO completion:Nil];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    [delegate setIsFromSAM:YES];
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ProspectProfileStoryboard" bundle:nil];
    ProspectListing *prospectListing = [cpStoryboard instantiateViewControllerWithIdentifier:@"newClientListing"];
    [self.navigationController pushViewController:prospectListing animated:YES];
    prospectListing.navigationItem.title = @"Data Nasabah";
    
}

-(IBAction)actionDataReferral:(id)sender{
    newNasabahAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Apakah Anda ingin menggunakan data nasabah yang ada?" delegate:self cancelButtonTitle:@"Batal" otherButtonTitles:@"Ya", @"Buat Baru", nil];
    [newNasabahAlertView setTag:ADD_NASABAH_ALERT_TAG];
    [newNasabahAlertView show];
    
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
        if(buttonIndex == 1) {
            //TODO: Add call to select existing nasabah
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
            [delegate setIsFromSAM:YES];
            UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ProspectProfileStoryboard" bundle:nil];
            ProspectListing *prospectListing = [cpStoryboard instantiateViewControllerWithIdentifier:@"newClientListing"];
            prospectListing.isSAMUseExistingNasabah = YES;
            [self.navigationController pushViewController:prospectListing animated:YES];
            prospectListing.navigationItem.title = @"Data Nasabah";
        } else if(buttonIndex == 2) {
            SAMNewNasabahViewController* viewController = [[SAMNewNasabahViewController alloc] initWithNibName:@"SAMNewNasabahViewController" bundle:nil];
            viewController.dashboardVC = self;
            [self.navigationController pushViewController:viewController animated:YES];
            viewController.navigationItem.title = @"New Refered";
            
//            UIStoryboard* clientProfileStoryboard = [UIStoryboard storyboardWithName:@"ProspectProfileStoryboard" bundle:nil];
//            prospectVC = [clientProfileStoryboard instantiateViewControllerWithIdentifier:@"Prospect"];
//            prospectVC.delegate = self;
//            prospectVC.isFromSam = YES;
//            [self.navigationController pushViewController: prospectVC animated:YES];
        } else {
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
        }
    } else if(alertView.tag == CONTINUE_ALERT_TAG) {
        if(buttonIndex == 0) {
            //Pressed "Lanjutkan"
            [self.navigationController popViewControllerAnimated:YES];
            [self actionActivityView];
            
        } else {
            //Pressed "Jadwalkan Meeting"
            SAMMeetingScheduleViewController *samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc] initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
            [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
            samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
            [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
        }
    }
}

-(void) FinishInsert {
    UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:@"Data Nasabah tersimpan" message:@"Apakah Anda ingin melanjutkan proses?" delegate:self cancelButtonTitle:@"Lanjut" otherButtonTitles: @"Jadwalkan Meeting", nil];
    [continueAlert setTag:CONTINUE_ALERT_TAG];
    [continueAlert show];
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
