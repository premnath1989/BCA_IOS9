//
//  NomineesTrustees.h
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNomineesTrusteesVC.h"
#import "MainTrusteesVC.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
//#import "Nominees.h"


@interface NomineesTrustees : UITableViewController <MainNomineesTrusteesDelegate, MainTrusteesVCProtocol, UIGestureRecognizerDelegate,UITableViewDelegate,UINavigationControllerDelegate, UIAlertViewDelegate> {
	FMResultSet *results;
	FMResultSet *results2;
	NSString *stringID;
    UIButton *Guidelines;
	BOOL isNoNomination;
}
@property (strong, nonatomic) IBOutlet UIView *disableCell;
- (IBAction)addNominees:(id)sender;
- (IBAction)addTrustee:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalShareLbl;
@property (strong, nonatomic) IBOutlet UILabel *trusteeLbl1;
@property (strong, nonatomic) IBOutlet UILabel *trusteeLbl2;
@property (strong, nonatomic) IBOutlet UILabel *Nominee1Lbl;
@property (strong, nonatomic) IBOutlet UILabel *Nominee2Lbl;
@property (strong, nonatomic) IBOutlet UILabel *Nominee3Lbl;
@property (strong, nonatomic) IBOutlet UILabel *Nominee4Lbl;

@property (strong,nonatomic) NSMutableArray *dataItems;
@property (strong, nonatomic) IBOutlet UITableViewCell *firstTCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondTCell;

@property (strong, nonatomic) IBOutlet UITableViewCell *firstNCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondNCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *thirdNCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *fourtNCell;

@property (weak, nonatomic) IBOutlet UIButton *btnNoNomination;
- (IBAction)ActionNoNomination:(id)sender;
@property (nonatomic, assign) BOOL NoNominationChecked;


@property (strong, nonatomic) UIButton *Guidelines;

@end
