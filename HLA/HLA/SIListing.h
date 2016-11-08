//
//  SIListing.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/2/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "siListingSortBy.h"
#import "SIDate.h"
#import "NDHTMLtoPDF.h"
#import "TableManagement.h"
#import "Model_SI_Master.h"
#import "Model_SI_Premium.h"
#import "ModelSIPOData.h"
#import "ModelAgentProfile.h"
#import "SIListingTableViewCell.h"
#import "ReaderViewController.h"
#import "ModelProspectProfile.h"

@interface SIListing : UIViewController<UITableViewDelegate, UITableViewDataSource,ReaderViewControllerDelegate, siListingDelegate, SIDateDelegate, NDHTMLtoPDFDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
    Boolean isFilter;
    siListingSortBy *_SortBy;
    
    ModelProspectProfile *modelProspectProfile;
    Model_SI_Master *_modelSIMaster;
    ModelSIPOData *_modelSIPOData;
    Model_SI_Premium *_modelSIPremium;
    ModelAgentProfile *_modelAgentProfile;
    
    UIPopoverController *_Popover;
    SIDate *_SIDate;
    UIPopoverController *_SIDatePopover;
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
    
    NSString *DBDateFrom2;
    NSString *DBDateTo2;
    NSString* sortMethod;
    NSString* sortedBy;
    
    IBOutlet UILabel *NoIlustrasi;
    UIView *TableHeader;
    UIColor *themeColour;
    NSArray *columnHeadersContent;
    UIFont *fontType;
    TableManagement *tableManagement;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSortFullName;
@property (strong, nonatomic) IBOutlet UIButton *btnSortSINO;
@property (strong, nonatomic) IBOutlet UIButton *btnSortCreatedDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSortProduct;
@property (strong, nonatomic) IBOutlet UIButton *btnSortSumAssured;

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property (nonatomic, copy) NSString *TradOrEver;

@property (nonatomic, retain) siListingSortBy *SortBy;
@property (nonatomic, retain) UIPopoverController *Popover;
@property (nonatomic, retain) SIDate *SIDate;

@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, copy) NSString *DBDateFrom;
@property (nonatomic, copy) NSString *DBDateTo;
@property (nonatomic, copy) NSString *OrderBy;
@property (retain, nonatomic) NSMutableArray *SINO;
@property (retain, nonatomic) NSMutableArray *DateCreated;
@property (retain, nonatomic) NSMutableArray *Name;
@property (retain, nonatomic) NSMutableArray *PlanName;
@property (retain, nonatomic) NSMutableArray *BasicSA;
@property (retain, nonatomic) NSMutableArray *SIStatus;
@property (retain, nonatomic) NSMutableArray *CustomerCode;
@property (retain, nonatomic) NSMutableArray *SIVersion;
@property (retain, nonatomic) NSMutableArray *SIValidStatus;
@property (retain, nonatomic) NSMutableArray *SIQQStatus;
@property (retain, nonatomic) NSMutableArray *SIEditStatus;
@property (retain, nonatomic) NSMutableArray *SISignedStatus;

@property (retain, nonatomic) NSMutableArray *FilteredSINO;
@property (retain, nonatomic) NSMutableArray *FilteredDateCreated;
@property (retain, nonatomic) NSMutableArray *FilteredName;
@property (retain, nonatomic) NSMutableArray *FilteredPlanName;
@property (retain, nonatomic) NSMutableArray *FilteredBasicSA;
@property (retain, nonatomic) NSMutableArray *FilteredSIStatus;
@property (retain, nonatomic) NSMutableArray *FilteredCustomerCode;
@property (retain, nonatomic) NSMutableArray *FilteredSIVersion;
@property (retain, nonatomic) NSMutableArray *FilteredSIValidStatus;

@property (weak, nonatomic) IBOutlet UITextField *txtSINO;
@property (weak, nonatomic) IBOutlet UITextField *txtLAName;

@property (weak, nonatomic) IBOutlet UIButton *outletDateFrom;
@property (weak, nonatomic) IBOutlet UIButton *outletDateTo;

@property (weak, nonatomic) IBOutlet UIButton *btnSortBy;
@property (weak, nonatomic) IBOutlet UIButton *outletDelete;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *outletDone;

@property (weak, nonatomic) IBOutlet UILabel *lblSINO;
@property (weak, nonatomic) IBOutlet UILabel *lblDateCreated;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlan;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicSA;
@property (weak, nonatomic) IBOutlet UILabel *lblProposalStats;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outletGender;
@property (weak, nonatomic) IBOutlet UIButton *outletEdit;


//@property (weak, nonatomic) IBOutlet UIView *TableHeader;

- (IBAction)btnDateFrom:(id)sender;
- (IBAction)btnDateTo:(id)sender;
- (IBAction)segOrderBy:(id)sender;
- (IBAction)btnSearch:(id)sender;
- (IBAction)btnEdit:(id)sender;
- (IBAction)btnDelete:(id)sender;
- (IBAction)btnDone:(id)sender;
- (IBAction)btnSortBy:(UIButton *)sender;
- (IBAction)btnReset:(id)sender;

//added for Add New SI Listing button by Juliana
- (IBAction)btnAddNewSI:(id)sender;
- (void)Refresh;
- (void)SIListingClear;

@end
