//
//  SIMenuViewController.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIMenuViewController.h"
#import "NewLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "SecondLAViewController.h"
#import "PayorViewController.h"
#import "MainScreen.h"
#import "ReportViewController.h"
#import "BrowserViewController.h"
#import "PDSViewController.h"
#import "CashPromiseViewController.h"
#import "AppDelegate.h"
#import "MaineApp.h"
#import "ColorHexCode.h"
#import "SubDetails.h"
#import "DBController.h"
#import "eAppCheckList.h"
#import "MasterMenuEApp.h"
#import "Cleanup.h"
#import "Constants.h"
#import "ReaderViewController.h"
#import "TabValidation.h"
#import "PremiumKeluargaku.h"
#import "UIView+viewRecursion.h"
#import "LoginDBManagement.h"
#import "PremiumViewController.h"

#define TRAD_PAYOR_FIRSTLA  @"0"
#define TRAD_PAYOR_SECONDLA  @"1"
#define TRAD_PAYOR_PAYOR  @"2"
#define TRAD_DETAILS_BASICPLAN @"3"
#define TRAD_RIDER_DETAILS @"4"

@interface SIMenuViewController (){
    PremiumViewController *_PremiumController;
    NSMutableArray* arrayIntValidate;
    NSMutableDictionary* dictionaryPOForInsert;
    NSMutableDictionary* dictionaryMasterForInsert;
    NSMutableDictionary* newDictionaryForBasicPlan;
    bool selfRelation;
    int lastIndexSelected;
}

@end
@implementation SIMenuViewController

@synthesize outletSaveAs, SaveSINO;
@synthesize myTableView, SIshowQuotation;
@synthesize RightView,EAPPorSI;
@synthesize ListOfSubMenu,SelectedRow;
@synthesize menuBH,menuPH,menuLa2ndH,getCommDate;
@synthesize getAge,getSINo,getOccpCode,getbasicSA;
@synthesize payorCustCode,payorSINo,CustCode2,clientID2,getPayorIndexNo,get2ndLAIndexNo;
@synthesize LAController = _LAController;
@synthesize PayorController = _PayorController;
@synthesize SecondLAController = _SecondLAController;
@synthesize BasicController = _BasicController;
@synthesize getIdPay,getIdProf,getPayAge,getPayDOB,getPayOccp,getPaySex,getPaySmoker;
@synthesize get2ndLAAge,get2ndLADOB,get2ndLAOccp,get2ndLASex,get2ndLASmoker,getOccpClass;
@synthesize getMOP,getbasicHL,getPlanCode,getAdvance,requestSINo2;
@synthesize RiderController = _RiderController;
@synthesize Name2ndLA,NameLA,getLAIndexNo,NamePayor,getSex,getbasicTempHL,getSmoker,getBasicPlan, PDFCreator, riderCode, getPlanName;
@synthesize FS = _FS;   
@synthesize HLController = _HLController;
id RiderCount;
@synthesize isNewSI;


const NSString * SUM_MSG_HLACP = @"Guaranteed Yearly Income";
const NSString * SUM_MSG_L100 = @"Basic Sum Assured";
int CurrentPath;
BOOL isFirstLoad;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];

    formatter = [[Formatter alloc] init];
    riderCalculation = [[RiderCalculation alloc]init];
    _modelSIPremium = [[Model_SI_Premium alloc]init];
    _modelSIPOData = [[ModelSIPOData alloc]init];
    _modelSIMaster = [[Model_SI_Master alloc]init];
    _modelSIRider = [[ModelSIRider alloc]init];
    
    self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
    _RiderController.delegate = self;
    
    _SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
    _SecondLAController.delegate = self;

    dictionaryPOForInsert = [[NSMutableDictionary alloc]init];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //--for table view
    //self.myTableView.backgroundColor = [UIColor darkGrayColor];
    
    arrayIntValidate = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];

    _NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"0",@"0", nil];
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Pemegang Polis", @"Tertanggung", @"Asuransi Dasar\nAsuransi Tambahan\nPremi", @"Ilustrasi ",@"Produk Brosur",@"Simpan sebagai Baru", nil];
    //ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1   Pemegang Polis", @"2   Tertanggung", @"3  Ansurasi Dasar \n Asuransi Tambahan \n Premi", @"4   Ilustrasi ",@"Produk Brosur",@"Simpan sebagai Baru", nil];
    
    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    
    PlanEmpty = YES;
    added = NO;
    saved = YES;
    payorSaved = YES;
    isFirstLoad = YES;
    
    LAotherIDType = @"";
    
    myTableView.rowHeight = 84;
    [myTableView reloadData];
    
    //self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
    //_RiderController.delegate = self;
    //[self.RightView addSubview:self.RiderController.view];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    if ([[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        CGRect frame = CGRectMake(0, 20, 220, 30);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
        label.text = @"e-Application";
        [self.view addSubview:label];
        
        CGRect frame2 = CGRectMake(0, frame.size.height + 30, 220, 30);
        UILabel *label2 = [[UILabel alloc] initWithFrame:frame2];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:14];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
        label2.text = [self.requestSINo description];
        [self.view addSubview:label2];
        
        label = nil, label2 = nil;
    }
    CustomColor = nil;
    
    [self geteProposalStatus];
    
    if (![[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        if ([eProposalStatus isEqualToString:@"Confirmed"] || [eProposalStatus isEqualToString:@"Submitted"] || [eProposalStatus isEqualToString:@"Received"] || [eProposalStatus isEqualToString:@"Failed"]  ) {
            NSString *msg = @"Amendment on SI is not allowed for eApp status = confirmed, submitted, Received/ Failed";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            alert = Nil;
            [self LoadViewController];
        } else if ([eProposalStatus isEqualToString:@"Created"]) {
            
            if ([isPOSign isEqualToString:@"YES"]) {
                if (_LAController == nil) {
                    self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                    _LAController.delegate = self;
                    self.LAController.requestSINo = [self.requestSINo description];
                    self.LAController.requesteProposalStatus = eProposalStatus;
                    self.LAController.EAPPorSI = [self.EAPPorSI description];
                    
                    [self.RightView addSubview:self.LAController.view];
                }else{
                    self.LAController.requestSINo = [self.requestSINo description];
                    self.LAController.requesteProposalStatus = eProposalStatus;
                    self.LAController.EAPPorSI = [self.EAPPorSI description];
                    
                    [self.LAController.view removeFromSuperview];
                    [self.RightView addSubview:self.LAController.view];
                }
                [_LAController processLifeAssured];
                
                NSString *msg = @"Please be informed that this SI is attached to a pending eApp case. System will auto delete the eApp case should you wish to amend the SI";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                alert.tag = 601;
                [alert show];
                
            } else {
                [self LoadViewController];
                [self SetInitialStatusToFalse];
            }
        } else {
            [self LoadViewController];
            [self SetInitialStatusToFalse];
        }
        
    } else {
        [self LoadViewController];
    }
    isFirstLoad = NO;
}


- (void)setSaveAsMode:(NSString *)SINO{
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:SINO];
    NSLog(@" Edit Mode second %@ : %@", EditMode, SINO);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] != NSOrderedSame){
        outletSaveAs.hidden = YES;
    }else{
        outletSaveAs.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.autoresizesSubviews = NO;
    
    if ([[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        self.myTableView.frame = CGRectMake(0, 100, 260, 748);
        self.RightView.frame = CGRectMake(255, 20, 600, 748);
    } else {
        self.myTableView.frame = CGRectMake(0, 20, 203, 748);
    }
    
    [self hideSeparatorLine];
    
    [self setSaveAsMode:[dictionaryPOForInsert valueForKey:@"SINO"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
	BrowserViewController *controller = [[BrowserViewController alloc] initWithFilePath:htmlToPDF.PDFpath PDSorSI:PDSorSI TradOrEver:@"Trad"];
    NSString *SIPDFName;
	if ([PDSorSI isEqualToString:@"PDS"]) {
        SIPDFName = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
	} else if ([PDSorSI isEqualToString:@"UNDERWRITING"]) {
		SIPDFName = [NSString stringWithFormat:@"UNDERWRITING_%@.pdf",self.getSINo];
	} else {
		SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
	}
    controller.title = SIPDFName;
	
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
	[spinner_SI stopAnimating ];
	[self.view setUserInteractionEnabled:YES];
	[_FS Reset];
	
	UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
	[v removeFromSuperview];
	v = Nil;
	
	if (previousPath == Nil) {
		previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
	}
	
	[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	selectedPath = previousPath;
	spinner_SI = Nil;
	
    [self presentViewController:navController animated:YES completion:nil];
    
#ifdef UAT_BUILD
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *targetDir = [NSString stringWithFormat:@"%@/%@",documentsDirectory, SIPDFName];
    NSString *exportDir = [NSString stringWithFormat:@"%@/UATExport", documentsDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:exportDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:exportDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *exportFile = [NSString stringWithFormat:@"%@/export_%@",exportDir, SIPDFName];
    NSError *error;
    BOOL result;
    [fileManager removeItemAtPath:exportFile error:nil];
    result = [fileManager copyItemAtPath:targetDir toPath:exportFile error:&error];
    if (!result && error) {
        NSLog(@"Copy problem: %@", [error localizedDescription]);
    }
#endif
    
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF {
}

//-(void)loadLAPage
//{
//	_LAController.delegate = self;
//	if (getSINo) {
//		self.LAController.requestSINo = getSINo;
//		self.LAController.EAPPorSI = [self.EAPPorSI description];
//		self.LAController.requesteProposalStatus = eProposalStatus;
//        
//	} else {
//		self.LAController.requestIndexNo = getLAIndexNo;
//		self.LAController.requestLastIDPay = getIdPay;
//		self.LAController.requestLastIDProf = getIdProf;
//		self.LAController.requestCommDate = getCommDate;
//		self.LAController.requestSex = getSex;
//		self.LAController.requestSmoker = getSmoker;
//		self.LAController.requesteProposalStatus = eProposalStatus;
//		
//	}
//    [self.RightView addSubview:self.LAController.view];
//    [_LAController processLifeAssured];
//    
//}

-(void)loadSecondLAPage
{
    if (!self.requestSINo) {
        isSecondLaNeeded = NO;
    } else {
        isSecondLaNeeded = [self requestSecondLA:[self.requestSINo description]];
    }
    
//    PremiumKeluargaku *premiK = [[PremiumKeluargaku alloc]initWithNibName:@"PremiumKeluargaku" bundle:nil SINO:@"1160001920160326141955"];
    
//    [self.RightView addSubview:premiK.view];
    
    if ([self select2ndLA]) {
        if (!_SecondLAController) {            
            self.SecondLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
            _SecondLAController.delegate = self;
            self.SecondLAController.requestLAIndexNo = getLAIndexNo;
			self.SecondLAController.EAPPorSI = [self.EAPPorSI description];
            self.SecondLAController.requestCommDate = getCommDate;
            //self.SecondLAController.requestSINo = getSINo;
			self.SecondLAController.requesteProposalStatus = eProposalStatus;
            [self.SecondLAController setQuickQuoteEnabled:quickQuoteEnabled];
            self.SecondLAController.requestSINo = [self.requestSINo description];
            [self.RightView addSubview:self.SecondLAController.view];
            lastActiveController = self.SecondLAController;
        } else {
            //self.SecondLAController.requestSINo = getSINo;
            [self.SecondLAController setQuickQuoteEnabled:quickQuoteEnabled];
            [self.SecondLAController setElementActive:quickQuoteEnabled];
            self.SecondLAController.requestSINo = [self.requestSINo description];
            [self.SecondLAController.view removeFromSuperview];
            [self.RightView addSubview:self.SecondLAController.view];
            [self.RightView bringSubviewToFront:self.SecondLAController.view];
            lastActiveController = self.SecondLAController;
        }
        previousPath = selectedPath;
        blocked = NO;
        //[self.SecondLAController setPoDictionaryPO:dictionaryPOForInsert];
        [self.SecondLAController setPODictionaryFromRoot:dictionaryPOForInsert originalRelation:[dictionaryPOForInsert valueForKey:@"originalRelation"]];
        [self hideSeparatorLine];
        //[myTableView reloadData];
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)loadPayorPage {
    isSecondLaNeeded = NO;
	
	if (!_PayorController) {
		self.PayorController = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
		_PayorController.delegate = self;
		self.PayorController.requestLAIndexNo = getLAIndexNo;
		self.PayorController.EAPPorSI = [self.EAPPorSI description];
		self.PayorController.requestLAAge = getAge;
		self.PayorController.requestCommDate = getCommDate;
		self.PayorController.requestSINo = getSINo;
		self.PayorController.requesteProposalStatus = eProposalStatus;
		[self.RightView addSubview:self.PayorController.view];
	} else {
		self.PayorController.requestLAIndexNo = getLAIndexNo;
		self.PayorController.EAPPorSI = [self.EAPPorSI description];
		self.PayorController.requestLAAge = getAge;
		self.PayorController.requestCommDate = getCommDate;
		self.PayorController.requestSINo = getSINo;
		self.PayorController.requesteProposalStatus = eProposalStatus;
		[self.PayorController loadData];
		[self.RightView bringSubviewToFront:self.PayorController.view];
	}
	previousPath = selectedPath;
	blocked = NO;
	
	[self hideSeparatorLine];
	[myTableView reloadData];
}

-(void)loadBasicPlanPage:(BOOL) loadsView
{
    //if ([self selectBasicPlan]) {
        if (!_BasicController) {
            self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
            _BasicController.delegate = self;
            self.BasicController.requestAge = getAge;
			self.BasicController.EAPPorSI = [self.EAPPorSI description];
            self.BasicController.requestOccpCode = getOccpCode;
            self.BasicController.requestOccpClass = getOccpClass;
            self.BasicController.requestIDPay = getIdPay;
            self.BasicController.requestIDProf = getIdProf;
            
            self.BasicController.requestIndexPay = getPayorIndexNo;
            self.BasicController.requestSmokerPay = getPaySmoker;
            self.BasicController.requestSexPay = getPaySex;
            self.BasicController.requestDOBPay = getPayDOB;
            self.BasicController.requestAgePay = getPayAge;
            self.BasicController.requestOccpPay = getPayOccp;
            
            self.BasicController.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicController.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicController.requestSex2ndLA = get2ndLASex;
            self.BasicController.requestDOB2ndLA = get2ndLADOB;
            self.BasicController.requestAge2ndLA = get2ndLAAge;
            self.BasicController.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicController.requestSINo = getSINo;
            self.BasicController.requesteProposalStatus = eProposalStatus;
            
            self.BasicController.MOP = getMOP;
            self.BasicController.requestEDD = getEDD;
			
            [self.BasicController loadData];
            
            if (!self.requestSINo){
                //[self.BasicController setDictionaryPOForInsert:dictionaryPOForInsert];
                [self.BasicController setPODictionaryFromRoot:dictionaryPOForInsert];
                [self.BasicController setPayorSex:[dictionaryPOForInsert valueForKey:@"PO_Gender"]];
                [self.BasicController setPayorAge:[[dictionaryPOForInsert valueForKey:@"PO_Age"] integerValue]];
                [self.BasicController setPlanType:[dictionaryPOForInsert valueForKey:@"ProductName"]];
                [self.BasicController setLAAge:[[dictionaryPOForInsert valueForKey:@"LA_Age"] integerValue]];
                [self.BasicController setLASex:[dictionaryPOForInsert valueForKey:@"LA_Gender"]];
                [self.BasicController setRelWithLA:[dictionaryPOForInsert valueForKey:@"RelWithLA"]];
                NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
                
                //if([PlanType isEqualToString:@"BCA Life Heritage Protection"])
                if([PlanType isEqualToString:@"BCA Life Keluargaku"])
                {
                    [self.BasicController KeluargakuEnable];
                }
                else
                {
                    [self.BasicController KeluargakuDisable];
                }

            }
            else{
                NSDictionary* dictPO=[_modelSIPOData getPO_DataFor:[self.requestSINo description]];
                //[self.BasicController setDictionaryPOForInsert:dictionaryPOForInsert];
                [self.BasicController setPODictionaryFromRoot:dictionaryPOForInsert];
                [self.BasicController setPayorSex:[dictPO valueForKey:@"PO_Gender"]];
                [self.BasicController setPayorAge:[[dictPO valueForKey:@"PO_Age"] integerValue]];
                [self.BasicController setPlanType:[dictPO valueForKey:@"ProductName"]];
                [self.BasicController setLAAge:[[dictPO valueForKey:@"LA_Age"] integerValue]];
                [self.BasicController setLASex:[dictPO valueForKey:@"LA_Gender"]];
                [self.BasicController setRelWithLA:[dictionaryPOForInsert valueForKey:@"RelWithLA"]];
                NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
                
                //if([PlanType isEqualToString:@"BCA Life Heritage Protection"])
                if([PlanType isEqualToString:@"BCA Life Keluargaku"])
                {
                    [self.BasicController KeluargakuEnable];
                }
                else
                {
                    [self.BasicController KeluargakuDisable];
                }

            }

            self.BasicController.requestSINo = [self.requestSINo description];
            if (loadsView) {
                [self.RightView addSubview:self.BasicController.view];
                lastActiveController = self.BasicController;
            }            
        } else {
            self.BasicController.requestAge = getAge;
			self.BasicController.EAPPorSI = [self.EAPPorSI description];
            self.BasicController.requestOccpCode = getOccpCode;
            self.BasicController.requestOccpClass = getOccpClass;
            self.BasicController.requestIDPay = getIdPay;
            self.BasicController.requestIDProf = getIdProf;
            
            self.BasicController.requestIndexPay = getPayorIndexNo;
            self.BasicController.requestSmokerPay = getPaySmoker;
            self.BasicController.requestSexPay = getPaySex;
            self.BasicController.requestDOBPay = getPayDOB;
            self.BasicController.requestAgePay = getPayAge;
            self.BasicController.requestOccpPay = getPayOccp;
            
            self.BasicController.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicController.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicController.requestSex2ndLA = get2ndLASex;
            self.BasicController.requestDOB2ndLA = get2ndLADOB;
            self.BasicController.requestAge2ndLA = get2ndLAAge;
            self.BasicController.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicController.requestSINo = getSINo;
			self.BasicController.requesteProposalStatus = eProposalStatus;
            self.BasicController.getPolicyTerm = getTerm;
            
            self.BasicController.MOP = getMOP;
            self.BasicController.requestEDD = getEDD;
            
            [self.BasicController KeluargakuDisable];
            
            
            [self.BasicController loadData];

            if (!self.requestSINo){
                //[self.BasicController setDictionaryPOForInsert:dictionaryPOForInsert];
                [self.BasicController setPODictionaryFromRoot:dictionaryPOForInsert];
                [self.BasicController setPayorSex:[dictionaryPOForInsert valueForKey:@"PO_Gender"]];
                [self.BasicController setPayorAge:[[dictionaryPOForInsert valueForKey:@"PO_Age"] integerValue]];
                [self.BasicController setPlanType:[dictionaryPOForInsert valueForKey:@"ProductName"]];
                [self.BasicController setLAAge:[[dictionaryPOForInsert valueForKey:@"LA_Age"] integerValue]];
                [self.BasicController setLASex:[dictionaryPOForInsert valueForKey:@"LA_Gender"]];
                [self.BasicController setRelWithLA:[dictionaryPOForInsert valueForKey:@"RelWithLA"]];
                
                NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
                
                //if([PlanType isEqualToString:@"BCA Life Heritage Protection"])
                if([PlanType isEqualToString:@"BCA Life Keluargaku"])
                {
                    [self.BasicController KeluargakuEnable];
                }
                else
                {
                    [self.BasicController KeluargakuDisable];
                }

            }
            else{
                NSDictionary* dictPO=[_modelSIPOData getPO_DataFor:[self.requestSINo description]];
                //[self.BasicController setDictionaryPOForInsert:dictionaryPOForInsert];
                [self.BasicController setPODictionaryFromRoot:dictionaryPOForInsert];
                [self.BasicController setPayorSex:[dictPO valueForKey:@"PO_Gender"]];
                [self.BasicController setPayorAge:[[dictPO valueForKey:@"PO_Age"] integerValue]];
                [self.BasicController setPlanType:[dictPO valueForKey:@"ProductName"]];
                [self.BasicController setLAAge:[[dictPO valueForKey:@"LA_Age"] integerValue]];
                [self.BasicController setLASex:[dictPO valueForKey:@"LA_Gender"]];
                [self.BasicController setRelWithLA:[dictPO valueForKey:@"RelWithLA"]];
                NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
                
                //if([PlanType isEqualToString:@"BCA Life Heritage Protection"])
                if([PlanType isEqualToString:@"BCA Life Keluargaku"])
                {
                    [self.BasicController KeluargakuEnable];
                }
                else
                {
                    [self.BasicController KeluargakuDisable];
                }

            }
            self.BasicController.requestSINo = [self.requestSINo description];
            if (loadsView) {
                [self.BasicController.view removeFromSuperview];
                [self.RightView addSubview:self.BasicController.view];
                [self.RightView bringSubviewToFront:self.BasicController.view];
                lastActiveController = self.BasicController;
            }
        }
        previousPath = selectedPath;
        blocked = NO;
        [self hideSeparatorLine];
        //[myTableView reloadData];
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    //}
}

-(void)LoadIlustrationPage
{
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:[dictionaryPOForInsert valueForKey:@"SINO"]];
    NSLog(@" Edit Mode %@ : %@", EditMode, [dictionaryPOForInsert valueForKey:@"SINO"]);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] == NSOrderedSame){
    
        if (_salesIlustrationViewController == nil) {
            _salesIlustrationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SalesIlustration"];
            //_LAController.delegate = self;
            [_salesIlustrationViewController setDictionaryPOForInsert:dictionaryPOForInsert];
            [_salesIlustrationViewController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
        }
        [_salesIlustrationViewController setDictionaryPOForInsert:dictionaryPOForInsert];
        [_salesIlustrationViewController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_salesIlustrationViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Simpan terlebih dahulu ilustrasi." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
}


-(void)loadHLPage
{
    if (getAge < 10 && payorSINo.length == 0) {        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    } else {
        if (getSINo) {            
            if (!_HLController) {
                self.HLController = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthLoadView"];
                _HLController.delegate = self;
                self.HLController.ageClient = getAge;
                self.HLController.EAPPorSI = [self.EAPPorSI description];
                self.HLController.SINo = getSINo;
                self.HLController.planChoose = getBasicPlan;
                self.HLController.getMOP = getMOP;
                self.HLController.requesteProposalStatus = eProposalStatus;
                
                [self.RightView addSubview:self.HLController.view];
                
            } else {
                self.HLController.ageClient = getAge;
                self.HLController.EAPPorSI = [self.EAPPorSI description];
                self.HLController.SINo = getSINo;
                self.HLController.planChoose = getBasicPlan;
                self.HLController.getMOP = getMOP;
                self.HLController.requesteProposalStatus = eProposalStatus;
                
                [self.HLController loadHL];
                [self.RightView bringSubviewToFront:self.HLController.view];
                
            }
            previousPath = selectedPath;
            blocked = NO;
            [self hideSeparatorLine];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please Press On Done Button First"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
	}
}

-(BOOL)requestSecondLA:(NSString*)SINo
{
    NSString* custCodeForSecondLa;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT a.SINo, a.CustCode FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo='%@' AND a.PTypeCode='LA' AND a.Sequence=2",SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                custCodeForSecondLa = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
	
    return custCodeForSecondLa?YES:NO;
    
}

-(void)LoadViewController
{
    if (_LAController == nil) {
        self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        _LAController.delegate = self;
        self.LAController.requestSINo = [self.requestSINo description];
        self.LAController.requesteProposalStatus = eProposalStatus;
        self.LAController.EAPPorSI = [self.EAPPorSI description];
        [self.RightView addSubview:self.LAController.view];
    }else{
        self.LAController.requestSINo = [self.requestSINo description];
        self.LAController.requesteProposalStatus = eProposalStatus;
        self.LAController.EAPPorSI = [self.EAPPorSI description];
        [self.LAController.view removeFromSuperview];
        [self.RightView addSubview:self.LAController.view];
    }
    lastActiveController = self.LAController;
    [_LAController processLifeAssured];
    blocked = NO;
    selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    previousPath = [NSIndexPath indexPathForRow:0 inSection:0];

    if (getAge<= 16) {
        [self loadPayorPage];
    } else {
        [self loadSecondLAPage];
    }
    [self loadBasicPlanPage:YES];
    [self loadSecondLAPage];


    [self.RightView bringSubviewToFront:self.LAController.view];
    [_LAController processLifeAssured];
    [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)checkNeedPromptMsg
{
	appDel.isNeedPromptSaveMsg = !isNewSI;	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)clearSINO{
    self.requestSINo = nil;
    self.requestSINo2 = nil;
}

-(void)Reset
{
    if ([self.requestSINo isEqualToString:self.requestSINo2] || (self.requestSINo == NULL && self.requestSINo2 == NULL) ) {        
        PlanEmpty = YES;
        added = NO;
        arrayIntValidate = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];
		ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Pemegang Polis", @"Tertanggung", @"Ansurasi Dasar \n Asuransi Tambahan \n Premi", @"Ilustrasi ",@"Produk Brosur",@"Simpan sebagai Baru", nil];
//		ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", nil];
        
        [self RemovePDS];
        [self clearDataLA];
        [self clearDataPayor];
        [self clearData2ndLA];
        [self clearDataBasic];
        [self hideSeparatorLine];
        eProposalStatus = @"";
        [self.myTableView reloadData];
        
       // _RiderController = nil;
        
        if (_LAController == nil) {
            self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
            _LAController.delegate = self;
        }
		
        [self.RightView addSubview:self.LAController.view];
        [_LAController processLifeAssured];
        blocked = NO;
        selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
        previousPath = selectedPath;
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
				
		appDel.MhiMessage = Nil;
    } else {
        requestSINo2 = self.requestSINo;
    }
}

-(void)toogleView
{
    if (PlanEmpty && added) {
        [ListOfSubMenu removeObject:@"Health Loading"];
        [ListOfSubMenu removeObject:@"Rider"];
        [ListOfSubMenu removeObject:@"Premium"];
        
    } else if (!PlanEmpty && !added) {		
        [ListOfSubMenu addObject:@"Health Loading"];
        [ListOfSubMenu addObject:@"Rider"];
        [ListOfSubMenu addObject:@"Premium"];
        [self addRemainingSubmenu];
        
        added = YES;
        
    }
    
    [self CalculateRider];
    [self hideSeparatorLine];
    [self.myTableView reloadData];
}

- (void) addRemainingSubmenu
{
	if (![[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
		[ListOfSubMenu addObject:@"Quotation"];
		[ListOfSubMenu addObject:@"Summary Quotation"];
		[ListOfSubMenu addObject:@"Product Disclosure Sheet"];
        [ListOfSubMenu addObject:@"Underwriting Sum Assured"];
		[ListOfSubMenu addObject:@"Save As New"];
	}    
}

-(void)hideSeparatorLine
{
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - temporary function added by faiz
//added by faiz

-(void)pullSIData{
    dictionaryPOForInsert = [[NSMutableDictionary alloc]initWithDictionary:[_LAController setDictionaryLA]];
    dictionaryMasterForInsert = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dictionaryPOForInsert valueForKey:@"SINO"],@"SINO",@"1.1",@"SI_Version",@"Not Created",@"ProposalStatus", nil];
    
    if (!_SecondLAController) {
        if (![dictionaryPOForInsert objectForKey:@"LA_ClientID"]){
            @try {
                NSDictionary* dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:[self.requestSINo description]]];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_ClientID"] forKey:@"LA_ClientID"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_Name"] forKey:@"LA_Name"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_DOB"] forKey:@"LA_DOB"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_Age"] forKey:@"LA_Age"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_Gender"] forKey:@"LA_Gender"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_OccpCode"] forKey:@"LA_OccpCode"];
                [dictionaryPOForInsert setObject:[dictPOData valueForKey:@"LA_Occp"] forKey:@"LA_Occp"];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
    else{
        @try {
            if ((![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])&&(![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])){
                [dictionaryPOForInsert addEntriesFromDictionary:[_SecondLAController setDictionarySecondLA]];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
    if (!_BasicController) {
        newDictionaryForBasicPlan=[NSMutableDictionary dictionaryWithDictionary:[_modelSIPremium getPremium_For:[self.requestSINo description]]];
        [newDictionaryForBasicPlan addEntriesFromDictionary:dictionaryPOForInsert];
    }
    else{
        @try {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_BasicController calculateValue];
                // Some long running task you want on another thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    newDictionaryForBasicPlan=[NSMutableDictionary dictionaryWithDictionary:[_BasicController setDataBasicPlan]];
                    [newDictionaryForBasicPlan addEntriesFromDictionary:dictionaryPOForInsert];
                });
            });
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    @try {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[newDictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"ProductCode"] forKey:@"ProductCode"];
        if(myNumber != nil)
            [newDictionaryForBasicPlan setObject:myNumber forKey:@"Number_Sum_Assured"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"PO_Gender"] forKey:@"PO_Gender"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"PO_Age"] forKey:@"PO_Age"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"LA_Gender"] forKey:@"LA_Gender"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"LA_Age"] forKey:@"LA_Age"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"SINO"] forKey:@"SINO"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"IsInternalStaff"] forKey:@"IsInternalStaff"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)brngSubview:(NSString *)view{
    if ([view isEqualToString:@"Rider"]){
        [RightView bringSubviewToFront:_RiderController.view];
    }
    else{
        if (!_PremiumController) {
            _PremiumController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            _PremiumController.delegate = self;
            _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
            [self.RightView addSubview:_PremiumController.view];
        }
        [_PremiumController setPremiumDictionary:newDictionaryForBasicPlan];
        [_PremiumController.view removeFromSuperview];
        [self.RightView addSubview:_PremiumController.view];
        _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
        [self.RightView bringSubviewToFront:_PremiumController.view];
    }
}

#pragma mark - action

-(BOOL)select2ndLA
{
//    if ([EAPPorSI isEqualToString:@"eAPP"]) {
//        return YES;
//    }
//    
//    if (getAge >= 18 && getAge <=70 && ![getOccpCode isEqualToString:@"(null)"]) {
//        return YES;
//    } else if (getAge < 16 && getOccpCode.length != 0 && ![getOccpCode isEqualToString:@"(null)"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Life Assured is less than 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        blocked = YES;
//        return NO;
//    } else if ( (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"]) 
//             && ![LAotherIDType isEqualToString:@"EDD"]) { // skip checking if equal to EDD
//        blocked = YES;
//        return NO;
//    } else if (!isFirstLoad) {
//        [self checkingPayor];
//        if (payorSINo.length != 0 || getPayorIndexNo != 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Not allowed as Payor has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            blocked = YES;
//            return NO;
//        }        
//    }
    return YES;
}

-(BOOL)selectPayor
{
    if ([EAPPorSI isEqualToString:@"eAPP"]) {
        return YES;
    }
    
    if (getAge >= 18 && ![getOccpCode isEqualToString:@"(null)"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Life Assured's age must not greater or equal to 18 years old."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        blocked = YES;
        return NO;
    } else if (getAge < 18  && getOccpCode.length != 0 && ([getSINo isEqualToString:@"(null)"] || getSINo.length == 0)) {
        return YES;
    } else if ( (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"])
                && ![LAotherIDType isEqualToString:@"EDD"]) {
        blocked = YES;
        return NO;
    } else if (!isFirstLoad) {
        [self checking2ndLA];
        if (CustCode2.length != 0 || get2ndLAIndexNo != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Not allowed as 2nd LA has been attached"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            blocked = YES;
            return NO;
        }
    }
    return YES;
}

-(BOOL)selectBasicPlan
{
    if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
        [self checkingPayor];
        if (getBasicPlan != NULL && getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
            return NO;
        } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge>65 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
            return NO;
        }
        
    } else if (getBasicPlan != NULL && getOccpCode != 0 && getSINo.length == 0) {        
        if (getAge < 10 && getPayDOB.length == 0) { //edited by heng to solve duplicate record in Trad_Payor
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
            return NO;            
        }		
    }    
    return YES;
}

-(void)calculatedPrem
{
    if (getSINo.length != 0 && getAge <= 70) {        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        } else {
            [self buildSpinner];
			[self RemovePDS];
            [ListOfSubMenu addObject:@"Health Loading"];
            [ListOfSubMenu addObject:@"Rider"];
            [ListOfSubMenu addObject:@"Premium"];
            [self addRemainingSubmenu];
            
            PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
			
            premView.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.executeMHI = @"YES";
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = FALSE;
            [premView calculateReport];
            _delegate = premView;
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
				if ([RiderCount intValue ] > 10) {
					sleep(5);
				} else {
					sleep(1);
				}
								
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.RightView addSubview:premView.view];
					previousPath = selectedPath;
					blocked = NO;
					[self hideSeparatorLine];
                    
                    appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                    if ([appDel.MhiMessage doubleValue] >0) {
                        _BasicController.yearlyIncomeField.text = appDel.MhiMessage;
                    }
                    
					[spinner_SI stopAnimating ];
					[self.view setUserInteractionEnabled:YES];
					[_FS Reset];
					UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
					[v removeFromSuperview];
					v = Nil;
					spinner_SI = nil;
				});
			});
        }
    } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"No record selected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 5000){
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"ok");
                NSString *oldSiNo = [dictionaryPOForInsert valueForKey:@"SINO"];
                NSString *newSiNo = [self generateSINO];
                NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
                if([PlanType isEqualToString:@"BCA Life Heritage Protection"]){
                    
                    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
                    [loginDB duplicateRow:@"SI_Master" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                    [loginDB duplicateRow:@"SI_Premium" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                    [loginDB duplicateRow:@"SI_PO_Data" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                }else{
                    NSString *oldSiNo = [dictionaryPOForInsert valueForKey:@"SINO"];
                    NSString *newSiNo = [self generateSINO];
                    
                    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
                    [loginDB duplicateRow:@"SI_Master" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                    [loginDB duplicateRow:@"SI_Premium" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                    [loginDB duplicateRow:@"SI_PO_Data" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                    [loginDB duplicateRow:@"SI_Temp_Trad_Raider" param:@"SINO" oldValue:oldSiNo newValue:newSiNo];
                }
                
                //update SI created date for newSiNo
                [_modelSIPOData updatePODataDate:newSiNo Date:[formatter getDateToday:@"dd/MM/yyyy"]];
                [_modelSIMaster updateIlustrationMasterDate:newSiNo];
                [_modelSIPremium updatePremiumDate:newSiNo];
                
                getSINo = newSiNo;
                self.requestSINo = getSINo;
                outletSaveAs.hidden = YES;
                [dictionaryPOForInsert setValue:getSINo forKey:@"SINO"];
                [_LAController updateSINO:getSINo];
                [self LoadViewController];
                [_LAController loadDataAfterSaveAs:newSiNo];
                arrayIntValidate = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];                
            }
                break;
            case 1:
            {
                // Do something for button #2
                NSLog(@"cancel");
            }
                break;
        }

    }else if (alertView.tag == 1001 && buttonIndex == 0) {
        saved = YES;
        _SecondLAController = nil;
        
        [self selectBasicPlan];
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 1001 && buttonIndex == 1) {
        saved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 2001 && buttonIndex == 0) {
        payorSaved = YES;
        _PayorController = nil;
        
        [self RemovePDS];
        [self selectBasicPlan];
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 2001 && buttonIndex == 1) {
        payorSaved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 1002 && buttonIndex == 0) {
        saved = YES;       
        
        [self RemovePDS];
        
        self.RiderController.requestAge = getAge;
        self.RiderController.requestSex = getSex;
        self.RiderController.requestOccpCode = getOccpCode;
        self.RiderController.requestOccpClass = getOccpClass;
        
        self.RiderController.requestSINo = getSINo;
        self.RiderController.requestPlanCode = getPlanCode;
        self.RiderController.requestCoverTerm = getTerm;
        self.RiderController.requestBasicSA = getbasicSA;
        self.RiderController.requestBasicHL = getbasicHL;
        self.RiderController.requestBasicTempHL = getbasicTempHL;
        self.RiderController.requestMOP = getMOP;
        self.RiderController.requestAdvance = getAdvance;
		self.RiderController.EAPPorSI = [self.EAPPorSI description];
        
        [self.RightView addSubview:self.RiderController.view];
        [_RiderController processRiders];
        
        previousPath = selectedPath;
        blocked = NO;
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 1002 && buttonIndex == 1) {
        saved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 2002 && buttonIndex == 0) {
        payorSaved = YES;        
        
        [self RemovePDS];
        
        self.RiderController.requestAge = getAge;
        self.RiderController.requestSex = getSex;
        self.RiderController.requestOccpCode = getOccpCode;
        self.RiderController.requestOccpClass = getOccpClass;
        
        self.RiderController.requestSINo = getSINo;
        self.RiderController.requestPlanCode = getPlanCode;
        self.RiderController.requestCoverTerm = getTerm;
        self.RiderController.requestBasicSA = getbasicSA;
        self.RiderController.requestBasicHL = getbasicHL;
        self.RiderController.requestBasicTempHL = getbasicTempHL;
        self.RiderController.requestMOP = getMOP;
        self.RiderController.requestAdvance = getAdvance;
		self.RiderController.EAPPorSI = [self.EAPPorSI description];
        
        [self addChildViewController:self.RiderController];
        [_RiderController processRiders];
        
        previousPath = selectedPath;
        blocked = NO;
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 2002 && buttonIndex == 1) {
        payorSaved = NO;
        blocked = YES;
        [myTableView reloadData];
        
        if (blocked) {
            [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else if (alertView.tag == 3001 && buttonIndex == 0) {        
        if ([getBasicPlan isEqualToString:STR_HLAWP] && [self DisplayMsgGIRR] == TRUE) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"Please note that the Guaranteed Benefit payout for selected plan will be lesser than total premium outlay. You may increase the Basic Desired Annual Premium to increase the Guaranteed Benefit payout.\nChoose OK to proceed.\nChoose CANCEL to increase Basic Desired Annual Premium."]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            
            CurrentPath = 0;
            alert.tag = 7001;
            [alert show];
        } else {
            if ([self validateSaveAll]) {
                if ([eProposalStatus isEqualToString:@"confirmed"] || [eProposalStatus isEqualToString:@"Confirmed"] || [isPOSign isEqualToString:@"Yes"]) {
                    eAppCheckList *PdfDelete =[[eAppCheckList alloc]init];
                    [PdfDelete deleteEAppCase:getSINo];
                }
                appDel.isNeedPromptSaveMsg = NO;
            }
        }
    } else if (alertView.tag == 3001 && buttonIndex == 1) {
        if (!appDel.isSIExist) {
            [self Reset];
        }
    } else if (alertView.tag == 2000001 && buttonIndex == 0) {
        NSString  *msg = [self SaveAsTemp]?@"New SI No Successful Created":@"SI Save As Fail";        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (alertView.tag == 7001) {
        if (buttonIndex == 1) {
            [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_BASIC_PLAN inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            self.BasicController.requestAge = getAge;
			self.BasicController.EAPPorSI = [self.EAPPorSI description];
            self.BasicController.requestOccpCode = getOccpCode;
            self.BasicController.requestOccpClass = getOccpClass;
            self.BasicController.requestIDPay = getIdPay;
            self.BasicController.requestIDProf = getIdProf;
            
            self.BasicController.requestIndexPay = getPayorIndexNo;
            self.BasicController.requestSmokerPay = getPaySmoker;
            self.BasicController.requestSexPay = getPaySex;
            self.BasicController.requestDOBPay = getPayDOB;
            self.BasicController.requestAgePay = getPayAge;
            self.BasicController.requestOccpPay = getPayOccp;
            
            self.BasicController.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicController.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicController.requestSex2ndLA = get2ndLASex;
            self.BasicController.requestDOB2ndLA = get2ndLADOB;
            self.BasicController.requestAge2ndLA = get2ndLAAge;
            self.BasicController.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicController.requestSINo = getSINo;
			self.BasicController.requesteProposalStatus = eProposalStatus;
            self.BasicController.getPolicyTerm = getTerm;
            
            self.BasicController.MOP = getMOP;
            self.BasicController.requestEDD = getEDD;
            
            [self.BasicController loadData];
            
            [self.BasicController.view removeFromSuperview];
            [self.RightView addSubview:self.BasicController.view];
            [self.RightView bringSubviewToFront:self.BasicController.view];
        } else {
            if (CurrentPath == SIMENU_QUOTATION) {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    [self showQuotation];
                }
            } else if (CurrentPath == SIMENU_SUMMARY_QUOTATION) {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    [self showSummaryQuotation];
                }
            } else if (CurrentPath == SIMENU_PRODUCT_DISCLOSURE_SHEET) {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    [self getSelectedLanguage];
                    [self showPDS];
                }
            } else if (CurrentPath == SIMENU_UNDERWRITING) {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    [self showUnderwriting];
                }
            } else if (CurrentPath == SIMENU_PDS_SAVE_AS) {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    appDel.isNeedPromptSaveMsg = NO;
                    
                    NSString* msg = [NSString stringWithFormat:@"Create a new SI from %@ (%@)?", getSINo, NameLA];                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                    alert.tag = 2000001;
                    [alert show];
                }
            } else if (CurrentPath == 0) { //from done button
                if ([self validateSaveAll]) {
                    appDel.isNeedPromptSaveMsg = NO;
                } else {
                    [self CheckPremAndMHI];
                }
            }            
        }
    } else if (alertView.tag == 601) { // this one is for created status with PO signed
        if (buttonIndex == 0) { //means delete the eAPP record
            eAppCheckList*deleteOldPDF=[[eAppCheckList alloc] init];
            [deleteOldPDF deleteEAppCase:self.requestSINo];
            deleteOldPDF = Nil;
            
            MasterMenuEApp *rrr = [[MasterMenuEApp alloc] init];
            [rrr deleteEAppCase:self.requestSINo];
            rrr = Nil;
            
            eProposalStatus = @"Created_Edit";
            [self SetInitialStatusToFalse];
            
        } else {
            eProposalStatus = @"Created_View";
        }

        //remove the initial VC
//        [self.LAController.view removeFromSuperview];
//        _LAController = nil;
        
        [self LoadViewController];

    } else if (alertView.tag == 8001) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Record saved." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }    
}

-(BOOL)validateSaveAllWithoutPrompt
{
    if (![self savePage:selectedPath.row]) { //to do section save for the current tab user visited
		[self UpdateSIToInvalid];
        return NO;
    }
	
    if (![self.LAController validateSave] && self.LAController) {
		[self UpdateSIToInvalid];
        return NO;
    }
	
    if (isSecondLaNeeded && self.SecondLAController) {        
        if (![self.SecondLAController validateSave]) {
			[self UpdateSIToInvalid];
            return NO;			
        }
    }
    
    if (getAge < 10 && payorSINo.length == 0) {
        if ([self.PayorController isPayorSelected]) {
            if (![self.PayorController validateSave]) {
				[self UpdateSIToInvalid];
                return NO;
            }
        } else {
			[self UpdateSIToInvalid];			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            return NO;
        }
    }
    
    if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
        [self UpdateSIToInvalid];
        return NO;
    }
    	
    [self loadBasicPlanPage:NO];
    [self.BasicController loadData];
    NSString *firstSex = getSex;
    if ([firstSex isEqualToString:@"MALE"]) {
        firstSex = @"M";
    } else if ([firstSex isEqualToString:@"FEMALE"]) {
        firstSex = @"F";
    }
        
    if ([self.BasicController validateSave] != 0 && self.BasicController) {
		[self UpdateSIToInvalid];
        return NO;		
    }
    
    if (![self.HLController validateSave] &&self.HLController) {
		[self UpdateSIToInvalid];
        return NO;		
    }
    
    if (([getBasicPlan isEqualToString:STR_S100]) && [self ValidateRiderL100] == FALSE) {
        [self UpdateSIToInvalid];
        return NO;
    }
    
    if (![self.LAController updateData:getSINo] && self.LAController) {
		[self UpdateSIToInvalid];
        return NO;		
    }
    
    if (isSecondLaNeeded) {		
        if (![self.SecondLAController performUpdateData] && self.SecondLAController) {
			[self UpdateSIToInvalid];
            return NO;
        }		
    }
    	
    [self.BasicController checkingExisting]; //added by Edwin 4-10-2013, to get the useExist boolean, else the it will choose to save again instead of update.
    if (![self.BasicController checkingSave:getSex] && self.BasicController) {
		[self UpdateSIToInvalid];
        return NO;
    } else {
        [self storeLAValues]; //added by Edwin 8-10-2013; to store the LA data after save for revert
    }
    
    if (![self.HLController updateHL] && self.HLController) {
		[self UpdateSIToInvalid];
        return NO;		
    }
    
    self.RiderController.requestAge = getAge;
    self.RiderController.requestSex = getSex;
    self.RiderController.requestOccpCode = getOccpCode;
    self.RiderController.requestOccpClass = getOccpClass;
    
    self.RiderController.requestSINo = getSINo;
    self.RiderController.requestPlanCode = getPlanCode;
    self.RiderController.requestPlanChoose = getBasicPlan;
    self.RiderController.requestCoverTerm = getTerm;
    self.RiderController.requestBasicSA = getbasicSA;
    self.RiderController.requestBasicHL = getbasicHL;
    self.RiderController.requestBasicTempHL = getbasicTempHL;
    self.RiderController.requestMOP = getMOP;
    self.RiderController.requestAdvance = getAdvance;
    self.RiderController.requesteEDD = getEDD;
    
    self.RiderController.EAPPorSI = [self.EAPPorSI description];
    [_RiderController processRiders];
    
    if (![self.RiderController RoomBoard]) {
        [self UpdateSIToInvalid];
        return NO;
    }
    
    PremiumViewController *premView = [[PremiumViewController alloc] init ];
    premView.requestAge = getAge;
    premView.requestOccpClass = getOccpClass;
    premView.requestOccpCode = getOccpCode;
    premView.requestSINo = getSINo;
    premView.requestMOP = getMOP;
    premView.requestTerm = getTerm;
    premView.requestBasicSA = getbasicSA;
    premView.requestBasicHL = getbasicHL;
    premView.requestBasicTempHL = getbasicTempHL;
    premView.requestPlanCode = getPlanCode;
    premView.requestBasicPlan = getBasicPlan;
    premView.sex = getSex;
    premView.EAPPorSI = [self.EAPPorSI description];
    premView.executeMHI = @"YES";
    premView.fromReport = TRUE; // TRUE because to avoid showing "min modal ..." temporarily for now, cant solve the problem
    [premView calculateReport];
    _delegate = premView;
    premView = Nil;
     
    if ([appDel.MhiMessage doubleValue] >0) {
        _BasicController.yearlyIncomeField.text = appDel.MhiMessage;
        UIAlertView *alert;
        
        if ([getBasicPlan isEqualToString:STR_HLAWP]) {
            alert = [[UIAlertView alloc] initWithTitle:@" "
                                               message:[NSString stringWithFormat:@"Basic Desired Annual Premium will be increased to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.", appDel.MhiMessage]
                                              delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@" "
                                               message:[NSString stringWithFormat:@"Basic Sum Assured will be increased to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.", appDel.MhiMessage]
                                              delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        }
        
        [alert show];        
        getbasicSA = appDel.MhiMessage;
        appDel.MhiMessage = Nil;
        return NO;
    }
    
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        [self wpGYIRiderExist:FALSE];
        if ([self CalcTPDbenefit] > 3500000) {
            [self UpdateSIToInvalid];            
            return NO;
        }        
    }
    
    if ([getBasicPlan isEqualToString:STR_HLAWP] || [getBasicPlan isEqualToString:STR_S100]) {
        if ([self calculateCIBenefit] > 4000000) {
            [self UpdateSIToInvalid];            
            return NO;
        }		
    }    
    
    if ([getBasicPlan isEqualToString:STR_HLAWP] && getEDD == TRUE ) {
        double totalPrem = [self returnTotalHLAWPPrem];
        if (totalPrem > 15000) {
            [self UpdateSIToInvalid];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"The Maximum allowable total annual premium (inclusive of Wealth Booster, Wealth Booster-m6, Wealth Booster-i6, Wealth Booster-d10 and EduWealth Riders) for an unborn Child allowable is RM15,000."]
                                                           delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }     	
    }
    
    [self UpdateSIToValid:FALSE];
    
    return YES;
}

-(BOOL)validateSaveAll
{
    if (![self savePage:selectedPath.row]) { //to do section save for the current tab user visited
		[self UpdateSIToInvalid];
        return NO;
    }
	
    if (![self.LAController validateSave] && self.LAController) {
		[self UpdateSIToInvalid];
        return NO;
    }
	
    if (isSecondLaNeeded && self.SecondLAController) {        
        if (![self.SecondLAController validateSave]) {
			[self UpdateSIToInvalid];
            return NO;			
        }
    }
    
    if (getAge < 10 && payorSINo.length == 0) {
        if ([self.PayorController isPayorSelected]) {
            if (![self.PayorController validateSave]) {
				[self UpdateSIToInvalid];
                return NO;
            }
        } else {
			[self UpdateSIToInvalid];
			
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
//                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//            [alert show];
//            
//            return NO;
        }
    }
    
    if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
		[self UpdateSIToInvalid];
        return NO;
    }
	
    [self loadBasicPlanPage:NO];
    [self.BasicController loadData];
    
    NSString *secondSex = [self.BasicController requestSex2ndLA];
    NSString *firstSex = getSex;
    if ([firstSex isEqualToString:@"MALE"]) {
        firstSex = @"M";
    } else if ([firstSex isEqualToString:@"FEMALE"]) {
        firstSex = @"F";
    }
    
    if (([getBasicPlan isEqualToString:STR_S100]) && [secondSex isEqualToString:firstSex]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Both First Life Assured and 2nd Life Assured cannot have the same sex."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [self UpdateSIToInvalid];
        return NO;
    }
    
    if ([self.BasicController validateSave] && self.BasicController) {
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_BASIC_PLAN inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if (!_BasicController) {
//            [self addChildViewController:self.BasicController];
            [self.RightView addSubview:self.BasicController.view];
        } else {
            [self.BasicController.view removeFromSuperview];
            [self.RightView addSubview:self.BasicController.view];
            [self.RightView bringSubviewToFront:self.BasicController.view];
        }
        
		[self UpdateSIToInvalid];
        return NO;		
    }
    
    [self.HLController loadHL];
    if (![self.HLController validateSave] && self.HLController) {
		[self UpdateSIToInvalid];
        return NO;
		
    }
    
    if (![self.LAController updateData:getSINo] && self.LAController) {
		[self UpdateSIToInvalid];
        return NO;
		
    }
    
    if (isSecondLaNeeded) {
        if (self.SecondLAController && ![self.SecondLAController performUpdateData]) {
			[self UpdateSIToInvalid];
            return NO;
        }
    }   
	
    [self.BasicController checkingExisting]; //added by Edwin 4-10-2013, to get the useExist boolean, else the it will choose to save again instead of update.
    if (![self.BasicController checkingSave:getSex] && self.BasicController) {
		[self UpdateSIToInvalid];
        return NO;
    } else {
        [self storeLAValues]; //added by Edwin 8-10-2013; to store the LA data after save for revert
    }
    
    if (![self.HLController updateHL] && self.HLController) {
		[self UpdateSIToInvalid];
        return NO;
    }
    
    self.RiderController.requestAge = getAge;
    self.RiderController.requestSex = getSex;
    self.RiderController.requestOccpCode = getOccpCode;
    self.RiderController.requestOccpClass = getOccpClass;
    
    self.RiderController.requestSINo = getSINo;
    self.RiderController.requestPlanCode = getPlanCode;
    self.RiderController.requestPlanChoose = getBasicPlan;
    self.RiderController.requestCoverTerm = getTerm;
    self.RiderController.requestBasicSA = getbasicSA;
    self.RiderController.requestBasicHL = getbasicHL;
    self.RiderController.requestBasicTempHL = getbasicTempHL;
    self.RiderController.requestMOP = getMOP;
    self.RiderController.requestAdvance = getAdvance;
    self.RiderController.requesteEDD = getEDD;
    
    self.RiderController.EAPPorSI = [self.EAPPorSI description];
    
    [_RiderController processRiders];
    
    if (![self.RiderController RoomBoard]) {
        [self UpdateSIToInvalid];
        return NO;
    }
    if (![self CheckPremAndMHI]) {
        [self UpdateSIToInvalid];
        return NO;
    }
    
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        if ([self CalcTPDbenefit] > 3500000) {
            [self UpdateSIToInvalid];
            return NO;
        } else if (getEDD == TRUE ) {
            double totalPrem = [self returnTotalHLAWPPrem];
            if (totalPrem > 15000) {
                [self UpdateSIToInvalid];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:[NSString stringWithFormat:@"The Maximum allowable total annual premium (inclusive of Wealth Booster, Wealth Booster-m6, Wealth Booster-i6, Wealth Booster-d10 and EduWealth Riders) for an unborn Child allowable is RM15,000."]
                                                               delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    } else if ([getBasicPlan isEqualToString:STR_S100]) {
        if ([self ValidateRiderL100] == FALSE) {
            [self UpdateSIToInvalid];
            return NO;
        } else if ([self calculateCIBenefit] > 4000000) {
            [self UpdateSIToInvalid];
            return NO;
        }
    }

    if ([eProposalStatus isEqualToString:@"Created"] && ![isPOSign isEqualToString:@"YES"]) {
        eAppCheckList *PdfDelete =[[eAppCheckList alloc]init];
        [PdfDelete deleteEAppCase:getSINo];
        PdfDelete = Nil;
        
    }

    [self UpdateSIToValid:FALSE];

    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        [self wpGYIRiderExist:TRUE];
    } else if ([getBasicPlan isEqualToString:STR_S100]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Record saved." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
    }
    
    return YES;
}

-(BOOL)CheckPremAndMHI{
    PremiumViewController *premView = [[PremiumViewController alloc] init ];
    premView.requestAge = getAge;
    premView.requestOccpClass = getOccpClass;
    premView.requestOccpCode = getOccpCode;
    premView.requestSINo = getSINo;
    premView.requestMOP = getMOP;
    premView.requestTerm = getTerm;
    premView.requestBasicSA = getbasicSA;
    premView.requestBasicHL = getbasicHL;
    premView.requestBasicTempHL = getbasicTempHL;
    premView.requestPlanCode = getPlanCode; // this one is not working
    premView.requestBasicPlan = getBasicPlan; //pass in plancode
    premView.sex = getSex;
    premView.EAPPorSI = [self.EAPPorSI description];
    premView.fromReport = TRUE; // TRUE because to avoid showing "min modal ..." temporarily for now, cant solve the problem
    premView.executeMHI = @"YES";
    [premView calculateReport];
    _delegate = premView;
    premView = Nil;
    
    if ([appDel.MhiMessage doubleValue]>0) {
        _BasicController.yearlyIncomeField.text = appDel.MhiMessage;
        
        UIAlertView *alert;
        
        if ([getBasicPlan isEqualToString:STR_HLAWP]) {
            alert = [[UIAlertView alloc] initWithTitle:@" "
                                               message:[NSString stringWithFormat:@"Basic Desired Annual Premium will be increased to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.", appDel.MhiMessage]
                                              delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        } else {
            alert = [[UIAlertView alloc] initWithTitle:@" "
                                               message:[NSString stringWithFormat:@"Basic Sum Assured will be increased to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.", appDel.MhiMessage]
                                              delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        }
        [alert show];
        
        getbasicSA = appDel.MhiMessage;
        [_RiderController loadRiderData];
        appDel.MhiMessage = Nil;
        
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)returnTotalPremVSBenefit{ //for HLAWP only
    sqlite3_stmt *statement;
    double tempBasicPrem = 0.00;
    double tempBasicBenefit = 0.00;
    double tempTotalRiderPrem = 0.00;
    double tempTotalRiderBenefit = 0.00;
    BOOL temp = FALSE;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *SelectSQL = [NSString stringWithFormat:@"select basicSA, PremiumPaymentTerm,  policyTerm from trad_details where sino = '%@' ", getSINo];        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempBasicBenefit = sqlite3_column_double(statement, 0) * sqlite3_column_double(statement, 1 ) * (sqlite3_column_double(statement, 2) == 30 ? 1.5 : 2.5);
            }
            sqlite3_finalize(statement);
        }
        
        SelectSQL = [NSString stringWithFormat: @"select replace(Annually, ',', '') from si_store_premium where sino = '%@' AND Type in ('B') ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempBasicPrem = sqlite3_column_double(statement, 0);
            }            
            sqlite3_finalize(statement);
        }

        SelectSQL = [NSString stringWithFormat:@"select sumAssured, ridercode from trad_Rider_details where sino = '%@' ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempTotalRiderBenefit = tempTotalRiderBenefit + sqlite3_column_double(statement, 0) * [self RiderBenefitFactor:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
            }
            sqlite3_finalize(statement);
        }
        
        SelectSQL = [NSString stringWithFormat:@"select sum(replace(Annually, ',', '')) from si_store_premium where sino = '%@' AND Type in ('EDUWR','WB30R','WB50R','WBI6R30','WBD10R30') ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempTotalRiderPrem = tempTotalRiderPrem + sqlite3_column_double(statement, 0);
            }            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    temp = !(tempBasicPrem + tempTotalRiderPrem > tempBasicBenefit + tempTotalRiderBenefit);
    
    return  temp;
}

-(double)RiderBenefitFactor : (NSString *)rcode {
    if ([rcode isEqualToString:@"WBI6R30"]) {
        return 165;
    } else if ([rcode isEqualToString:@"WB30R"]) {
        return 30;
    } else if ([rcode isEqualToString:@"WB50R"]) {
        return 50;
    } else if ([rcode isEqualToString:@"WBD10R30"]) {
        return 20;
    } else {
        return 0.00;
    }
}

-(double)returnTotalHLAWPPrem{ // to check for EDD case for HLAWP only
    sqlite3_stmt *statement;
    double temp = 0.00;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *SelectSQL = [NSString stringWithFormat: @"select basicSA from trad_details where sino = '%@' ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                temp = sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        NSString *SelectSQL2 = [NSString stringWithFormat:  @"SELECT SUM(REPLACE(Annually, ',', '')) FROM Si_Store_Premium "
                                "WHERE SiNo = '%@' AND Type IN ('WBM6R', 'EDUWR','WB30R','WB50R','WBI6R30','WBD10R30') ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                temp = temp + sqlite3_column_double(statement, 0);
            }            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return  temp;
}

-(BOOL)ValidateRiderL100
{
    BOOL allowedToAdd = TRUE;
    double riderSumAssured = 0;
    int noDeleted = 0;
    int noOfRiders = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT sumAssured from trad_rider_details where SINO=\"%@\" and RiderCode=\"ACIR_MPP\"",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderSumAssured =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT count(*) from trad_rider_details where SINO=\"%@\" ",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                noOfRiders =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        if ([getbasicSA doubleValue] == riderSumAssured && noOfRiders > 1) {
            
            querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SiNo=\"%@\" AND RiderCode "
                        "NOT IN ('ACIR_MPP', 'CIR', 'LCPR', 'ICR', 'SP_PRE', 'SP_STD') AND PTypeCode = 'LA' AND Seq = 1",getSINo];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    noDeleted = sqlite3_changes(contactDB);
                }
                sqlite3_finalize(statement);
            }
        }
        
        sqlite3_close(contactDB);
    }
    
    if (noDeleted > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Some Rider(s) has been deleted due to marketing rule."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        allowedToAdd = FALSE;
        [self RiderAdded];
    } else {
        allowedToAdd = TRUE;
    }
    
    return allowedToAdd;
}


-(double)calculateCIBenefit {
    
    sqlite3_stmt *statement;
    double CI = 0.00;
    NSMutableArray *ArrayCIRider = [[NSMutableArray alloc] init ];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    NSString *strRiders = @"";
    NSString *tempCode;
    int count = 0;
    int tempRiderTerm;
        
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *SelectSQL = [NSString stringWithFormat:
                               @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                               "('ACIR_MPP', 'CIR', 'ICR', 'LCPR','CIWP') and sino = \"%@\" ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                if ([tempCode isEqualToString:@"ACIR_MPP"] || [tempCode isEqualToString:@"CIR"] || [tempCode isEqualToString:@"LCPR"] || [tempCode isEqualToString:@"PLCP"]) {
                    CI = CI + sqlite3_column_double(statement, 1);
                    count++;
                } else if ([tempCode isEqualToString:@"ICR"]) {
                    CI = CI +  sqlite3_column_double(statement, 1) * 10;
                    count++;
                } else if ([tempCode isEqualToString:@"CIWP"]) {
                    [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                             forKey:tempCode];
                    count++;
                }                
                strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];                
            }            
            sqlite3_finalize(statement);
        }
        
        SelectSQL = [NSString stringWithFormat:
                     @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                     "('CIWP') and sino = \"%@\" ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];
                if (tempRiderTerm <= 10) {
                    CI = CI +  sqlite3_column_double(statement, 1) * 4;
                } else {
                    CI = CI +  sqlite3_column_double(statement, 1) * 8;
                }
            }            
            sqlite3_finalize(statement);
        }
        
        if (CI <= 4000000 || count < 0) {
            if (payorSINo.length > 0) {
                temp = [[NSMutableDictionary alloc] init];
                count = 0;
                CI = 0.00;
                ArrayCIRider = [[NSMutableArray alloc] init ];
                strRiders = @"";
                
                SelectSQL = [NSString stringWithFormat:
                             @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                             "('LCWP') and sino = \"%@\" ", getSINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                                 forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                        count++;
                        strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode]];
                    }                    
                    sqlite3_finalize(statement);
                }
                
                SelectSQL = [NSString stringWithFormat:
                             @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                             "('LCWP') and sino = \"%@\" ", getSINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];
                        if (tempRiderTerm <= 10) {
                            CI = CI +  sqlite3_column_double(statement, 1) * 4;                                
                        } else {
                            CI = CI +  sqlite3_column_double(statement, 1) * 8;                                
                        }
                    }                    
                    sqlite3_finalize(statement);
                }                
            }
            
            if (clientID2 > 0) {
                temp = [[NSMutableDictionary alloc] init];
                count = 0;
                CI = 0.00;
                ArrayCIRider = [[NSMutableArray alloc] init ];
                strRiders = @"";
                
                SelectSQL = [NSString stringWithFormat:
                             @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                             "('SP_PRE') and sino = \"%@\" ", getSINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        
                        if ([tempCode isEqualToString:@"SP_PRE"]) {
                            [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                                     forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                            count++;
                        }                        
                        strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];                        
                    }                    
                    sqlite3_finalize(statement);
                }
                
                SelectSQL = [NSString stringWithFormat:
                             @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                             "('SP_PRE') and sino = \"%@\" ", getSINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                           [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                           [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                            tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];                            
                            if (tempRiderTerm <= 10) {
                                CI = CI +  sqlite3_column_double(statement, 1) * 4;                                
                            } else {
                                CI = CI +  sqlite3_column_double(statement, 1) * 8;                                
                            }
                        }
                    }                    
                    sqlite3_finalize(statement);
                }
            }
        }        
        sqlite3_close(contactDB);
    }
    
    temp = Nil;
    ArrayCIRider = Nil;
    return CI;
}


-(double)CalcTPDbenefit{
    sqlite3_stmt *statement;
    double tempValue = 0.00;
    int tempPrem = 0;
    double tempPremWithoutLoading = 0;
    NSString *strRiders = @"";
    NSString *tempCode;
    NSMutableDictionary *tempArray = [[NSMutableDictionary alloc] init];
    int count = 1;
    BOOL attachTPDRiders = FALSE;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT Ridercode, sumAssured FROM TRAD_Rider_Details WHERE RiderCode in ('CCTR', 'LCPR', 'WPTPD30R', 'WPTPD50R' ) "
                    "AND SINO = '%@' ", getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                [tempArray setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]
                              forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];                
            }
            
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT Type, replace(Annually, ',', ''),replace(PremiumWithoutHLoading, ',', '') FROM "
                    "SI_STORE_PREMIUM WHERE TYPE in ('B', 'CCTR', 'EDUWR', 'LCPR', 'WB30R', 'WB50R','WBI6R30', 'WBD10R30', 'WPTPD30R', 'WPTPD50R' ) AND SINO = '%@' ",
                    getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempPrem = sqlite3_column_double(statement, 1);
                tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                tempPremWithoutLoading = sqlite3_column_double(statement, 2);
                
                if (![[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {

                    if (![[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"] &&
                        ![[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                        strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];
                    }                    
                    count++;
                }
                
                if (getTerm == 30) {
                    if (getMOP == 6) {                        
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 9; //9 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            
                        }
                        
                    } else {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 15; //9 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            
                        }
                    }
                } else {
                    if (getMOP == 6) {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 15; //15 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD50R"] doubleValue]; //50% of the Rider Sum Assured
                        }
                    } else {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 25; //15 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD50R"] doubleValue]; //50% of the Rider Sum Assured
                        }
                    }
                }            
            }        
            sqlite3_finalize(statement);
        }        
        sqlite3_close(contactDB);
    }
    
    if (tempValue > 3500000 && count > 1 && attachTPDRiders == TRUE ) {
        NSString *msg = [NSString stringWithFormat:@"TPD Benefit Limit per Life for 1st Life Assured has exceeded RM3.5mil. "
                         "Please revise the RSA of Wealth TPD Protector or revise the RSA of the TPD related rider(s) below:\n %@", strRiders];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show ];
    } else {
        tempValue = 0;
    }    
    return tempValue;
}

-(BOOL)DisplayMsgGIRR{
    sqlite3_stmt *statement;
    double tempValue = 0.00;
    double tempValueBenefit = 0.00;
    double tempPrem = 0;
    double tempSA = 0;
    NSString *tempCode;
    BOOL bProceed = FALSE;
 
    if (getAge < 35) {
        return FALSE;
    }
    
    // this is not very good but it's required to initialise SI_Store_Premium
    PremiumViewController *premView = [[PremiumViewController alloc] init ];
    premView.requestAge = getAge;
    premView.requestOccpClass = getOccpClass;
    premView.requestOccpCode = getOccpCode;
    premView.requestSINo = getSINo;
    premView.requestMOP = getMOP;
    premView.requestTerm = getTerm;
    premView.requestBasicSA = getbasicSA;
    premView.requestBasicHL = getbasicHL;
    premView.requestBasicTempHL = getbasicTempHL;
    premView.requestPlanCode = getPlanCode;
    premView.requestBasicPlan = getBasicPlan;
    premView.sex = getSex;
    premView.EAPPorSI = [self.EAPPorSI description];
    premView.executeMHI = @"YES";
    premView.fromReport = TRUE;
    [premView calculateReport];
    _delegate = premView;
    premView = Nil;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL;
        querySQL = [NSString stringWithFormat:@"SELECT Ridercode, sumAssured FROM TRAD_Rider_Details WHERE RiderCode in ('WB30R','WB50R', 'WBM6R', 'WBI6R30','WBD10R30') AND SINO = '%@' ", getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempSA = sqlite3_column_double(statement, 1);
                tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];   
                if (getTerm == 30) {
                    if (getMOP == 6) {                        
                        if ([tempCode isEqualToString:@"B"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 9;
                        } else if ([tempCode isEqualToString:@"WB30R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 30;
                        } else if ([tempCode isEqualToString:@"WB50R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 50;
                        } else if ([tempCode isEqualToString:@"WBM6R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 360;
                        } else if ([tempCode isEqualToString:@"WBD10R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 20;
                        } else if ([tempCode isEqualToString:@"WBI6R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 165;
                        }
                    } else {
                        if ([tempCode isEqualToString:@"B"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 15;
                        } else if ([tempCode isEqualToString:@"WB30R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 30;
                        } else if ([tempCode isEqualToString:@"WB50R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 50;
                        } else if ([tempCode isEqualToString:@"WBD10R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 20;
                        } else if ([tempCode isEqualToString:@"WBI6R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 165;
                        }
                    }
                } else {
                    if (getMOP == 6) {
                        if ([tempCode isEqualToString:@"B"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 15;
                        } else if ([tempCode isEqualToString:@"WB30R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 30;
                        }
                        else if ([tempCode isEqualToString:@"WBM6R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 360;
                        }
                        else if ([tempCode isEqualToString:@"WB50R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 50;
                        } else if ([tempCode isEqualToString:@"WBD10R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 20;
                        } else if ([tempCode isEqualToString:@"WBI6R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 165;
                        }
                    } else {
                        if ([tempCode isEqualToString:@"B"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 25;
                        } else if ([tempCode isEqualToString:@"WB30R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 30;
                        } else if ([tempCode isEqualToString:@"WB50R"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 50;
                        } else if ([tempCode isEqualToString:@"WBD10R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 20;
                        } else if ([tempCode isEqualToString:@"WBI6R30"]) {
                            tempValueBenefit = tempValueBenefit + tempSA * 165;
                        }
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        
        if (tempValueBenefit == 0) {
            bProceed = FALSE;
        } else {
            bProceed = TRUE;
            if (getTerm == 30) {
                if (getMOP == 6) {
                    tempValueBenefit = tempValueBenefit + [getbasicSA doubleValue] * 9;
                } else {
                    tempValueBenefit = tempValueBenefit + [getbasicSA doubleValue] * 15;
                }
            } else {
                if (getMOP == 6) {
                    tempValueBenefit = tempValueBenefit + [getbasicSA doubleValue] * 15;
                } else {
                    tempValueBenefit = tempValueBenefit + [getbasicSA doubleValue] * 25;
                }
            }
            querySQL = [NSString stringWithFormat:@"SELECT Type, replace(Annually, ',', '') FROM SI_STORE_PREMIUM WHERE TYPE in ('B', 'WBM6R', 'WB30R', 'WB50R', 'WBI6R30', 'WBD10R30') AND SINO = '%@' ", getSINo];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                double tempTotalPrem = 0;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    tempPrem = sqlite3_column_double(statement, 1);
                    tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    tempTotalPrem += tempPrem;
                }
                tempValue = tempValue + (tempTotalPrem * getMOP * 1.05);
                sqlite3_finalize(statement);
            }
        }        
        sqlite3_close(contactDB);
    }
    
    if (bProceed == FALSE) {
        [self setGIRRFLAG:FALSE];
        return FALSE;
    } else {
        if (tempValue >= tempValueBenefit) {
            [self setGIRRFLAG:TRUE];
            return TRUE;
        } else {
            [self setGIRRFLAG:FALSE];
            return FALSE;
        }
    }
}

-(void)setGIRRFLAG :(BOOL)aaTrueOrFalse{
	NSString *querySQL;
	sqlite3_stmt *statement;
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
		querySQL = [NSString stringWithFormat:@"Update Trad_Details SET GIRR = '%d' where sino = '%@' ", aaTrueOrFalse , getSINo];
		
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}		
		sqlite3_close(contactDB);
	}
}


-(void)UpdateSIToValid:(BOOL)ignoreSI {
	NSString *querySQL;
	sqlite3_stmt *statement;
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (ignoreSI) {
            querySQL = [NSString stringWithFormat:@"Update Trad_Details SET SIStatus = 'VALID' where sino = '%@' ", getSINo];
        } else {
            NSString *AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
            querySQL = [NSString stringWithFormat:@"Update Trad_Details SET SIStatus = 'VALID', SIVersion = '%@' where sino = '%@' ", AppsVersion, getSINo];
        }
        
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}		
		sqlite3_close(contactDB);
	}
    SIStatus = @"VALID";
}

-(void)UpdateSIToInvalid{
	NSString *querySQL;
	sqlite3_stmt *statement;
	NSString *AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
		querySQL = [NSString stringWithFormat:@"Update Trad_Details SET SIStatus = 'INVALID', SIVersion = '%@' where sino = '%@' ", AppsVersion , getSINo];
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}		
		sqlite3_close(contactDB);
	}    
    SIStatus = @"INVALID";
}

-(void)SetInitialStatusToFalse{
	NSString *querySQL;
	sqlite3_stmt *statement;
	
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
		querySQL = [NSString stringWithFormat:@"Update Trad_Details SET SIStatus = 'INVALID' where sino = '%@' ", getSINo];
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}

#pragma mark - db
-(void)geteProposalStatus
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SIStatus from Trad_Details where sino = '%@'", [self.requestSINo description]];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                SIStatus = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }			
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT B.status FROM eProposal as A, eProposal_Status AS B, eAPP_Listing AS C "
							  "WHERE C.Status = B.StatusCode AND A.eProposalNo = C.ProposalNo AND A.SINo=\"%@\"", [self.requestSINo description]];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				const char *temp = (const char *)sqlite3_column_text(statement, 0);
                eProposalStatus = temp == NULL ? @"NotFound" : [[NSString alloc] initWithUTF8String:temp];
            } else {
				eProposalStatus = @"NotFound";
			}
			
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT eProposalNo FROM eProposal WHERE SINo=\"%@\"", [self.requestSINo description]];
        NSString *eProposalNo;
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				const char *temp = (const char *)sqlite3_column_text(statement, 0);
                eProposalNo = temp == NULL ? @"" : [[NSString alloc] initWithUTF8String:temp];
            }
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT isPOSign FROM eProposal_Signature WHERE eproposalNo =\"%@\"", eProposalNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
				const char *temp = (const char *)sqlite3_column_text(statement, 0);
                isPOSign = temp == NULL ? @"No" : [[NSString alloc] initWithUTF8String:temp]; //return value 'YES' if got, empty or NULL if dont have any
            }			
            sqlite3_finalize(statement);
        }
		querySQL = Nil;		
        sqlite3_close(contactDB);
    }
	statement = Nil;
}


-(NSString *)getSINoAndCustCode
{
    NSString * toReturn = nil;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",
                              getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {				
                saveAsSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                saveAsCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                toReturn = saveAsCustCode;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return toReturn;
}

-(NSString *)getSINoAndCustCode2nd
{
    NSString * toReturn = nil;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",
                              getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {				
                saveAsSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                saveAsCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                toReturn = saveAsCustCode;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return toReturn;
}

-(NSString*)getSINoAndCustCodePY
{
    NSString * toReturn = nil;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode='PY'",
                              getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                saveAsSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                saveAsCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                toReturn = saveAsCustCode;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return toReturn;
}

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id "
							  "FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" "
							  "AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];        
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                delegate.ExistPayor = YES;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checking2ndLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM "
                              "Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",
                              getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                clientID2 = sqlite3_column_int(statement, 9);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

//check if wealth plan's GYI rider exist
-(void)wpGYIRiderExist:(BOOL)showAlert
{
    sqlite3_stmt *statement;
    int count=-1;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"Select count(*) from trad_rider_details where sino = '%@' and riderCode in ('WB30R', 'WB50R', 'WBM6R', 'EDUWR', 'WBI6R30', 'WBD10R30')",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                count = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_stmt *statement2;
        NSString *querySQL2 = [[NSString alloc] initWithFormat: @"UPDATE Trad_Details SET isGYI='%d' WHERE SINo='%@'", count > 0, getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL2 UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
            sqlite3_step(statement2);
            sqlite3_finalize(statement2);
        }
        sqlite3_close(contactDB);
    }
    
    if (showAlert) {
        if (count>0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Record saved." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
        } else {
            NSString * msg = @"Monthly Cash Coupons/Yearly Cash Coupons/Cash Payments accumulation and payout option is not applicable as no riders with GMCC, GYCC or GCP have been selected.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            alert.tag = 8001;
            [alert show];
            alert = Nil;
        }
    }
}

-(void)CalculateRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select count(*) from trad_rider_details where sino = '%@' ", getSINo ];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                RiderCount = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
}

-(void)getLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, OtherIDType FROM prospect_profile WHERE IndexNo= \"%d\"",getLAIndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NameLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
				LAotherIDType = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)get2ndLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",get2ndLAIndexNo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPayorName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",getPayorIndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return ListOfSubMenu.count-2;
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
    NSLog(@"cell last index %i",lastIndexSelected);
	/*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (PlanEmpty) {        
        cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];        
    } else {
        if (indexPath.row == 5) {
            //change the rider count on the left tab bar
            cell.textLabel.text = [[ListOfSubMenu objectAtIndex:indexPath.row] stringByAppendingFormat:@"(%@)", RiderCount ];
        } else {
            cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
        }
    }
        
    //--detail text label
	
    if (indexPath.row == 0) {
       if (NameLA.length != 0)
        {
//            NSString *str = [[NSString alloc] initWithFormat:@"1.Pemegang Polis"];
//            str = [str substringToIndex:MIN(30, [str length])];
//            cell.detailTextLabel.text = str;
        } else {
           // cell.detailTextLabel.text = @"";
        }
    } else if (indexPath.row == 1) {
        if (Name2ndLA.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",Name2ndLA];
            str = [str substringToIndex:MIN(30, [str length])];
			
            cell.detailTextLabel.text = str;
        } else {
            cell.detailTextLabel.text = @"";
        }
    } else if (indexPath.row == 2) {
        if (NamePayor.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",NamePayor];
            str = [str substringToIndex:MIN(30, [str length])];
            cell.detailTextLabel.text = str;
        } else {
            cell.detailTextLabel.text = @"";
        }
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor orangeColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    if (cell.textLabel.text.length > 25) {
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:15];
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
	if (self.myTableView.frame.size.height < 400.00 && indexPath.row == 3 ) {
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.backgroundColor = [UIColor clearColor ];
		cell.contentView.backgroundColor = [UIColor clearColor];
//		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else {
//		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, cell.contentView.bounds.size.height - 1.0f, cell.contentView.bounds.size.width, 1.0f)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lineView.backgroundColor = [UIColor blackColor];
    
    [cell.contentView addSubview:lineView];*/
    static NSString *CellIdentifier = @"Cell";
    SIMenuTableViewCell *cell = (SIMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UIView *bgColorView = [[UIView alloc] init];
    if (indexPath.row<[arrayIntValidate count]){
        if ([[arrayIntValidate objectAtIndex:indexPath.row] isEqualToString:@"1"]){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
    }
    else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    
    if (indexPath.row == 1){
        if (selfRelation){
            [cell setUserInteractionEnabled:NO];
        }
        else{
            [cell setUserInteractionEnabled:YES];
        }
    }
    
    bgColorView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell.button1 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button2 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button3 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row != 2){
        [cell.button1 setEnabled:false];
        [cell.button2 setEnabled:false];
        [cell.button3 setEnabled:false];
    }
    else{
        if (lastIndexSelected != 2){
            [cell.button1 setEnabled:false];
            [cell.button2 setEnabled:false];
            [cell.button3 setEnabled:false];
        }
        else{
            if (indexPath.row == 2){
                [cell.button1 setEnabled:true];
                if (([[dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:@"BCA Life Keluargaku"])||([[dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:@"BCA Life Keluargaku"])){
                    [cell.button2 setEnabled:true];
                }
                else{
                    [cell.button2 setEnabled:false];
                }
                [cell.button3 setEnabled:true];
            }
        }
    }

    
    
    
    if ([[_NumberListOfSubMenu objectAtIndex:indexPath.row] isEqualToString:@"0"]){
        [cell.labelNumber setText:@""];
        [cell.labelDesc setText:@""];
        [cell.labelWide setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
    }
    else{
        [cell.labelNumber setText:[_NumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
    }
    
    return cell;
}

#pragma mark - void added by faiz
-(void)checkValidateView{
    @try {
        if ([_LAController validateSave]){
            [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
        }
        else{
            [arrayIntValidate replaceObjectAtIndex:0 withObject:@"0"];
        }
        
        if ([_SecondLAController validateSave]){
            [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
        }
        else{
            [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
        }
        
        if ([_BasicController validateSave]){
             [arrayIntValidate replaceObjectAtIndex:2 withObject:@"1"];
        }
        else{
             [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
        }
        [myTableView reloadData];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)showviewControllerFromCellView:(UIButton *)sender{
        [self pullSIData];
        switch (sender.tag) {
            case 0:
                if (!_BasicController) {
                    self.BasicController = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
                    _BasicController.delegate = self;
                    [self.RightView addSubview:self.BasicController.view];
                }else{
                    [self.BasicController.view removeFromSuperview];
                    [self.RightView addSubview:self.BasicController.view];
                }
                @try {
                    if([self.RiderController.view isDescendantOfView:self.RightView]) {
                        [_RiderController localSaveRider];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }

                [self.RightView bringSubviewToFront:self.BasicController.view];
                break;
            case 1:
                if ([_BasicController validationDataBasicPlan]) {
                    newDictionaryForBasicPlan=[NSMutableDictionary dictionaryWithDictionary:[_BasicController setDataBasicPlan]];
                    if(![self.RiderController.view isDescendantOfView:self.RightView]) {
                        [_RiderController setPODictionaryFromRoot:dictionaryPOForInsert];
                        [_RiderController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
                        [_RiderController setElementActive];
                        [_RiderController loadInitialRiderDataFromDatabase];
                        [self.RightView addSubview:self.RiderController.view];
                    } else {
                        [_RiderController setPODictionaryFromRoot:dictionaryPOForInsert];
                        [_RiderController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
                        [_RiderController setElementActive];
                        [_RiderController loadInitialRiderDataFromDatabase];
                        [self.RiderController.view removeFromSuperview];
                        [self.RightView addSubview:self.RiderController.view];
                        [self.RightView bringSubviewToFront:self.RiderController.view];
                    }
                    @try {
                        [self saveLAForTableDidSelect];
                        [self saveBasicPlanForTableDidSelect];

                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        
                    }
                    
                    [_RiderController loadInitialRiderDataFromDatabase];
                    [_RiderController calculateRiderPremi];
                }
                break;
            case 2:
                if ([_BasicController validationDataBasicPlan]) {
                    if(([[dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:@"BCA Life Heritage Protection"])||([[dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:@"BCA Life Heritage Protection – For BCA Staff"])){
                        if([_BasicController validationDataBasicPlan]){
                            if (!_PremiumController) {
                                _PremiumController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
                                _PremiumController.delegate = self;
                                _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
                                
                                [self.RightView addSubview:_PremiumController.view];
                                
                            }else{
                                [_PremiumController.view removeFromSuperview];
                                [self.RightView addSubview:_PremiumController.view];
                            }
                            //[_PremiumController setDictionaryPremium:newDictionaryForBasicPlan];
                            //[_PremiumController setDictionaryPremium:newDictionaryForBasicPlan];
                            
                            [self pullSIData];
                            [_PremiumController setPremiumDictionary:newDictionaryForBasicPlan];
                            [_PremiumController loadDataFromDB];
                            _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
                            [self.RightView bringSubviewToFront:_PremiumController.view];
                            
                            @try {
                                [self saveLAForTableDidSelect];
                                [self saveBasicPlanForTableDidSelect];
                                if([self.RiderController.view isDescendantOfView:self.RightView]) {
                                    [_RiderController localSaveRider];
                                }

                            }
                            @catch (NSException *exception) {
                                
                            }
                            @finally {
                                
                            }
                        }
                    }
                    else{
                        PremiumKeluargaku *premiK = [[PremiumKeluargaku alloc]initWithNibName:@"PremiumKeluargaku" bundle:nil SINO:[dictionaryPOForInsert valueForKey:@"SINO"]];
                        premiK.delegate = self;
                        [premiK setDictionaryPOForInsert:dictionaryPOForInsert];
                        [premiK setDictionaryForBasicPlan:newDictionaryForBasicPlan];
                        [self addChildViewController:premiK];
                        [self.RightView addSubview:premiK.view];
                        [self.RightView bringSubviewToFront:premiK.view];
                    }
                }
                break;
            default:
                break;
        }
}

#pragma mark - delegate added by faiz
-(void)setBasicPlanDictionaryWhenLoadFromList:(NSDictionary *)basicPlan{
    newDictionaryForBasicPlan = [NSMutableDictionary dictionaryWithDictionary:basicPlan];
    NSDictionary* dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:[self.requestSINo description]]];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:[newDictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    
    [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"ProductCode"] forKey:@"ProductCode"];
    [newDictionaryForBasicPlan setObject:[self.requestSINo description] forKey:@"SINO"];
    if(myNumber != nil)
        [newDictionaryForBasicPlan setObject:myNumber forKey:@"Number_Sum_Assured"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"PO_Gender"] forKey:@"PO_Gender"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"PO_Age"] forKey:@"PO_Age"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"LA_Gender"] forKey:@"LA_Gender"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"RelWithLA"] forKey:@"RelWithLA"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"LA_Age"] forKey:@"LA_Age"];
    [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"IsInternalStaff"] forKey:@"IsInternalStaff"];
}

-(void)setPODictionaryWhenLoadFromList:(NSDictionary *)dataPO{
    dictionaryPOForInsert= [NSMutableDictionary dictionaryWithDictionary:dataPO];
}

-(void)saveLAForTableDidSelect{
    if ([_modelSIPOData getPODataCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
        if ([[dictionaryPOForInsert valueForKey:@"LA_Name"] length] > 0){
            [_modelSIPOData updatePOData:dictionaryPOForInsert];
        }
        else{
            [_modelSIPOData updatePartialPOData:dictionaryPOForInsert];
        }
        [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
    }
    else{
        if ([[dictionaryPOForInsert valueForKey:@"LA_Name"] length] > 0){
            [_modelSIPOData savePODate:dictionaryPOForInsert];
        }
        else{
            [_modelSIPOData savePartialPODate:dictionaryPOForInsert];
        }
        [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
    }
}

-(void)saveBasicPlanForTableDidSelect{
    if ([_modelSIPremium getPremiumCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
        [_modelSIPremium updatePremium:newDictionaryForBasicPlan];
    }
    else{
        [_modelSIPremium savePremium:newDictionaryForBasicPlan];
    }
    
    if (!_RiderController){
        self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        _RiderController.delegate = self;
    }
    [_RiderController setPODictionaryFromRoot:dictionaryPOForInsert];
    [_RiderController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
    //[_RiderController calculateRiderPremi];
}

-(void)saveNewLA:(NSDictionary *)dataPO{
    dictionaryPOForInsert = [NSMutableDictionary dictionaryWithDictionary:dataPO];
    [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
    [self.myTableView reloadData];
    if ([[dataPO valueForKey:@"LA_Name"] length] > 0){
        selfRelation = YES;
        [self clearData2ndLA];
        dictionaryPOForInsert = [NSMutableDictionary dictionaryWithDictionary:dataPO];
        dictionaryMasterForInsert = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dictionaryPOForInsert valueForKey:@"SINO"],@"SINO",@"1.1",@"SI_Version",@"Not Created",@"ProposalStatus", nil];

        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
        
        if (self.requestSINo){
            if ([_modelSIPOData getPODataCount:[self.requestSINo description]]>0){
                [_modelSIPOData updatePOData:dictionaryPOForInsert];
                [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
            }
            else{
                [_modelSIPOData savePODate:dictionaryPOForInsert];
                [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
            }
        }
        else{
            if ([_modelSIPOData getPODataCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
                [_modelSIPOData updatePOData:dictionaryPOForInsert];
                [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
            }
            else{
                [_modelSIPOData savePODate:dictionaryPOForInsert];
                [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
            }
        }
        [self.SecondLAController setPODictionaryRegular:dictionaryPOForInsert];
        [self loadBasicPlanPage:YES];
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_BASIC_PLAN inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    }
    else{
        selfRelation = NO;
        dictionaryPOForInsert = [NSMutableDictionary dictionaryWithDictionary:dataPO];
        dictionaryMasterForInsert = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dictionaryPOForInsert valueForKey:@"SINO"],@"SINO",@"1.1",@"SI_Version",@"Not Created",@"ProposalStatus", nil];
        
        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
        
        if (self.requestSINo){
            if ([_modelSIPOData getPODataCount:[self.requestSINo description]]>0){
                [_modelSIPOData updatePartialPOData:dictionaryPOForInsert];
                [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
            }
            else{
                [_modelSIPOData savePartialPODate:dictionaryPOForInsert];
                [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
            }
        }
        else{
            if ([_modelSIPOData getPODataCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
                [_modelSIPOData updatePartialPOData:dictionaryPOForInsert];
                [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
            }
            else{
                [_modelSIPOData savePartialPODate:dictionaryPOForInsert];
                [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
            }
        }
        [self loadSecondLAPage];
        //[self.SecondLAController resetField];
        [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_SECOND_LIFE_ASSURED inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    

}

-(void)saveSecondLA:(NSDictionary *)dataLA{
    dictionaryMasterForInsert = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dictionaryPOForInsert valueForKey:@"SINO"],@"SINO",@"1.1",@"SI_Version",@"Not Created",@"ProposalStatus", nil];
    [dictionaryPOForInsert addEntriesFromDictionary:dataLA];
    [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
    [self.myTableView reloadData];
    
    if (self.requestSINo){
        if ([_modelSIPOData getPODataCount:[self.requestSINo description]]>0){
            [_modelSIPOData updatePOData:dictionaryPOForInsert];
            [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
        }
        else{
            [_modelSIPOData savePODate:dictionaryPOForInsert];
            [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
        }
    }
    else{
        if ([_modelSIPOData getPODataCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
            [_modelSIPOData updatePOData:dictionaryPOForInsert];
            [_modelSIMaster updateIlustrationMaster:dictionaryMasterForInsert];
        }
        else{
            [_modelSIPOData savePODate:dictionaryPOForInsert];
            [_modelSIMaster saveIlustrationMaster:dictionaryMasterForInsert];
        }
    }

    [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
    [self loadBasicPlanPage:YES];
    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_BASIC_PLAN inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)saveBasicPlan:(NSDictionary *)basicPlan{
    [arrayIntValidate replaceObjectAtIndex:2 withObject:@"1"];
    NSDictionary* dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:[self.requestSINo description]]];
    newDictionaryForBasicPlan=[NSMutableDictionary dictionaryWithDictionary:basicPlan];
    if (self.requestSINo){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[newDictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"ProductCode"] forKey:@"ProductCode"];
        [newDictionaryForBasicPlan setObject:[self.requestSINo description] forKey:@"SINO"];
        if(myNumber != nil)
        [newDictionaryForBasicPlan setObject:myNumber forKey:@"Number_Sum_Assured"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"PO_Gender"] forKey:@"PO_Gender"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"PO_Age"] forKey:@"PO_Age"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"LA_Gender"] forKey:@"LA_Gender"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"RelWithLA"] forKey:@"RelWithLA"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"LA_Age"] forKey:@"LA_Age"];
        [newDictionaryForBasicPlan setObject:[dictPOData valueForKey:@"IsInternalStaff"] forKey:@"IsInternalStaff"];
        if ([_modelSIPremium getPremiumCount:[self.requestSINo description]]>0){
            [_modelSIPremium updatePremium:newDictionaryForBasicPlan];
        }
        else{
            [_modelSIPremium savePremium:newDictionaryForBasicPlan];
        }
    }
    else{
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[newDictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"ProductCode"] forKey:@"ProductCode"];
        if(myNumber != nil)
            [newDictionaryForBasicPlan setObject:myNumber forKey:@"Number_Sum_Assured"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"PO_Gender"] forKey:@"PO_Gender"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"PO_Age"] forKey:@"PO_Age"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"LA_Gender"] forKey:@"LA_Gender"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"RelWithLA"] forKey:@"RelWithLA"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"LA_Age"] forKey:@"LA_Age"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"SINO"] forKey:@"SINO"];
        [newDictionaryForBasicPlan setObject:[dictionaryPOForInsert valueForKey:@"IsInternalStaff"] forKey:@"IsInternalStaff"];
        
        if ([_modelSIPremium getPremiumCount:[dictionaryPOForInsert valueForKey:@"SINO"]]>0){
            [_modelSIPremium updatePremium:newDictionaryForBasicPlan];
        }
        else{
            [_modelSIPremium savePremium:newDictionaryForBasicPlan];
        }
    }

    NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
    
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        if(![self.RiderController.view isDescendantOfView:self.RightView]) {
            [_RiderController setPODictionaryFromRoot:dictionaryPOForInsert];
            [_RiderController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
            [_RiderController setElementActive];
            [_RiderController loadInitialRiderData];
            [self.RightView addSubview:self.RiderController.view];
        } else {
            [_RiderController setPODictionaryFromRoot:dictionaryPOForInsert];
            [_RiderController setDictionaryForBasicPlan:newDictionaryForBasicPlan];
            [_RiderController setElementActive];
            [_RiderController loadInitialRiderData];
            [self.RiderController.view removeFromSuperview];
            [self.RightView addSubview:self.RiderController.view];
            [self.RightView bringSubviewToFront:self.RiderController.view];
        }
        [_RiderController calculateRiderPremi];
    }
    else{
        if (!_PremiumController) {
            _PremiumController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            _PremiumController.delegate = self;
            _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
            [self.RightView addSubview:_PremiumController.view];
        }
        [_PremiumController setPremiumDictionary:newDictionaryForBasicPlan];
        [_PremiumController loadDataFromDB];
        [_PremiumController.view removeFromSuperview];
        _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
        [self.RightView addSubview:_PremiumController.view];
        [self.RightView bringSubviewToFront:_PremiumController.view];
    }
    
    
    /*

    if (!_RiderController){
        self.RiderController = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        _RiderController.delegate = self;
        [self.RightView addSubview:self.RiderController.view];
    }
    [self.RiderController setSumAssured:[newDictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    [self.RightView bringSubviewToFront:self.RiderController.view];    //[self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_RIDER inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];*/
}

-(void)saveRider:(NSDictionary *)dictMDBKK MDKK:(NSDictionary *)dictMDKK BP:(NSDictionary *)dictBasicPremi{
    NSMutableDictionary *mutableMDBKK=[[NSMutableDictionary alloc]initWithDictionary:dictMDBKK];
    NSMutableDictionary *mutableMDKK=[[NSMutableDictionary alloc]initWithDictionary:dictMDKK];
    NSMutableDictionary *mutableBP=[[NSMutableDictionary alloc]initWithDictionary:dictBasicPremi];
    
    [mutableMDBKK setObject:[dictionaryPOForInsert valueForKey:@"SINO"] forKey:@"SINO"];
    [mutableMDKK setObject:[dictionaryPOForInsert valueForKey:@"SINO"] forKey:@"SINO"];
    [mutableBP setObject:[dictionaryPOForInsert valueForKey:@"SINO"] forKey:@"SINO"];
    if ([_modelSIRider getRiderCount:[dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:[dictMDBKK valueForKey:@"RiderCode"]]<=0){
        [_modelSIRider saveRider:mutableMDBKK];
    }
    else{
        [_modelSIRider updateRider:mutableMDBKK];
    }
    
    if ([_modelSIRider getRiderCount:[dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:[dictMDKK valueForKey:@"RiderCode"]]<=0){
        [_modelSIRider saveRider:mutableMDKK];
    }
    else{
        [_modelSIRider updateRider:mutableMDKK];
    }
    
    if ([_modelSIRider getRiderCount:[dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:[mutableBP valueForKey:@"RiderCode"]]<=0){
        [_modelSIRider saveRider:mutableBP];
    }
    else{
        [_modelSIRider updateRider:mutableBP];
    }
    
    /*if (!_PremiumController) {
        _PremiumController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
        //_PremiumController.delegate = self;
        [self.RightView addSubview:_PremiumController.view];
    }
    [_PremiumController setPremiumDictionary:newDictionaryForBasicPlan];
    [self.RightView bringSubviewToFront:_PremiumController.view];*/
}

#pragma mark auto save rider
-(void)setQuickQuoteValue:(BOOL)value{
    quickQuoteEnabled=value;
}

#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self pullSIData];
    [tableView reloadData];
    //[self checkValidateView];
    lastIndexSelected = indexPath.row;
    switch (lastIndexSelected) {
        case 0:
            if (_LAController == nil) {
                self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                _LAController.delegate = self;
                [self.RightView addSubview:self.LAController.view];
            }else{
                [self.LAController.view removeFromSuperview];
                [self.RightView addSubview:self.LAController.view];
            }
            self.LAController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
            [self.RightView bringSubviewToFront:self.LAController.view];
            
            
            lastActiveController = self.LAController;
            [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
            [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
            [arrayIntValidate replaceObjectAtIndex:0 withObject:@"0"];
            
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            lastIndexSelected = 0;
            break;
        case 1:
            if ([_LAController validateSave]){
                if ((![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])&&(![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])){
                    [self loadSecondLAPage];
                    lastIndexSelected = 1;
                    [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                    [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                    [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                }
                else{
                    [self clearData2ndLA];
                    [self loadBasicPlanPage:YES];
                    [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                    [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                    [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                    lastIndexSelected=2;
                }
                @try {
                    [self saveLAForTableDidSelect];
                    [self saveBasicPlanForTableDidSelect];
                    if([self.RiderController.view isDescendantOfView:self.RightView]) {
                        [_RiderController localSaveRider];
                    }

                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }

            }
            else{
                if (_LAController == nil) {
                    self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                    _LAController.delegate = self;
                    [self.RightView addSubview:self.LAController.view];
                }else{
                    [self.LAController.view removeFromSuperview];
                    [self.RightView addSubview:self.LAController.view];
                }
                [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:0 withObject:@"0"];
                lastIndexSelected=0;
                [self.RightView bringSubviewToFront:self.LAController.view];
                lastActiveController = self.LAController;
                
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            break;
        case 2:
            if ([_LAController validateSave]){
                if (([[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])||([[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])){
                    lastIndexSelected=2;
                    [self loadBasicPlanPage:YES];
                    [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                    [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                    [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                }
                else{
                    if ([_SecondLAController validateSave]){
                        lastIndexSelected=2;
                        [self loadBasicPlanPage:YES];
                        [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                        [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                    }
                    else{
                        lastIndexSelected=1;
                        [self loadSecondLAPage];
                        [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                    }
                }
                @try {
                    [self saveLAForTableDidSelect];
                    [self saveBasicPlanForTableDidSelect];
                    if([self.RiderController.view isDescendantOfView:self.RightView]) {
                        [_RiderController localSaveRider];
                    }

                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
            }
            else{
                if (_LAController == nil) {
                    self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                    _LAController.delegate = self;
                    [self.RightView addSubview:self.LAController.view];
                }else{
                    [self.LAController.view removeFromSuperview];
                    [self.RightView addSubview:self.LAController.view];
                }
                lastIndexSelected=0;
                [self.RightView bringSubviewToFront:self.LAController.view];
                lastActiveController = self.LAController;
                [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:0 withObject:@"0"];
                
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            
            break;
        case 3:
            if ([_LAController validateSave]){
                if ((![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])&&(![[dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])){
                    if ([_SecondLAController validateSave]){
                        if ([_BasicController validationDataBasicPlan]) {
                            [arrayIntValidate replaceObjectAtIndex:2 withObject:@"1"];
                            [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                            [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                            lastIndexSelected=3;
                            [self LoadIlustrationPage];
                            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                            
                        }
                        else{
                            [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                            [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                            [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                            lastIndexSelected=2;
                            [self loadBasicPlanPage:YES];
                        }
                    }
                    else{
                        [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                        lastIndexSelected=1;
                        [self loadSecondLAPage];
                    }

                }
                else{
                    if ([_BasicController validationDataBasicPlan]) {
                        [arrayIntValidate replaceObjectAtIndex:2 withObject:@"1"];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                        [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                        lastIndexSelected=3;
                        [self LoadIlustrationPage];
                        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                        
                    }
                    else{
                        [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                        [arrayIntValidate replaceObjectAtIndex:0 withObject:@"1"];
                        lastIndexSelected=2;
                        [self loadBasicPlanPage:YES];
                        [arrayIntValidate replaceObjectAtIndex:1 withObject:@"1"];
                    }
                }
            }
            else{
                if (_LAController == nil) {
                    self.LAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
                    _LAController.delegate = self;
                    [self.RightView addSubview:self.LAController.view];
                }else{
                    [self.LAController.view removeFromSuperview];
                    [self.RightView addSubview:self.LAController.view];
                }
                lastIndexSelected=0;
                [self.RightView bringSubviewToFront:self.LAController.view];
                lastActiveController = self.LAController;
                [arrayIntValidate replaceObjectAtIndex:2 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:1 withObject:@"0"];
                [arrayIntValidate replaceObjectAtIndex:0 withObject:@"0"];
                
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                
                /*@try {
                    [self saveLAForTableDidSelect];
                    [self saveBasicPlanForTableDidSelect];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }*/
            }
            
            break;
        default:
            break;
    }
    
    if (lastIndexSelected==2){
        [cell.button1 setEnabled:true];
        [cell.button2 setEnabled:true];
        [cell.button3 setEnabled:true];
    }
    else{
        [cell.button1 setEnabled:false];
        [cell.button2 setEnabled:false];
        [cell.button3 setEnabled:false];
    }
	//perform checking before going next page
    //temporary remark by faiz
    /*blocked = YES;
    if ([self validatePage:indexPath]) {
        blocked = NO;
        
        [self hideKeyboard];
        if (indexPath.row == SIMENU_LIFEASSURED) {            
            [self loadLAPage];
            selectedPath = indexPath;
            previousPath = selectedPath;
            blocked = NO;			
        } else if (indexPath.row == SIMENU_SECOND_LIFE_ASSURED)
        {
            
            [self loadSecondLAPage];
            
            
        }
        else if (indexPath.row == SIMENU_PAYOR)
        
        {
            
            [self loadBasicPlanPage:YES];*/
//            if ([getOccpCode isEqualToString:@"OCC01975"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
//                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                [alert show];
//                alert = Nil;
//                blocked = YES;
//            } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
//                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                [alert show];
//                alert = Nil;
//                blocked = YES;
//                
//            } else if (getBasicPlan == NULL) {
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select basic plan first."
////                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
////                [alert show];
////                alert = Nil;
////                blocked = YES;
//                
//            } else {
//                if ([self selectPayor]) {
//                    [self loadPayorPage];
//                    selectedPath = indexPath;					
//                } else {
//                    blocked = YES;
//                }
//            }
            
            
        //temporary remark by faiz
        /*} else if (indexPath.row == SIMENU_BASIC_PLAN) {
            [_BasicController loadData];
            if ([getOccpCode isEqualToString:@"OCC01975"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
                blocked = YES;
				                
            } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
                
				blocked = !isSaveBasicPlan;                
            } else {
                if (!saved) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"2nd Life Assured has not been saved yet.Leave this page without saving?"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
                    [alert setTag:1001];
                    [alert show];
                } else if (!payorSaved) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Payor has not been saved yet.Leave this page without saving?"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
                    [alert setTag:2001];
                    [alert show];
                } else {
                    [self loadBasicPlanPage:YES];
                    selectedPath = indexPath;
                    
                }
            }            
        } else if (indexPath.row == SIMENU_HEALTH_LOADING) {
            if ([getOccpCode isEqualToString:@"OCC01975"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
                
            } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;				
            } else {
                
                [self loadHLPage];
                selectedPath = indexPath;
				
            }            
        } else if (indexPath.row == SIMENU_RIDER) {
            if ([getOccpCode isEqualToString:@"OCC01975"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
                
            } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
            } else {
                [self checkingPayor];
                if (getAge < 10 && payorSINo.length == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    blocked = YES;
                } else if (!saved) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"2nd Life Assured has not been saved yet.Leave this page without saving?"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
                    [alert setTag:1002];
                    [alert show];
                } else if (!payorSaved) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Payor has not been saved yet.Leave this page without saving?"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
                    [alert setTag:2002];
                    [alert show];
                } else {
                    self.RiderController.requestAge = getAge;
                    self.RiderController.requestSex = getSex;
                    self.RiderController.requestOccpCode = getOccpCode;
                    self.RiderController.requestOccpClass = getOccpClass;
                    
                    self.RiderController.requestSINo = getSINo;
                    self.RiderController.requestPlanCode = getPlanCode;
                    self.RiderController.requestPlanChoose = getBasicPlan;
                    self.RiderController.requestCoverTerm = getTerm;
                    self.RiderController.requestBasicSA = getbasicSA;
                    self.RiderController.requestBasicHL = getbasicHL;
                    self.RiderController.requestBasicTempHL = getbasicTempHL;
                    self.RiderController.requestMOP = getMOP;
                    self.RiderController.requestAdvance = getAdvance;
                    self.RiderController.requesteProposalStatus = eProposalStatus;
                    self.RiderController.requesteEDD = getEDD;
                    self.RiderController.EAPPorSI = [self.EAPPorSI description];
                    
                    [self.RightView addSubview:self.RiderController.view];
                    [_RiderController processRiders];
                    
                    selectedPath = indexPath;
                    previousPath = selectedPath;
                    blocked = NO;
                    [self hideSeparatorLine];
                    [myTableView reloadData];
                }
            }            
        } else if (indexPath.row == SIMENU_PREMIUM) {
            if ([getOccpCode isEqualToString:@"OCC01975"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
                
            } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                alert = Nil;
            } else {
                [self CheckPremAndMHI];
				[self calculatedPrem];
				selectedPath = indexPath;                
				[myTableView reloadData];
            }
        } else if (indexPath.row == SIMENU_QUOTATION || indexPath.row == SIMENU_SUMMARY_QUOTATION) {
            [self hideKeyboard];
            if (getAge < 10 && payorSINo.length == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                blocked = YES;
            } else if ([getBasicPlan isEqualToString:STR_HLAWP] && [self DisplayMsgGIRR] == TRUE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:[NSString stringWithFormat:@"Please note that the Guaranteed Benefit payout for selected plan will be lesser than total premium outlay. You may increase the Basic Desired Annual Premium to increase the Guaranteed Benefit payout.\nChoose OK to proceed.\nChoose CANCEL to increase Basic Desired Annual Premium."]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
             
                CurrentPath = indexPath.row;
                alert.tag = 7001;
                [alert show];
            } else {
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    if (([getBasicPlan isEqualToString:STR_S100]) && appDel.allowedToShowReport == FALSE) {
                        NSString *dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                        [alert show];
                    } else if (indexPath.row == SIMENU_SUMMARY_QUOTATION) {
                        [self showSummaryQuotation];
                    } else {
                        [self showQuotation];
                    }
                }            
            }
        } else if (indexPath.row == SIMENU_PRODUCT_DISCLOSURE_SHEET) {   
            if (getAge < 10 && payorSINo.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:@"Please attach Payor as Life Assured is below 10 years old."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                blocked = YES;
            } else if ([getBasicPlan isEqualToString:STR_HLAWP] && [self DisplayMsgGIRR] == TRUE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:[NSString stringWithFormat:@"Please note that the Guaranteed Benefit payout for selected plan will be lesser than total premium outlay. You may increase the Basic Desired Annual Premium to increase the Guaranteed Benefit payout.\nChoose OK to proceed.\nChoose CANCEL to increase Basic Desired Annual Premium."]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                
                CurrentPath = indexPath.row;
                alert.tag = 7001;
                [alert show];
            } else {                
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    if (([getBasicPlan isEqualToString:STR_S100]) && !appDel.allowedToShowReport) {
                        NSString *dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                        [alert show];
                    } else {
                        [self getSelectedLanguage];
                        [self showPDS];
                    }                    
                }                
            }
        } else if (indexPath.row == SIMENU_EXP_PDS) {
            if ([self validateSaveAllWithoutPrompt] == TRUE) {
                if (([getBasicPlan isEqualToString:STR_S100]) && !appDel.allowedToShowReport) {
                    NSString *dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                    [alert show];
                } else {
                    [self getSelectedLanguage];
                    [self exportPDS];
                }
            }
        } else if (indexPath.row == SIMENU_UNDERWRITING) {            
            if (getAge < 10 && payorSINo.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                blocked = YES;
            } else if ([getBasicPlan isEqualToString:STR_HLAWP] && [self DisplayMsgGIRR] == TRUE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:[NSString stringWithFormat:@"Please note that the Guaranteed Benefit payout for selected plan will be lesser than total premium outlay. You may increase the Basic Desired Annual Premium to increase the Guaranteed Benefit payout.\nChoose OK to proceed.\nChoose CANCEL to increase Basic Desired Annual Premium."]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                CurrentPath = indexPath.row;
                alert.tag = 7001;
                [alert show];
            } else {                
                if ([self validateSaveAllWithoutPrompt] == TRUE) {
                    if (([getBasicPlan isEqualToString:STR_S100]) && appDel.allowedToShowReport == FALSE) {
                        NSString *dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                        [alert show];
                    } else {
                        [self getSelectedLanguage];
                        [self showUnderwriting];
                    }                    
                }                
            }
        } else if (indexPath.row == SIMENU_PDS_SAVE_AS) {
            if ([getBasicPlan isEqualToString:STR_HLAWP] && [self DisplayMsgGIRR] == TRUE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:[NSString stringWithFormat:@"Please note that the Guaranteed Benefit payout for selected plan will be lesser than total premium outlay. You may increase the Basic Desired Annual Premium to increase the Guaranteed Benefit payout.\nChoose OK to proceed.\nChoose CANCEL to increase Basic Desired Annual Premium."]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                CurrentPath = indexPath.row;
                alert.tag = 7001;
                [alert show];
            } else {
                if ([self validateSaveAllWithoutPrompt]) {
                    if (([getBasicPlan isEqualToString:STR_S100]) && appDel.allowedToShowReport == FALSE) {
                        NSString *dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                        [alert show];
                    } else {
                        //*******set the isNeedPromptSaveMsg to NO to prevent further "Do you need to save changes" dialog from popping up ********/
                        //temporary remark by faiz
                        /* appDel.isNeedPromptSaveMsg = NO;
                        
                        NSString* msg = [NSString stringWithFormat:@"Create a new SI from %@ (%@)?", getSINo, NameLA];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                        alert.tag = 2000001;
                        [alert show];
                    }                    
                }
            }
        }		
    }
    
    if (blocked) {
        [tableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        selectedPath = previousPath;
    } else {
        [tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        previousPath = selectedPath;
    }*/
}

-(void) getSelectedLanguage
{
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {        
        NSString *QuerySQL = [ NSString stringWithFormat:@"select \"quotationLang\" from Trad_Details as A where A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                lang = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
    int lastIndexSelected = indexPath.row;
    switch (lastIndexSelected) {
        case 1:
            if(![[TabValidation sharedMySingleton] CheckTab1]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:@"Harap isi mandatory fields"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return nil;
            }
            break;
        case 2:
            if(![[TabValidation sharedMySingleton] CheckTab1] &&
               ![[TabValidation sharedMySingleton] CheckTab2]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:@"Harap isi mandatory fields"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return nil;
            }
            break;
        case 3:
            if(![[TabValidation sharedMySingleton] CheckTab1] &&
               ![[TabValidation sharedMySingleton] CheckTab2] &&
               ![[TabValidation sharedMySingleton] CheckTab3]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:@"Harap isi mandatory fields"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return nil;
            }
            break;
        default:
            break;
    }

    return indexPath;
}*/

- (void)buildSpinner {    
    spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner_SI.center = CGPointMake(400, 350);
    
    spinner_SI.hidesWhenStopped = YES;
    [self.view addSubview:spinner_SI];
    UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
    spinnerLabel.text  = @" Please Wait...";
    spinnerLabel.backgroundColor = [UIColor blackColor];
    spinnerLabel.opaque = YES;
    spinnerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:spinnerLabel];
    [self.view setUserInteractionEnabled:NO];
    [spinner_SI startAnimating];
    
    if (_FS == Nil && ![[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        self.FS = [FSVerticalTabBarController alloc];
        _FS.delegate = self;
    }
    
    [_FS Test ];
}

- (void) showGST {
    reportType = REPORT_GST;
    [self buildSpinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *htmlLang;
        if ([lang isEqualToString:@"Malay"]) {
            htmlLang = @"mly";
        } else {
            htmlLang = @"eng";
        }
                
        dispatch_async(dispatch_get_main_queue(), ^{           
            NSString *htmlPage = nil;
            
            htmlPage = [NSString stringWithFormat:@"gst/gst_%@_Page1", htmlLang];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:htmlPage ofType:@"html"];
            NSURL *pathURL = [NSURL fileURLWithPath:path];
            NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
            NSData* data = [NSData dataWithContentsOfURL:pathURL];
            [data writeToFile:[NSString stringWithFormat:@"%@/gst_Temp.html",documentsDirectory] atomically:YES];
            
            NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"gst_Temp.html"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
                NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                // Converting HTML to PDF
                NSString *SIPDFName = [NSString stringWithFormat:@"gst_%@.pdf",self.getSINo];
                self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                                     pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                       delegate:self
                                                       pageSize:kPaperSizeA4
                                                        margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                targetURL = nil, SIPDFName = nil;
            }
            path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
        });
    });

}

-(void)hideKeyboard {    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
    
}

- (void) showUnderwriting
{
    reportType = REPORT_UNDERWRITING;
    PDSorSI = @"UNDERWRITING";
    
    if ([getOccpCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];			
    } else {        
        if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL) {
            NSString *RevisedSumAssured = appDel.MhiMessage;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"%@ will be increase to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.",MHI_MSG_TYPE,RevisedSumAssured]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            RevisedSumAssured = Nil;
        }        
        [self buildSpinner];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{			
            PremiumViewController *premView = [[PremiumViewController alloc] init ];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = TRUE;
            [premView calculateReport];
            _delegate = premView;
            
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            BOOL showReport = false;
            BOOL hasSecondOrPayor = false;
            NSArray *payorOrSecondLA = [NSArray arrayWithObjects: @"SP_PRE",@"SP_STD",@"LCWP",@"PLCP",@"PR",@"PTR",nil];

            int riderCodeCount = [premView.riderCode count];
            for (int p=0; p<riderCodeCount; p++) {
                riderCode = [premView.riderCode objectAtIndex:p];
                
                if ([payorOrSecondLA containsObject:riderCode]) {
                    hasSecondOrPayor = TRUE;
                    break;
                }
            }
            
            if (riderCodeCount > 14 || (riderCodeCount >= 10 && hasSecondOrPayor)) {
                need2PagesUnderwriting = true;
            } else {
                need2PagesUnderwriting = false;
            }
            
            premView = Nil;
            
            if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP ]) {
                showReport = del.allowedToShowReport;
            }
            
            if (showReport) {
                CashPromiseViewController *CPReportPage;
                
                if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                    CPReportPage = [[CashPromiseViewController alloc] init ];
                    CPReportPage.SINo = getSINo;
                    CPReportPage.PDSorSI = @"PDS";
                    CPReportPage.pPlanCode = getBasicPlan;
                    CPReportPage.lang = lang;
                    CPReportPage.need2PagesUnderwriting = need2PagesUnderwriting;
                    CPReportPage.reportType = reportType;
                    CPReportPage.paymentOption = getMOP;
                    [CPReportPage calculateForReport];
                    [premView dismissViewControllerAnimated:NO completion:nil];
                    [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                }
                
                PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
                PDSPage.SINo = getSINo;
                
                if ([lang isEqualToString:@"Malay"]) {
                    PDSPage.PDSLanguage = @"M";
                } else {
                    PDSPage.PDSLanguage = @"E";
                }
                
                PDSPage.PDSPlanCode = getBasicPlan;
                [PDSPage calculateForReport];
                
                [CPReportPage generateJSON_HLCP:YES];
                [CPReportPage copyReportFolderToDoc:@"underwriting"];
                CPReportPage = Nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PDSPage dismissViewControllerAnimated:NO completion:Nil];
                    NSString *htmlPage = nil;
                    
                    if ([lang isEqualToString:@"Malay"]) {
                        htmlPage = @"underwriting/Trad_mly_Page1";
                    } else {
                        htmlPage = @"underwriting/Trad_eng_Page1";
                    }
                        
                    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPage ofType:@"html"];
                    NSURL *pathURL = [NSURL fileURLWithPath:path];
                    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
                    
                    NSData* data = [NSData dataWithContentsOfURL:pathURL];
                    [data writeToFile:[NSString stringWithFormat:@"%@/underwriting_Temp.html",documentsDirectory] atomically:YES];
                    
                    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"underwriting_Temp.html"];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
                        NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                        // Converting HTML to PDF
                        NSString *SIPDFName = [NSString stringWithFormat:@"underwriting_%@.pdf",self.getSINo];
                        self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                                             pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                               delegate:self
                                                               pageSize:kPaperSizeA4
                                                                margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                        targetURL = nil, SIPDFName = nil;
                    }
                    path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
                });
                PDSPage = Nil;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Display/dismiss your alert
                    [spinner_SI stopAnimating ];
                    [self.view setUserInteractionEnabled:YES];
                    [_FS Reset];
                    
                    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                    [v removeFromSuperview];
                    v = Nil;
                    
                    if (previousPath == Nil) {
                        previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                    }
                    
                    [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    selectedPath = previousPath;
                    spinner_SI = Nil;
                    
                    [_delegate showReportCantDisplay:[PremiumViewController getMsgTypeL100] ];                    
                });
            }
        });
    }
}

- (void) showPDS
{
    reportType = REPORT_PDS;
    PDSorSI = @"PDS";
    
    if ([getOccpCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"There is no existing plan which can be offered to this occupation."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];			
    } else {
        NSString *RevisedSumAssured = appDel.MhiMessage;
        if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"%@ will be increase to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.",MHI_MSG_TYPE,RevisedSumAssured]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            RevisedSumAssured = Nil;
        }
        
        [self buildSpinner];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            PremiumViewController *premView = [[PremiumViewController alloc] init ];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = TRUE;
            [premView calculateReport];
            _delegate = premView;
            premView = Nil;
            
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            BOOL showReport = false;
            
            if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                showReport = del.allowedToShowReport;
            }
            
            if (showReport ) {
                CashPromiseViewController *CPReportPage;
                if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                    CPReportPage = [[CashPromiseViewController alloc] init ];
                    CPReportPage.SINo = getSINo;
                    CPReportPage.PDSorSI = @"PDS";
                    CPReportPage.pPlanCode = getBasicPlan;
                    CPReportPage.lang = lang;
                    CPReportPage.need2PagesUnderwriting = need2PagesUnderwriting;
                    CPReportPage.reportType = reportType;
                    CPReportPage.paymentOption = getMOP;
                    [CPReportPage calculateForReport];
                    [premView dismissViewControllerAnimated:NO completion:nil];
                    [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                }
                
                PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
                PDSPage.SINo = getSINo;
                
                if ([lang isEqualToString:@"Malay"]) {
                    PDSPage.PDSLanguage = @"M";
                } else {
                    PDSPage.PDSLanguage = @"E";
                }
                PDSPage.PDSPlanCode = getBasicPlan;
                [PDSPage calculateForReport];
                
                [CPReportPage generateJSON_HLCP:YES];
                [CPReportPage copyReportFolderToDoc:@"PDS"];
                
                CPReportPage = Nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{                    
                    [PDSPage dismissViewControllerAnimated:NO completion:Nil];
                    NSString *htmlPage = nil;

                    if ([getBasicPlan isEqualToString:STR_S100 ]) {
                            if ([lang isEqualToString:@"Malay"]) {
                                htmlPage = @"PDS/PDS_BM_S100_Page1";
                            } else {
                                htmlPage = @"PDS/PDS_ENG_S100_Page1";
                            }
                    } else if ([getBasicPlan isEqualToString:STR_HLAWP ]) {
                        if ([lang isEqualToString:@"Malay"]) {
                            htmlPage = @"PDS/PDS_BM_HLAWP_Page1";
                        } else {
                            htmlPage = @"PDS/PDS_ENG_HLAWP_Page1";
                        }
                    }
                    
                    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPage ofType:@"html"];
                    NSURL *pathURL = [NSURL fileURLWithPath:path];                    
                    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
                    
                    NSData* data = [NSData dataWithContentsOfURL:pathURL];
                    [data writeToFile:[NSString stringWithFormat:@"%@/PDS_Temp.html",documentsDirectory] atomically:YES];
                    
                    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"PDS_Temp.html"];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
                        NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                        // Converting HTML to PDF
                        NSString *SIPDFName = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
                        self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                                             pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                               delegate:self
                                                               pageSize:kPaperSizeA4
                                                                margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                        targetURL = nil, SIPDFName = nil;
                    }
                    path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
                });
                
                PDSPage = Nil;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Display/dismiss your alert
                    [spinner_SI stopAnimating ];
                    [self.view setUserInteractionEnabled:YES];
                    [_FS Reset];
                    
                    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                    [v removeFromSuperview];
                    v = Nil;
                    
                    if (previousPath == Nil) {
                        previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                    }
                    
                    [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    selectedPath = previousPath;
                    spinner_SI = Nil;
                    
                    [_delegate showReportCantDisplay:[PremiumViewController getMsgTypeL100] ];
                });
            }            
        });        
    }   
}

//added by Edwin 25-09-2013
- (void) exportPDS
{
    PDSorSI = @"PDS";
    if ([getOccpCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL) {
            NSString *RevisedSumAssured = appDel.MhiMessage;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ will be increase to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.",MHI_MSG_TYPE,RevisedSumAssured]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            RevisedSumAssured = Nil;
        }
                
        if (_FS == Nil) {
            self.FS = [FSVerticalTabBarController alloc];
            _FS.delegate = self;
        }        
        [_FS Test ];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{			
            PremiumViewController *premView = [[PremiumViewController alloc] init ];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = TRUE;
            [premView calculateReport];
            _delegate = premView;
            premView = Nil;
            
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            BOOL showReport = false;
            
            if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                showReport = del.allowedToShowReport;
            }
            
            if (showReport ) {
                CashPromiseViewController *CPReportPage;
                if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                    CPReportPage = [[CashPromiseViewController alloc] init ];
                    CPReportPage.SINo = getSINo;
                    CPReportPage.PDSorSI = @"PDS";
                    CPReportPage.pPlanCode = getBasicPlan;
                    CPReportPage.lang = lang;
                    CPReportPage.need2PagesUnderwriting = need2PagesUnderwriting;
                    CPReportPage.reportType = reportType;
                    CPReportPage.paymentOption = getMOP;
                    [CPReportPage calculateForReport];
                    [premView dismissViewControllerAnimated:NO completion:nil];
                    [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                }
                
                PDSViewController *PDSPage = [[PDSViewController alloc ] init ];
                PDSPage.SINo = getSINo;
                if ([lang isEqualToString:@"Malay"]) {
                    PDSPage.PDSLanguage = @"M";
                } else {
                    PDSPage.PDSLanguage = @"E";
                }
                
                PDSPage.PDSPlanCode = getBasicPlan;
                
                [CPReportPage dismissViewControllerAnimated:NO completion:^{
                    [self presentViewController:PDSPage animated:NO completion:Nil];
                }];
                
                [CPReportPage generateJSON_HLCP:YES];
                [CPReportPage copyReportFolderToDoc:@"PDS"];
                
                CPReportPage = Nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PDSPage dismissViewControllerAnimated:NO completion:Nil];                    
                    NSString *htmlPage = nil;
                    
                    if ([getBasicPlan isEqualToString:STR_S100]) {
                        if ([lang isEqualToString:@"Malay"])  {
                            htmlPage = @"PDS/PDS_BM_S100_Page1";
                        } else {
                            htmlPage = @"PDS/PDS_ENG_S100_Page1";
                        }
                    } else if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                        if ([lang isEqualToString:@"Malay"]) {
                            htmlPage = @"PDS/PDS_BM_HLAWP_Page1";
                        } else {
                            htmlPage = @"PDS/PDS_ENG_HLAWP_Page1";
                        }
                    }
                    
                    NSString *path = [[NSBundle mainBundle] pathForResource:htmlPage ofType:@"html"];
                    NSURL *pathURL = [NSURL fileURLWithPath:path];
                    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
                    
                    NSData* data = [NSData dataWithContentsOfURL:pathURL];
                    [data writeToFile:[NSString stringWithFormat:@"%@/PDS_Eng_Temp.html",documentsDirectory] atomically:YES];
                    
                    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"PDS_Eng_Temp.html"];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
                        NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                        // Converting HTML to PDF
                        NSString *SIPDFName = [NSString stringWithFormat:@"PDS_export_%@.pdf",self.getSINo];
                        self.PDFCreator = [NDHTMLtoPDF exportPDFWithURL:targetURL
                                                             pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                               delegate:self
                                                               pageSize:kPaperSizeA4
                                                                margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                        message:[@"Created " stringByAppendingPathComponent:SIPDFName]
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert show];
                        alert = Nil;
                        targetURL = nil, SIPDFName = nil;
                    }
                    
                    [_FS Reset];
                    path = nil,pathURL = nil,path_forDirectory = nil, documentsDirectory = nil, data = nil, HTMLPath =nil;
                });
                
                PDSPage = Nil;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Display/dismiss your alert
                    [self.view setUserInteractionEnabled:YES];
                    [_FS Reset];
                    
                    UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                    [v removeFromSuperview];
                    v = Nil;
                    
                    if (previousPath == Nil) {
                        previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                    }                    
                    [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    selectedPath = previousPath;
                    
                    [_delegate showReportCantDisplay:[PremiumViewController getMsgTypeL100] ];
                });
            }
        });
    }
}

- (void) checkMandatoryField{
    
}

/**
 Edwin 22-08-2013
 Switch language common function
 */
- (void) showQuotation
{
    reportType = REPORT_SI;
    PDSorSI = @"SI";
    if ([getOccpCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL  ) {
            NSString *RevisedSumAssured = appDel.MhiMessage;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ will be increase to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.",MHI_MSG_TYPE,RevisedSumAssured]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            RevisedSumAssured = Nil;
        }
 
        sqlite3_stmt *statement;
        BOOL cont = FALSE;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {            
            NSString *QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                                  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\", \"quotationLang\" from Trad_Details as A, "
                                  "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
                                  "A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    cont = TRUE;
                    lang = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                } else {
                    cont = FALSE;
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);            
        }
        
        if (_FS == Nil) {
            self.FS = [FSVerticalTabBarController alloc];
            _FS.delegate = self;
        }        
        
        if (cont == TRUE) {
            [self buildSpinner];            
            PremiumViewController *premView = [[PremiumViewController alloc] init ];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = TRUE;
            [premView calculateReport];
            _delegate = premView;
            premView = Nil;
            
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                BOOL showReport = false;
                
                if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                    showReport = del.allowedToShowReport;
                }
                
                if (showReport ) {
                    CashPromiseViewController *CPReportPage;
                    if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                        CPReportPage = [[CashPromiseViewController alloc] init ];
                        CPReportPage.isNotSummary = TRUE;
                        CPReportPage.SINo = getSINo;
                        CPReportPage.PDSorSI = @"SI";
                        CPReportPage.pPlanCode = getBasicPlan;
                        CPReportPage.lang = lang;
                        CPReportPage.need2PagesUnderwriting = need2PagesUnderwriting;
                        CPReportPage.reportType = reportType;
                        CPReportPage.paymentOption = getMOP;
                        [CPReportPage calculateForReport];
                        [premView dismissViewControllerAnimated:NO completion:nil];
                    }
                    
                    [CPReportPage generateJSON_HLCP:NO];
                    [CPReportPage copyReportFolderToDoc:@"SI"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP])
                        {
                            if (CPReportPage.TotalCI > 4000000) {
                                [spinner_SI stopAnimating ];
                                [self.view setUserInteractionEnabled:YES];
                                [_FS Reset];
                                
                                UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                                [v removeFromSuperview];
                                v = Nil;
                                
                                if (previousPath == Nil) {
                                    previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                                }
                                
                                [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                selectedPath = previousPath;
                                spinner_SI = Nil;
                                
                                NSString *strCIRiders = @"";
                                
                                for (int i = 0; i < CPReportPage.CIRiders.count; i++) {
                                    strCIRiders = [strCIRiders stringByAppendingFormat:@"\n%d. %@", i + 1, [CPReportPage.CIRiders objectAtIndex:i]];
                                }
                                
                                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                                message:[ NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                                                                         "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 1st Life Assured"
                                                                                         " has exceeded RM4mil. %@", strCIRiders]
                                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [Alert show];
                                Alert = nil;
                                
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                                
                                return;
                            } else if (CPReportPage.TotalCI2 > 4000000) {
                                [spinner_SI stopAnimating ];
                                [self.view setUserInteractionEnabled:YES];
                                [_FS Reset];
                                
                                UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                                [v removeFromSuperview];
                                v = Nil;
                                
                                if (previousPath == Nil) {
                                    previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                                }
                                
                                [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                selectedPath = previousPath;
                                spinner_SI = Nil;
                                
                                NSString *strCIRiders2 = @"";
                                
                                for (int i = 0; i < CPReportPage.CIRiders2.count; i++) {
                                    strCIRiders2 = [strCIRiders2 stringByAppendingFormat:@"\n%d. %@", i + 1, [CPReportPage.CIRiders2 objectAtIndex:i]];
                                }
                                
                                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                                message:[ NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                                                                         "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 2nd Life Assured"
                                                                                         " has exceeded RM4mil. %@", strCIRiders2]
                                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [Alert show];
                                Alert = nil;
                                
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                                
                                return;
                            } else {
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                            }                            
                        }
                                                
                        NSString *path = nil;                        
                        if ([lang isEqualToString:@"Malay"])
                        {
                            if ([getBasicPlan isEqualToString:STR_S100]) {
                                    path = [[NSBundle mainBundle] pathForResource:@"SI/mly_S100_Page1" ofType:@"html"];
                            }  else if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/mly_HLAWP_Page1" ofType:@"html"]; 
                            }
                        } else {
                            if ([getBasicPlan isEqualToString:STR_S100]) {
                                    path = [[NSBundle mainBundle] pathForResource:@"SI/eng_S100_Page1" ofType:@"html"]; //changed for language switcher @edwin 4-9-2013
                            }  else if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/eng_HLAWP_Page1" ofType:@"html"]; //changed for language switcher @edwin 4-9-2013
                            }
                        }
                        
                        NSURL *pathURL = [NSURL fileURLWithPath:path];
                        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
                        
                        NSData* data = [NSData dataWithContentsOfURL:pathURL];
                        [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
                        
                        NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {                            
                            NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                            // Converting HTML to PDF
                            NSString *SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
                            self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                                                 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                                   delegate:self
                                                                   pageSize:kPaperSizeA4
                                                                    margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                        }
                    });
                    
                    CPReportPage = Nil;
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Display/dismiss your alert
                        [spinner_SI stopAnimating ];
                        [self.view setUserInteractionEnabled:YES];
                        [_FS Reset];
                        
                        UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                        [v removeFromSuperview];
                        v = Nil;
                        
                        if (previousPath == Nil) {
                            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                        }
                        
                        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        selectedPath = previousPath;
                        spinner_SI = Nil;

                        [_delegate showReportCantDisplay:[PremiumViewController getMsgTypeL100] ];
                    });
                }
            });            
        } else {            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"SI has been deleted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
            [alert show];
            alert = Nil;            
        }        
        statement = Nil;
    }    
}


- (void) showSummaryQuotation
{
    reportType = REPORT_SI;
    PDSorSI = @"SI";
    if ([getOccpCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    } else if (([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) && getAge > 65 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 65 for this product."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        if (previousPath == Nil) {
            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        if (![appDel.MhiMessage isEqualToString:@""] && appDel.MhiMessage != NULL  ) {
            NSString *RevisedSumAssured = appDel.MhiMessage;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ will be increase to RM%@ in accordance to MHI Guideline. The RSA for non-MHI rider(s) (if any) have been increased accordingly as well.",MHI_MSG_TYPE,RevisedSumAssured]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            RevisedSumAssured = Nil;
        }
        
        sqlite3_stmt *statement;
        BOOL cont = FALSE;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            NSString *QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
                                  "\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",  \"sex\", \"quotationLang\" from Trad_Details as A, "
                                  "Clt_Profile as B, trad_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
                                  "A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    cont = TRUE;
                    lang = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                } else {
                    cont = FALSE;
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        if (_FS == Nil) {
            self.FS = [FSVerticalTabBarController alloc];
            _FS.delegate = self;
        }
        
        if (cont == TRUE) {
            [self buildSpinner];
            PremiumViewController *premView = [[PremiumViewController alloc] init ];
            premView.requestAge = getAge;
            premView.requestOccpClass = getOccpClass;
            premView.requestOccpCode = getOccpCode;
            premView.requestSINo = getSINo;
            premView.requestMOP = getMOP;
            premView.requestTerm = getTerm;
            premView.requestBasicSA = getbasicSA;
            premView.requestBasicHL = getbasicHL;
            premView.requestBasicTempHL = getbasicTempHL;
            premView.requestPlanCode = getPlanCode;
            premView.requestBasicPlan = getBasicPlan;
            premView.sex = getSex;
            premView.EAPPorSI = [self.EAPPorSI description];
            premView.fromReport = TRUE;
            [premView calculateReport];
            _delegate = premView;
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            premView = Nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                BOOL showReport = false;
                
                if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                    showReport = del.allowedToShowReport;
                } 
                
                if (showReport ) {
                    CashPromiseViewController *CPReportPage;
                    
                    if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                        CPReportPage = [[CashPromiseViewController alloc] init ];
                        CPReportPage.isNotSummary = FALSE;
                        CPReportPage.SINo = getSINo;
                        CPReportPage.PDSorSI = @"SI";
                        CPReportPage.pPlanCode = getBasicPlan;
                        CPReportPage.lang = lang;
                        CPReportPage.need2PagesUnderwriting = need2PagesUnderwriting;
                        CPReportPage.reportType = reportType;
                        CPReportPage.paymentOption = getMOP;
                        [CPReportPage calculateForReport];
                        [premView dismissViewControllerAnimated:NO completion:nil];
                    }
                    
                    [CPReportPage generateJSON_HLCP:NO];
                    [CPReportPage copyReportFolderToDoc:@"SI"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([getBasicPlan isEqualToString:STR_S100] || [getBasicPlan isEqualToString:STR_HLAWP]) {
                            if (CPReportPage.TotalCI > 4000000) {
                                [spinner_SI stopAnimating ];
                                [self.view setUserInteractionEnabled:YES];
                                [_FS Reset];
                                
                                UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                                [v removeFromSuperview];
                                v = Nil;
                                
                                if (previousPath == Nil) {
                                    previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                                }
                                
                                [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                selectedPath = previousPath;
                                spinner_SI = Nil;
                                
                                NSString *strCIRiders = @"";
                                
                                for (int i = 0; i < CPReportPage.CIRiders.count; i++) {
                                    strCIRiders = [strCIRiders stringByAppendingFormat:@"\n%d. %@", i + 1, [CPReportPage.CIRiders objectAtIndex:i]];
                                }
                                
                                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                                message:[ NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                                                                         "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 1st Life Assured"
                                                                                         " has exceeded RM4mil. %@", strCIRiders]
                                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [Alert show];
                                Alert = nil;
                                
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                                
                                return;
                            } else if (CPReportPage.TotalCI2 > 4000000) {
                                [spinner_SI stopAnimating ];
                                [self.view setUserInteractionEnabled:YES];
                                [_FS Reset];
                                
                                UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                                [v removeFromSuperview];
                                v = Nil;
                                
                                if (previousPath == Nil) {
                                    previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                                }
                                
                                [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                selectedPath = previousPath;
                                spinner_SI = Nil;
                                
                                NSString *strCIRiders2 = @"";
                                
                                for (int i = 0; i < CPReportPage.CIRiders2.count; i++) {
                                    strCIRiders2 = [strCIRiders2 stringByAppendingFormat:@"\n%d. %@", i + 1, [CPReportPage.CIRiders2 objectAtIndex:i]];
                                }
                                
                                UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                                message:[ NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                                                                         "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 2nd Life Assured"
                                                                                         " has exceeded RM4mil. %@", strCIRiders2]
                                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [Alert show];
                                Alert = nil;
                                
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                                
                                return;
                            } else {
                                [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
                            }
                        } 
                        
                        NSString *path = nil;
                        if ([lang isEqualToString:@"Malay"]) {
                            if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/mly_HLAWP_Page1" ofType:@"html"];
                            } else if ([getBasicPlan isEqualToString:STR_S100]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/mly_S100_Page1" ofType:@"html"];
                            } 
                        }
                        else
                        {
                            if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/eng_HLAWP_Page1" ofType:@"html"]; //changed for language switcher @edwin 4-9-2013
                            } else if ([getBasicPlan isEqualToString:STR_S100]) {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/eng_S100_Page1" ofType:@"html"]; //changed for language switcher @edwin 4-9-2013
                            }
                            
                            else if([getBasicPlan isEqualToString:@"BCALH"] )
                            {
                                path = [[NSBundle mainBundle] pathForResource:@"SI/eng_BCALH_Page1" ofType:@"html"]; //changed for language switcher @edwin 4-9-2013
                            }

                        }
                        
                        NSURL *pathURL = [NSURL fileURLWithPath:path];
                        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
                        
                        NSData* data = [NSData dataWithContentsOfURL:pathURL];
                        [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
                        
                        NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
                        if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
                            NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
                            // Converting HTML to PDF
                            NSString *SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
                            self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                                                 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                                                   delegate:self
                                                                   pageSize:kPaperSizeA4
                                                                    margins:UIEdgeInsetsMake(0, 0, 0, 0)];
                        }
                    });
                    
                    CPReportPage = Nil;
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Display/dismiss your alert
                        [spinner_SI stopAnimating ];
                        [self.view setUserInteractionEnabled:YES];
                        [_FS Reset];
                        
                        UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
                        [v removeFromSuperview];
                        v = Nil;
                        
                        if (previousPath == Nil) {
                            previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
                        }
                        
                        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        selectedPath = previousPath;
                        spinner_SI = Nil;
                        
                        [_delegate showReportCantDisplay:[PremiumViewController getMsgTypeL100] ];
                    });
                }
            });
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"SI has been deleted" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
            [alert show];
            alert = Nil;
        }
        statement = Nil;
    }    
}

-(void)setIsSecondLaNeeded:(BOOL)temp
{
    isSecondLaNeeded = temp;
}

-(BOOL)savePage:(int)option//validate then save page
{
    int result;
    switch (option) {
        case SIMENU_LIFEASSURED:
            if ([self.LAController validateSave]) {
                return[self.LAController performSaveData];
            }
            break;
        case SIMENU_SECOND_LIFE_ASSURED:
            if (isSecondLaNeeded) {
				self.SecondLAController.requestSINo = getSINo;
                if ([self.SecondLAController validateSave]) {
                    return[self.SecondLAController performUpdateData];
                }
            } else {
                return YES; //added in to return true if SECOND LA is not added, if not it will continue to stuck at 2nd LA page 
            }
            break;
        case SIMENU_PAYOR:
            if (self.PayorController && [self.PayorController isPayorSelected]) {
                if ([self.PayorController validateSave]) {
                    return[self.PayorController performSavePayor];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                return NO;
            }
            break;
        case SIMENU_BASIC_PLAN:			
            if (self.BasicController && [self.BasicController isBasicPlanSelected]) {
                result = [self.BasicController validateSave];
                if (result == 0) {
                    if (isSaveBasicPlan) {                        
                        return[self.BasicController checkingSave:getSex];
                    } else {
                        return YES;
                    }
                } else if (result == SIMENU_HEALTH_LOADING) {
                    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_HEALTH_LOADING inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                    selectedPath = [NSIndexPath indexPathForRow:SIMENU_HEALTH_LOADING inSection:0];
                    [self loadHLPage];
                    return NO;
                }
            } else {
                return YES;
            }			
            break;            
        case SIMENU_HEALTH_LOADING:
            if ([self.HLController validateSave]) {
                return [self.HLController updateHL];
            }
            break;            
        case SIMENU_RIDER:
        case SIMENU_PREMIUM:
        case SIMENU_QUOTATION:
        case SIMENU_SUMMARY_QUOTATION:
        case SIMENU_PRODUCT_DISCLOSURE_SHEET:
        case SIMENU_PDS_SAVE_AS:
            return YES;
            break;
        default:
            break;
    }	
    return NO;
}

#pragma mark - GET SI AND CUSTCODE
-(void)getRunningSI
{
    sqlite3_stmt *statement;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"SI\" AND LastUpdated like \"%%%@%%\"", dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                SILastNo = sqlite3_column_int(statement, 0);
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                SIDateSIMenu = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
            } else {
                SILastNo = 0;
                SIDateSIMenu = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
    [self updateFirstRunSI];
}

-(void)getRunningCustCode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\" AND LastUpdated like \"%%%@%%\" ",dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustLastNo = sqlite3_column_int(statement, 0);
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                CustDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];              
            } else {
                CustLastNo = 0;
                CustDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
    [self updateFirstRunCust];
}

-(void)updateFirstRunSI
{
    int newLastNo;
    newLastNo = SILastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated=\"%@\" WHERE TrnTypeCode=\"SI\"",newLastNo, dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateSecondRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 2;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


#pragma mark - Save As
-(BOOL)saveAs
{
    BOOL success = NO;
    
    [self getSINoAndCustCode];
    [self getRunningSI];
    
    //CONTINUE DUPLICATE SI FOR SAVE AS WITH FROM LAPAYOR
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSMutableArray * arrTempLAPayor = [[NSMutableArray alloc]init];
    
    NSString* sqlStatement;
    
    sqlStatement = [NSString stringWithFormat:@"SELECT * from Trad_LAPayor WHERE SINo = '%@'",[self.getSINo description]];
    [self retrieveRowFromDB:sqlStatement arrOfLaPayor:arrTempLAPayor];
    
    [self insertDuplicateSIData:arrTempLAPayor];
    return success;
}

-(void)insertDuplicateSIData:(NSArray*)arr
{
    NSString* sqlStatement;
    NSMutableDictionary* dict;
    for (int i =0; i< [arr count]; i++) {
        sqlStatement = @"INSERT INTO Trad_LAPayor VALUES (";        
        dict = [arr objectAtIndex:i];
        
        for (int j = 0; j<[dict count]; j++) {            
            if (j == [dict count]-1) {
                sqlStatement = [NSString stringWithFormat:@"%@ '%@')",sqlStatement,[dict objectForKey:[NSString stringWithFormat:@"key%d",j]]];
            } else {
                sqlStatement = [NSString stringWithFormat:@"%@ '%@',",sqlStatement,[dict objectForKey:[NSString stringWithFormat:@"key%d",j]]];
            }            
        }
    }	
}

-(NSString*) getRunningCust:(NSString*)currentdate
{
    CustLastNo++;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", CustLastNo];
    NSString* custCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    return custCode;
}

-(BOOL)SaveAsTemp{ //save as new SI
	
    NSString * firstCustCode = [self getSINoAndCustCode];
    NSString * secondCustCode = [self getSINoAndCustCode2nd];
    NSString * pYCustCode = [self getSINoAndCustCodePY];
    [self getRunningSI];
    [self getRunningCustCode];
    
    if (secondCustCode.length > 0) { //update clt_profile to prevent duplicate issue by increase CL counter
        [self updateSecondRunCust];
    }
    
    if (pYCustCode.length > 0) {
        [self updateSecondRunCust];
    }

    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoSI = SILastNo + 1;        
    NSString *fooSI = [NSString stringWithFormat:@"%04d", runningNoSI];
    
    getSINo = [[NSString alloc] initWithFormat:@"SI%@-%@",currentdate,fooSI];    
    
    NSString* currSINo = saveAsSINo;
    NSString* nextSiNo = getSINo ;
    NSString* nextCustCode = nil;
		
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        nextCustCode = [self getRunningCust:currentdate];
        [self create1stLA:currSINo currCustCode:firstCustCode currentdate:currentdate nextSiNo:nextSiNo nextCustCode:nextCustCode];
        [self createCltProfile:nextCustCode currCustCode:firstCustCode];
        
        nextCustCode = [self getRunningCust:currentdate];
        [self create2ndLA:currSINo nextSiNo:nextSiNo currentdate:currentdate nextCustCode:nextCustCode];
        [self createCltProfile:nextCustCode currCustCode:secondCustCode];
        
        [self createPYLA:currSINo nextSiNo:nextSiNo currentdate:currentdate nextCustCode:nextCustCode];
        [self createCltProfile:nextCustCode currCustCode:pYCustCode];
        
        [self createTradDetails:currSINo nextSiNo:nextSiNo];
        [self createSIStorePrem:currSINo nextSiNo:nextSiNo];
        
        sqlite3_close(contactDB);
    }
        
    NSMutableArray *ridersArr = nil;    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {  
        ridersArr = [self getRiders:currSINo];
        sqlite3_close(contactDB);
    }
        
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {     
        for (NSString * rider in ridersArr) {
            [self createRiders:rider currSINo:currSINo nextSiNo:nextSiNo];
        }
        sqlite3_close(contactDB);
    }
    return YES;
}

- (NSString *)generateSINO{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
   // [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    [dateFormatter setDateFormat:@"YYMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    
    NSString *_AgentCode;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"hladb.sqlite"];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    results = [database executeQuery:@"select AgentCode,AgentName from Agent_profile"];
    if (![database open]) {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
        
    {
        _AgentCode  = [results stringForColumn:@"AgentCode"];
    }
    
    
    return [NSString stringWithFormat:@"%@%@",_AgentCode,dateString];
}



- (IBAction)SaveTapped:(UIButton *)sender{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Konfirmasi" message:@"Anda yakin untuk menduplikat data?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"cancel", nil];
    alert.tag = 5000;
    [alert show];
}


-(void)createTradDetails:(NSString*) currSINo nextSiNo:(NSString*)nextSiNo
{
    NSString * tableName = @"Trad_Details";    
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\"",tableName,currSINo];    
    bool success = [self sqlStatement:createSQL];
    
    if (success) {
        createSQL = @"UPDATE tmp SET SINo ='0'";
        success = [self sqlStatement:createSQL];
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\", createdAt = datetime(\"now\", \"+8 hour\") WHERE SINo='0'",
                                 tableName,nextSiNo];
                    [self sqlStatement:createSQL];
                }
            }
        }
    }
    //==============  end of update trad_details ==================
}


-(void)createSIStorePrem:(NSString*) currSINo nextSiNo:(NSString*)nextSiNo
{
    NSString * tableName = @"SI_Store_premium";    
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\"",tableName,currSINo];
    
    bool success = [self sqlStatement:createSQL];
    if (success) {
        createSQL = @"UPDATE tmp SET SINo ='0'";
        success = [self sqlStatement:createSQL];
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\" WHERE SINo='0'",tableName,nextSiNo];
                    
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }    
}

-(void) create1stLA:(NSString*)currSINo currCustCode:(NSString*)currCustCode currentdate:(NSString *)currentdate nextSiNo:(NSString*)nextSiNo nextCustCode:(NSString*)nextCustCode
{
    NSString * tableName = @"Trad_LAPayor";
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\" AND CustCode=\"%@\" LIMIT 1 ",
                            tableName,currSINo,currCustCode];
    bool success = [self sqlStatement:createSQL];
    
    if (success) {
        createSQL = @"UPDATE tmp SET SINo ='0'";
        success = [self sqlStatement:createSQL];
        
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\", CustCode=\"%@\" WHERE SINo='0'",
                                 tableName,nextSiNo,nextCustCode];
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }//end first success statement
    
    //=======duplicate data in Clt_profile with next SINo ===========   
}

-(void) create2ndLA:(NSString *) currSINo nextSiNo:(NSString*)nextSiNo currentdate:(NSString*)currentdate nextCustCode:(NSString*)nextCustCode
{
    //duplicate data in 2ndLA trad_LAPayor with next SINo and CustCode
    
    NSString * tableName = @"Trad_LAPayor";    
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\" AND sequence='2' ",
                            tableName,currSINo];
    bool success = [self sqlStatement:createSQL];
    
    if (success) {
        createSQL = @"UPDATE tmp SET SINo ='0'";
        success = [self sqlStatement:createSQL];
        
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\", CustCode=\"%@\" WHERE SINo='0'",
                                 tableName,nextSiNo,nextCustCode];
                    
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }//end first success statement
    
    //=======duplicate data in 2ndLA Clt_profile with next SINo ===========   
}

-(void) createPYLA:(NSString *) currSINo nextSiNo:(NSString*)nextSiNo currentdate:(NSString*)currentdate nextCustCode:(NSString*)nextCustCode
{
    NSString * tableName = @"Trad_LAPayor";   
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\" AND PtypeCode='PY' ",
                            tableName,currSINo];
    bool success = [self sqlStatement:createSQL];    
    if (success) {
        createSQL = @"UPDATE tmp SET SINo ='0'";
        success = [self sqlStatement:createSQL];        
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\", CustCode=\"%@\" WHERE SINo='0'",
                                 tableName,nextSiNo,nextCustCode];
                    
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }//end first success statement
    
    //=======duplicate data in Payor Clt_profile with next SINo =========== 
}


-(void) createCltProfile:(NSString*)nextCustCode currCustCode:(NSString*)currCustCode
{
    NSString * tableName = @"Clt_Profile";    
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where CustCode=\"%@\"",
                            tableName,currCustCode];    
    bool success = [self sqlStatement:createSQL];    
    if (success) {
        createSQL = [NSString stringWithFormat:@"UPDATE tmp SET CustCode ='0', id = ((Select max(id) from %@)+1)",tableName];
        success = [self sqlStatement:createSQL];
        
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET CustCode=\"%@\" WHERE CustCode='0'",tableName,nextCustCode];
                    
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }    
    //=================end duplicate clt profile==============
}

-(void) createRiders:(NSString*) curRider currSINo:(NSString *) currSINo nextSiNo:(NSString*) nextSiNo
{
    int indexNo = [self getLastRunningTradRiderIndex];
    indexNo++;
    
    NSString * tableName = @"Trad_Rider_Details";    
    NSString * createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where SINo=\"%@\" and RiderCode=\"%@\"",
                            tableName,currSINo,curRider];        
    bool success = [self sqlStatement:createSQL];    
    if (success) {
        createSQL = [NSString stringWithFormat:@"UPDATE tmp SET SINo ='0',indexNo='%d'", indexNo];
        success = [self sqlStatement:createSQL];
        
        if (success) {
            createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
            success = [self sqlStatement:createSQL];
            
            if (success) {
                createSQL = @"DROP TABLE tmp";
                [self sqlStatement:createSQL];
                
                if (success) {
                    createSQL = [NSString stringWithFormat:@"UPDATE %@ SET SINo=\"%@\" WHERE SINo='0' and RiderCode=\"%@\"",tableName,nextSiNo,curRider];
                    
                    [self sqlStatement:createSQL];
                }
            }
        }        
    }   
}

-(int)getLastRunningTradRiderIndex
{
    int toReturn = -1;
    sqlite3_stmt *statement;        
    NSString *querySQL = @"select indexNo from trad_rider_details order by indexNo desc limit 1";
    
    if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            toReturn = sqlite3_column_int(statement, 0);
        }        
        sqlite3_finalize(statement);
    }    
    querySQL = Nil;	
	statement = Nil;
    
    return toReturn;
}


-(NSMutableArray*)getRiders:(NSString*) currSINo
{
    NSMutableArray* temp = [ [NSMutableArray alloc] init];
    sqlite3_stmt *statement;        
    NSString *sqlStmt  = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' ORDER BY RiderCode ASC ",currSINo];
            
    if (sqlite3_prepare_v2(contactDB, [sqlStmt UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString * toReturn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            [temp addObject:toReturn];
        }        
        sqlite3_finalize(statement);
    }
    sqlStmt = Nil;    
	statement = Nil;
    return temp;
}


-(BOOL)sqlStatement:(NSString*)querySQL
{
    BOOL success = YES;
    sqlite3_stmt *statement;
    
    int status = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) ;
	if ( status == SQLITE_OK) {
        int errorCode = sqlite3_step(statement);
		success = errorCode == SQLITE_DONE;
		sqlite3_finalize(statement);
	}
    return  success;
}

#pragma mark - Switch page control
-(void)isSaveBasicPlan:(BOOL)temp
{
    isSaveBasicPlan = temp;
}

-(void)deleteSecondLAFromDB
{
    if (_SecondLAController) {
        [self.SecondLAController deleteLA];
    }
}

-(BOOL)validatePage:(NSIndexPath *)indexPath//check for each page validation before change page
{
    // temporary work around (a plan must be selected before any other menu items can be selected).
    if (self.BasicController.planChoose == NULL && indexPath.row != SIMENU_BASIC_PLAN) {
        if (previousPath.row == SIMENU_BASIC_PLAN || previousPath.row == SIMENU_SECOND_LIFE_ASSURED || previousPath.row == SIMENU_PAYOR) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select a plan."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
            return NO;
        }
    } else if (selectedPath.row == SIMENU_BASIC_PLAN && self.BasicController.isFirstSaved) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please save the selected plan."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = Nil;
        return NO;
    }
    
    switch (selectedPath.row) {
        case SIMENU_LIFEASSURED:
            if (self.LAController) {
                if ([self.LAController validateSave]) {
                    if (self.BasicController) {
                        // HACK
                        self.BasicController.ageClient = getAge;
                        [self.BasicController reloadPaymentOption];
                    }
                    return[self.LAController performSaveData];
                } else {
					[self UpdateSIToInvalid];
				}
            }
            break;
        case SIMENU_SECOND_LIFE_ASSURED:
            self.SecondLAController.requestSINo = getSINo;
            if (self.SecondLAController) {
                if (isSecondLaNeeded && ![self.SecondLAController.nameField.text isEqualToString:@""]) {
                    if ([self.SecondLAController validateSave]) {
                        return[self.SecondLAController performUpdateData];
                    } else {
						[self UpdateSIToInvalid];
					}
                } else {                    
                    UITableViewCell* secondLACell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
					secondLACell.detailTextLabel.text = @"";
                    return YES;
                }
            } else {
                return YES;
            }
            break;
        case SIMENU_PAYOR:
            if (self.PayorController) {
                return [self.PayorController performSavePayor];
            } else {
                return YES;
            }
            break;
        case SIMENU_BASIC_PLAN:
            if (self.BasicController && [self.BasicController isBasicPlanSelected]) {
                int validate = [self.BasicController validateSave];
                if (validate == 0) {
                    if (isSaveBasicPlan) {
                        [self.HLController loadHL];
                        [self.RiderController clearField];
                        [self.BasicController checkingExisting];
                        return[self.BasicController checkingSave:getSex];
                    } else {
                        return YES;
                    }                    
                } else if (validate == SIMENU_HEALTH_LOADING) {
                    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_HEALTH_LOADING inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    
                    selectedPath = [NSIndexPath indexPathForRow:SIMENU_HEALTH_LOADING inSection:0];
                    [self loadHLPage];
                    return NO;
                } else {
					[self UpdateSIToInvalid];
				}
            } else {
                return YES;
            }
            break;
        case SIMENU_HEALTH_LOADING:
            if ([self.HLController validateSave]) {
				return [self.HLController updateHL];
            } else {
				[self UpdateSIToInvalid];
			}
            break;            
        case SIMENU_RIDER:
            return YES;
            break;
        case SIMENU_PREMIUM:
        case SIMENU_QUOTATION:
        case SIMENU_SUMMARY_QUOTATION:
        case SIMENU_PDS_SAVE_AS:			
            return  YES;            
        default:
            break;
    }
    return NO;
}

-(void)saveAll
{    
    /*NSString* msg = @"Simpan perubahan?";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
    [alert setTag:3001];
    [alert show];*/
    
    NSString *PlanType = [dictionaryPOForInsert valueForKey:@"ProductName"];
    
    if([PlanType isEqualToString:@"BCA Life Heritage Protection"])
    {
        if (!_PremiumController) {
            _PremiumController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
            _PremiumController.delegate = self;
            _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
            [self.RightView addSubview:_PremiumController.view];
        }else{
            [_PremiumController.view removeFromSuperview];
            [self.RightView addSubview:_PremiumController.view];
        }
        [_PremiumController setPremiumDictionary:newDictionaryForBasicPlan];
        _PremiumController.requestSINo = [dictionaryPOForInsert valueForKey:@"SINO"];
        [self.RightView bringSubviewToFront:_PremiumController.view];
    }
    else
    {
        PremiumKeluargaku *premiK = [[PremiumKeluargaku alloc]initWithNibName:@"PremiumKeluargaku"
                                                                       bundle:nil SINO:[dictionaryPOForInsert valueForKey:@"SINO"]];
        premiK.delegate = self;
        [premiK setDictionaryPOForInsert:dictionaryPOForInsert];
        [premiK setDictionaryForBasicPlan:newDictionaryForBasicPlan];
        [self addChildViewController:premiK];
        [self.RightView addSubview:premiK.view];
        [self.RightView bringSubviewToFront:premiK.view];
    }
}

#pragma mark - delegate FSVerticalTabBarController

- (void)tabBarController:(FSVerticalTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{   
}

#pragma mark - handle FSvertical Bar save or revert

-(BOOL)RevertSIStatus // revert SI status back to original IF there are no changes to SI
{
    if (![[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        if ([SIStatus isEqualToString:@"VALID"]) {
            [self UpdateSIToValid:TRUE];
        }
    }
    return TRUE;
}

-(BOOL)performSaveSI:(BOOL)saveChanges
{	
    return[self isNeedSaveChanges:saveChanges];    
}

- (void)savePremium{
    [self setSaveAsMode:[dictionaryPOForInsert valueForKey:@"SINO"]];
    [self LoadIlustrationPage];
    
}

#pragma mark - copy object from diff tab
-(BOOL)storeDBIntoObj:(NSMutableDictionary*)dict sqlStatement:(NSString*)sqlQuery
{
    BOOL success = NO;
    sqlite3_stmt *statement;    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {                
                if ([flagForCustomer isEqualToString:@"LA"]) {
					custCodeForLA   = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
					
                } else if ([flagForCustomer isEqualToString:@"secondLA"]) {
                    custCodeForLATwo   = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
					
                } else if ([flagForCustomer isEqualToString:@"payor"]) {
                    custCodeForPayor   = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
					
                }
                
                int rowCount = sqlite3_column_count(statement);
                NSString* obj;
                for (int i = 0; i<rowCount; i++) {
                    if (sqlite3_column_text(statement, i) == nil) {
                        obj = @"";                        
                    } else {                        
                        obj = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
                    }                    
                    [dict setObject:obj forKey:[NSString stringWithFormat:@"key%d",i]];
                }
                success = YES;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
    return success;
}

-(NSMutableArray*)getTableHeader:(NSString*)tableName
{	
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    NSString *sqlQUERY = [NSString stringWithFormat:@"PRAGMA table_info(%@);",tableName];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {		
        if (sqlite3_prepare_v2(contactDB, [sqlQUERY UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {				
                [arr addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];				
            }			
			sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return arr;
}

-(BOOL)performActionOnDB:(NSString*)sqlQuery//sql update delete etc
{
    sqlite3_stmt *statement;
    BOOL success = NO;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {        
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {            
            success = sqlite3_step(statement) == SQLITE_DONE;
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return success;
}

-(BOOL)retrieveRowFromDB:(NSString*)sqlQuery arrOfLaPayor:(NSMutableArray*)array//sql update delete etc
{
    sqlite3_stmt *statement;    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {            
            NSMutableDictionary * dict;
            NSString* obj;
            int i, rowCount;
            while(sqlite3_step(statement) == SQLITE_ROW) {
                dict = [[NSMutableDictionary alloc]init];				
                rowCount = sqlite3_column_count(statement);
                for (i = 0; i<rowCount; i++) {                    
                    if (sqlite3_column_text(statement, i) == nil) {
                        obj = @"";                        
                    } else {                        
                        obj = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
                    }                    
                    [dict setObject:obj forKey:[NSString stringWithFormat:@"key%d",i]];
                }
                [array addObject:dict];
            }
			sqlite3_finalize(statement);            
        }
		sqlite3_close(contactDB);
    }
    return YES;
}

-(BOOL)retrieveRowFromDBTwo:(NSString*)sqlQuery dictionary:(NSMutableDictionary*)dict//sql update delete etc
{
    sqlite3_stmt *statement;    
    BOOL success = NO;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {       
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                int rowCount = sqlite3_column_count(statement);                
                NSString* obj;
                for (int i = 0; i<rowCount; i++) {                    
                    if (sqlite3_column_text(statement, i) == nil) {
                        obj = @"";                        
                    } else {                        
                        obj = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
                    }                    
                    [dict setObject:obj forKey:[NSString stringWithFormat:@"key%d",i]];
                }
                success = YES;
            }
			sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return success;
}

-(BOOL)requestCustCodeFromDB:(NSString*)sqlQuery CustCode:(NSMutableArray*)arrCustomerCodeTemp
{
    sqlite3_stmt* statement;
    BOOL success = NO;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [arrCustomerCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                success = YES;
            }            
            sqlite3_finalize(statement);
        }        
        sqlite3_close(contactDB);
        
    }
    return success;
}

-(BOOL)requestRiderCodeFromDB:(NSString*)sqlQuery
{
    arrRiderCode = [[NSMutableArray alloc]init];
    
    sqlite3_stmt* statement;
    BOOL success = NO;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(contactDB, [sqlQuery UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [arrRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                success = YES;
            }            
            sqlite3_finalize(statement);
        }        
        sqlite3_close(contactDB);
        
    }
    return success;
}

-(void)storeLAValues//to store for revert
{
    arrTempLA = [[NSMutableArray alloc]init];
    arrTempLATwo = [[NSMutableArray alloc]init];
    dictBP = [[NSMutableDictionary alloc]init];
    arrTempRider = [[NSMutableArray alloc]init];
	
    NSString* sqlStatement;
	
    NSString * tempSINo = [self.getSINo description];
    arrCustomerCode = [[NSMutableArray alloc]init];
    sqlStatement = [NSString stringWithFormat:@"SELECT CustCode from Trad_LAPayor WHERE SINO = '%@'",tempSINo];
	
    [self requestCustCodeFromDB:sqlStatement CustCode:arrCustomerCode];
    
    sqlStatement = [NSString stringWithFormat:@"SELECT * from Trad_LAPayor WHERE SINO = '%@'",tempSINo];
	
    [self retrieveRowFromDB:sqlStatement arrOfLaPayor:arrTempLA];
    
    NSString* str;
    NSMutableDictionary* dictTempLA;
    for (int i =0; i< [arrCustomerCode count]; i++) {        
        str = [arrCustomerCode objectAtIndex:i];        
        sqlStatement = [NSString stringWithFormat:@"SELECT * from Clt_Profile WHERE CustCode = '%@'",str];
        dictTempLA = [[NSMutableDictionary alloc]init];
		
        if ([self retrieveRowFromDBTwo:sqlStatement dictionary:dictTempLA]) {
            [arrTempLATwo addObject:dictTempLA];
        }		
    }
    sqlStatement = [NSString stringWithFormat:@"SELECT * from Trad_Details WHERE SINo = '%@'",tempSINo];
	
    [self retrieveRowFromDBTwo:sqlStatement dictionary:dictBP];
    
    //===================rider===================
    sqlStatement = [NSString stringWithFormat:@"SELECT RiderCode from Trad_Rider_Details WHERE SINO = '%@'",tempSINo];
	
    [self requestRiderCodeFromDB:sqlStatement];    
    for (int i =0; i< [arrRiderCode count]; i++) {        
        str = [arrRiderCode objectAtIndex:i];        
        sqlStatement = [NSString stringWithFormat:@"SELECT * from Trad_Rider_Details WHERE SINo = '%@' AND RiderCode ='%@'",tempSINo,str];
        dictTempLA = [[NSMutableDictionary alloc]init];
        
        if ([self retrieveRowFromDBTwo:sqlStatement dictionary:dictTempLA]) {
            [arrTempRider addObject:dictTempLA];
        }        
    }	
}

-(void)deleteDBData
{
    NSString* tempSINo = [self.getSINo description];
    NSString* sqlStatement = [NSString stringWithFormat:@"DELETE from Trad_LAPayor WHERE SINo = '%@'",tempSINo];
    [self performActionOnDB:sqlStatement];	
    
    if (arrCustomerCode) {        
        for(int i =0; i<[arrCustomerCode count];i++) {
            sqlStatement = [NSString stringWithFormat:@"DELETE from Clt_Profile WHERE CustCode = '%@'",[arrCustomerCode objectAtIndex:i]];
            [self performActionOnDB:sqlStatement];
        }
    }    
    
    sqlStatement = [NSString stringWithFormat:@"DELETE from Trad_Details WHERE SINo = '%@'",tempSINo];
    [self performActionOnDB:sqlStatement];
    
    sqlStatement = [NSString stringWithFormat:@"DELETE from Trad_Rider_Details WHERE SINo = '%@'",tempSINo];
    [self performActionOnDB:sqlStatement];
    
}

-(BOOL)isNeedSaveChanges:(BOOL)saveChanges
{
    [self UpdateSIToInvalid];
    
    if (saveChanges) { 
        eAppCheckList*deleteOldPDF=[[eAppCheckList alloc] init];
        [deleteOldPDF deleteEAppCase:getSINo];
        deleteOldPDF = Nil;
        
        return [self validateSaveAllWithoutPrompt];
    }
    
    return YES;
}

#pragma mark - delegate source

-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker DiffClient:(BOOL)DiffClient bEDDCase:(BOOL)aaEDDCase
{
    getAge = aaAge;
    getSex = aaSex;
    getSmoker = aaSmoker;
    getOccpClass = aaOccpClass;
    getOccpCode = aaOccpCode;
    getCommDate = aaCommDate;
    getIdPay = aaIdPayor;
    getIdProf = aaIdProfile;
    getLAIndexNo = aaIndexNo;
    getEDD = aaEDDCase;
    
    if (DiffClient) {
        [self.SecondLAController deleteSecondLA];
        [self.PayorController deletePayor];
    }
    
    [self getLAName];
    [self.myTableView reloadData];
    int select = 0;
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        select = previousPath.row;
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        select = selectedPath.row;
    }
    
    if (select == 0) {
        [self.RightView addSubview:self.LAController.view];
    }
}

-(void)PayorIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    getPayorIndexNo = aaIndexNo;
    getPaySmoker = aaSmoker;
    getPaySex = aaSex;
    getPayDOB = aaDOB;
    getPayAge = aaAge;
    getPayOccp = aaOccpCode;
    
    [self getPayorName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)payorSaved:(BOOL)aaTrue
{
    payorSaved = aaTrue;
}

-(void)PayorDeleted
{
    [self clearDataPayor];
    [self getPayorName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if ([getBasicPlan isEqualToString:prevPlan]) {
        [self loadPayorPage];
    }
}

-(void)LA2ndIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    get2ndLAIndexNo = aaIndexNo;
    get2ndLASmoker = aaSmoker;
    get2ndLASex = aaSex;
    get2ndLADOB = aaDOB;
    get2ndLAAge = aaAge;
    get2ndLAOccp = aaOccpCode;
    
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }    
}

-(void)saved:(BOOL)aaTrue
{
    saved = aaTrue;
}

-(void)secondLADelete
{    
    [self clearData2ndLA];
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (selectedPath.row == SIMENU_SECOND_LIFE_ASSURED) {
        [self loadSecondLAPage];
    }
	
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    isSecondLaNeeded = NO;
}

-(void) getMHIMsgType
{
    MHI_MSG_TYPE = nil;
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        MHI_MSG_TYPE = SUM_MSG_HLACP;
    } else if ([getBasicPlan isEqualToString:STR_S100]) {
        MHI_MSG_TYPE = SUM_MSG_L100;
    } 
}

-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan planName:(NSString *)planName
{
    getSINo = aaSINo;
    getMOP = aaMOP;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getbasicTempHL = aaBasicTempHL;
    getPlanCode = aaPlanCode;
    
    prevPlan = getBasicPlan;
    getBasicPlan = aabasicPlan;
    getAdvance = aaAdvance;
    getPlanName = planName;
    [self getMHIMsgType];
        
    if (getbasicSA.length != 0) {
        PlanEmpty = NO;
    }
    
    [self checkingPayor];
    [self checking2ndLA];
    [self toogleView];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)clearSecondLA
{
    [self.SecondLAController deleteSecondLA];
}

NSString *prevPlan;
-(void)clearPayor
{
    [self.PayorController deletePayor];
}

-(void)setNewPlan:(NSString*)planChoose
{
    //riderController
    self.RiderController.getPlanChoose = planChoose;
}

-(void)RiderAdded
{
    [self toogleView];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)BasicSARevised:(NSString *)aabasicSA
{
    getbasicSA = aabasicSA;    
    AppDelegate *delegate= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    
	if (delegate.bpMsgPrompt) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:delegate.bpMsgPrompt delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];		        
        [alert show];
        delegate.bpMsgPrompt = nil;        
    }
}

-(void)SwitchToRiderTab{
    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SIMENU_RIDER inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.RiderController.requestAge = getAge;
    self.RiderController.requestSex = getSex;
    self.RiderController.requestOccpCode = getOccpCode;
    self.RiderController.requestOccpClass = getOccpClass;
    
    self.RiderController.requestSINo = getSINo;
    self.RiderController.requestPlanCode = getPlanCode;
    self.RiderController.requestPlanChoose = getBasicPlan;
    self.RiderController.requestCoverTerm = getTerm;
    self.RiderController.requestBasicSA = getbasicSA;
    self.RiderController.requestBasicHL = getbasicHL;
    self.RiderController.requestBasicTempHL = getbasicTempHL;
    self.RiderController.requestMOP = getMOP;
    self.RiderController.requestAdvance = getAdvance;
    self.RiderController.requesteEDD = getEDD;
    
    self.RiderController.EAPPorSI = [self.EAPPorSI description];
    [self.RightView addSubview:_RiderController.view];
    [_RiderController processRiders];
    
    selectedPath = [NSIndexPath indexPathForRow:SIMENU_RIDER inSection:0];
    previousPath = selectedPath;
    [myTableView reloadData];
}

-(void)HLInsert:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL
{
    getbasicHL = aaBasicHL;
    getbasicTempHL = aaBasicTempHL;
}


-(NSString*)getRiderCode:(NSString *)rider
{
    NSString *riderName;    
    if ([[rider substringWithRange:NSMakeRange(0,3)] isEqualToString:@"WOP"]) {
        riderName = [[rider componentsSeparatedByString:@") ("] objectAtIndex:0];
        riderName = [riderName stringByAppendingString:@")"];
    } else {
        riderName = [[rider componentsSeparatedByString:@" ("] objectAtIndex:0];
    }
    
    return [riderCode objectForKey:riderName];
}

#pragma mark - memory

- (void)viewDidUnload
{
    appDel = nil;
    [self resignFirstResponder];
    [self setMyTableView:nil];
    [self setRightView:nil];
    [self setGetSINo:nil];
    [self setGetOccpCode:nil];
    [self setPayorCustCode:nil];
    [self setPayorSINo:nil];
    [self setCustCode2:nil];
    [self setGetbasicSA:nil];
    [self setMenuBH:nil];
    [self setMenuPH:nil];
    [self setGetOccpCode:nil];
    [self setGetCommDate:nil];
    [self setGetPaySmoker:nil];
    [self setGetPaySex:nil];
    [self setGetPayDOB:nil];
    [self setGetPayOccp:nil];
    [self setGet2ndLASmoker:nil];
    [self setGet2ndLASex:nil];
    [self setGet2ndLADOB:nil];
    [self setGet2ndLAOccp:nil];
    [self setGetSINo:nil];
    [self setGetbasicSA:nil];
    [self setGetbasicHL:nil];
    [self setGetPlanCode:nil];
    [self setGetBasicPlan:nil];
    [super viewDidUnload];
}

-(void)clearDataLA
{
    _LAController = nil;
    getAge = 0;
    getSex = nil;
    getSmoker = nil;
    getOccpClass = 0;
    getOccpCode = nil;
    getCommDate = nil;
    getIdPay = 0;
    getIdProf = 0;
    getLAIndexNo = 0;
    NameLA = nil;
}

-(void)clearDataPayor
{
    _PayorController = nil;
    [self.PayorController resetField];
    getPayorIndexNo = 0;
    getPaySmoker = nil;
    getPaySex = nil;
    getPayDOB = nil;
    getPayAge = 0;
    getPayOccp = nil;
    NamePayor = nil;
    payorSINo = nil;
}

-(void)clearData2ndLA
{
    _SecondLAController = nil;
    [self.SecondLAController resetField];
	
    get2ndLAIndexNo = 0;
    get2ndLASmoker = nil;
    get2ndLASex = nil;
    get2ndLADOB = nil;
    get2ndLAAge = 0;
    get2ndLAOccp = nil;
    Name2ndLA = nil;
    CustCode2 = nil;
}

-(void)clearDataBasic
{
    _BasicController = nil;
    getSINo = nil;
    getMOP = 0;
    getTerm = 0;
    getbasicSA = nil;
    getbasicHL = nil;
    getbasicTempHL = nil;
    getPlanCode = nil;
    getBasicPlan = nil;
    getPlanName = nil;
    getAdvance = 0;
}

- (IBAction)brochureTapped:(UIButton *)sender
{
    NSLog(@"pdf : %@", _LAController.NamaProduk.titleLabel.text);
    if([_LAController.NamaProduk.titleLabel.text caseInsensitiveCompare:@"--Please Select--"] == NSOrderedSame){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"informasi" message:@"mohon terlebih dahulu memilih nama produk" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alert show];
    }
    if([_LAController.NamaProduk.titleLabel.text caseInsensitiveCompare:@"BCA Life Heritage Protection"] == NSOrderedSame){
        [self seePDF:@"Brochure_ProdukBCALifeHeritage"];
    }
    if([_LAController.NamaProduk.titleLabel.text caseInsensitiveCompare:@"BCA Life Keluargaku"] == NSOrderedSame){
        [self seePDF:@"Brochure_ProdukBCALIfeKeluargaku"];
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)seePDF:(NSString *)pdfFile{
    NSString *file = [[NSBundle mainBundle] pathForResource:pdfFile ofType:@"pdf"];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
    
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:Nil];
    }
}


-(void)RemovePDS {
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Pemegang Polis", @"Tertanggung", @"Ansurasi Dasar \n Asuransi Tambahan \n Premi", @"Ilustrasi ",@"Produk Brosur",@"Simpan sebagai Baru", nil];
//	ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", nil];
}

-(void)setNewBasicSA :(NSString*)aaSA {
    _BasicController.yearlyIncomeField.text = aaSA;
}

-(void)dismissEApp
{
    self.modalTransitionStyle = UIModalPresentationFormSheet;
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

- (void)heritageSimpan{
    [self setSaveAsMode:[dictionaryPOForInsert valueForKey:@"SINO"]];
    [self LoadIlustrationPage];
}

@end
