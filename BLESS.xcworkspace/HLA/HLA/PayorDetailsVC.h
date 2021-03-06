//
//  PayorDetailsVC.h
//  iMobile Planner
//
//  Created by Juliana on 11/13/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMDatabase.h"
#import "FMResultSet.h"

@interface PayorDetailsVC : UITableViewController {
	FMDatabase *db;
	FMResultSet *results;
	NSString *stringID;
	NSString *poFlag;
	NSString *religion;
	NSString *gender;
	NSString *smoker;
	NSString *corrAdd;
	NSString *ownership;
	NSString *resForeignAdd;
	NSString *ofcForeignAdd;
}

@property (strong, nonatomic) IBOutlet UIButton *btnPOFlag;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *DOBLbl;
@property (strong, nonatomic) IBOutlet UITextField *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *raceLbl;
@property (strong, nonatomic) IBOutlet UITextField *nricLbl;
@property (strong, nonatomic) IBOutlet UILabel *nationalityLbl;
@property (strong, nonatomic) IBOutlet UILabel *OtherTypeIDLbl;
@property (strong, nonatomic) IBOutlet UITextField *otherIDLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segReligion;
@property (strong, nonatomic) IBOutlet UILabel *OccupationLbl;
@property (strong, nonatomic) IBOutlet UILabel *relationshipLbl;
@property (strong, nonatomic) IBOutlet UILabel *maritalStatusLbl;
@property (strong, nonatomic) IBOutlet UITextField *employerLbl;
@property (strong, nonatomic) IBOutlet UITextField *businessLbl;
@property (strong, nonatomic) IBOutlet UITextView *exactDutiesLbl;
@property (strong, nonatomic) IBOutlet UITextField *yearlyIncomeLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSmoker;


//Correspondence Address
@property (strong, nonatomic) IBOutlet UIButton *BtnResidence;
@property (strong, nonatomic) IBOutlet UIButton *BtnOffice;


//Residence Address
@property (strong, nonatomic) IBOutlet UISegmentedControl *segOwnership;
@property (strong, nonatomic) IBOutlet UITextField *txtPostcode1;
@property (strong, nonatomic) IBOutlet UITextField *txtState1;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry1;
@property (strong, nonatomic) IBOutlet UITextField *txtTown1;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd1;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd12;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd13;
@property (strong, nonatomic) IBOutlet UIButton *BtnResidenceForeignAdd;


//Office Address
@property (strong, nonatomic) IBOutlet UITextField *txtPostcode2;
@property (strong, nonatomic) IBOutlet UITextField *txtState2;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry2;
@property (strong, nonatomic) IBOutlet UITextField *txtTown2;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd2;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd22;
@property (strong, nonatomic) IBOutlet UITextField *txtAdd23;
@property (strong, nonatomic) IBOutlet UIButton *BtnOfficeForeignAdd;


//Contact Tel No
@property (strong, nonatomic) IBOutlet UITextField *txtResidence1;
@property (strong, nonatomic) IBOutlet UITextField *txtResidence2;
@property (strong, nonatomic) IBOutlet UITextField *txtOffice1;
@property (strong, nonatomic) IBOutlet UITextField *txtOffice2;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile1;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile2;
@property (strong, nonatomic) IBOutlet UITextField *txtFax1;
@property (strong, nonatomic) IBOutlet UITextField *txtFax2;


//Parent Consent
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtIC;

@end
