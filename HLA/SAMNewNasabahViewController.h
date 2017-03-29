//
//  SAMNewNasabahViewController.h
//  BLESS
//
//  Created by administrator on 3/27/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIPInfo.h"
#import "BranchInfo.h"
#import "ReferralSource.h"
#import "SIDate.h"
#import "SAMDashboardViewController.h"

@interface SAMNewNasabahViewController : UIViewController <NIPInfoDelegate, BranchInfoDelegate, ReferralSourceDelegate, SIDateDelegate, UIAlertViewDelegate> {

    NIPInfo *_nipInfo;
    BranchInfo *_branchInfo;
    ReferralSource *_referralSource;
    SIDate *_SIDate;
    
    UIPopoverController *_nipInfoPopover;
    UIPopoverController *_branchInfoPopover;
    UIPopoverController *_referralSourcePopover;
    UIPopoverController *_datePopover;
    
    IBOutlet UIScrollView *scrollViewForm;
}

@property (nonatomic, retain) SAMDashboardViewController *dashboardVC;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, retain) SIDate *SIDate;

@property (weak, nonatomic) IBOutlet UITextField *txtNip;
@property (weak, nonatomic) IBOutlet UITextField *txtReferralName;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchCode;
@property (weak, nonatomic) IBOutlet UITextField *txtBranchName;
@property (weak, nonatomic) IBOutlet UITextField *txtKanwil;
@property (weak, nonatomic) IBOutlet UITextField *txtKcu;
@property (weak, nonatomic) IBOutlet UIButton *outletReferralSource;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segReferralType;

@property (weak, nonatomic) IBOutlet UITextField *txtProspectFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtProspectNoHP;
@property (weak, nonatomic) IBOutlet UITextField *txtProspectId;
@property (weak, nonatomic) IBOutlet UITextField *txtProspectBirthplace;
@property (weak, nonatomic) IBOutlet UIButton *outletDoB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segNationality;

@property NSString *gender;
@property NSString *nationality;

- (IBAction)actionEmployeeNip:(UIButton *)sender;
- (IBAction)actionBranchInfo:(UIButton *)sender;
- (IBAction)actionReferralSource:(id)sender;

@end
