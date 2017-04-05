//
//  SAMActivityViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityViewController.h"
#import "SAMMeetingScheduleViewController.h"
#import "SAMMeetingNoteViewController.h"
#import "MainCustomer.h"
#import "MainScreen.h"
#import "ProductInformation.h"
#import "SPAJ Main.h"
#import "CFFListingViewController.h"
#import "SIListing.h"
#import "SPAJ E Application List.h"

@interface SAMActivityViewController (){
    SAMMeetingScheduleViewController* samMeetingScheduleVC;
    SAMMeetingNoteViewController* samMeetingNoteVC;
}

@end

@implementation SAMActivityViewController

@synthesize _SAMModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCircleAndBorderView];
    samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc]initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
    samMeetingNoteVC = [[SAMMeetingNoteViewController alloc] initWithNibName:@"SAMMeetingNoteViewController" bundle:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCircleAndBorderView{
    
    for (UIView *view in viewActivitySteps.subviews){
        if ([view isKindOfClass:[UIView class]]){
            view.layer.cornerRadius = view.bounds.size.width/2;
            for (UIView *viewInner in view.subviews){
                viewInner.layer.cornerRadius = viewInner.bounds.size.width/2;
            }
        }
    }
    
    viewActivityComments.layer.borderWidth = 1.0;
    viewActivityComments.layer.borderColor = [UIColor colorWithRed:137.0/255.0 green:199.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
}

- (void) loadSAMData {
    
}

-(IBAction)actionScheduleMeeting:(id)sender{
    [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
    samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
    [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
}

-(IBAction)actionNewMeetingNote:(id)sender {
    [samMeetingNoteVC setModalPresentationStyle:UIModalPresentationFormSheet];
    samMeetingNoteVC.preferredContentSize = CGSizeMake(703, 456);
    [self presentViewController:samMeetingNoteVC animated:YES completion:nil];
}

-(IBAction)actionCFF:(id)sender {
    CFFListingViewController *cffListingVC = [[CFFListingViewController alloc] initWithNibName:@"CFFListingViewController" bundle:nil];
    cffListingVC.isFromSAM = YES;
    cffListingVC.SAMFilter = @"bonitus";
    [self.navigationController pushViewController:cffListingVC animated:YES];
    
    //UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"CFFStoryboard" bundle:Nil];
    //MainCustomer *mainCustomer = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainCFF"];
    //mainCustomer.modalPresentationStyle = UIModalPresentationFullScreen;
    //mainCustomer.IndexTab = 1;
    //[self.navigationController pushViewController:mainCustomer animated:YES];
    //mainCustomer = Nil;
    //AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //appdlg.eApp=NO;
}

-(IBAction)actionRecomendation:(id)sender {
    ProductInformation *view = [[ProductInformation alloc] initWithNibName:@"ProductInformation" bundle:nil];
    view.modalTransitionStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:view animated:YES];
}

-(IBAction)actionVideo:(id)sender {
    
}

-(IBAction)actionIllustration:(id)sender {
    // Override option, open the Traditional SI
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"HLAWPStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    SIListing *SIListing = [cpStoryboard instantiateViewControllerWithIdentifier:@"SIListing"];
    SIListing.TradOrEver = @"TRAD";
    [self.navigationController pushViewController:SIListing animated:YES];
}

-(IBAction)actionSPAJ:(id)sender {
    SPAJMain* viewController = [[SPAJMain alloc] initWithNibName:@"SPAJ Main" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
//    
//    UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
//    SPAJEApplicationList *viewControllerEappListing = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
//    [self addChildViewController:viewControllerEappListing];
//    [self presentViewController:viewControllerEappListing animated:YES completion:nil];
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
