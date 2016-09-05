    //
//  BasicPlanViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "NewLAViewController.h"
#import "PremiumViewController.h"
#import "MainScreen.h"
#import "BasicPlanHandler.h"
#import "AppDelegate.h"
#import "SIObj.h"
#import "Constants.h"
#import "TabValidation.h"
#import "UIView+viewRecursion.h"
#import "LoginDBManagement.h"

@interface BasicPlanViewController (){
    ColorHexCode *CustomColor;
    double discountPembelian;
    int roundedDiscount;
}
@end

@implementation BasicPlanViewController
@synthesize btnPlan;
@synthesize termField;
@synthesize FrekuensiPembayaranChecking,FRekeunsiPembayaranMode,YearlyIncm;
@synthesize yearlyIncomeField;
@synthesize ExtraPremiDasarLBL;
@synthesize MasaExtraPremiLBL;
@synthesize ExtraPremiDasarNumberLBL;
@synthesize ExtraPremiTotal;
@synthesize ExtraPrecenttotal;
@synthesize minSALabel;
@synthesize maxSALabel;
@synthesize healthLoadingView;
@synthesize MOPSegment;
@synthesize totalDivide;
@synthesize S100MOPSegment;
@synthesize incomeSegment,cashDivSgmntCP,DiscountCalculation;
@synthesize advanceIncomeSegment;
@synthesize cashDividendSegment;
@synthesize HLField,PlanType;
@synthesize HLTermField;
@synthesize PaymentDescMDKK;
@synthesize tempHLField,annualRiderSum,halfRiderSum,monthRiderSum,quarterRiderSum;
@synthesize tempHLTermField,basicPremAnn,basicPremHalf,basicPremQuar,basicPremMonth;
@synthesize myScrollView,labelThree,labelSix,labelSeven,labelFour,labelFive,annualMedRiderPrem,monthMedRiderPrem,quarterMedRiderPrem;
@synthesize ageClient,requestSINo,termCover,maxSA,minSA,halfMedRiderPrem,AnuityRt;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,cashDividend,TotalA;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize planCode,requestOccpCode,dataInsert,basicBH,basicPH,basicLa2ndH;
@synthesize SINo,LACustCode,PYCustCode,SalesIlustrationDate,SILastNo,CustDate,CustLastNo,BasisSumAssured;
@synthesize NamePP,DOBPP,OccpCodePP,GenderPP,secondLACustCode,IndexNo,PayorIndexNo,secondLAIndexNo;
@synthesize delegate = _delegate;
@synthesize requestAge,OccpCode,requestIDPay,requestIDProf,idPay,idProf,annualMedRiderSum,halfMedRiderSum,quarterMedRiderSum;
@synthesize requestAgePay,requestDOBPay,requestIndexPay,requestOccpPay,requestSexPay,requestSmokerPay,monthMedRiderSum;
@synthesize PayorAge,PayorDOB,PayorOccpCode,PayorSex,PayorSmoker,LPlanOpt,LDeduct,LAge,LSmoker,MBKKPremium;
@synthesize LAAge,LASex,RelWithLA,MDBKK,MDBKK_Mil;
@synthesize LTerm,age,sex,LSex,riderRate,LRidHL1K,LRidHL100,LRidHLP,LTempRidHL1K,LOccpCode;
@synthesize requestAge2ndLA,requestDOB2ndLA,requestIndex2ndLA,requestOccp2ndLA,requestSex2ndLA,requestSmoker2ndLA;
@synthesize secondLAAge,secondLADOB,secondLAOccpCode,secondLASex,secondLASmoker;
@synthesize LRiderCode,LSumAssured,expAge,minSATerm,maxSATerm,minTerm,maxTerm,riderCode,_maxRiderSA,maxRiderSA,GYI;
@synthesize requestOccpClass,OccpClass,SavedMOP,yearlyIncomeHLAIB,cashDividendHLAIB,cashDividendHLACP;
@synthesize advanceYearlyIncomeHLAIB,advanceYearlyIncomeHLACP,maxAge,occLoad,LSDRate,LUnits,occCPA_PA;
@synthesize planList = _planList;
@synthesize Pembelianke = _Pembelianke;
@synthesize _masaPembayaran = _masaPembayaran;
@synthesize planPopover = _planPopover;
@synthesize labelParAcc,labelParPayout,labelPercent1,labelPercent2,parAccField,parPayoutField,getParAcc,getParPayout;
@synthesize pTypeOccp,occLoadRider,riderPrem,waiverRiderAnn,medRiderPrem;
@synthesize waiverRiderAnn2,waiverRiderHalf,waiverRiderHalf2,waiverRiderMonth,waiverRiderMonth2,waiverRiderQuar,waiverRiderQuar2;
@synthesize quotationLang,requesteProposalStatus, EAPPorSI, outletDone, outletEAPP, DiskounPremi;
@synthesize labelPremiumPay, requestEDD;
@synthesize planChoose,PremiType;
@synthesize isFirstSaved;
@synthesize navigationBar;
@synthesize percentPaymentMode;

#pragma mark - Cycle View

NSString* const STR_L100 = @"BCALH";

bool WPTPD30RisDeleted = FALSE;

- (void)viewDidLoad
{
    [super viewDidLoad];
    riderCalculation = [[RiderCalculation alloc]init];
    classFormatter=[[Formatter alloc]init];
    heritageCalculation = [[HeritageCalculation alloc]init];
    discountPembelian = 0;

    CustomColor = [[ColorHexCode alloc] init ];
    
//    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
//    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
//    [self.navigationBar setTitleTextAttributes:newAttributes];

    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],
                                                           NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]
                                                           }];
    
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    self.healthLoadingView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
	if ([requesteProposalStatus isEqualToString:@"Failed"] || [requesteProposalStatus isEqualToString:@"Submitted"] ||
		[requesteProposalStatus isEqualToString:@"Received"] || [requesteProposalStatus isEqualToString:@"Confirmed"] || [EAPPorSI isEqualToString:@"eAPP"] ||
        [requesteProposalStatus isEqualToString:@"Created_View"])
    {
		Editable = NO;
	} else {
		Editable = YES;
	}
	
    _masaExtraPremiField.enabled=false;
    
    [self loadData];
    
    self.planList = [[PlanList alloc] init];
    _planList.delegate = self;
	self.planList.TradOrEver = @"TRAD";
    labelThree.text = @"Basic Sum Assured:";
    
    useExist = NO;
    termField.enabled = NO;
    healthLoadingView.alpha = 0;
    showHL = NO;
    [self togglePlan];
    _frekuensiPembayaranButton.enabled;
    
    [self resetData];
    if (self.requestSINo) {
        [self checkingExisting];
        [self loadDataFromList];
        if (getSINo.length != 0) {
            [self getExistingBasic:true];
            [self togglePlan];
            [self toggleExistingField];
			
        }
    } else {
        [self getRunningSI];
        [self getRunningCustCode];
        
        SavedMOP = 0;
    }
    
    if (PayorIndexNo != 0) {
        IndexNo = PayorIndexNo;
        [self getProspectData];
    }
    
    if (secondLAIndexNo != 0) {
        IndexNo = secondLAIndexNo;
        [self getProspectData];
    }
    [parAccField setDelegate:self];
    [parPayoutField setDelegate:self];
    [termField setDelegate:self];
    [yearlyIncomeField setDelegate:self];
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tap];
	
    _planList = nil;
    
    ExtraPremiDasarNumberLBL.hidden =YES;
    ExtraPremiDasarLBL.hidden=YES;
    
    outletEAPP.title = @"";
    outletEAPP.enabled = FALSE;
    
	if (Editable == NO) {
		[self DisableTextField:termField ];
		[self DisableTextField:yearlyIncomeField];
		[self DisableTextField:parAccField ];
		[self DisableTextField:parPayoutField ];
		
        MOPSegment.enabled = FALSE;
        S100MOPSegment.enabled = FALSE;
		incomeSegment.enabled = FALSE;
		btnPlan.enabled = FALSE;
		cashDividendSegment.enabled = FALSE;
		advanceIncomeSegment.enabled = FALSE;
		cashDivSgmntCP.enabled = FALSE;
		_quotationLangSegment.enabled = FALSE;
        _policyTermSeg.enabled = FALSE;
        
        if([EAPPorSI isEqualToString:@"eAPP"]){
            outletEAPP.title = @"e-Application Checklist";
            outletEAPP.enabled = TRUE;
            outletDone.enabled = FALSE;
        }
		
	} else {
		if([requesteProposalStatus isEqualToString:@"Created"]){
			btnPlan.enabled = FALSE;
		}		
	}
    
    if([EAPPorSI isEqualToString:@"eAPP"]){
        [self disableFieldsForEapp];
    }
    if (planChoose == NULL) {
        isFirstSaved = TRUE;
    } else {
        isFirstSaved = FALSE;
    }

    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    
    [yearlyIncomeField addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    [yearlyIncomeField addTarget:self action:@selector(AnnualIncomeChange:) forControlEvents:UIControlEventEditingDidEnd];
    [self setTextfieldBorder];
    
    [_basicPremiField addTarget:self action:@selector(PremiDasarIncomeChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    NSString *detectedPlanType = [_dictionaryPOForInsert valueForKey:@"ProductName"];
    //if([detectedPlanType isEqualToString:@"BCA Life Heritage Protection"])
    if([detectedPlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        [self KeluargakuEnable];
        
    }
    else
    {
        [self KeluargakuDisable];
    }
  }

-(void) disableFieldsForEapp
{
    [btnPlan setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    _policyTermSeg.enabled = FALSE;
    
    yearlyIncomeField.enabled = NO;
    yearlyIncomeField.backgroundColor = [UIColor lightGrayColor];
    
    parAccField.enabled = NO;
    parAccField.backgroundColor = [UIColor lightGrayColor];
    
    parPayoutField.enabled = NO;
    parPayoutField.backgroundColor = [UIColor lightGrayColor];
}

-(void)resetField
{
    premiType = @"S";
    [yearlyIncomeField setText:@""];
    [_basicPremiField setText:@""];
    [_extraPremiPercentField setText:@""];
    [_extraPremiNumberField setText:@""];
    [_masaExtraPremiField setText:@""];
    [_extraBasicPremiField setText:@""];
    [_totalPremiWithLoadingField setText:@""];
    [_masaPembayaranButton setTitle:@"--Please Select--" forState:UIControlStateNormal];
    [_frekuensiPembayaranButton setTitle:@"--Please Select--" forState:UIControlStateNormal];
    FRekeunsiPembayaranMode = @"";
    [_KKLKPembelianKeBtn setTitle:@"--Please Select--" forState:UIControlStateNormal];
    [_KKLKDiskaunBtn setText:@"0"];
    BasisSumAssured = 0;
    discountPembelian=0;
    PembelianKEString =@"0";
    PaymentDescMDKK = FRekeunsiPembayaranMode;
    [_basicPremiFieldAfterDiscount setText:@"0"];
}


-(void)resetData{
    cashDividendHLACP = @"";
    cashDividend = @"";
    quotationLang = @"English"; //default without selection is English
    policyTermSegInt = 30; //default policy term segment ; @Edwin 09/07/2014
}

-(void)hideKeyboard{
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
}

- (void)passValidationCheck{
    if(![_masaPembayaranButton.titleLabel.text isEqualToString:@"--Please Select--"] && ![_frekuensiPembayaranButton.titleLabel.text isEqualToString:@"--Please Select--"]){
        [[TabValidation sharedMySingleton] setValidTab3:TRUE];
    }
}

-(void)DisableTextField :(UITextField *)aaTextField{
	aaTextField.backgroundColor = [UIColor lightGrayColor];
    aaTextField.textColor = [UIColor grayColor];
	aaTextField.enabled = FALSE;
}

-(void)loadData//pass data to local variable from other view controller
{
    //request LA details
    ageClient = requestAge;
    OccpCode = [self.requestOccpCode description];
    OccpClass = requestOccpClass;
    idPay = requestIDPay;
    idProf = requestIDProf;
    PayorIndexNo = requestIndexPay;
    PayorSmoker = [self.requestSmokerPay description];
    PayorSex = [self.requestSexPay description];
    PayorSex = [PremiumViewController getShortSex:PayorSex];
    PayorDOB = [self.requestDOBPay description];
    PayorAge = requestAgePay;
    PayorOccpCode = [self.requestOccpPay description];
    secondLAIndexNo = requestIndex2ndLA;
    secondLASmoker = [self.requestSmoker2ndLA description];
    secondLASex = [self.requestSex2ndLA description];
    secondLASex = [PremiumViewController getShortSex:secondLASex];
    secondLADOB = [self.requestDOB2ndLA description];
    secondLAAge = requestAge2ndLA;
    secondLAOccpCode = [self.requestOccp2ndLA description];
    SINo = [self.requestSINo description];
    
    [self getTermRule];
    
    if ([planChoose isEqualToString:STR_HLAWP])
    {
        if (requestAge > 45 && policyTermSegInt == 50) {
            [_policyTermSeg setEnabled:NO forSegmentAtIndex:1];
            [[_policyTermSeg.subviews objectAtIndex:0] setAlpha:0.8];
        }
        else{
            [_policyTermSeg setEnabled:YES forSegmentAtIndex:1];;
            [[_policyTermSeg.subviews objectAtIndex:0] setAlpha:1];
        }        
    }
    
   
}
-(void)calculateValue{
    if([[_dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:@"BCA Life Heritage Protection"]){
        [self PremiDasarAct];
        [self PremiDasarActB];
        [self ExtraNumbPremi];
        [self loadHeritageCalculation];
    }
    /*else{
        [self PremiDasarActKeluargaku:FRekeunsiPembayaranMode];
        [self calculateRiderPremi];
    }*/
}


-(void)KeluargakuDisable
{
    NSLog(@"%@",PlanType);
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if (IsInternalStaff==0){
        //_KKLKDiskaunBtn.hidden = YES;
        //_KKLKDiskaunLbl.hidden = YES;
        [ExtraPremiDasarLBL setText:@"Min  Rp 500,000,000  Max Rp 300,000,000,000"];
    }
    else{
        //_KKLKDiskaunBtn.hidden = NO;
        //_KKLKDiskaunLbl.hidden = NO;
        [ExtraPremiDasarLBL setText:@"Min  Rp 500,000,000    Max Rp 300,000,000,000"];
    }
//    if ([PlanType isEqualToString:@"BCA Life Heritage"])
//    {
        _KKLKDiskaunBtn.hidden = NO;
        _KKLKDiskaunLbl.hidden = NO;
        _KKLKExtraPremiDasarLBL.hidden = YES;
        _KKLKPembelianKeBtn.hidden = YES;
        _KKLKPembelianKeLbl.hidden = YES;
        _KKLKMasaPembayaran.hidden = YES;
        _masaPembayaranButton.hidden = NO;
         ExtraPremiDasarLBL.hidden = NO;
        //yearlyIncomeField.text = @"";
    
//    }
    [self SetDisplayForProduct:[_dictionaryPOForInsert valueForKey:@"ProductCode"]];
    
    [self PremiDasarAct];
    [self PremiDasarActB];
    [self ExtraNumbPremi];
    [self loadHeritageCalculation];
}

-(void)KeluargakuEnable
{
    NSLog(@"%@",PlanType);
    //    if ([PlanType isEqualToString:@"BCA Life Keluargaku"])
    //    {
    _KKLKDiskaunBtn.hidden = NO;
    _KKLKDiskaunLbl.hidden = NO;
    _KKLKExtraPremiDasarLBL.hidden = NO;
    _KKLKPembelianKeBtn.hidden = NO;
    _KKLKPembelianKeLbl.hidden = NO;
    _KKLKMasaPembayaran.hidden = NO;
    _masaPembayaranButton.hidden = YES;
    ExtraPremiDasarLBL.hidden = YES;
    FrekuensiPembayaranChecking =@"10 Tahun";
    //yearlyIncomeField.text = @"";
    //    }
    [self SetDisplayForProduct:[_dictionaryPOForInsert valueForKey:@"ProductCode"]];
    [self PremiDasarActKeluargaku:FRekeunsiPembayaranMode];
    [self calculateRiderPremi];
}

-(void)SetDisplayForProduct:(NSString *)productCode{
    if ([productCode isEqualToString:@"BCALH"]){
        [labelExtraPremi setText:@"Extra Premi Dasar (B)"];
        [labelTotalPremi setText:@"Total Premi (A+B)"];
        
        [_KKLKDiskaunLbl setHidden:YES];
        [labelTotalPremiAfterDiscount setHidden:YES];
        [_KKLKDiskaunBtn setHidden:YES];
        [_basicPremiFieldAfterDiscount setHidden:YES];
    }
    else if ([productCode isEqualToString:@"BCALHST"]){
        [labelExtraPremi setText:@"Extra Premi Dasar (C)"];
        [labelTotalPremi setText:@"Total Premi (A-B)+C"];
        
        [_KKLKDiskaunLbl setHidden:NO];
        [labelTotalPremiAfterDiscount setHidden:NO];
        [_KKLKDiskaunBtn setHidden:NO];
        [_basicPremiFieldAfterDiscount setHidden:NO];
    }
    else if ([productCode isEqualToString:@"BCAKK"]){
        [labelExtraPremi setText:@"Extra Premi Dasar (C)"];
        [labelTotalPremi setText:@"Total Premi (A-B)+C"];
        
        [_KKLKDiskaunLbl setHidden:NO];
        [labelTotalPremiAfterDiscount setHidden:NO];
        [_KKLKDiskaunBtn setHidden:NO];
        [_basicPremiFieldAfterDiscount setHidden:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{    
    self.view.frame = CGRectMake(0, 0, 775, 1004);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self checkEditingMode];
}

- (void) checkEditingMode {
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:[_dictionaryPOForInsert valueForKey:@"SINO"]];
    NSLog(@" Edit Mode second %@ : %@", EditMode, [_dictionaryPOForInsert valueForKey:@"SINO"]);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] == NSOrderedSame){
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=NO;
            }
        }
    }else{
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=YES;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = _totalPremiWithLoadingField.frame.origin;
    CGFloat buttonHeight = _totalPremiWithLoadingField.frame.size.height;
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (keyboardSize.height-buttonOrigin.y <= 0 && ![yearlyIncomeField isEditing]){
        CGPoint scrollPoint = CGPointMake(0.0, visibleRect.size.height - buttonOrigin.y);
        [self.myScrollView setContentOffset:scrollPoint animated:YES];
    }
}


-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    [self.myScrollView setContentOffset:CGPointZero animated:YES];
}

//-(void)keyboardDidShow:(NSNotificationCenter *)notification
//{
//    self.myScrollView.frame = CGRectMake(0, 44, 775, 960-264);
//    self.myScrollView.contentSize = CGSizeMake(775, 960);
//    
//    CGRect textFieldRect = [activeField frame];
//    textFieldRect.origin.y += 10;
//    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
//}
//
//-(void)keyboardDidHide:(NSNotificationCenter *)notification
//{
//    minSALabel.text = @"";
//    maxSALabel.text = @"";    
//    self.myScrollView.frame = CGRectMake(0, 44, 775, 960);
//}

-(void)textFieldDidChange:(UITextField*)textField
{
    appDelegate.isNeedPromptSaveMsg = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
			
        case 1:            
            if(planChoose != nil)
            {
                minSALabel.text = [NSString stringWithFormat:@"Min: %d",minSA];
                maxSALabel.text = [NSString stringWithFormat:@"Max: %d",maxSA];
            }            
            break;
            
        default:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
    }
    activeField = textField;
	[textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == yearlyIncomeField)
    {
        /*NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && newLength <= 15);*/
        BOOL return13digit = FALSE;
        //KY - IMPORTANT - PUT THIS LINE TO DETECT THE FIRST CHARACTER PRESSED....
        //This method is being called before the content of textField.text is changed.
        NSString * AI = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([AI rangeOfString:@"."].length == 1) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c > 15);
            
        } else if([AI rangeOfString:@"."].length == 0) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c  > 15);
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if( return13digit == TRUE) {
            return (([string isEqualToString:filtered])&&(newLength <= 15));
        } else {
            return (([string isEqualToString:filtered])&&(newLength <= 19));
        }
    }
    if (textField == _extraPremiPercentField)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && newLength <= 3);
        
        
    }
    else if (textField == _extraPremiNumberField)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && newLength <= 2);
        
        
    }
    else if (textField == _masaExtraPremiField)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        NSString *PlanTypeProduct = [_dictionaryPOForInsert valueForKey:@"ProductName"];
        if([PlanTypeProduct isEqualToString:@"BCA Life Keluargaku"]){
            return (([string isEqualToString:filtered]) && newLength <= 2);
        }
        else{
            return (([string isEqualToString:filtered]) && newLength <= 1);
        }
       
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ((textField == yearlyIncomeField)&&(PlanType = @"BCA Life Heritage"))
//    {
//        ExtraPremiDasarLBL.hidden=NO;
//
//    }


}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == yearlyIncomeField)
    {
        //ExtraPremiDasarLBL.hidden=YES;
    }
    if(textField == _extraPremiNumberField)
    {
        if([PlanType isEqualToString:@"BCA Life Keluargaku"])
        {
            //[self MeninggalDuniaMDBKK];
        }
        else
        {
           
        }
        _masaExtraPremiField.enabled=TRUE;
        //_masaExtraPremiField.text =@"0";
    }
    if(textField == _extraPremiPercentField)
    {
        _masaExtraPremiField.enabled =TRUE;
        
        if([PlanType isEqualToString:@"BCA Life Keluargaku"])
        {
            //[self MeninggalDuniaMDBKK];
        }
        else
        {
             [self PremiDasarActB];
            [self loadHeritageCalculation];
        }

           //_masaExtraPremiField.text =@"0";
        
    }
    else if (textField == _masaExtraPremiField)
    {
        int masaExtraPremi=[textField.text intValue];
        NSString *PlanTypeProduct = [_dictionaryPOForInsert valueForKey:@"ProductName"];
        
        if([PlanTypeProduct isEqualToString:@"BCA Life Keluargaku"]){
            if (([_extraPremiNumberField.text length]>0)||([_extraPremiPercentField.text length]>0)){
                if (masaExtraPremi<1 || masaExtraPremi>10){
                    [self createAlertViewAndShow:@"Masa extra premi tidak boleh lebih dari 10 dan kurang dari 1" tag:0];
                    [textField setText:@""];
                    [textField becomeFirstResponder];
                }
            }
            else{
                [self calculateRiderPremi];
            }
        }
        else{
            if ([_masaPembayaranButton.titleLabel.text isEqualToString:@"Premi Tunggal"]){
                if (([_extraPremiNumberField.text length]>0)||([_extraPremiPercentField.text length]>0)){
                    if (masaExtraPremi != 1){
                        [self createAlertViewAndShow:@"Masa extra premi harus sama dengan 1" tag:0];
                        [textField setText:@""];
                        [textField becomeFirstResponder];
                    }
                }
                else{
                    [self PremiDasarActB];
                    [self loadHeritageCalculation];
                }
            }
            else{
                if (([_extraPremiNumberField.text length]>0)||([_extraPremiPercentField.text length]>0)){
                    if (masaExtraPremi<1 || masaExtraPremi>5){
                        [self createAlertViewAndShow:@"Masa extra premi tidak boleh lebih dari 5 dan kurang dari 1" tag:0];
                        [textField setText:@""];
                        [textField becomeFirstResponder];
                    }
                }
                else{
                    [self PremiDasarActB];
                    [self loadHeritageCalculation];
                }
            }
        }
    }
}


#pragma mark - added by faiz 
//added by faiz
-(IBAction)validationExtraPremiField:(UITextField *)sender{
//    if (sender==_extraPremiPercentField){
//        if ([sender.text length]>0){
//            //[self setActiveTextField:_extraPremiNumberField Active:NO];
//        }
//        else{
//            [//self setActiveTextField:_extraPremiPercentField Active:YES];
//            //[self setActiveTextField:_extraPremiNumberField Active:YES];
//        }
//    }
//    else{
//        if ([sender.text length]>0){
//            //[self setActiveTextField:_extraPremiPercentField Active:NO];
    
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        //[self MeninggalDuniaMDBKK];
        [self calculateRiderPremi];
    }
    else
    {
        [self PremiDasarAct];
        [self PremiDasarActB];
        [self ExtraNumbPremi];
        [self loadHeritageCalculation];
    }

    
//        }
//        else{
//            //[self setActiveTextField:_extraPremiPercentField Active:YES];
//           // [self setActiveTextField:_extraPremiNumberField Active:YES];
//        }
//    }
}

-(void)ExtraNumbPremi
{
    double  ExtraPremiNumb = [_extraPremiNumberField.text doubleValue];
    
    double PaymentMode;
    
    if ([FRekeunsiPembayaranMode isEqualToString:@"Pembayaran Sekaligus"]||[FRekeunsiPembayaranMode isEqualToString:@"Tahunan"])
    {
        PaymentMode = 1;
    }
    if ([FRekeunsiPembayaranMode isEqualToString:@"Bulanan"])
    {
        PaymentMode = 0.1;
    }

    //long long Extraprem =(ExtraPremiNumb* PaymentMode) *(BasisSumAssured/1000);
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    ExtraPremiTotal = Extraprem;
    
    //long long ExtraPrem1 = ExtraPremiTotal + ExtraPrecenttotal;
    double ExtraPrem1 = ExtraPremiTotal + ExtraPrecenttotal;
    
    //long long Alltotal = TotalA +ExtraPrem1;
    //double Alltotal = TotalA +ExtraPrem1;

    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    
    NSString *numberExtraBasicPremi = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:ExtraPrem1]];
    

    long long Alltotal = [[classFormatter convertAnyNonDecimalNumberToString:_basicPremiField.text] longLongValue] + [[classFormatter convertAnyNonDecimalNumberToString:numberExtraBasicPremi] longLongValue];
    
    NSString *numberExtraBasicTotal = [numberFormatter stringFromNumber: [NSNumber numberWithLongLong:Alltotal]];
    [_extraBasicPremiField setText:[NSString stringWithFormat:@"%@", numberExtraBasicPremi]];
    [_totalPremiWithLoadingField setText:[NSString stringWithFormat:@"%@", numberExtraBasicTotal]];
}

-(void)setActiveTextField:(UITextField *)textField Active:(BOOL)active{
    if (active){
        [textField setEnabled:YES];
        [textField setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [CustomColor colorWithHexString:@"EEEEEE"];
        [textField setEnabled:NO];
        [textField setBackgroundColor:[CustomColor colorWithHexString:@"EEEEEE"]];
    }
}

-(IBAction)MasaExtraPremiTextFieldDidBegin:(UITextField *)sender{
    NSString *PlanTypeProduct = [_dictionaryPOForInsert valueForKey:@"ProductName"];
    /*if(([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection"])||([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection - For BCA Staff"])){
        if ([_masaPembayaranButton.titleLabel.text isEqualToString:@"Premi Tunggal"]){
            [MasaExtraPremiLBL setText:@"Min 1 | Max 1"];
        }
        else if ([_masaPembayaranButton.titleLabel.text isEqualToString:@"Premi 5 Tahun"]){
            [MasaExtraPremiLBL setText:@"Min 1 | Max 5"];
        }
    }
    else{
        [MasaExtraPremiLBL setText:@"Min 1 | Max 10"];
    }*/
    if([PlanTypeProduct isEqualToString:@"BCA Life Keluargaku"]){
        [MasaExtraPremiLBL setText:@"Min 1 | Max 10"];
    }
    else{
        if ([_masaPembayaranButton.titleLabel.text isEqualToString:@"Premi Tunggal"]){
            [MasaExtraPremiLBL setText:@"Min 1 | Max 1"];
        }
        else if ([_masaPembayaranButton.titleLabel.text isEqualToString:@"Premi 5 Tahun"]){
            [MasaExtraPremiLBL setText:@"Min 1 | Max 5"];
        }
    }
    [MasaExtraPremiLBL setHidden:NO];
}

-(IBAction)MasaExtraPremiTextFieldDidEnd:(UITextField *)sender {
    [MasaExtraPremiLBL setHidden:YES];
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        [self PremiDasarActKeluargaku:FRekeunsiPembayaranMode];
        [self calculateRiderPremi];
    }
    else{
        [self PremiDasarAct];
        [self PremiDasarActB];
        [self ExtraNumbPremi];
        [self loadHeritageCalculation];
    }
}


-(IBAction)actionMasaPembayaran:(id)sender
{
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_masaPembayaran == nil) {
        _masaPembayaran = [[MasaPembayaran alloc] init];
        _masaPembayaran.TradOrEver = @"TRAD";
        _masaPembayaran.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_masaPembayaran];
        
    }
    else
    {
        _masaPembayaran = [[MasaPembayaran alloc] init];
        _masaPembayaran.TradOrEver = @"TRAD";
        _masaPembayaran.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_masaPembayaran];
        
        
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

-(NSString *)getPremiType:(NSString *)FrekuensiPembayaran{
    NSString* localPremiType;
    if ([FrekuensiPembayaran isEqualToString:@"Premi Tunggal"]){
        localPremiType=@"S";
    }
    else if ([FrekuensiPembayaran isEqualToString:@"Premi 5 Tahun"]){
        localPremiType=@"R";
    }
    else if ([FrekuensiPembayaran isEqualToString:@"10 Tahun"]){
        localPremiType=@"S";
    }
    return localPremiType;
}

-(IBAction)actionFrekuensiPembayaran:(id)sender
{
    if ([FrekuensiPembayaranChecking isEqualToString:@"Premi Tunggal"])
    {
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        if (_frekuensi == nil) {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"Premi Tunggal";
            _frekuensi.delegate = self;
            premiType = @"S";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];
        }
        else
        {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"Premi Tunggal";
            _frekuensi.delegate = self;
            premiType = @"S";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];
        }
        
        CGRect rect = [sender frame];
        rect.origin.y = [sender frame].origin.y + 30;
        
        [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
        [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        //_frekuensiPembayaranButton.enabled =TRUE;
    }
    else if ([FrekuensiPembayaranChecking isEqualToString:@"Premi 5 Tahun"])
    {
        
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        if (_frekuensi == nil) {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"Premi 5 Tahun";
            _frekuensi.delegate = self;
            premiType = @"R";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];
        }
        else
        {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"Premi 5 Tahun";
            _frekuensi.delegate = self;
            premiType = @"R";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];

        }
        CGRect rect = [sender frame];
        rect.origin.y = [sender frame].origin.y + 30;
        
        [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
        [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
       // _frekuensiPembayaranButton.enabled =TRUE;
    }
    else if ([FrekuensiPembayaranChecking isEqualToString:@"10 Tahun"])
    {
        
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        if (_frekuensi == nil) {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"10 Tahun";
            _frekuensi.delegate = self;
            premiType = @"S";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];
        }
        else
        {
            _frekuensi = [[Frekeunsi alloc] init];
            _frekuensi.Frekuensi = @"10 Tahun";
            _frekuensi.delegate = self;
            premiType = @"S";
            self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_frekuensi];
            
        }
        CGRect rect = [sender frame];
        rect.origin.y = [sender frame].origin.y + 30;
        
        [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
        [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        // _frekuensiPembayaranButton.enabled =TRUE;

    }
    
}

-(void)PaymentDasarMDBKK: (NSString *)PaymentDesc
{
    double PaymentType;
    double PaymentFoctor;
    
    //PAymentFactorRate//
    
    if ([PaymentDesc isEqualToString:@"Tahunan"])
    {
        PaymentType =1;
    }
    else if ([PaymentDesc isEqualToString:@"Semester"])
    {
        PaymentType =2;
    }
    else if ([PaymentDesc isEqualToString:@"Kuartal"])
    {
        PaymentType =3;
    }
    else if ([PaymentDesc isEqualToString:@"Bulanan"])
    {
        PaymentType =4;
    }
    
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    FMResultSet *Results2;
    NSString * RatesMop = [NSString stringWithFormat:@"SELECT Payment_Fact FROM Keluargaku_Rates_MOP Where Payment_Code = %f",PaymentType];
    Results2 = [database executeQuery:RatesMop];
    
    while([Results2 next])
    {
        PaymentFoctor = [[Results2 stringForColumn:@"Payment_Fact"]doubleValue];
        
    }
    
    ////BasicPremiRate/////
    
    AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM Keluargaku_Rates_basicPrem Where BasicCode = '%@' AND EntryAge = %i",PayorSex,@"KLK",PayorAge];
    results = [database executeQuery:AnsuransiDasarQuery];
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
    {
        if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
            RatesPremiumRate  = [results stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate  = [results stringForColumn:@"Female"];
        }
        
    }
    
    double RatesInt = [RatesPremiumRate doubleValue];
    
    ///BasiSumAssured///
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:yearlyIncomeField.text];
    
    BasisSumAssured = [myNumber longLongValue];
    
    long long total =(BasisSumAssured/1000);
    
    //NoPolRate//
    
    int NoPolRate =0;
    
    //MDBKK Premi//
    
    double MDBKK_Premi = 0 * RatesInt * total * PaymentFoctor;
    
    //


    
}

- (IBAction)KKLKPembelianKe:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_Pembelianke.title == nil) {
        self.Pembelianke = [[PembeliaKe alloc] init];
        _Pembelianke.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_Pembelianke];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    

}
-(void)Diskaun
{
    
}


-(void)PremiDasarActKeluargaku: (NSString *)PaymentDesc//BasicRiderPremium ||Rider Premium MBKK
{
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        PayorSex = LASex;
        PayorAge = LAAge;
    }
    
    double PaymentType;
    double PaymentFoctor;
    
    //PAymentFactorRate//
    
    if ([PaymentDesc isEqualToString:@"Tahunan"])
    {
        PaymentType =1;
    }
    else if ([PaymentDesc isEqualToString:@"Semester"])
    {
        PaymentType =2;
    }
    else if ([PaymentDesc isEqualToString:@"Kuartal"])
    {
        PaymentType =3;
    }
    else if ([PaymentDesc isEqualToString:@"Bulanan"])
    {
        PaymentType =4;
    }
    
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    FMResultSet *Results2;
    NSString * RatesMop = [NSString stringWithFormat:@"SELECT Payment_Fact FROM Keluargaku_Rates_MOP Where Payment_Code = %f",PaymentType];
    Results2 = [database executeQuery:RatesMop];
    
    while([Results2 next])
    {
        
      PaymentFoctor = [[Results2 stringForColumn:@"Payment_Fact"]doubleValue];
    PaymentFoctor =  PaymentFoctor/100.0f;
        
    }
    
    ////BasicPremiRate/////
    
    AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT MALE,FEMALE FROM Keluargaku_Rates_basicPrem Where BasicCode = '%@' AND EntryAge = %i",@"KLK",LAAge];
    results = [database executeQuery:AnsuransiDasarQuery];
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
    {
        if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
            RatesPremiumRate  = [results stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate  = [results stringForColumn:@"Female"];
        }
        
    }
    
     double RatesInt = [RatesPremiumRate doubleValue];
    
    ///BasiSumAssured///
 
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    //NSNumber *myNumber = [f numberFromString:yearlyIncomeField.text];
    NSNumber *myNumber = [classFormatter convertAnyNonDecimalNumberToString:yearlyIncomeField.text];
    
    BasisSumAssured = [myNumber longLongValue];
    
    long long total =(BasisSumAssured/1000);
    
    //NoPolRate//
    
    int NoPolRate =[PembelianKEString intValue];
    
    //Diskoun Premi//
    
    DiscountCalculation = NoPolRate * RatesInt * total * PaymentFoctor;
    
    
    DiskounPremi = NoPolRate * RatesInt * total * PaymentFoctor;//
    
    NSNumberFormatter *format1 = [[NSNumberFormatter alloc]init];
    [format1 setNumberStyle:NSNumberFormatterNoStyle];
    [format1 setGeneratesDecimalNumbers:FALSE];
    [format1 setMaximumFractionDigits:0];
    [format1 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    DiskounPremi = [[format1 stringFromNumber:[NSNumber numberWithDouble:DiskounPremi]] doubleValue];
    [_KKLKDiskaunBtn setText:[NSString stringWithFormat:@"%@",[format1 stringFromNumber:[NSNumber numberWithDouble:DiskounPremi]]]];
    
    NSString*WaiverRate;
    
    NSArray *paths5 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath5 = [paths5 objectAtIndex:0];
    NSString *path5 = [docsPath5 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database5 = [FMDatabase databaseWithPath:path5];
    [database open];
    FMResultSet *results5;
    
    NSString*RatesPremiumRate5;
    double PaymentMode5;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
        {
    WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",PayorSex,PayorAge,@"T"];
    results5 = [database executeQuery:WaiverRate];
    
    while([results5 next])
    {
        if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate5  = [results5 stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate5 = [results5 stringForColumn:@"Female"];
        }
        
    }
    
        }
        else
        {
            WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",LASex,LAAge,@"P"];
            results5 = [database5 executeQuery:WaiverRate];
    
            while([results5 next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                    RatesPremiumRate5 = [results5 stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRate5  = [results5 stringForColumn:@"Female"];
                }
    
            }
    
    
        }
    
    
    
    double RatesInt5 = [RatesPremiumRate5 doubleValue];
    double  RiderPremium5 = (RatesInt5/100)* DiskounPremi;
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterNoStyle];
    [format setGeneratesDecimalNumbers:FALSE];
    [format setMaximumFractionDigits:0];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    RiderPremium5 = [[format stringFromNumber:[NSNumber numberWithDouble:RiderPremium5]] doubleValue];
    RiderPremium5 = RiderPremium5/100;
    RiderPremium5 = [[format stringFromNumber:[NSNumber numberWithDouble:RiderPremium5]] doubleValue];
    RiderPremium5 = RiderPremium5 * 100;
 //   RiderPremium5 = round(RiderPremium5);
//    RiderPremium5 =RiderPremium5/1000;
//    RiderPremium5 = round();
    
    
    double totalPremiumDasarA = RiderPremium5 + DiskounPremi;//
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    
    NSString *numberExtraBasicPremi = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:totalPremiumDasarA]];

    
    
    [_basicPremiField setText:[NSString stringWithFormat:@"%2@",numberExtraBasicPremi]];
   // [self PremiDasarIncomeChange:_basicPremiField.text];

    
   // [_KKLKDiskaunBtn setText:[NSString stringWithFormat:@"%2f", DiskounPremi]];
    
    //Current Defaulr
    //[_KKLKDiskaunBtn setText:[NSString stringWithFormat:@"%@",@"0"]];
    
    
    
    
    //DiskonFormula
    //Diskoun Premi//
    [self MeninggalDuniaMDBKK];
    
    DiscountCalculation = discountPembelian * RatesInt * total * percentPaymentMode;
    //DiskounPremi = NoPolRate * RatesInt * total * PaymentFoctor;//
    
    NSNumberFormatter *format21 = [[NSNumberFormatter alloc]init];
    [format21 setNumberStyle:NSNumberFormatterNoStyle];
    [format21 setGeneratesDecimalNumbers:TRUE];
    [format21 setMaximumFractionDigits:1];
    [format21 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    DiscountCalculation = [[format21 stringFromNumber:[NSNumber numberWithDouble:DiscountCalculation]] doubleValue];
    roundedDiscount=round(DiscountCalculation);
    [_KKLKDiskaunBtn setText:[classFormatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%i",roundedDiscount]]];
    NSLog(@"MDBKK %f",MDBKK);
  //  [self PremiDasarIncomeChange:_basicPremiField.text];
}

-(void)PremiDasarAct
{
    NSString*AnsuransiDasarQuery;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }

    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",PayorSex,@"HRT",premiType,PayorAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }

    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",premiType,LAAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }


    }
    
    if ([FRekeunsiPembayaranMode isEqualToString:@"Pembayaran Sekaligus"]||[FRekeunsiPembayaranMode isEqualToString:@"Tahunan"])
    {
        PaymentMode = 1;
    }
    else if ([FRekeunsiPembayaranMode isEqualToString:@"Bulanan"])
    {
        PaymentMode = 0.1;
    }
    else{
        PaymentMode = 0;
    }
    
    double RatesInt = [RatesPremiumRate doubleValue];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:yearlyIncomeField.text];
    
    BasisSumAssured = [myNumber longLongValue];

    //long long total =(BasisSumAssured/1000);
    double total =((double)BasisSumAssured/1000);
    double test = PaymentMode * RatesInt;
    
    double test2 = (test * BasisSumAssured)/1000;
    
    
    
    TotalA = total * test;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    //[numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];

    
    [_basicPremiField setText:[NSString stringWithFormat:@"%2f", test2]];
    //[_basicPremiField setText:[numberFormatter stringFromNumber:[NSNumber numberWithDouble:TotalA]]];
    [self PremiDasarIncomeChange:_basicPremiField.text];
}

-(void)PremiDasarActkklk
{
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:yearlyIncomeField.text];
    
    BasisSumAssured = [myNumber longLongValue];
    
    long long total =BasisSumAssured *2;

    
    
    NSString*WaiverRate;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
//    if([RelWithLA isEqualToString:@"DIRI SENDIRI"])
//    {
        WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",PayorSex,PayorAge,@"P"];
        results = [database executeQuery:WaiverRate];
        
        while([results next])
        {
            if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
//    }
//    else
//    {
//        WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",LASex,LAAge,@"T"];
//        results = [database executeQuery:WaiverRate];
//        
//        while([results next])
//        {
//            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
//                RatesPremiumRate  = [results stringForColumn:@"Male"];
//            }
//            else{
//                RatesPremiumRate  = [results stringForColumn:@"Female"];
//            }
//            
//        }
//        
//        
//    }
//
    double RatesInt = [RatesPremiumRate doubleValue];
    double  RiderPremium = (RatesInt/100)* total;
    
 //   double totalPremiumDasarA = RiderPremium + total;
    
//    [_basicPremiField setText:[NSString stringWithFormat:@"%2f", totalPremiumDasarA]];
//    [self PremiDasarIncomeChange:_basicPremiField.text];
    
//    
//    if ([FRekeunsiPembayaranMode isEqualToString:@"Pembayaran Sekaligus"]||[FRekeunsiPembayaranMode isEqualToString:@"Tahunan"])
//    {
//        PaymentMode = 1;
//    }
//    if ([FRekeunsiPembayaranMode isEqualToString:@"Bulanan"])
//    {
//        PaymentMode = 0.1;
//    }
//    
//    double RatesInt = [RatesPremiumRate doubleValue];
//    
//    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//    f.numberStyle = NSNumberFormatterDecimalStyle;
//    NSNumber *myNumber = [f numberFromString:yearlyIncomeField.text];
//    
//    BasisSumAssured = [myNumber longLongValue];
//    
//    long long total =(BasisSumAssured/1000);
//    
//    double test = PaymentMode * RatesInt;
//    
//    double test2 = (test * BasisSumAssured)/1000;
//    
//    
//    
//    TotalA = total * test;
//    
//    
//    [_basicPremiField setText:[NSString stringWithFormat:@"%2f", test2]];
//    [self PremiDasarIncomeChange:_basicPremiField.text];
}

#pragma mark : common Func

-(void)MeninggalDuniaMDBKK
{
    //(EM% * EMrate) * BasicSum_Assured/1000 * PaymentFactorRate;
    
    double ExtraPremiField = [_extraPremiPercentField.text doubleValue];
    
    float percentExtraPremiField = ExtraPremiField / 100.0f;
    
    double ExtraPremiFieldMil = [_extraPremiNumberField.text doubleValue];
    
    
    NSString*EmRateQuery;
    NSString*EMValue;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        EmRateQuery = [NSString stringWithFormat:@"SELECT %@ FROM Keluargaku_Rates_EM Where EntryAge = '%i'",PayorSex,PayorAge];
        results = [database executeQuery:EmRateQuery];
        
        while([results next])
        {
            if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"])
            {
                EMValue  = [results stringForColumn:@"Male"];
            }
            else
            {
                EMValue  = [results stringForColumn:@"Female"];
            }
            
        }
    }
        else
        {
            EmRateQuery = [NSString stringWithFormat:@"SELECT %@ FROM Keluargaku_Rates_EM Where EntryAge = '%i'",LASex,LAAge];
            results = [database executeQuery:EmRateQuery];
            
            while([results next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"])
                {
                    EMValue  = [results stringForColumn:@"Male"];
                }
                else
                {
                    EMValue  = [results stringForColumn:@"Female"];
                }
                
            }

        }
    
    double EMvalueDouble =[EMValue doubleValue];
    
   totalDivide =(BasisSumAssured/1000);
    
    double PaymentType;
    double PaymentFoctor;
    
    //PAymentFactorRate//
    
    if ([PaymentDescMDKK isEqualToString:@"Tahunan"])
    {
        PaymentType =1;
    }
    else if ([PaymentDescMDKK isEqualToString:@"Semester"])
    {
        PaymentType =2;
    }
    else if ([PaymentDescMDKK isEqualToString:@"Kuartal"])
    {
        PaymentType =3;
    }
    else if ([PaymentDescMDKK isEqualToString:@"Bulanan"])
    {
        PaymentType =4;
    }
    
    NSString*PaymentFactoryQuery;
   // NSArray *path3= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *docsPath3 = [path3 objectAtIndex:0];
   //  NSString *path4 = [docsPath3 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
   // FMDatabase *database3 = [FMDatabase databaseWithPath:path4];
    [database open];
    FMResultSet *Results2;
    NSString * RatesMop = [NSString stringWithFormat:@"SELECT Payment_Fact FROM Keluargaku_Rates_MOP Where Payment_Code = %f",PaymentType];
    Results2 = [database executeQuery:RatesMop];
    
    
    while([Results2 next])
    {
        PaymentFactoryQuery = [Results2 stringForColumn:@"Payment_Fact"];
        
    }
    
     percentPaymentMode = [PaymentFactoryQuery floatValue] / 100.0f;
    
    
     MDBKK =percentExtraPremiField * EMvalueDouble * totalDivide * percentPaymentMode;
    
    
   // Rider Loading Premium
   // Formula = (EM% * BP_Premi +  MDBKK_Premi * (AnuityRate/1000) *PaymentFactorRate
    
    NSString*WaiverRate;
    
    NSArray *paths5 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath5 = [paths5 objectAtIndex:0];
    NSString *path5 = [docsPath5 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database5 = [FMDatabase databaseWithPath:path5];
    [database open];
    FMResultSet *results5;
    
    NSString*RatesPremiumRate5;
    double PaymentMode5;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",PayorSex,PayorAge,@"T"];
        results5 = [database executeQuery:WaiverRate];
        
        while([results5 next])
        {
            if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate5  = [results5 stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate5 = [results5 stringForColumn:@"Female"];
            }
            
        }
        
    }
    else
    {
        WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM KLK_Waiver Where EntryAge = '%i' AND PersonType = '%@'",LASex,LAAge,@"P"];
        results5 = [database5 executeQuery:WaiverRate];
        
        while([results5 next])
        {
            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                RatesPremiumRate5 = [results5 stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate5  = [results5 stringForColumn:@"Female"];
            }
            
        }
        
        
    }
    
    double RatesInt5 = [RatesPremiumRate5 doubleValue];
    double  RiderPremium5 = (RatesInt5/100)*(DiskounPremi + MDBKK);
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterNoStyle];
    [format setGeneratesDecimalNumbers:FALSE];
    [format setMaximumFractionDigits:0];
    [format setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    RiderPremium5 = [[format stringFromNumber:[NSNumber numberWithDouble:RiderPremium5]] doubleValue];
    RiderPremium5 = RiderPremium5/100;
    RiderPremium5 = [[format stringFromNumber:[NSNumber numberWithDouble:RiderPremium5]] doubleValue];
    RiderPremium5 = RiderPremium5 * 100;
    
    NSString*PaymentFactoryAnuityRate;
    // NSArray *path3= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *docsPath3 = [path3 objectAtIndex:0];
    //  NSString *path4 = [docsPath3 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    // FMDatabase *database3 = [FMDatabase databaseWithPath:path4];
    [database open];
    FMResultSet *Results3;
    NSString * AnuityRate = [NSString stringWithFormat:@"SELECT \"Annuity Factor\" FROM Keluargaku_Rates_AnuityRate Where PaymentCode = %f",PaymentType];
    Results3 = [database executeQuery:AnuityRate];
    
    while([Results3 next])
    {
        PaymentFactoryAnuityRate = [Results3 stringForColumn:@"Annuity Factor"];
        
    }
    
    AnuityRt = [PaymentFactoryAnuityRate doubleValue];
                
                AnuityRt = (AnuityRt/1000);
    
    MDBKK_Mil = ExtraPremiFieldMil* totalDivide *percentPaymentMode;//MDBKKMIL extra premi
    
    NSNumberFormatter *format2 = [[NSNumberFormatter alloc]init];
    [format2 setNumberStyle:NSNumberFormatterNoStyle];
    [format2 setGeneratesDecimalNumbers:FALSE];
    [format2 setMaximumFractionDigits:0];
    [format2 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    MDBKK_Mil = [[format2 stringFromNumber:[NSNumber numberWithDouble:MDBKK_Mil]] doubleValue];
    
    
    
    
    
//    long long MDBKK =percentExtraPremiField * EMvalueDouble * totalDivide * percent;
    long long totalBasicPremium = percentExtraPremiField * (RiderPremium5 + DiskounPremi) *AnuityRt *percentPaymentMode;
    
    double ValueExtraPremi = percentExtraPremiField * RiderPremium5;
    
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setMaximumFractionDigits:0];
    
    
    double ExtraValue = ExtraPremiFieldMil * DiskounPremi * percentPaymentMode * AnuityRt ;
    
    NSNumberFormatter *format21 = [[NSNumberFormatter alloc]init];
    [format21 setNumberStyle:NSNumberFormatterNoStyle];
    [format21 setGeneratesDecimalNumbers:FALSE];
    [format21 setMaximumFractionDigits:0];
    [format21 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    ExtraValue = [[format21 stringFromNumber:[NSNumber numberWithDouble:ExtraValue]] doubleValue];
    
    
    
//    double Test = RiderPremium5 * percentExtraPremiField;
//    double Test2 = percentExtraPremiField * Test;
    
[self validationExtraPremiTxt];
    
}

-(void)validationExtraPremiTxt
{
 
     //EM *(sumAsured/1000)* payment_mode
    
     double EtraPremMil =[_extraPremiNumberField.text doubleValue];
    
    long long ExtraPremiMilOne = totalDivide *percentPaymentMode * EtraPremMil;
    
     //Em* (Anuaty/1000)*payment mode/
    
    long long ExtraPremiMilTwo = EtraPremMil * AnuityRt * percentPaymentMode;
    
}



-(void)PremiDasarActB
{
    
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",PayorSex,@"HRT",premiType,PayorAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }


    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",premiType,LAAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }


    }
    
    if ([FRekeunsiPembayaranMode isEqualToString:@"Pembayaran Sekaligus"]||[FRekeunsiPembayaranMode isEqualToString:@"Tahunan"])
    {
        PaymentMode = 1;
    }
    if ([FRekeunsiPembayaranMode isEqualToString:@"Bulanan"])
    {
        PaymentMode = 0.1;
    }
    _PAymentModeForInt = PaymentMode;
    
    double RatesInt0 = [RatesPremiumRate doubleValue];
    
    float percent = [_extraPremiPercentField.text floatValue] / 100.0f;
    
    double RatesInt = percent * RatesInt0;
    
    long long totalDivide =(BasisSumAssured/1000);
    
    double valueofTotal =(PaymentMode * RatesInt);
    
    //double total =(totalDivide * valueofTotal);
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
  //  [_basicPremiField setText:[NSString stringWithFormat:@"%d", total]];

    int masaExtraPremiBTotal =[_masaExtraPremiField.text intValue];\
    
    //double totalB = total * masaExtraPremiBTotal;
    double totalB = total;
    //prem//
    
    long long Extraprem =totalB;
    
    //ExtraPrecenttotal = Extraprem;
    ExtraPrecenttotal = totalB;
    //long long ExtraPrem1 = ExtraPremiTotal + ExtraPrecenttotal;
    double ExtraPrem1 = ExtraPremiTotal + ExtraPrecenttotal;

    
    
    //double TotalAB = TotalA + ExtraPrem1;
    
    [self ExtraNumbPremi];
    
    
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    //[numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    
    NSString *numberExtraBasicPremi = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:ExtraPrem1]];
    
    //NSString *totalPremiWithLoading = [numberFormatter stringFromNumber: [NSNumber numberWithDouble:TotalAB]];
    long long TotalAB = [[classFormatter convertAnyNonDecimalNumberToString:_basicPremiField.text] longLongValue] + [[classFormatter convertAnyNonDecimalNumberToString:numberExtraBasicPremi] longLongValue];
    
    NSString *totalPremiWithLoading = [numberFormatter stringFromNumber: [NSNumber numberWithLongLong:TotalAB]];

    
    [_extraBasicPremiField setText:[NSString stringWithFormat:@"%@", numberExtraBasicPremi]];
    [_totalPremiWithLoadingField setText:[NSString stringWithFormat:@"%@", totalPremiWithLoading]];
}



-(void)setTextfieldBorder{
    UIFont *font= [UIFont fontWithName:@"TreBuchet MS" size:16.0f];
    for (UIView *view in [myScrollView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.layer.borderColor=themeColour.CGColor;
            textField.layer.borderWidth=1.0;
            textField.delegate=self;
            [textField setFont:font];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
        
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.layer.borderColor=themeColour.CGColor;
            button.layer.borderWidth=1.0;
            [button.titleLabel setFont:font];
        }
    }

}

-(void)loadDataFromList{
    _modelSIPremium = [[Model_SI_Premium alloc]init];
    NSDictionary* dictPremiData=[[NSDictionary alloc]initWithDictionary:[_modelSIPremium getPremium_For:[self.requestSINo description]]];
    if ([dictPremiData count]!=0){
        premiType = [self getPremiType:[dictPremiData valueForKey:@"Payment_Term"]];
        [yearlyIncomeField setText:[dictPremiData valueForKey:@"Sum_Assured"]];
        [_basicPremiField setText:[dictPremiData valueForKey:@"PremiumPolicyA"]];
        [_extraPremiPercentField setText:[dictPremiData valueForKey:@"ExtraPremiumPercentage"]];
        [_extraPremiNumberField setText:[dictPremiData valueForKey:@"ExtraPremiumSum"]];
        [_masaExtraPremiField setText:[dictPremiData valueForKey:@"ExtraPremiumTerm"]];
        [_extraBasicPremiField setText:[dictPremiData valueForKey:@"ExtraPremiumPolicy"]];
        [_totalPremiWithLoadingField setText:[dictPremiData valueForKey:@"TotalPremiumLoading"]];
        [_masaPembayaranButton setTitle:[dictPremiData valueForKey:@"Payment_Term"] forState:UIControlStateNormal];
        [_frekuensiPembayaranButton setTitle:[dictPremiData valueForKey:@"Payment_Frequency"] forState:UIControlStateNormal];
        FRekeunsiPembayaranMode = [dictPremiData valueForKey:@"Payment_Frequency"];
        [_KKLKPembelianKeBtn setTitle:[dictPremiData valueForKey:@"PurchaseNumber"] forState:UIControlStateNormal];
        [_KKLKDiskaunBtn setText:[dictPremiData valueForKey:@"Discount"]];
        [_basicPremiFieldAfterDiscount setText:[dictPremiData valueForKey:@"SubTotalPremium"]];
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        //NSNumber *myNumber = [f numberFromString:[dictPremiData valueForKey:@"Sum_Assured"]];
        NSNumber *myNumber = [classFormatter convertAnyNonDecimalNumberToString:[dictPremiData valueForKey:@"Sum_Assured"]];
        
        BasisSumAssured = [myNumber longLongValue];

        if ([[dictPremiData valueForKey:@"PurchaseNumber"] intValue]>=2){
            discountPembelian=0.05;
        }
        else{
            discountPembelian=0;
        }
        PembelianKEString =[dictPremiData valueForKey:@"PurchaseNumber"];
        PaymentDescMDKK = FRekeunsiPembayaranMode;
        [_delegate setBasicPlanDictionaryWhenLoadFromList:dictPremiData];
    }
}
//end of added by faiz

#pragma mark - Action

- (IBAction)ActionEAPP:(id)sender {
    [_delegate dismissEApp];
}

- (IBAction)btnPlanPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        self.planList.TradOrEver = @"TRAD";
        _planList.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)policyTermSegPressed:(id)sender {
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if(_policyTermSeg.selectedSegmentIndex == 0)
    {
        policyTermSegInt = 30;
    }else
    if(_policyTermSeg.selectedSegmentIndex == 1)
    {
        policyTermSegInt = 50;
    }
    
    [self getTermRule];
}


- (IBAction)quotationLangSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if(_quotationLangSegment.selectedSegmentIndex == 0)
    {
        quotationLang = @"English";
    } else if(_quotationLangSegment.selectedSegmentIndex == 1) {
        quotationLang = @"Malay";
    }    
}

-(int)scanForNumbersFromString:(NSString*)strData {
    NSScanner *scanner = [NSScanner scannerWithString:strData];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *numberString; //intermediate
    
    //throw away characters before the first number
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    //collect numbers
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    //result
    int num = [numberString integerValue];
    return num;
}

- (IBAction)MOPSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    int val = [self scanForNumbersFromString:[MOPSegment titleForSegmentAtIndex:MOPSegment.selectedSegmentIndex]];
    SavedMOP = val;
    appDelegate.isNeedPromptSaveMsg = YES;	
}

-(IBAction)S100MOPSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    int val = [self scanForNumbersFromString:[S100MOPSegment titleForSegmentAtIndex:S100MOPSegment.selectedSegmentIndex]];
    SavedMOP = val;
    appDelegate.isNeedPromptSaveMsg = YES;
}

- (IBAction)incomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (incomeSegment.selectedSegmentIndex == 0) {
        yearlyIncomeHLAIB = @"ACC";
    }
    else if (incomeSegment.selectedSegmentIndex == 1) {
        yearlyIncomeHLAIB = @"POF";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

- (IBAction)cashDividendSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (cashDividendSegment.selectedSegmentIndex == 0) {
        cashDividendHLAIB = @"ACC";
    }
    else if (cashDividendSegment.selectedSegmentIndex == 1) {
        cashDividendHLAIB = @"POF";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

- (IBAction)advanceIncomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (advanceIncomeSegment.selectedSegmentIndex == 0) {
        advanceYearlyIncomeHLAIB = 60;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 1) {
        advanceYearlyIncomeHLAIB = 75;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 2) {
        advanceYearlyIncomeHLAIB = 0;
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

- (IBAction)cashDivSgmntCPPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (cashDivSgmntCP.selectedSegmentIndex == 0) {
        cashDividendHLACP = @"ACC";
    }
    else if (cashDivSgmntCP.selectedSegmentIndex == 1) {
        cashDividendHLACP = @"POF";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

-(void)setPODictionaryFromRoot:(NSMutableDictionary *)dictionaryRootPO{
    if ([_dictionaryPOForInsert count]>0){
        int rootIsInternalStaff=[[dictionaryRootPO valueForKey:@"IsInternalStaff"] intValue];
        int isInternalStaff=[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
        
        if (![[_dictionaryPOForInsert valueForKey:@"ProductName"] isEqualToString:[dictionaryRootPO valueForKey:@"ProductName"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (![[_dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:[dictionaryRootPO valueForKey:@"RelWithLA"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (![[_dictionaryPOForInsert valueForKey:@"LA_DOB"] isEqualToString:[dictionaryRootPO valueForKey:@"LA_DOB"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (![[_dictionaryPOForInsert valueForKey:@"LA_Gender"] isEqualToString:[dictionaryRootPO valueForKey:@"LA_Gender"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (![[_dictionaryPOForInsert valueForKey:@"PO_DOB"] isEqualToString:[dictionaryRootPO valueForKey:@"PO_DOB"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (![[_dictionaryPOForInsert valueForKey:@"PO_Gender"] isEqualToString:[dictionaryRootPO valueForKey:@"PO_Gender"]]){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else if (isInternalStaff!=rootIsInternalStaff){
            [self resetField];
            _dictionaryPOForInsert=dictionaryRootPO;
        }
        else{
            _dictionaryPOForInsert=dictionaryRootPO;
        }
    }
    else{
        _dictionaryPOForInsert=dictionaryRootPO;
    }
}

-(NSMutableDictionary *)setDataBasicPlan{
    @try {
        NSString *discountText;
        NSString *purchaseNumberText;
        if (!_KKLKDiskaunBtn.text){
            discountText=@"";
        }
        else{
            discountText=_KKLKDiskaunBtn.text;
        }
        
        if (!_KKLKPembelianKeBtn.titleLabel.text){
            purchaseNumberText=@"";
        }
        else{
            purchaseNumberText=_KKLKPembelianKeBtn.titleLabel.text;
        }
        
        NSNumber* discount=[classFormatter convertAnyNonDecimalNumberToString:_KKLKDiskaunBtn.text];
        NSNumber* totalPremi=[classFormatter convertAnyNonDecimalNumberToString:_totalPremiWithLoadingField.text];
        
        double totalPremiWODiscount = [totalPremi doubleValue]+[discount doubleValue];
        NSMutableDictionary *dictionaryBasicPlan=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                  yearlyIncomeField.text,@"Sum_Assured",
                                                  //[classFormatter convertNumberFromString:yearlyIncomeField.text],@"Number_Sum_Assured",
                                                  [classFormatter convertAnyNonDecimalNumberToString:yearlyIncomeField.text],@"Number_Sum_Assured",
                                                  _masaPembayaranButton.titleLabel.text,@"Payment_Term",
                                                  _frekuensiPembayaranButton.titleLabel.text,@"Payment_Frequency",
                                                  _basicPremiField.text,@"PremiumPolicyA",
                                                  _extraPremiPercentField.text,@"ExtraPremiumPercentage",
                                                  _extraPremiNumberField.text,@"ExtraPremiumSum",
                                                  _masaExtraPremiField.text,@"ExtraPremiumTerm",
                                                  _extraBasicPremiField.text,@"ExtraPremiumPolicy",
                                                  _totalPremiWithLoadingField.text,@"TotalPremiumLoading",
                                                  _basicPremiFieldAfterDiscount.text,@"SubTotalPremium",
                                                  discountText,@"Discount",
                                                  purchaseNumberText,@"PurchaseNumber",
                                                  [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:totalPremiWODiscount]],@"TotalPremiWithoutDiscount",nil];
        return dictionaryBasicPlan;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }}

- (IBAction)doSavePlan:(id)sender
{
    //if ([self validateSave]){
    if ([self validationDataBasicPlan]){
        isFirstSaved = FALSE;
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        //[self updateBasicPlan];
        //[_delegate saveAll];
        [self passValidationCheck];
        [_delegate saveBasicPlan:[self setDataBasicPlan]];
    }
    
}

- (IBAction)tempNext:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    //[_delegate brngSubview:@"Rider"];
    //[_delegate brngSubview:@"Premium"];
    NSMutableDictionary *dictionaryBasicPlan=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                              yearlyIncomeField.text,@"Sum_Assured",
                                              _masaPembayaranButton.titleLabel.text,@"Payment_Term",
                                              _frekuensiPembayaranButton.titleLabel.text,@"Payment_Frequency",
                                              _basicPremiField.text,@"PremiumPolicyA",
                                              _extraPremiPercentField.text,@"ExtraPremiumPercentage",
                                              _extraPremiNumberField.text,@"ExtraPremiumSum",
                                              _masaExtraPremiField.text,@"ExtraPremiumTerm",
                                              _extraBasicPremiField.text,@"ExtraPremiumPolicy",
                                              _totalPremiWithLoadingField.text,@"TotalPremiumLoading",
                                              @"0",@"SubTotalPremium",nil];
    //[self updateBasicPlan];
    //[_delegate saveAll];
    [_delegate saveBasicPlan:dictionaryBasicPlan];
}


-(void)RealTimeFormat:(UITextField *)sender{
    NSNumber *plainNumber = [classFormatter convertAnyNonDecimalNumberToString:sender.text];
    [sender setText:[classFormatter numberToCurrencyDecimalFormatted:plainNumber]];
}

-(void)AnnualIncomeChange:(id) sender
{
    BasisSumAssured = [(yearlyIncomeField.text) longLongValue];
    NSLog(@"basicsumassured %lli",BasisSumAssured);
    yearlyIncomeField.text = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    yearlyIncomeField.text = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    yearlyIncomeField.text = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    yearlyIncomeField.text = [yearlyIncomeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *result;
    
    /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    double entryFieldFloat = [yearlyIncomeField.text doubleValue];
    
    if ([yearlyIncomeField.text rangeOfString:@""].length == 3) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@"00"];
        
    } else  if ([yearlyIncomeField.text rangeOfString:@"."].length == 1) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        
    } else if ([yearlyIncomeField.text rangeOfString:@"."].length != 1) {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
        
    }
    
    
    if(yearlyIncomeField.text.length==0) {
        yearlyIncomeField.text = @"";
    } else {
        yearlyIncomeField.text = result;
    }*/
    
    /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
     [formatter setMaximumFractionDigits:2];
     [formatter setUsesGroupingSeparator:YES];
     [formatter setNumberStyle:NSNumberFormatterDecimalStyle];*/
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter = [classFormatter formatterForCurrencyText];
    double entryFieldFloat = [yearlyIncomeField.text doubleValue];
    
    if ([yearlyIncomeField.text rangeOfString:@""].length == 3) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@"00"];
        
    } else  if ([yearlyIncomeField.text rangeOfString:@"."].length == 1) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        
    } else if ([yearlyIncomeField.text rangeOfString:@"."].length != 1) {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
        
    }
    
    
    if(yearlyIncomeField.text.length==0) {
        yearlyIncomeField.text = @"";
    } else {
        yearlyIncomeField.text = result;
    }
    
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        [self PremiDasarActkklk];
    }
    else
    {
        [self PremiDasarAct];
        [self PremiDasarActB];
        [self ExtraNumbPremi];
        [self loadHeritageCalculation];
    }

    
}

-(void)PremiDasarIncomeChange:(NSString *)BAsicPremiDasar
{
    //BasisSumAssured = [yearlyIncomeField.text intValue];
    
    _basicPremiField.text = [BAsicPremiDasar stringByReplacingOccurrencesOfString:@" " withString:@""];
    _basicPremiField.text = [BAsicPremiDasar stringByReplacingOccurrencesOfString:@"," withString:@""];
    _basicPremiField.text = [BAsicPremiDasar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:0];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    double entryFieldFloat = [_basicPremiField.text doubleValue];
    
    if ([_basicPremiField.text rangeOfString:@""].length == 3)
    {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
        
    } else  if ([_basicPremiField.text rangeOfString:@"."].length == 1)
    {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
    } else if ([_basicPremiField.text rangeOfString:@"."].length != 1)
    {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
    }
    
    NSLog(@"uang dasar %@", result);
    
    if([result hasSuffix:@"."]){
        NSString *str = result;
        result = [str substringToIndex:[str length]-1];
    }
        
    
    if(_basicPremiField.text.length==0)
    {
        _basicPremiField.text = @"";
    } else {
        _basicPremiField.text = result;
    }
}




-(void)PremiDasarIncomeChangeB:(NSString *)BAsicPremiDasarB
{
    //BasisSumAssured = [yearlyIncomeField.text intValue];
    
    _extraBasicPremiField.text = [BAsicPremiDasarB stringByReplacingOccurrencesOfString:@" " withString:@""];
    _extraBasicPremiField.text = [BAsicPremiDasarB stringByReplacingOccurrencesOfString:@"," withString:@""];
    _extraBasicPremiField.text = [BAsicPremiDasarB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:0];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    double entryFieldFloat = [_extraBasicPremiField.text doubleValue];
    
    if ([_extraBasicPremiField.text rangeOfString:@""].length == 3) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@"00"];
        
    } else  if ([_extraBasicPremiField.text rangeOfString:@"."].length == 1) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        
    } else if ([_extraBasicPremiField.text rangeOfString:@"."].length != 1) {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
        
    }
    
    if(_extraBasicPremiField.text.length==0)
    {
        _extraBasicPremiField.text = @"";
    } else {
        _extraBasicPremiField.text = result;
    }
}

-(void)PremiDasarIncomeChangeAplusB:(NSString *)BAsicPremiDasar
{
    //BasisSumAssured = [yearlyIncomeField.text intValue];
    
    _basicPremiField.text = [BAsicPremiDasar stringByReplacingOccurrencesOfString:@" " withString:@""];
    _basicPremiField.text = [BAsicPremiDasar stringByReplacingOccurrencesOfString:@"," withString:@""];
    _basicPremiField.text = [BAsicPremiDasar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *result;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    double entryFieldFloat = [_basicPremiField.text doubleValue];
    
    if ([_basicPremiField.text rangeOfString:@""].length == 3) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@"00"];
        
    } else  if ([_basicPremiField.text rangeOfString:@"."].length == 1) {
        formatter.alwaysShowsDecimalSeparator = YES;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        
    } else if ([_basicPremiField.text rangeOfString:@"."].length != 1) {
        formatter.alwaysShowsDecimalSeparator = NO;
        result =[formatter stringFromNumber:[NSNumber numberWithDouble:entryFieldFloat]];
        result = [result stringByAppendingFormat:@""];
        
    }
    
    if(_basicPremiField.text.length==0)
    {
        _basicPremiField.text = @"";
    } else {
        _basicPremiField.text = result;
    }
}



-(BOOL)checkingSave:(NSString *)getSex
{
    if([getSex length]>0) {
        sex = getSex;
        sex = [PremiumViewController getShortSex:sex];
    }
    
    [self checkExistRider];
    if ([self isPlanChanged]) {
        if (arrExistRiderCode.count > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert setTag:1007];
            [alert show];
        }
    }
    
    if (useExist) {
        if([self updateBasicPlan]) {
            return YES;
        }
    } else {
        [self saveBasicPlan];
        return YES;
    }
    [self checkingExisting];
    return NO;
}

-(BOOL)isPlanChanged
{
    if( [prevPlanChoose length]==0 ) {
        return false;
    } else {
        if( [prevPlanChoose isEqualToString:planChoose] ) {
            return false;
        } else {
            return true;
        }
    }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 && buttonIndex == 0) {
        
        NewLAViewController *NewLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        MainScreenPage.IndexTab = 3;
        NewLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentViewController:MainScreenPage animated:YES completion:^(){
            [MainScreenPage presentViewController:NewLAPage animated:NO completion:nil];
            NewLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
            
        }];
    } else if (alertView.tag==1002 && buttonIndex == 0) {
        [self checkingSave:@""];
    } else if (alertView.tag==1003 && buttonIndex == 0) {
        [self checkingSave:@""];
    } else if (alertView.tag==1004 && buttonIndex == 0) {
		//        [self closeScreen];
    } else if (alertView.tag == 1007 && buttonIndex == 0) {
        [self deleteRider];
    } else if (alertView.tag==1010){
        btnPlan.titleLabel.text = @"";
        [self togglePlan];
    } else if (alertView.tag==1011){
        btnPlan.titleLabel.text = @"";
        [self togglePlan];
    }
    else if (alertView.tag==2){
        [self loadHeritageCalculation];
    }
}

#pragma mark - Toogle view

-(void)toggleExistingField
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:getSumAssured]];
    sumAss = [sumAss stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([planChoose isEqualToString:prevPlanChoose]) {
        yearlyIncomeField.text = [[NSString alloc] initWithFormat:@"%@",sumAss];
    } else {
        yearlyIncomeField.text = @"";
    }
    
    if ([quotationLang isEqualToString:@"English"]) {
        _quotationLangSegment.selectedSegmentIndex = 0;
    }
    else if ([quotationLang isEqualToString:@"Malay"]) {
        _quotationLangSegment.selectedSegmentIndex = 1;
    }
    
    if ([planChoose isEqualToString:STR_HLAWP]) {
        SavedMOP = MOP;
        if (MOP == 6) {
            MOPSegment.selectedSegmentIndex = 0;
        } else if (MOP == 10) {
            MOPSegment.selectedSegmentIndex = 1;
        } else {
            MOP = 6;
            MOPSegment.selectedSegmentIndex = 0;
        }
        
        SavedMOP = MOP;
        
        parAccField.text = [NSString stringWithFormat:@"%d",getParAcc];
        parPayoutField.text = [NSString stringWithFormat:@"%d",getParPayout];
        
        if([cashDividend length]>0 && ![cashDividend isEqualToString:@"(null)"]) {
            cashDividendHLACP = cashDividend;
        }
        
        if ([cashDividendHLACP isEqualToString:@"ACC"]) {
            cashDivSgmntCP.selectedSegmentIndex = 0;
        } else if ([cashDividendHLACP isEqualToString:@"POF"]) {
            cashDivSgmntCP.selectedSegmentIndex = 1;
        }
    
        if (getPolicyTerm == 30) {
            policyTermSegInt = 30;
            _policyTermSeg.selectedSegmentIndex = 0;
        } else if (getPolicyTerm == 50) {
            policyTermSegInt = 50;
            _policyTermSeg.selectedSegmentIndex = 1;
        }
    
    } else if ([planChoose isEqualToString:STR_S100]) {
        if (SavedMOP == 0) {
            SavedMOP = MOP;
        }
        NSString *tempMOPStr = [NSString stringWithFormat:@"%d", MOP];
        int i=0;
        for (i=0;i < S100MOPSegment.numberOfSegments-1; i++) {
            if ([[S100MOPSegment titleForSegmentAtIndex:i] isEqualToString:tempMOPStr]) {
                if (i == S100MOPSegment.numberOfSegments-1) {
                    MOP = 100 - ageClient;
                    SavedMOP = MOP;
                }

                break;
            }
        }
        S100MOPSegment.selectedSegmentIndex = i;
    }
    
    if (getHL.length != 0) {
        NSRange rangeofDot = [getHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getHL substringToIndex:rangeofDot.location ];
            } else {
                valueToDisplay = getHL;
            }
        } else {
            valueToDisplay = getHL;
        }
        HLField.text = valueToDisplay;
    }
    
    if (getHLTerm != 0) {
        HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];
    }
    
    if (getTempHL.length != 0) {
        NSRange rangeofDot = [getTempHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getTempHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getTempHL substringToIndex:rangeofDot.location ];
            } else {
                valueToDisplay = getTempHL;
            }
        }
        else {
            valueToDisplay = getTempHL;
        }
        tempHLField.text = valueToDisplay;
    }
    
    if (getTempHLTerm != 0) {
        tempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];		
    }
    [self getPlanCodePenta];
    [self getTermRule];
    [_delegate BasicSI:getSINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text
            andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP
           andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose planName:(NSString *)btnPlan.titleLabel.text];
}

-(void)updateHealthLoading {
    getHL = @"";
    HLField.text = @"";
    getHLTerm = 0;
    HLTermField.text = @"";
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Trad_Details SET HL1KSA=\"%@\", HL1KSATerm=\"%d\" WHERE SINo=\"%@\"",getHL, getHLTerm, SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateCurrentHealthLoading {
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                getHL = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getHLTerm = sqlite3_column_int(statement, 1);
                getTempHL = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                getTempHLTerm = sqlite3_column_int(statement, 3);
                
                HLField.text = getHL;
                HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];
                tempHLField.text = getTempHL;
                tempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateTemporaryHealthLoading {
    getTempHL = @"";
    tempHLField.text = @"";
    getTempHLTerm = 0;
    tempHLTermField.text = @"";
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Trad_Details SET TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\" WHERE SINo=\"%@\"",getTempHL, getTempHLTerm, SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
}

-(void)reloadPaymentOption
{
    if ([planChoose isEqualToString:STR_S100]) {
        // temporary hack
        if (S100MOPSegment.selectedSegmentIndex == S100MOPSegment.numberOfSegments-1) {
            SavedMOP = 100 - ageClient;
        }
        MOP = SavedMOP;
    }
}

-(void)togglePlan
{    
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    BOOL isDiffPlan = FALSE;
    if (planChoose != NULL && ![planChoose isEqualToString:prevPlanChoose]) {
        getSumAssured = 0;
        yearlyIncomeField.text = @"";
        isDiffPlan = TRUE;
    }
    if ([planChoose isEqualToString:STR_HLAWP]) {
        [self togglePlanHLAWP:zzz];
        if (isDiffPlan) {
            SavedMOP = 0;
        }          
    } else if ([planChoose isEqualToString:STR_S100]) {
        [self togglePlanS100:zzz];
        if (isDiffPlan) {
            // temporary hack
            SavedMOP = 100 - ageClient;
            MOP = SavedMOP;
        }
                
    } else {
        labelPremiumPay.hidden = YES;
        cashDivSgmntCP.hidden = YES;
        labelFour.hidden = YES;
        labelFive.hidden = YES;
        labelSix.hidden = YES;
        labelSeven.hidden = YES;
        labelParAcc.hidden = YES;
        labelParPayout.hidden = YES;
        labelPercent1.hidden = YES;
        labelPercent2.hidden = YES;
        parPayoutField.hidden = YES;
        parAccField.hidden = YES;
        MOPSegment.hidden = YES;
        S100MOPSegment.hidden = YES;
        incomeSegment.hidden = YES;
        cashDividendSegment.hidden = YES;
        advanceIncomeSegment.hidden = YES;
        btnPlan.titleLabel.text = @"";
        planChoose = nil;
    }
    
    [self getTermRule];
    
}

-(void)togglePlanS100:(AppDelegate *)zzz {
    
    _policyTermSeg.hidden = YES;
    cashDivSgmntCP.hidden = YES;
    labelFour.hidden = YES;
    labelFive.hidden = YES;
    labelSeven.hidden = YES;
    labelParAcc.hidden = YES;
    labelParPayout.hidden = YES;
    labelPercent1.hidden = YES;
    labelPercent2.hidden = YES;
    parPayoutField.hidden = YES;
    parAccField.hidden = YES;
    MOPSegment.hidden = YES;
    S100MOPSegment.hidden = NO;
    incomeSegment.hidden = YES;
    cashDividendSegment.hidden = YES;
    advanceIncomeSegment.hidden = YES;
    labelSix.hidden = YES;
    labelPremiumPay.hidden = NO;
    labelPremiumPay.text = @"Premium Payment Term :";
    
    [self setS100MOPsegment];
    labelThree.text = @"Basic Sum Assured(RM)* :";    
    labelFour.text = @"Premium Payment Term* :";
    
    zzz.planChoose = planChoose;
    termField.hidden = NO;
    btnPlan.titleLabel.text = @"";
    labelThree.text = @"Basic Sum Assured :";
    planChoose = STR_L100;
    zzz.planChoose = planChoose;
    termField.hidden = NO;
    termField.text = [NSString stringWithFormat:@"%d", 100 - ageClient];
    [self.btnPlan setTitle:@"" forState:UIControlStateNormal];
    
    [MOPSegment setTitle:@" Single Payment " forSegmentAtIndex:0];
    [MOPSegment setTitle:@" 5 payment " forSegmentAtIndex:1];
    
    [advanceIncomeSegment setTitle:@" Lump Sum " forSegmentAtIndex:0];
    [advanceIncomeSegment setTitle:@" Annually " forSegmentAtIndex:1];
    [advanceIncomeSegment setTitle:@" Monthly " forSegmentAtIndex:2];

}

-(void)setS100MOPsegment {
    // clear segment
    [S100MOPSegment removeAllSegments];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT MaxTerm FROM Trad_Sys_mtn WHERE PlanCode=\"S100\"";
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            UILabel *label;
            CGRect frame;
            NSString *mopstr;
            NSString *temp;
            int count = 0;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                mopstr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                if ([mopstr isEqualToString:@"100"]) {
                    temp = @"Whole\nPolicy\nTerm";
                } else {
                    temp = [[NSString alloc] initWithFormat:@"Limited\n%@\nyears", mopstr];
                }
                [S100MOPSegment insertSegmentWithTitle:temp atIndex:count animated:NO];
                count++;
            }
            
            for (UIView *subview in [S100MOPSegment subviews]) {
                if ([NSStringFromClass(subview.class) isEqualToString:@"UISegment"]) {
                    for (UIView *labelView in [subview subviews]) {
                        if ([NSStringFromClass(labelView.class) isEqualToString:@"UISegmentLabel"]) {
                            label = (id)labelView;
                            label.numberOfLines = 3;
                            label.textAlignment = NSTextAlignmentCenter;
                            frame = CGRectMake(0, 0, label.frame.size.width, 160);
                            label.frame = frame;
                            break;
                        }
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }

}


-(int)getIntDataInDatabase:(NSString *)table forKey:(NSString *)key withValue:(NSString *)value whereKey:(NSString *)whereKey whereValue:(NSString *)whereValue{
    
    sqlite3_stmt *statement;
    NSString *resultStr;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@=\"%@\"", key, table, whereKey, whereValue];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                resultStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
            }            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return [resultStr integerValue];
}

-(void)setHLAWPMOPsegment {
    // clear segment
    [MOPSegment removeAllSegments];
    [MOPSegment insertSegmentWithTitle:@"6 years" atIndex:0 animated:NO];
    [MOPSegment insertSegmentWithTitle:@"10 years" atIndex:1 animated:NO];
}

-(NSDictionary *)loadPlistWithName:(NSString *)name {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return data;
}

-(void) togglePlanHLAWP:(AppDelegate *)del {
    _policyTermSeg.hidden = NO;
    cashDivSgmntCP.hidden = NO;
    labelPremiumPay.hidden = NO;
    labelPremiumPay.text = @"Premium Payment Option";
    labelThree.text = @"Desired Annual Premium(RM)* :";
    labelFour.numberOfLines = 4;
    labelFour.text = @"Monthly Cash Coupons/Yearly Cash Coupons/Cash Payments\n(Only applicable if Wealth Savings\nRider(s) is attached) :";
    labelFour.hidden = NO;
    labelFive.text = @"Cash Dividend :";
    labelFive.hidden = NO;
    labelSix.text = @"";
    labelSeven.text = @"";
    labelParAcc.hidden = NO;
    labelParPayout.hidden = NO;
    labelPercent1.hidden = NO;
    labelPercent2.hidden = NO;
    parPayoutField.hidden = NO;
    parAccField.hidden = NO;
    MOPSegment.hidden = NO;
    S100MOPSegment.hidden = YES;
    [self setHLAWPMOPsegment];
    incomeSegment.hidden = YES;
    cashDividendSegment.hidden = YES;
    advanceIncomeSegment.hidden = YES;
    [cashDivSgmntCP setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    //MOPHLACP = 6;
    advanceYearlyIncomeHLACP = 0;
    btnPlan.titleLabel.text = @"";
    planChoose = STR_HLAWP;
    termField.hidden = NO;
    termField.text = [NSString stringWithFormat:@"%d", 100 - age];
    del.planChoose = planChoose;
    
    [self.btnPlan setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - calculationForKeluargaku
-(int)getPaymentType{
    int PaymentType;
    if ([_frekuensiPembayaranButton.titleLabel.text isEqualToString:@"Tahunan"])
    {
        PaymentType =1;
    }
    else if ([_frekuensiPembayaranButton.titleLabel.text isEqualToString:@"Semester"])
    {
        PaymentType =2;
    }
    else if ([_frekuensiPembayaranButton.titleLabel.text isEqualToString:@"Kuartal"])
    {
        PaymentType =3;
    }
    else {
        PaymentType =4;
    }
    return PaymentType;
}

-(void)calculateRiderPremi{
    NSMutableDictionary* dictForCalculate =[[NSMutableDictionary alloc]initWithObjectsAndKeys:_extraPremiPercentField.text,@"ExtraPremiPerCent",_extraPremiNumberField.text,@"ExtraPremiPerMil",_masaExtraPremiField.text,@"MasaExtraPremi", nil];

    NSMutableDictionary* dictForCalculateBPPremi;

    NSString *personCharacterType;
    if (([[_dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[_dictionaryPOForInsert valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        personCharacterType = @"T";
        dictForCalculateBPPremi=[[NSMutableDictionary alloc]initWithObjectsAndKeys:_extraPremiPercentField.text,@"ExtraPremiPerCent",_extraPremiNumberField.text,@"ExtraPremiPerMil",_masaExtraPremiField.text,@"MasaExtraPremi", nil];
        
    }
    else{
         personCharacterType = @"P";
         dictForCalculateBPPremi=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"ExtraPremiPerCent",@"0",@"ExtraPremiPerMil",@"0",@"MasaExtraPremi", nil];
    }
    
    //double RiderPremium = [riderCalculation calculateBPPremi:dictForCalculate DictionaryBasicPlan:[self setDataBasicPlan] DictionaryPO:_dictionaryPOForInsert BasicCode:@"KLK" PaymentCode:[self getPaymentType] PersonType:personCharacterType];
    double MDBKKPremi = [riderCalculation calculateMDBKK:dictForCalculate DictionaryBasicPlan:[self setDataBasicPlan] DictionaryPO:_dictionaryPOForInsert BasicCode:@"KLK" PaymentCode:[self getPaymentType] PersonType:personCharacterType];
    double MDBKKLoading = [riderCalculation calculateMDBKKLoading:dictForCalculate DictionaryBasicPlan:[self setDataBasicPlan] DictionaryPO:_dictionaryPOForInsert BasicCode:@"KLK" PaymentCode:[self getPaymentType] PersonType:personCharacterType];
    //double RiderLoading = [riderCalculation calculateBPPremiLoading:dictForCalculateBPPremi DictionaryBasicPlan:[self setDataBasicPlan] DictionaryPO:_dictionaryPOForInsert BasicCode:@"KLK" PaymentCode:[self getPaymentType] PersonType:personCharacterType];
    
    //double premiDasar = RiderPremium + MDBKKPremi + roundedDiscount;
    double premiDasar = MDBKKPremi + roundedDiscount;
    //double extrapremi = MDBKKLoading + RiderLoading;
    double extrapremi = MDBKKLoading;
    //double totalPremi = RiderPremium + MDBKKPremi + MDBKKLoading + RiderLoading;
    double totalPremi = MDBKKPremi + MDBKKLoading;
    
    NSString *PremiDasar = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiDasar]];
    NSString *ExtraPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:extrapremi]];
    NSString *TotalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:totalPremi]];
    NSString *TotalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKPremi]];
    [_basicPremiField setText:PremiDasar];
    [_extraBasicPremiField setText:ExtraPremi];
    [_totalPremiWithLoadingField setText:TotalPremi];
    [_basicPremiFieldAfterDiscount setText:TotalPremiAfterDiscount];
}


#pragma mark - calculation

-(double)getBasicSAFactor{
    if (termCover == 50) {
        return 2.5;
    }
    else if (termCover == 30){
        return 1.5;
    }
    else{
        return 0.00;
    }
}

-(void)getOccpCatCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT OccpCatCode FROM Adm_OccpCat_Occp WHERE OccpCode=\"%@\"",pTypeOccp];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                OccpCat = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                OccpCat = [OccpCat stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)calculateSA //exact copy of RiderViewController.m
{
    double dblPseudoBSA;
    double dblPseudoBSA2 ;
    double dblPseudoBSA3 ;
    double dblPseudoBSA4 ;
    NSString *str;    
    getSumAssured = [yearlyIncomeField.text doubleValue];    
    if ([planChoose isEqualToString:STR_HLAWP]) {
        dblPseudoBSA = getSumAssured * MOP * [self getBasicSAFactor];
        dblPseudoBSA2 = dblPseudoBSA * 0.1;
        dblPseudoBSA3 = dblPseudoBSA * 5;
        dblPseudoBSA4 = dblPseudoBSA * 2;
    } else {
        dblPseudoBSA = getSumAssured / 0.05;
        dblPseudoBSA2 = dblPseudoBSA * 0.1;
        dblPseudoBSA3 = dblPseudoBSA * 5;
        dblPseudoBSA4 = dblPseudoBSA * 2;
    }
    
    double pseudoFactor = 0;
    if(termCover == 30)
    {
        pseudoFactor = 1.5;
    } else if(termCover == 50) {
        pseudoFactor = 2.5;
    }
    
    int MaxUnit = 0;    
    if ([riderCode isEqualToString:@"ACIR_MPP"])
    {
        _maxRiderSA = fmin(getSumAssured,4000000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    } else if ([riderCode isEqualToString:@"CCTR"]) {
        if([planChoose isEqualToString:STR_HLAWP]) {
            _maxRiderSA = dblPseudoBSA * 5;
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        } else if([planChoose isEqualToString:STR_S100]) {
            _maxRiderSA = getSumAssured;
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
            maxRiderSA = maxRiderSA * maxSAFactor;
        }
    } else if ([riderCode isEqualToString:@"TPDYLA"]) {
        if ([planChoose isEqualToString:STR_S100]) {
            if ([OccpCat isEqualToString:@"UNEMP"] || [OccpCat isEqualToString:@"JUV"] || [OccpCat isEqualToString:@"STU"] || [OccpCat isEqualToString:@"HSEWIFE"] || [OccpCat isEqualToString:@"RET"] ) {
                _maxRiderSA = fmin(24000, floor(getSumAssured * maxSAFactor));
            } else {
                _maxRiderSA = fmin(200000, getSumAssured * maxSAFactor);
            }
        } else if ([planChoose isEqualToString:STR_HLAWP]) {
            if ([OccpCat isEqualToString:@"UNEMP"] || [OccpCat isEqualToString:@"JUV"] || [OccpCat isEqualToString:@"STU"] || [OccpCat isEqualToString:@"HSEWIFE"] || [OccpCat isEqualToString:@"RET"] ) {
                _maxRiderSA = fmin(24000, floor(dblPseudoBSA * maxSAFactor));
            } else {
                _maxRiderSA = fmin(200000, dblPseudoBSA * maxSAFactor);
            }            
        }
        
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
        
    } else if ([riderCode isEqualToString:@"CPA"]) {
        if (OccpClass == 1 || OccpClass == 2) {
            if([planChoose isEqualToString:STR_HLAWP])
            {
                if (dblPseudoBSA < 100000) {
                    _maxRiderSA = fmin(dblPseudoBSA3,200000);
                    NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                    maxRiderSA = [a_maxRiderSA doubleValue];
                } else if (dblPseudoBSA >= 100000) {
                    _maxRiderSA = fmin(dblPseudoBSA4,1000000);
                    NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                    maxRiderSA = [a_maxRiderSA doubleValue];
                }
            } else if([planChoose isEqualToString:STR_S100]) {
                if (getSumAssured < 100000) {
                    _maxRiderSA = fmin(getSumAssured*5,200000);
                    NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                    maxRiderSA = [a_maxRiderSA doubleValue];
                } else if (getSumAssured >= 100000) {
                    _maxRiderSA = fmin(getSumAssured*2,maxSATerm);
                    NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                    maxRiderSA = [a_maxRiderSA doubleValue];
                }
            }
        } else if (OccpClass == 3 || OccpClass == 4) {
            if([planChoose isEqualToString:STR_HLAWP]) {
                _maxRiderSA = fmin(dblPseudoBSA3,100000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            } else if([planChoose isEqualToString:STR_S100]) {
                _maxRiderSA = fmin(getSumAssured *5,100000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
        }
    } else if ([riderCode isEqualToString:@"PA"]) {
        if ([planChoose isEqualToString:STR_HLAWP])
        {
            _maxRiderSA = fmin(5 * dblPseudoBSA,1000000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        } else if ([planChoose isEqualToString:STR_S100]) {
            _maxRiderSA = fmin(5* getSumAssured,maxSATerm);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        }
    } else if ([riderCode isEqualToString:@"PTR"]) {
        if ([planChoose isEqualToString:STR_S100]) {
            _maxRiderSA = fmin(getSumAssured * 5, 500000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        } else {
            _maxRiderSA = fmin(5 * dblPseudoBSA, 500000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        }
    } else if ([riderCode isEqualToString:@"HB"]) {
               double tempPseudo = 0.00;
        if ([planChoose isEqualToString:STR_HLAWP]) {
            tempPseudo = dblPseudoBSA;
        } else if ([planChoose isEqualToString:STR_S100]){
            tempPseudo = getSumAssured;
        }
        
        if (tempPseudo >= 10000 && tempPseudo <= 25000) {
            MaxUnit = 4;
        } else if (tempPseudo >= 25001 && tempPseudo <= 50000) {
            MaxUnit = 6;
        } else if (tempPseudo >= 50001 && tempPseudo <= 75000) {
            MaxUnit = 8;
        } else if (tempPseudo > 75000) {
            MaxUnit = 10;
        } else {
            MaxUnit = 0;
        }
        
        maxRiderSA = MaxUnit;
    } else if ([riderCode isEqualToString:@"ETPDB"]) {
        double max = basicPremAnn * 10;
        _maxRiderSA = fmin(max, maxSATerm);
        maxRiderSA = _maxRiderSA;
    } else if ([riderCode isEqualToString:@"ICR"]) {
        double minOf = -1;
        if ([planChoose isEqualToString:STR_HLAWP]) {
            _maxRiderSA = MIN(120000, dblPseudoBSA);
            
        } else if ([planChoose isEqualToString:STR_S100] ) {
            minOf = getSumAssured;
            _maxRiderSA = fmin(minOf, 120000);            
            
        }
        
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
        
    } else {
        if ([planChoose isEqualToString:STR_HLAWP] || [planChoose isEqualToString:STR_S100] )
        {
            if ([riderCode isEqualToString:@"CIR"]||[riderCode isEqualToString:@"LCPR"]) {
                _maxRiderSA = 4000000 ; // ignore for temp
            } else {
                _maxRiderSA = maxSATerm;
            }
        } else {
            _maxRiderSA = maxSATerm;
        }
        
        if([riderCode isEqualToString:@"WB30R"] || [riderCode isEqualToString:@"WB50R"] || [riderCode isEqualToString:@"WBD10R30"] || [riderCode isEqualToString:@"WBI6R30"]) {        
            if (requestEDD == TRUE) {
                _maxRiderSA = floor((15000 - getSumAssured)/maxGycc * 1000);
            } else {
                _maxRiderSA = MIN(floor(getSumAssured *  maxGycc/1000.00), 9999999) ;
            }
            
        } else if([riderCode isEqualToString:@"EDUWR"]) {
            if (requestEDD == TRUE) {
                _maxRiderSA = floor((15000 - getSumAssured)/maxGycc * 1000);
            } else {
                _maxRiderSA = getSumAssured * maxGycc/1000;
            }            
        } else if([riderCode isEqualToString:@"WBM6R"]) {
            float fac = 1;
            if (requestEDD) {
                fac = 46320;
                maxSATerm = (15000 - getSumAssured) / fac * 1000;
            } else {
                if (ageClient <= 61) {
                    fac = 1079;
                } else if (ageClient == 62) {
                    fac = 255;
                } else if (ageClient == 63) {
                    fac = 143;
                } else if (ageClient == 64) {
                    fac = 95;
                } else if (ageClient == 65) {
                    fac = 71;
                }
                _maxRiderSA = getSumAssured * fac / 1000;
            }

        } else if([riderCode isEqualToString:@"WP30R"] || [riderCode isEqualToString:@"WP50R"] ) {
            _maxRiderSA = 999999999;
        } else if([riderCode isEqualToString:@"WPTPD30R"] ) {
            double tempAll = 3500000 - [self CalcTPDbenefit : &str excludeSelf:TRUE];
            double tempGrossPrem = 0.00;
            double temps;
            
            if( [LRiderCode indexOfObject:@"WPTPD50R"] != NSNotFound){
                temps =  1000000 - [[LSumAssured objectAtIndex:[LRiderCode indexOfObject:@"WPTPD50R"]] doubleValue];
                tempGrossPrem = 60 * dblGrossPrem - [[LSumAssured objectAtIndex:[LRiderCode indexOfObject:@"WPTPD50R"]] doubleValue];
            } else {
                temps = 1000000;
                tempGrossPrem = 60 * dblGrossPrem;
            }
            
            _maxRiderSA = floor(MIN(tempGrossPrem, MIN(tempAll, temps)));
            
        } else if([riderCode isEqualToString:@"WPTPD50R"]) {
            double tempAll = 3500000 - [self CalcTPDbenefit : &str excludeSelf:TRUE];
            double tempGrossPrem = 0.00;
            double temps;
            
            if( [LRiderCode indexOfObject:@"WPTPD30R"] != NSNotFound && WPTPD30RisDeleted == FALSE){
                temps = 1000000 - [[LSumAssured objectAtIndex:[LRiderCode indexOfObject:@"WPTPD30R"]] doubleValue];
                tempGrossPrem = 60 * dblGrossPrem - [[LSumAssured objectAtIndex:[LRiderCode indexOfObject:@"WPTPD30R"]] doubleValue];
            } else {
                temps = 1000000;
                tempGrossPrem = 60 * dblGrossPrem;
            }
            
            _maxRiderSA = floor(MIN(tempGrossPrem, MIN(tempAll, temps)));
        }
        
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
}

-(void)CalcPrem{        
    PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
    premView.requestAge = ageClient;
    premView.requestOccpClass = requestOccpClass;
    premView.requestOccpCode = requestOccpCode;
    premView.requestSINo = getSINo;
    premView.requestMOP = MOP;
    premView.requestTerm = termCover;
    premView.requestBasicSA = yearlyIncomeField.text;
    premView.requestBasicHL = getHL;
    premView.requestBasicTempHL = getTempHL;
    premView.requestPlanCode = planChoose;
    premView.requestBasicPlan = planChoose;
    premView.sex = GenderPP;
    premView.EAPPorSI = [self.EAPPorSI description];
    premView.executeMHI = FALSE;

    premView.fromReport = FALSE;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 0, 0) ];
    [view addSubview:premView.view];

    dblGrossPrem = premView.ReturnGrossPrem;
  
    [view removeFromSuperview ];
    view = Nil;
    premView = Nil;
}

-(double)CalcTPDbenefit : (NSString **)aaMsg excludeSelf : (BOOL)aaExcludeSelf{
    sqlite3_stmt *statement;
    double tempValue = 0.00;
    double tempPrem = 0;
    double tempPremWithoutLoading = 0;
    int count = 1;
    NSMutableString *strRiders = [[NSMutableString alloc] initWithString: @""];
    NSMutableDictionary *tempArray = [[NSMutableDictionary alloc] init];
    NSString *tempCode;
    int getTerm = termCover;
    int getMOP = MOP;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;        
        querySQL = [NSString stringWithFormat:@"SELECT Ridercode, sumAssured FROM TRAD_Rider_Details WHERE RiderCode in ('CCTR', 'LCPR', 'WPTPD30R', 'WPTPD50R' ) "
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
        
        if (aaExcludeSelf == TRUE) {
            querySQL = [NSString stringWithFormat:@"SELECT Type, replace(Annually, ',', ''),replace(PremiumWithoutHLoading, ',', '') FROM SI_STORE_PREMIUM "
                        "WHERE TYPE in ('B', 'CCTR', 'EDUWR', 'LCPR', 'WB30R', 'WB50R','WBI6R30', 'WBD10R30', 'WBM6R', 'WPTPD30R', 'WPTPD50R' ) AND SINO = '%@' AND TYPE <> '%@' ",
                        getSINo, riderCode];
        } else {
            querySQL = [NSString stringWithFormat:@"SELECT Type, replace(Annually, ',', ''),replace(PremiumWithoutHLoading, ',', '') FROM SI_STORE_PREMIUM "
                        "WHERE TYPE in ('B', 'CCTR', 'EDUWR', 'LCPR', 'WB30R', 'WB50R','WBI6R30', 'WBD10R30', 'WBM6R', 'WPTPD30R', 'WPTPD50R' ) AND SINO = '%@' ",
                        getSINo];
        }
        
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
                        [strRiders appendFormat:@"%d. %@\n", count, tempCode];
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
                        
                    }
                    else{
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
                }
                else{
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
                    } else{
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
    
    if (tempValue > 3500000 && count > 1) {
        *aaMsg = strRiders;
    }

    
    return tempValue;
}

-(void) getRiderTermRuleGYCC:(NSString*)rider riderTerm:(int)riderTerm
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        
        if (requestEDD == TRUE) {
            querySQL = [NSString stringWithFormat: @"select gycc from SI_Trad_Rider_HLAWP_GYCC where planoption='%@' and PolTerm='%d' and premPayOpt='%d' and StartAge = \"%d\" AND EndAge = \"%d\"", rider,
                        [rider isEqualToString:@"EDUWR"] ? termCover : riderTerm,
                        MOP, -1, -1];
        }
        else{
            querySQL = [NSString stringWithFormat: @"select gycc from SI_Trad_Rider_HLAWP_GYCC where planoption='%@' and PolTerm='%d' and premPayOpt='%d' and StartAge <= \"%d\" AND EndAge >= \"%d\"", rider,
                        [rider isEqualToString:@"EDUWR"] ? termCover : riderTerm,
                        MOP,ageClient,ageClient];
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                maxGycc = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(double)calculateBasic:(double)basicSA Rate:(double)rate withFormatter:(NSNumberFormatter *)formatter {
    double basic;
    if ([planChoose isEqualToString:STR_HLAWP])
    {
        basic = basicSA * rate;
    } else {        
        basic = basicRate * (basicSA/1000) * rate;
    }
    
    NSString *basicStr = [formatter stringFromNumber:[NSNumber numberWithDouble:basic]];
    double basicValue = [[basicStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    return basicValue;
}

-(double)calculateOccLoading:(double)basicSA Rate:(double)rate PolicyTerm:(int)policyTerm withFormatter:(NSNumberFormatter *)formatter {
    double occpl = 0;
    if ([planChoose isEqualToString:STR_HLAWP]) {
        double factor = 0;
        if(policyTerm == 30) {
            factor = 1.5;
        } else if(policyTerm == 50) {
            factor = 2.5;
        }
        
        occpl = occLoad *factor * basicSA * MOP * rate;
        
    } else if ([planChoose isEqualToString:STR_S100]) {
        occpl = occLoad * (basicSA/1000) * rate;        
    }
    
    NSString *occplStr = [formatter stringFromNumber:[NSNumber numberWithDouble:occpl]];
    double occplValue = [[occplStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    return occplValue;
}

-(double)calculateHealthLoading:(double)basicSA Rate:(double)rate BasicHLoad:(double)basicHLoad BasicTempHLoad:(double)basicTempHLoad withFormatter:(NSNumberFormatter *)formatter {
    //calculate basic health loading
    double basicHL = basicHLoad * (basicSA/1000) * rate;
    
    //calculate basic temporary health loading
    double basicTempHL = basicTempHLoad * (basicSA/1000) * rate;
    
    double allHLoading = basicHL + basicTempHL;
    
    NSString *basicHStr = [formatter stringFromNumber:[NSNumber numberWithDouble:allHLoading]];
    double basicHLValue = [[basicHStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    return basicHLValue;
}

-(double)calculateLSD:(double)basicSA Rate:(double)rate withFormatter:(NSNumberFormatter *)formatter {
    
    double lsd = LSDRate * (basicSA/1000) * rate;
    NSString *lsdStr = [formatter stringFromNumber:[NSNumber numberWithDouble:lsd]];
    
    //for negative value
    lsdStr = [lsdStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    lsdStr = [lsdStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    double lsdValue = [[lsdStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    return lsdValue;
}

-(void)calculateBasicPremium
{
    [self getBasicSIRate:ageClient toAge:ageClient];
    NSString *basicTotalA = nil;
    NSString *basicTotalS = nil;
    NSString *basicTotalQ = nil;
    NSString *basicTotalM = nil;
    
    double BasicSA = [yearlyIncomeField.text doubleValue];
    double PolicyTerm = [[self getTerm] doubleValue];
    double BasicHLoad = [getHL doubleValue];
    double BasicTempHLoad = [getTempHL doubleValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    //calculate basic premium    
    double BasicAnnually_ = [self calculateBasic:BasicSA Rate:annualRate withFormatter:formatter];
    double BasicHalfYear_ = [self calculateBasic:BasicSA Rate:semiAnnualRate withFormatter:formatter];
    double BasicQuarterly_ = [self calculateBasic:BasicSA Rate:quarterlyRate withFormatter:formatter];
    double BasicMonthly_ = [self calculateBasic:BasicSA Rate:monthlyRate withFormatter:formatter];    
    
    
    //calculate occupationLoading
    double OccpLoadA_ = [self calculateOccLoading:BasicSA Rate:annualRate PolicyTerm:PolicyTerm withFormatter:formatter];
    double OccpLoadH_ = [self calculateOccLoading:BasicSA Rate:semiAnnualRate PolicyTerm:PolicyTerm withFormatter:formatter];
    double OccpLoadQ_ = [self calculateOccLoading:BasicSA Rate:quarterlyRate PolicyTerm:PolicyTerm withFormatter:formatter];
    double OccpLoadM_ = [self calculateOccLoading:BasicSA Rate:monthlyRate PolicyTerm:PolicyTerm withFormatter:formatter];
    
    //calculate basic health loading
    double BasicHLAnnually_ = [self calculateHealthLoading:BasicSA Rate:annualRate BasicHLoad:BasicHLoad BasicTempHLoad:BasicTempHLoad withFormatter:formatter];
    double BasicHLHalfYear_ = [self calculateHealthLoading:BasicSA Rate:semiAnnualRate BasicHLoad:BasicHLoad BasicTempHLoad:BasicTempHLoad withFormatter:formatter];
    double BasicHLQuarterly_ = [self calculateHealthLoading:BasicSA Rate:quarterlyRate BasicHLoad:BasicHLoad BasicTempHLoad:BasicTempHLoad withFormatter:formatter];
    double BasicHLMonthly_ = [self calculateHealthLoading:BasicSA Rate:monthlyRate BasicHLoad:BasicHLoad BasicTempHLoad:BasicTempHLoad withFormatter:formatter];
    
    //calculate LSD
    double LSDAnnually_ = [self calculateLSD:BasicSA Rate:annualRate withFormatter:formatter];
    double LSDHalfYear_ = [self calculateLSD:BasicSA Rate:semiAnnualRate withFormatter:formatter];
    double LSDQuarterly_ = [self calculateLSD:BasicSA Rate:quarterlyRate withFormatter:formatter];
    double LSDMonthly_ = [self calculateLSD:BasicSA Rate:monthlyRate withFormatter:formatter];
    
    //calculate Total basic premium
    double _basicTotalA = 0;
    double _basicTotalS = 0;
    double _basicTotalQ = 0;
    double _basicTotalM = 0;
    if (BasicSA < 1000) {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ + LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ + LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ + LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ + LSDMonthly_;
    } else {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ - LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ - LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ - LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ - LSDMonthly_;
    }
    
    basicTotalA = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalA]];
    basicTotalS = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalS]];
    basicTotalQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalQ]];
    basicTotalM = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalM]];
    
    
    basicPremAnn = [[basicTotalA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremHalf = [[basicTotalS stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremQuar = [[basicTotalQ stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremMonth = [[basicTotalM stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
}

#pragma mark - Handle DB

-(void)getRunningSI {
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
                SalesIlustrationDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
            }
            else{
                SILastNo = 0;
                SalesIlustrationDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(void)getRunningCustCode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\" AND LastUpdated like \"%%%@%%\" ",dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
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
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated=\"%@\" WHERE TrnTypeCode=\"SI\"",newLastNo, dateString];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
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
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,MinTerm,MaxTerm,MinSA,MaxSA,ExpiryAge FROM Trad_Sys_Mtn WHERE PlanCode=\"%@\"",planChoose];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int minAge =  sqlite3_column_int(statement, 0);
                maxAge =  sqlite3_column_int(statement, 1);				
				maxSA = sqlite3_column_int(statement, 5);
                
                if([planChoose isEqualToString:STR_HLAWP]) // @Edwin 14-7-2014 <-- totally wrong logic
                {
                    minSA = sqlite3_column_int(statement, 4);                       
                    termCover = getPolicyTerm == 0 ? 30 : getPolicyTerm; //30 is the default term for HLAWP
                    
                    if(_policyTermSeg.selectedSegmentIndex == 1) {
                        maxAge = 45;
                        minSA = 1800;
                    } else if(_policyTermSeg.selectedSegmentIndex == 0) {
                        if(MOPSegment.selectedSegmentIndex == 0) { // 6
                            if(ageClient==63) { 
                                minSA = 1500;
                            } else if(ageClient==64) {
                                minSA = 1600;
                            } else if(ageClient==65) {
                                minSA = 1700;
                            }
                        } else if(MOPSegment.selectedSegmentIndex == 1) {
                            minSA = 1500;
                        }
                    }
                } else if ([planChoose isEqualToString:STR_S100]) {
                    
                    minSA = sqlite3_column_int(statement, 4);
                    termCover = 100 - ageClient;
                    [S100MOPSegment setSelectedSegmentIndex:(S100MOPSegment.numberOfSegments-1)];
                    if (MOP > 0) {
                        for (int i=0; i<S100MOPSegment.numberOfSegments-1; i++) {
                            if ([[S100MOPSegment titleForSegmentAtIndex:i] rangeOfString:[NSString stringWithFormat:@"%d", MOP]].location != NSNotFound) {
                                [S100MOPSegment setSelectedSegmentIndex:i];
                                break;
                            }
                        }
                    }
                }
                termField.text = [[NSString alloc] initWithFormat:@"%d",termCover];
                
                if (ageClient < minAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Age Last Birthday must be greater than or equal to %d for this product.",minAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    alert.tag = 1011;
                    [alert show];
                } else if (ageClient > maxAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to %d for this product.",maxAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    alert.tag = 1010;
                    [alert show];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (getSINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)getExistingBasic:(BOOL) fromViewLoad
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT SINo, PlanCode, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome,HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm,PartialAcc,PartialPayout,QuotationLang FROM Trad_Details WHERE SINo=\"%@\"",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                if([planChoose length]==0)
                    planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                prevPlanChoose =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                getPolicyTerm = sqlite3_column_int(statement, 2);
                getSumAssured = sqlite3_column_double(statement, 3);
                MOP = sqlite3_column_int(statement, 4);
                if([planChoose isEqualToString:STR_HLAWP])
                {
                    if([cashDividend length] == 0 || [cashDividend isEqualToString:@"(null)"])
                    {
                        cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                    }
                }
                
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                advanceYearlyIncome = sqlite3_column_int(statement, 7);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 8);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 9);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 10);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 11);
                
                if([planChoose isEqualToString:STR_HLAWP])
                {
                    if( (![parAccField.text isEqualToString:@"0"] && ![parAccField.text isEqualToString:@""]) ||
                       (![parPayoutField.text isEqualToString:@"0"] && ![parPayoutField.text isEqualToString:@""])) {
                        getParAcc = [parAccField.text intValue];
                        getParPayout = [parPayoutField.text intValue];
                    } else {
                        getParAcc = sqlite3_column_int(statement, 12);
                        getParPayout = sqlite3_column_int(statement, 13);
                    }
                }
				
                if(sqlite3_column_text(statement, 14) == NULL)
                {
                    quotationLang = nil;
                } else {
                    if(fromViewLoad) {
                        quotationLang = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                    } else {
                        if(_quotationLangSegment.selectedSegmentIndex == 0) {
                            quotationLang = @"English";
                        } else if(_quotationLangSegment.selectedSegmentIndex == 1) {
                            quotationLang = @"Malay";
                        }
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(NSString*) getTerm
{
    NSString *term = nil;
    if([planChoose isEqualToString:STR_HLAWP]) {
        term = [NSString stringWithFormat:@"%d",policyTermSegInt];
    } else {
        term = termField.text;
    }
    return term;
}

-(void)saveBasicPlan
{    
    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoSI = SILastNo + 1;
    int runningNoCust = CustLastNo + 1;
    NSString *fooSI = [NSString stringWithFormat:@"%04d", runningNoSI];
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    SINo = [[NSString alloc] initWithFormat:@"SI%@-%@",currentdate,fooSI];
    LACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
	NSString *AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        sqlite3_stmt *statement;
        NSString *query = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"", SINo];
        BOOL isUpdate = FALSE;
        if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                isUpdate = TRUE;
            }
            sqlite3_finalize(statement);
        }
        
        if (isUpdate) {
            query = [NSString stringWithFormat:
                     @"UPDATE Trad_Details SET PlanCode=\"%@\", PTypeCode=\"LA\", Seq=\"1\", PolicyTerm=\"%@\", BasicSA=\"%@\", "
                     "PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", "
                     "TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", CreatedAt=%@,UpdatedAt=%@,PartialAcc=%d,PartialPayout=%d, QuotationLang=\"%@\", SIVersion='%@', SIStatus='%@' "
                     "WHERE SINo=\"%@\"",
                     planChoose, [self getTerm], yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,
                     advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text,
                     [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")",
                     [parAccField.text intValue],[parPayoutField.text intValue], quotationLang, AppsVersion, @"INVALID", SINo];
        } else {
            query = [NSString stringWithFormat:
                       @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, "
                       "PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, "
                       "TempHL1KSA, TempHL1KSATerm, CreatedAt,UpdatedAt,PartialAcc,PartialPayout, QuotationLang, SIVersion, SIStatus) "
                       "VALUES (\"%@\", \"%@\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", "
                       "\"%d\", \"%@\", \"%d\", %@ , %@,%d,%d, \"%@\", '%@', '%@')",
                       SINo, planChoose, [self getTerm], yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,
                       advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text,
                       [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")",
                       [parAccField.text intValue],[parPayoutField.text intValue], quotationLang, AppsVersion, @"INVALID"];
        }
        
        if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [self updateLA];
                [self getPlanCodePenta];
				
                prevPlanChoose = planChoose;
                
                if (PayorIndexNo != 0) {
					IndexNo = PayorIndexNo;
					[self getProspectData];
                    [self savePayor];
                }
				
                if (secondLAIndexNo != 0) {
					IndexNo = secondLAIndexNo;
					[self getProspectData];
                    [self saveSecondLA]; 
                }
                
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose planName:(NSString *)btnPlan.titleLabel.text];
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.SICompleted = YES;
                [self updateFirstRunSI];
            } else {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    appDelegate.isSIExist = YES;
}

-(void)savePayor
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    PYCustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {   
        NSString *insertSQL = [NSString stringWithFormat:
                               @"UPDATE Trad_LAPayor SET SINo=\"%@\", CustCode=\"%@\", PTypeCode=\"PY\", Sequence=\"1\", DateCreated=\"%@\",CreatedBy=\"hla\" WHERE CustCode=\"PY\"",
							   SINo, PYCustCode,dateStr];
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        
        int ANB =PayorAge + 1;
        insertSQL = [NSString stringWithFormat:
                     @"UPDATE Clt_Profile SET CustCode=\"%@\", Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateCreated=\"%@\", CreatedBy=\"hla\", indexNo=\"%d\" "
                     "WHERE CustCode=\"PY\"",
								PYCustCode, NamePP, PayorSmoker, PayorSex, PayorDOB, PayorAge, ANB, PayorOccpCode, dateStr,PayorIndexNo];
		
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }        
        
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

-(NSString*) getCustCode:(NSString*)currentDate
{
    int runningNoCust = CustLastNo;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];	
    NSString *custcode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentDate,fooCust];
    
    return custcode;
}


-(void)saveSecondLA
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
	
    secondLACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];

    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querysQL;
        querysQL = [NSString stringWithFormat:
                               @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",SINo, secondLACustCode,dateStr]; 
        if(sqlite3_prepare_v2(contactDB, [querysQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        
        int ANB = secondLAAge + 1;
        querysQL = [NSString stringWithFormat:
								@"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) "
								"VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")",
								secondLACustCode, NamePP, secondLASmoker, [secondLASex substringToIndex:1], secondLADOB, secondLAAge,
								ANB, secondLAOccpCode, dateStr,secondLAIndexNo];
        
        if(sqlite3_prepare_v2(contactDB, [querysQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
        
    }
}

-(void)updateLA
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Clt_Profile SET CustCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" WHERE id=\"%d\"",LACustCode,currentdate,idProf];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
        }
        
        querySQL = [NSString stringWithFormat:
							   @"UPDATE Trad_LAPayor SET SINo=\"%@\", CustCode=\"%@\", DateModified=\"%@\", "
							   "ModifiedBy=\"hla\" WHERE rowid=\"%d\"", SINo,LACustCode,currentdate,idPay];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

-(int)ReturnPaymentTerm :(NSString *)aaPlanChosen {
    if ([aaPlanChosen isEqualToString:STR_HLAWP]) {
        return MOPSegment.selectedSegmentIndex == 0 ? 6 : 10;
    } else if ([aaPlanChosen isEqualToString:STR_S100]) {
        return MOP;
    } else{
        return 0;
    }
}

-(BOOL)updateBasicPlan
{
    if (planChoose != NULL) {
        [self getTermRule];
    }
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {        
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET PlanCode=\"%@\", PolicyTerm=\"%@\", BasicSA=\"%@\", PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", UpdatedAt=%@, PartialAcc=\"%d\", PartialPayout=\"%d\" , QuotationLang=\"%@\" WHERE SINo=\"%@\"", planChoose, [self getTerm], yearlyIncomeField.text, [self ReturnPaymentTerm:planChoose], cashDividend, yearlyIncome,advanceYearlyIncome, @"datetime(\"now\", \"+8 hour\")",[parAccField.text intValue],[parPayoutField.text intValue], quotationLang, SINo];
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            int status = sqlite3_step(statement);
            if (status == SQLITE_DONE) {
                prevPlanChoose = planChoose;
                [self getPlanCodePenta];
                
                if([planChoose isEqualToString:STR_HLAWP]) {
                    termCover = policyTermSegInt;
                }
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose planName:(NSString *)btnPlan.titleLabel.text];
                
                if ([planChoose isEqualToString:STR_HLAWP] || [planChoose isEqualToString:STR_S100]) {
                    getSumAssured = [yearlyIncomeField.text doubleValue];
                }
            } else {                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
                return NO;
            }
            sqlite3_finalize(statement);            
        }
        sqlite3_close(contactDB);
    }
    
    if ([planChoose isEqualToString:STR_HLAWP]) {
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            NSString *querySQL;
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET RiderTerm=\"%@\", payingTerm = '%@' WHERE SINo=\"%@\" AND RiderCode in ('HMM', 'MG_IV')", [self getTerm],[self getTerm], SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET RiderTerm=\"%d\", payingTerm = '%d' WHERE SINo=\"%@\" AND RiderCode = 'CPA'",
                        (65 - ageClient) > [[self getTerm] intValue] ? [[self getTerm] intValue]: (65 - ageClient) , MIN([[self getTerm] intValue], (65 - ageClient)), SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET RiderTerm=\"%d\", payingTerm = '%d' WHERE SINo=\"%@\" AND RiderCode = 'PA'",
                        MIN([[self getTerm] intValue], (75 - ageClient)) , MIN([[self getTerm] intValue], (75 - ageClient)), SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);               
                sqlite3_finalize(statement);
            }
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET RiderTerm=\"%d\", payingTerm = '%d' WHERE SINo=\"%@\" AND RiderCode in ('MG_II', 'HSP_II') ",
                        MIN((70 - ageClient), [[self getTerm] intValue]), MIN((70 - ageClient), [[self getTerm] intValue]),  SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);               
                sqlite3_finalize(statement);
            }
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET RiderTerm=\"%d\", payingTerm = '%d' WHERE SINo=\"%@\" AND RiderCode in ('HB') ",
                        MIN((60 - ageClient), [[self getTerm] intValue]), MIN((60 - ageClient), [[self getTerm] intValue]),  SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);               
                sqlite3_finalize(statement);
            }            
            
            querySQL = [NSString stringWithFormat:@"UPDATE Trad_Rider_Details SET payingTerm='%d' WHERE SINo=\"%@\" AND RiderCode in ('EDUWR','WB30R','WB50R','WBI6R30','WBD10R30', 'WP30R', 'WP50R', 'WPTPD30R', 'WPTPD50R') ",
                        MOP, SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);               
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(contactDB);
        }
    }

    [self getListingRider];
    
    if ([LRiderCode indexOfObject:@"WPTPD30R"] != NSNotFound ||
        [LRiderCode indexOfObject:@"WPTPD50R"] != NSNotFound ||
        [LRiderCode indexOfObject:@"LCPR"] != NSNotFound ||
        [LRiderCode indexOfObject:@"PLCP"] != NSNotFound ||
        [LRiderCode indexOfObject:@"ACIR_MPP"] != NSNotFound ||
        [LRiderCode indexOfObject:@"CCTR"] != NSNotFound ||
        [LRiderCode indexOfObject:@"CIR"] != NSNotFound ||
        [LRiderCode indexOfObject:@"ICR"] != NSNotFound ) {
        [self CalcPrem];
    }
    
    NSString *strRiders = @"";
    BOOL onlyTPDRiders = FALSE;
    BOOL WBTPDRidersExist = FALSE;
    
    if ([LRiderCode indexOfObject:@"WPTPD30R"] != NSNotFound || [LRiderCode indexOfObject:@"WPTPD50R"] != NSNotFound) {        
        WBTPDRidersExist = TRUE;
        
        if ([LRiderCode indexOfObject:@"WB30R"] == NSNotFound &&
            [LRiderCode indexOfObject:@"WB50R"] == NSNotFound &&
            [LRiderCode indexOfObject:@"EDUWR"] == NSNotFound &&
            [LRiderCode indexOfObject:@"WBI6R30"] == NSNotFound &&
            [LRiderCode indexOfObject:@"WBD10R30"] == NSNotFound &&
            [LRiderCode indexOfObject:@"LCPR"] == NSNotFound &&
            [LRiderCode indexOfObject:@"CCTR"] == NSNotFound ) {
            onlyTPDRiders = TRUE;
        }        
    }    

    if (onlyTPDRiders == FALSE && WBTPDRidersExist == TRUE) {
        if ([self CalcTPDbenefit : &strRiders excludeSelf:FALSE] > 3500000) {
            NSString *msg = [NSString stringWithFormat:@"TPD Benefit Limit per Life for 1st Life Assured has exceeded RM3.5mil. "
                             "Please revise the RSA of Wealth TPD Protector or revise the RSA of the TPD related rider(s) below:\n %@", strRiders];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Basic"
                                                            message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
            [alert show ];
            [_delegate SwitchToRiderTab];
            return NO;
        }
    }
    
    if ([self validateExistingRider] == TRUE) {
        return YES;
    } else {
        return NO;
    }
}

-(void)checkExistRider
{
    arrExistRiderCode = [[NSMutableArray alloc] init];
    arrExistPlanChoice = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT RiderCode, PlanOption FROM Trad_Rider_Details WHERE SINo=\"%@\" and SEQ not in ('2')",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [arrExistRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [arrExistPlanChoice addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" and SEQ not in ('2') ",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [_delegate RiderAdded];
}

-(BOOL)validateExistingRider
{    
    BOOL dodelete = NO;
    int RTerm;
    
    double riderSA;
    int riderUnit;
    int HL1kTerm;
    int HL100Term;
    int HLPTerm;
    int HLTempTerm;
    
    int maxRiderTerm;
    if (LRiderCode.count > 0) {
        [self getLSDRate];
        [self getOccLoad];
        [self calculateBasicPremium];
    }
    
    int tempMaxRiderTerm = 0;
    for (int p=0; p<LRiderCode.count; p++) {
        riderCode = [LRiderCode objectAtIndex:p];
        tempMaxRiderTerm = [self calculateTerm];
        if (tempMaxRiderTerm > maxRiderTerm) {
            maxRiderTerm = tempMaxRiderTerm;
        }
    }
    
    for (int p=0; p<LRiderCode.count; p++) {
        riderCode = [LRiderCode objectAtIndex:p];
        RTerm = [[LTerm objectAtIndex:p] integerValue];
        
        if([riderCode isEqualToString:@"WB30R"] || [riderCode isEqualToString:@"WB50R"] || [riderCode isEqualToString:@"WBD10R30"] || [riderCode isEqualToString:@"WBI6R30"] ||
           [riderCode isEqualToString:@"EDUWR"] || [riderCode isEqualToString:@"WBM6R"]) {
            [self getRiderTermRuleGYCC:riderCode riderTerm:RTerm];
        }
        
        [self getRiderTermRule];
        tempMaxRiderTerm = [self calculateTerm];
        [self calculateSA];
        
        riderSA = [[LSumAssured objectAtIndex:p] doubleValue];
        riderUnit = [[LUnits objectAtIndex:p] intValue];
        HL1kTerm = [[LRidHL1KTerm objectAtIndex:p] intValue];
        HL100Term = [[LRidHL100Term objectAtIndex:p] intValue];
        HLPTerm = [[LRidHLPTerm objectAtIndex:p] intValue];
        HLTempTerm = [[LTempRidHL1KTerm objectAtIndex:p] intValue];
        
        if (RTerm > termCover) {
            dodelete = YES;
            [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
        } else if ([riderCode isEqualToString:@"LCWP"] || [riderCode isEqualToString:@"PR"] || [riderCode isEqualToString:@"SP_PRE"] || [riderCode isEqualToString:@"SP_STD"]) {
            if (RTerm > maxRiderTerm) {
                dodelete = YES;
                [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
            }
        } else if (RTerm > tempMaxRiderTerm && !([riderCode isEqualToString:@"PLCP"] || [riderCode isEqualToString:@"PTR"])) {
            dodelete = YES;
            [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
        }
        
        if ([planChoose isEqualToString:STR_HLAWP] &&
            ([riderCode isEqualToString:@"WB30R"] ||
             [riderCode isEqualToString:@"WB50R"] ||
             [riderCode isEqualToString:@"WBD10R30"] ||
             [riderCode isEqualToString:@"WBI6R30"] ||
             [riderCode isEqualToString:@"EDUWR"] ||
             [riderCode isEqualToString:@"WP30R"] ||
             [riderCode isEqualToString:@"WP50R"] ||
             [riderCode isEqualToString:@"WPTPD30R"] ||
             [riderCode isEqualToString:@"WPTPD50R"] ||
             [riderCode isEqualToString:@"WBM6R"])) {
            if (HL1kTerm > 0) {
                if(HL1kTerm > MOP){
                    dodelete = YES;
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            }
            
            if (HLTempTerm > 0) {
                if(HLTempTerm > MOP){
                    dodelete = YES;
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            }
                
            if ([riderCode isEqualToString:@"WBM6R"] && MOP != 6) {
                dodelete = YES;
                [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
            }
        
        } else { // not using MOP
            if (HL1kTerm > 0) {
                if(HL1kTerm > termCover) {
                    dodelete = YES;                    
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            } else if (HL100Term > 0) {
                if(HL100Term > termCover) {
                    dodelete = YES;
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            } else if (HLPTerm > 0) {
                if(HLPTerm > termCover) {
                    dodelete = YES;
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            }
            
            if (HLTempTerm > 0) {
                if(HLTempTerm > termCover) {
                    dodelete = YES;
                    [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
                }
            }
        }
        
        if (riderSA > [RiderViewController getRoundedSA:maxRiderSA]) {
            dodelete = YES;
            [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
            if ([riderCode isEqualToString:@"WPTPD30R"]) {
                WPTPD30RisDeleted = TRUE;
            }            
        }
        
        if (riderUnit > maxRiderSA) {
            dodelete = YES;
            [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
        }
        
        if ([planChoose isEqualToString:STR_S100]) {
            if (getSumAssured < 500000 && [[LPlanOpt objectAtIndex:p] isEqualToString:@"HMM_1000"]) {
                dodelete = YES;
                [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];                
            }
            
            if ([[LRiderCode objectAtIndex:p] isEqualToString:@"ACIR_MPP"] && riderSA > [yearlyIncomeField.text doubleValue] ) {
                dodelete = YES;
                [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
            }
        } else if ([planChoose isEqualToString:STR_HLAWP] && (getSumAssured * MOP * [self getBasicSAFactor]) < 500000 && [[LPlanOpt objectAtIndex:p] isEqualToString:@"HMM_1000"]) {
            dodelete = YES;
            [self deleteSpecificRider:requestSINo WithRiderCode:riderCode];
        }
        
    }
    
    if (dodelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [_delegate RiderAdded];
        return FALSE;
    }
    
    return TRUE;
}

-(void)deleteSpecificRider:(NSString *)SiNo  WithRiderCode:(NSString *)triderCode {
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",SiNo,triderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        
        if ([triderCode isEqualToString:@"PR"]) {
            // remove PTR as well
            querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"PTR\"",SiNo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
        } else if ([triderCode isEqualToString:@"LCWP"]) {
            // remove PLCP as well
            querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"PLCP\"",SiNo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPlanCodePenta
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"%@\"",planChoose];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)  {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getProspectData //to get name for payor or second LA from prospect_profile
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getListingRider
{
    LRiderCode = [[NSMutableArray alloc] init];
    LSumAssured = [[NSMutableArray alloc] init];
    LTerm = [[NSMutableArray alloc] init];
    LPlanOpt = [[NSMutableArray alloc] init];
    LUnits = [[NSMutableArray alloc] init];
    LDeduct = [[NSMutableArray alloc] init];
    LRidHL1K = [[NSMutableArray alloc] init];
    LRidHL100 = [[NSMutableArray alloc] init];
    LRidHLP = [[NSMutableArray alloc] init];
    LSmoker = [[NSMutableArray alloc] init];
    LSex = [[NSMutableArray alloc] init];
    LAge = [[NSMutableArray alloc] init];
    LOccpCode = [[NSMutableArray alloc] init];
    LTempRidHL1K = [[NSMutableArray alloc] init];
    LRidHL1KTerm = [[NSMutableArray alloc] init];
    LRidHL100Term = [[NSMutableArray alloc] init];
    LRidHLPTerm = [[NSMutableArray alloc] init];
    LTempRidHL1KTerm = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.RiderCode, a.SumAssured, a.RiderTerm, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.Smoker, c.Sex, c.ALB, c.OccpCode, a.TempHL1KSA, a.HL1KSATerm, a.HL100SATerm, a.HLPercentageTerm, a.TempHL1KSATerm FROM Trad_Rider_Details a, Trad_LAPayor b, Clt_Profile c WHERE a.PTypeCode=b.PTypeCode AND a.Seq=b.Sequence AND b.CustCode=c.CustCode AND a.SINo=b.SINo AND a.SINo=\"%@\" ORDER by a.RiderCode asc",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            const char *aaRidCode;
            const char *aaRidSA;
            const char *aaTerm;
            const char *zzplan;
            const char *aaUnit;
            const char *deduct2;
            double ridHL;
            double ridHL100;
            double ridHLP;
            double TempridHL;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                aaRidCode = (const char *)sqlite3_column_text(statement, 0);
                [LRiderCode addObject:aaRidCode == NULL ? @"" : [[NSString alloc] initWithUTF8String:aaRidCode]];
                
                aaRidSA = (const char *)sqlite3_column_text(statement, 1);
                [LSumAssured addObject:aaRidSA == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaRidSA]];
                
                aaTerm = (const char *)sqlite3_column_text(statement, 2);
                [LTerm addObject:aaTerm == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaTerm]];
                
                zzplan = (const char *) sqlite3_column_text(statement, 3);
                [LPlanOpt addObject:zzplan == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzplan]];
                
                aaUnit = (const char *)sqlite3_column_text(statement, 4);
                [LUnits addObject:aaUnit == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaUnit]];
                
                deduct2 = (const char *) sqlite3_column_text(statement, 5);
                [LDeduct addObject:deduct2 == NULL ? @"" :[[NSString alloc] initWithUTF8String:deduct2]];
                
                ridHL = sqlite3_column_double(statement, 6);
                [LRidHL1K addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHL]];
                
                ridHL100 = sqlite3_column_double(statement, 7);
                [LRidHL100 addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHL100]];
                
                ridHLP = sqlite3_column_double(statement, 8);
                [LRidHLP addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHLP]];
                
                [LSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)]];
                [LSex addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [LAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
                [LOccpCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]];
                
                TempridHL = sqlite3_column_double(statement, 13);
                [LTempRidHL1K addObject:[[NSString alloc] initWithFormat:@"%.2f",TempridHL]];                
                [LRidHL1KTerm addObject:[[NSString alloc] initWithFormat:@"%.2f", sqlite3_column_double(statement, 14)]];                
                [LRidHL100Term addObject:[[NSString alloc] initWithFormat:@"%.2f",sqlite3_column_double(statement, 15)]];                
                [LRidHLPTerm addObject:[[NSString alloc] initWithFormat:@"%.2f",sqlite3_column_double(statement, 16)]];                
                [LTempRidHL1KTerm addObject:[[NSString alloc] initWithFormat:@"%.2f",sqlite3_column_double(statement, 17)]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getRiderTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,ExpiryAge,MinTerm,MaxTerm,MinSA,MaxSA,MaxSAFactor FROM Trad_Sys_Rider_Mtn WHERE RiderCode=\"%@\"",riderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                expAge =  sqlite3_column_int(statement, 2);
                minTerm =  sqlite3_column_int(statement, 3);
                maxTerm =  sqlite3_column_int(statement, 4);
                minSATerm = sqlite3_column_int(statement, 5);
                maxSATerm = sqlite3_column_int(statement, 6);
                maxSAFactor = sqlite3_column_double(statement, 7);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(int) getMaxRiderTerm:(NSString*)RiderCode {
    int tempMaxTerm = 0;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL;
        if ([riderCode isEqualToString:@"CIWP"]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"ACIR_MPP\" AND RiderCode !=\"CIR\" AND RiderCode !=\"ICR\" AND RiderCode !=\"LCPR\" AND RiderCode !=\"LCWP\" AND RiderCode !=\"PR\" AND RiderCode !=\"SP_PRE\" AND RiderCode !=\"SP_STD\" AND RiderCode !=\"WB30R\" AND RiderCode !=\"WB50R\" AND RiderCode !=\"EDUWR\" AND RiderCode !=\"WBI6R30\" AND RiderCode !=\"WBD10R30\" AND RiderCode !=\"WP30R\" AND RiderCode !=\"WP50R\" AND RiderCode !=\"WPTPD30R\" AND RiderCode !=\"WPTPD50R\"", getSINo ];
            
        } else if ([riderCode isEqualToString:@"LCWP"]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"LCWP\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"PLCP\"", getSINo ];
        } else if ([riderCode isEqualToString:@"PR"]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"PR\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"PTR\"", getSINo ];
        } else if ([riderCode isEqualToString:@"SP_PRE"] || [riderCode isEqualToString:@"SP_STD"]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"SP_STD\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"SP_PRE\"", getSINo ];
        } else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT  max(RiderTerm) as term FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode !=\"I20R\" AND RiderCode !=\"I30R\" AND RiderCode !=\"I40R\" AND RiderCode !=\"ID20R\" AND RiderCode !=\"ID30R\" AND RiderCode !=\"ID40R\" AND RiderCode !=\"CIWP\" AND RiderCode !=\"LCWP\" AND RiderCode !=\"PR\" AND RiderCode !=\"PLCP\" AND RiderCode !=\"PTR\" AND RiderCode !=\"SP_STD\" AND RiderCode !=\"SP_PRE\" AND RiderCode !=\"IE20R\" AND RiderCode !=\"IE30R\" AND RiderCode !=\"EDB\" AND RiderCode !=\"ETPDB\" AND RiderCode not in ('WB30R','WB50R','EDUWR','WBI6R30','WBD10R30','WP30R','WP50R','WPTPD30R','WPTPD50R') ",getSINo];
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempMaxTerm = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return tempMaxTerm;
    
}

-(int)calculateTerm
{
    int minus = -1000;//exaggeration easier for debugging
    
    minus = ageClient;
    int maxRiderTerm;
    
    int period = expAge - minus;
    int period2 = 80 - minus;
    double age1 = fmin(period2, 60);
    int storedMaxTerm = 0;
    
    if ([riderCode isEqualToString:@"CIWP"]) {
        storedMaxTerm = [self getMaxRiderTerm:riderCode];
        double maxRiderTerm1 = fmin(period, termCover);
        double maxRiderTerm2 = fmax(MOP,storedMaxTerm);
        
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
        
    } else if ([riderCode isEqualToString:@"LCWP"]||[riderCode isEqualToString:@"PR"]||[riderCode isEqualToString:@"PLCP"]||
             [riderCode isEqualToString:@"PTR"]||[riderCode isEqualToString:@"SP_STD"]||[riderCode isEqualToString:@"SP_PRE"]) {
        [self getMaxRiderTerm : riderCode];
        double maxRiderTerm1 = fmin(termCover,age1);
        double maxRiderTerm2 = fmax(MOP,storedMaxTerm);
        
        maxRiderTerm = fmin(maxRiderTerm1,maxRiderTerm2);
        if (maxRiderTerm < minTerm) {
            maxRiderTerm = maxTerm;
        }
        
        if (([riderCode isEqualToString:@"PLCP"] || [riderCode isEqualToString:@"PTR"]) && maxRiderTerm > maxTerm) {
            maxRiderTerm = maxTerm;
        }
    } else if ([riderCode isEqualToString:@"MG_II"] || [riderCode isEqualToString:@"HSP_II"] ) {
        maxRiderTerm = MIN(termCover, 70 - ageClient);        
    } else if ([riderCode isEqualToString:@"MG_IV"] || [riderCode isEqualToString:@"HMM"] ) {
        maxRiderTerm = termCover;
    } else if ([riderCode isEqualToString:@"CPA"]  ) {
        maxRiderTerm = MIN(termCover, 65 - ageClient);
    } else if ([riderCode isEqualToString:@"HB"]  ) {
        maxRiderTerm = MIN(termCover, 60 - ageClient);
    } else if ([riderCode isEqualToString:@"PA"]  ) {
        maxRiderTerm = MIN(termCover, 75 - ageClient);
    } else if ([riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]) {
        maxRiderTerm = fmin(period, termCover);        
    } else if([riderCode isEqualToString:@"WB30R"] || [riderCode isEqualToString:@"WB50R"] || [riderCode isEqualToString:@"WBI6R30"]
       || [riderCode isEqualToString:@"WBD10R30"] || [riderCode isEqualToString:@"WP30R"] || [riderCode isEqualToString:@"WP50R"]
       || [riderCode isEqualToString:@"WPTPD30R"] || [riderCode isEqualToString:@"WPTPD50R"] || [riderCode isEqualToString:@"WBM6R"]) {
        maxRiderTerm = maxTerm;
    } else if ([riderCode isEqualToString:@"ICR"] || [riderCode isEqualToString:@"TPDYLA"] || [riderCode isEqualToString:@"CIR"]) {
        maxRiderTerm = fmax(period, termCover);
    } else {
        maxRiderTerm = fmin(period, termCover);
    }
    return maxRiderTerm;
}

-(void)getBasicSIRate:(int)fromAge toAge:(int)toAge
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        NSString *sexStr;
        
        if( [sex isEqualToString:@"FEMALE"] ) {
            sexStr = @"F";
        } else if( [sex isEqualToString:@"MALE"] ) {
            sexStr = @"M";
        } else {
            sexStr = sex;
        }
        
        if([planChoose isEqualToString:STR_HLAWP]) {
            querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem_new WHERE PlanCode=\"%@\" AND FromAge=\"%d\" AND ToAge=\"%d\" and FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND PremPayOpt=\"%d\" ",
                        planChoose,fromAge,toAge,termCover,termCover,MOP];
        } else if([planChoose isEqualToString:STR_S100]) {
            int premPayOpt = 100;
            if (MOP != 100 - ageClient) {
                premPayOpt = MOP;
            }
            querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem_new WHERE PlanCode=\"%@\" AND Sex=\"%@\" AND FromAge=\"%d\" AND ToAge=\"%d\" AND PremPayOpt=\"%d\" ",planChoose,sexStr,fromAge,toAge, premPayOpt];
        } 
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccLoad
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Class, PA_CPA, OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",OccpCode];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occCPA_PA  = sqlite3_column_int(statement, 0);
                occLoad =  sqlite3_column_int(statement, 1);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
}

-(void)getOccLoadRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",pTypeOccp];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoadRider =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getLSDRate
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Basic_LSD WHERE PlanCode=\"%@\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",planChoose,yearlyIncomeField.text,yearlyIncomeField.text];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                LSDRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getHLAWPRiderRate:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND PremPayOpt=\"%d\"",RidCode,aaterm,fromAge,toAge,MOP];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getHLAWPRiderRateNonGYI:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND PremPayOpt=\"%d\" and sex='%@'",RidCode,aaterm,fromAge,toAge,MOP,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateSex:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND PremPayOpt=\"%d\" AND Sex=\"%@\" ",RidCode,aaterm,fromAge,toAge,MOP,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(double) getFormattedRates:(NSString *) ratesStr
{
    NSString *newString = [ratesStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    double d = [newString doubleValue];   
    
    return d;
}

-(void)getRiderRateSex:(NSString *)aaplan
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromMortality=0 AND Sex=\"%@\" AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,sex,age,age];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAge:(NSString *)aaplan riderTerm:(int)aaterm
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE RiderCode=\"%@\" AND FromTerm <=\"%d\" AND ToTerm >= \"%d\" AND FromMortality=0 AND FromAge<=\"%d\" AND ToAge >=\"%d\"",aaplan,aaterm,aaterm,age,age];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSex:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\"  AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" ",RidCode,aaterm,fromAge,toAge,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassMG_IV:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString * entryAgeGrp;
        int ageNo = [fromAge intValue];
        if( ageNo > 60 ) {
            entryAgeGrp = @"2";
        } else {
            entryAgeGrp = @"1";
        }
        
        int subClass;
        if(OccpClass == 2) {
            subClass = 1;
        } else {
            subClass = OccpClass;
        }
        
        planOption2 = [planOption2 stringByReplacingOccurrencesOfString:@"IVP_" withString:@""];
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, \"FromAge\", \"ToAge\" FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" AND occpClass = \"%d\" AND PlanOption=\"%@\" AND EntryAgeGroup=\"%@\"", RidCode,fromAge,toAge,sex, subClass, planOption2, entryAgeGrp];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassMG_II:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" AND occpClass = \"%d\" AND PlanOption=\"%@\"", RidCode,fromAge,toAge,sex, OccpClass, planOption2];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassHMM:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2 hmm:(NSString *)hmm
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString * entryAgeGrp;
        int ageNo = [fromAge intValue];
        if( ageNo > 60 ) {
            entryAgeGrp = @"2";
        } else {
            entryAgeGrp = @"1";
        }
        
        int subClass;
        if(OccpClass == 2) {
            subClass = 1;
        } else {
            subClass = OccpClass;
        }
        
        planOption2 = [planOption2 stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE "
                              "RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" AND occpClass = \"%d\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND EntryAgeGroup=\"%@\"", RidCode,fromAge,toAge,sex, subClass, planOption2, hmm, entryAgeGrp];
                
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeClassPA:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND occpClass = \"%d\" ",RidCode,fromAge,toAge, OccpClass ];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeClassHSP_II:(NSString *)RidCode riderTerm:(int)aaterm planHSPII:(NSString *)plans fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND occpClass = \"%d\" AND RiderOpt=\"%@\"",RidCode, fromAge,toAge, OccpClass,plans ];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexCplus:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOptC:(NSString *) plnOptC2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {       
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\"  AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" AND RiderOpt=\"%@\" ",RidCode,aaterm,fromAge,toAge,sex, plnOptC2];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateClass:(NSString *)RidCode riderTerm:(int)aaterm 
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" "
                              " AND occpClass = \"%d\" ",
                              RidCode, OccpClass];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - VALIDATION
- (void)createAlertViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}


- (bool)validationDataBasicPlan{
    bool valid=true;
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -",@"--Please Select--", nil];
    
    //validation message data refferal
    NSString *validationUangPertanggunganDasar=@"Uang Pertanggungan dasar harus diisi";
    NSString *validationMasaPembayaran=@"Masa Pembayaran harus diisi";
    NSString *validationFrekuensiPembayaran=@"Frekuensi Pembayaran harus diisi";
    NSString *validationMasaExtraPremi=@"Masa Extra Premi harus diisi";
    NSString *validationEmptyExtraPremi=@"Extra Premi harus diisi";
    NSString *validationDiskonLebih=@"Diskon untuk produk ini tidak boleh lebih dari 0. Tekan tombol OK untuk melakukan penghitungan ulang";
    NSString *validationUanglebih;
    
    NSString *validationUanglebihkk=@"Uang Pertangungan Dasar Min:Rp30,000,000 Max:Rp1,500,000,000";
    NSString *validationExtraPremi=@"Extra Premi harus 25%,50%,75%,100%.....300%";
    NSString *validationExtraNumber=@"Extra Premi 0/100 harus 1-10";
    NSString *validationPembelianKe=@"Pembelian Ke tidak boleh sama dengan 0";
    
    NSString* uangPertanggunganDasar=yearlyIncomeField.text;
    NSString* masaPembayaran=_masaPembayaranButton.titleLabel.text;
    NSString* frekuensiPembayaran=_frekuensiPembayaranButton.titleLabel.text;
    NSString* masaEktraPremi=_masaExtraPremiField.text;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    //NSNumber *myNumber = [f numberFromString:uangPertanggunganDasar];
    NSNumber *myNumber = [classFormatter convertAnyNonDecimalNumberToString:uangPertanggunganDasar];
    
    long long sumAssured = [myNumber longLongValue];
    long long maxNumber = 300000000000;
    long long minNumber;
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    NSNumber* diskonPremi = [classFormatter convertAnyNonDecimalNumberToString:_KKLKDiskaunBtn.text];
    if (IsInternalStaff==0){
        //minNumber= 1000000000;
        //validationUanglebih=@"Uang Pertangungan Dasar Min:Rp1,000,000,000 Max:Rp300,000,000,000";
        minNumber= 500000000;
        validationUanglebih=@"Uang Pertangungan Dasar Min:Rp500,000,000 Max:Rp300,000,000,000";
    }
    else{
        minNumber= 500000000;
        validationUanglebih=@"Uang Pertangungan Dasar Min:Rp500,000,000 Max:Rp300,000,000,000";
    }
    
    
    long long maxNumberkk = 1500000000;
    long long minNumberkk = 30000000;
    
    NSLog(@"%lld",sumAssured);
    NSLog(@"%lld",maxNumber);
    
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        if ([validationSet containsObject:uangPertanggunganDasar]||uangPertanggunganDasar==NULL){
            [self createAlertViewAndShow:validationUangPertanggunganDasar tag:0];
            [yearlyIncomeField becomeFirstResponder];
            return false;
        }

        else if ((sumAssured > maxNumberkk)||(sumAssured < minNumberkk)){
            [self createAlertViewAndShow:validationUanglebihkk tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ([_KKLKMasaPembayaran.text isEqualToString:@""]||_KKLKMasaPembayaran.text==NULL){
            [self createAlertViewAndShow:validationMasaPembayaran tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ([validationSet containsObject:frekuensiPembayaran]||frekuensiPembayaran==NULL){
            [self createAlertViewAndShow:validationFrekuensiPembayaran tag:0];
            //[btnOccp setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ([PembelianKEString intValue]==0){
            [self createAlertViewAndShow:validationPembelianKe tag:0];
            //[btnOccp setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ((![_extraPremiPercentField.text isEqualToString:@""] && ![_extraPremiPercentField.text isEqualToString:@"0"])&&![_extraPremiPercentField.text isEqualToString:@"25"]&&![_extraPremiPercentField.text isEqualToString:@"50"]&&![_extraPremiPercentField.text isEqualToString:@"75"]&&![_extraPremiPercentField.text isEqualToString:@"100"]&&![_extraPremiPercentField.text isEqualToString:@"125"]&&![_extraPremiPercentField.text isEqualToString:@"150"]&&![_extraPremiPercentField.text isEqualToString:@"175"]&&![_extraPremiPercentField.text isEqualToString:@"200"]&&![_extraPremiPercentField.text isEqualToString:@"225"]&&![_extraPremiPercentField.text isEqualToString:@"250"]&&![_extraPremiPercentField.text isEqualToString:@"275"]&&![_extraPremiPercentField.text isEqualToString:@"300"])
        {
            
            [self createAlertViewAndShow:validationExtraPremi tag:0];
            //[btnOccp setBackgroundColor:[UIColor redColor]];
            return false;
        }
        
        else if ((![_extraPremiNumberField.text isEqualToString:@""]&&![_extraPremiNumberField.text isEqualToString:@"1"]&&![_extraPremiNumberField.text isEqualToString:@"2"]&&![_extraPremiNumberField.text isEqualToString:@"3"]&&![_extraPremiNumberField.text isEqualToString:@"4"]&&![_extraPremiNumberField.text isEqualToString:@"5"]&&![_extraPremiNumberField.text isEqualToString:@"6"]&&![_extraPremiNumberField.text isEqualToString:@"7"]&&![_extraPremiNumberField.text isEqualToString:@"8"]&&![_extraPremiNumberField.text isEqualToString:@"9"]&&![_extraPremiNumberField.text isEqualToString:@"10"]))
        {
            [self createAlertViewAndShow:validationExtraNumber tag:0];
            [_masaExtraPremiField becomeFirstResponder];
            return false;
        }
        
        
        else if (([_extraPremiPercentField.text length]>0)||([_extraPremiNumberField.text length]>0))
        {
            if ([validationSet containsObject:masaEktraPremi]||masaEktraPremi==NULL)
            {
                [self createAlertViewAndShow:validationMasaExtraPremi tag:0];
                [_masaExtraPremiField becomeFirstResponder];
                return false;
            }
        }
        
        else if ([_masaExtraPremiField.text length]>0)
        {
            if (([_extraPremiPercentField.text length]==0)&&([_extraPremiNumberField.text length]==0))
            {
                [self createAlertViewAndShow:validationEmptyExtraPremi tag:0];
                return false;
            }
        }
        return valid;

        
    }else
    {
        if ([validationSet containsObject:uangPertanggunganDasar]||uangPertanggunganDasar==NULL){
            [self createAlertViewAndShow:validationUangPertanggunganDasar tag:0];
            [yearlyIncomeField becomeFirstResponder];
            return false;
        }
        else if ((sumAssured > maxNumber)||(sumAssured < minNumber)){
            [self createAlertViewAndShow:validationUanglebih tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        
        else if ([validationSet containsObject:masaPembayaran]||masaPembayaran==NULL){
            [self createAlertViewAndShow:validationMasaPembayaran tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ([validationSet containsObject:masaPembayaran]||masaPembayaran==NULL){
            [self createAlertViewAndShow:validationMasaPembayaran tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if ([validationSet containsObject:frekuensiPembayaran]||frekuensiPembayaran==NULL){
            [self createAlertViewAndShow:validationFrekuensiPembayaran tag:0];
            //[btnOccp setBackgroundColor:[UIColor redColor]];
            return false;
        }
        
        else if ((IsInternalStaff==0)&&([diskonPremi longLongValue]>0)){
            //if ([diskonPremi longLongValue]>0){
                [self createAlertViewAndShow:validationDiskonLebih tag:2];
                return false;
            //}
        }
        
        else if ((![_extraPremiPercentField.text isEqualToString:@""] && ![_extraPremiPercentField.text isEqualToString:@"0"])&&![_extraPremiPercentField.text isEqualToString:@"25"]&&![_extraPremiPercentField.text isEqualToString:@"50"]&&![_extraPremiPercentField.text isEqualToString:@"75"]&&![_extraPremiPercentField.text isEqualToString:@"100"]&&![_extraPremiPercentField.text isEqualToString:@"125"]&&![_extraPremiPercentField.text isEqualToString:@"150"]&&![_extraPremiPercentField.text isEqualToString:@"175"]&&![_extraPremiPercentField.text isEqualToString:@"200"]&&![_extraPremiPercentField.text isEqualToString:@"225"]&&![_extraPremiPercentField.text isEqualToString:@"250"]&&![_extraPremiPercentField.text isEqualToString:@"275"]&&![_extraPremiPercentField.text isEqualToString:@"300"])
        {
            
            [self createAlertViewAndShow:validationExtraPremi tag:0];
            //[btnOccp setBackgroundColor:[UIColor redColor]];
            return false;
        }
        
        else if ((![_extraPremiNumberField.text isEqualToString:@""]&&![_extraPremiNumberField.text isEqualToString:@"1"]&&![_extraPremiNumberField.text isEqualToString:@"2"]&&![_extraPremiNumberField.text isEqualToString:@"3"]&&![_extraPremiNumberField.text isEqualToString:@"4"]&&![_extraPremiNumberField.text isEqualToString:@"5"]&&![_extraPremiNumberField.text isEqualToString:@"6"]&&![_extraPremiNumberField.text isEqualToString:@"7"]&&![_extraPremiNumberField.text isEqualToString:@"8"]&&![_extraPremiNumberField.text isEqualToString:@"9"]&&![_extraPremiNumberField.text isEqualToString:@"10"]))
        {
            [self createAlertViewAndShow:validationExtraNumber tag:0];
            [_masaExtraPremiField becomeFirstResponder];
            return false;
        }
        
        else if (([_extraPremiPercentField.text length]>0)||([_extraPremiNumberField.text length]>0))
        {
            if ([validationSet containsObject:masaEktraPremi]||masaEktraPremi==NULL)
            {
                [self createAlertViewAndShow:validationMasaExtraPremi tag:0];
                [_masaExtraPremiField becomeFirstResponder];
                return false;
            }
        }
        
        else if ([_masaExtraPremiField.text length]>0)
        {
            if (([_extraPremiPercentField.text length]==0)&&([_extraPremiNumberField.text length]==0))
            {
                [self createAlertViewAndShow:validationEmptyExtraPremi tag:0];
                return false;
            }
        }
        
        
        return valid;
    }
    
}


-(int)validateSave//basic plan validation checking before save
{
    [_delegate isSaveBasicPlan:YES];//condition of life assured not matching hence cannot be save : @Edwin 3-10-2013:changed to NO as switching to Riders will increase the counter by 1, emptying the riders when switching tab to Basic and goes back to Rider
    int validatePasses = 100;
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSRange rangeofDotSUM = [yearlyIncomeField.text rangeOfString:@"."];
    NSString *substringSUM = @"";
    NSRange rangeofDotHL = [HLField.text rangeOfString:@"."];
    NSString *substringHL = @"";
    NSRange rangeofDotTempHL = [tempHLField.text rangeOfString:@"."];
    NSString *substringTempHL = @"";
    NSRange rangeofDotAcc = [parAccField.text rangeOfString:@"."];
    NSString *substringAcc = @"";
    NSRange rangeofDotPayout = [parPayoutField.text rangeOfString:@"."];
    NSString *substringPayout = @"";
    
    if (rangeofDotSUM.location != NSNotFound) {
        substringSUM = [yearlyIncomeField.text substringFromIndex:rangeofDotSUM.location ];
    }
    if (rangeofDotHL.location != NSNotFound) {
        substringHL = [HLField.text substringFromIndex:rangeofDotHL.location ];
    }
    if (rangeofDotTempHL.location != NSNotFound) {
        substringTempHL = [tempHLField.text substringFromIndex:rangeofDotTempHL.location ];
    }
    if (rangeofDotAcc.location != NSNotFound) {
        substringAcc = [parAccField.text substringFromIndex:rangeofDotAcc.location ];
    }
    if (rangeofDotPayout.location != NSNotFound) {
        substringPayout = [parPayoutField.text substringFromIndex:rangeofDotPayout.location ];
    }
    int maxParIncome = 0;
    NSString *msgType = nil;
    NSString *msgGYI = nil;
    if ([planChoose isEqualToString:STR_HLAWP]) {
        if (SavedMOP == 0) {
            SavedMOP = 6;
        }
        MOP = SavedMOP;
        cashDividend = cashDividendHLACP;
        advanceYearlyIncome = advanceYearlyIncomeHLACP;
        
        maxParIncome = [parAccField.text intValue] + [parPayoutField.text intValue];
        if ([parAccField.text intValue] == 0) {
            yearlyIncome = @"POF";
        } else {
            yearlyIncome = @"ACC";
        }
        
        if ([parAccField.text intValue] == 100 && parPayoutField.text.length == 0) {
            parPayoutField.text = @"0";
        }
        
        if ([parPayoutField.text intValue] == 100 && parAccField.text.length == 0) {
            parAccField.text = @"0";
        }
        msgType = @"Desired Annual Premium";
        msgGYI = @"Monthly Cash Coupons/Yearly Cash Coupons/Cash Payments";
    } else if ([planChoose isEqualToString:STR_S100]) {
        if (SavedMOP != 0) {
            MOP = SavedMOP; // get value from ui segment selection
        } else {
            MOP = 100 - ageClient;
        }
        msgType = @"Basic Sum Assured";
    } 
    
    if (![planChoose isEqualToString:prevPlanChoose]) {
        [self updateHealthLoading];
        [self updateTemporaryHealthLoading];
    }
    
    [self updateCurrentHealthLoading];
    if (msgType == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select a basic plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if (yearlyIncomeField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ is required.", msgType] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    } else if (substringSUM.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ only allow 2 decimal places.", msgType] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    } else if ([yearlyIncomeField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Invalid input format. %@ must be numeric 0 to 9 or dot(.)", msgType] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        yearlyIncomeField.text = @"";
        [yearlyIncomeField becomeFirstResponder];
    } else if (requestEDD == TRUE && [yearlyIncomeField.text intValue] > 15000 && [planChoose isEqualToString:STR_HLAWP] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"The Maximum allowable total annual premium (inclusive of Wealth Booster, Wealth Booster-m6, Wealth Booster-i6, Wealth Booster -d10 and EduWealth Riders) for an unborn Child allowable is RM15,000."] delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    } else if ([yearlyIncomeField.text intValue] < minSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ must be greater than or equal to %d",msgType,minSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    } else if ([yearlyIncomeField.text intValue] > maxSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"%@ must be less than or equal to %d",msgType,maxSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    } else if (!(MOP)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select Premium Payment option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //----------
	else if ([planChoose isEqualToString:STR_HLAWP] && ageClient > maxAge) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to %d for this product.",maxAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.tag = 1010;
        [alert show];
    }
	else if ([planChoose isEqualToString:STR_HLAWP] && parAccField.text.length==0 && parPayoutField.text.length==0  ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Please key in the Percentage of %@ Option.", msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && parAccField.text.length==0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Total Percentage of %@ Option must be 100%%",msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && parPayoutField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Total Percentage of %@ Option must be 100%%",msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && [parAccField.text intValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Total Percentage of %@ Option must be 100%%",msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && [parPayoutField.text intValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Total Percentage of %@ Option must be 100%%",msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && substringAcc.length > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Yearly Income Option must not contains decimal places."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && substringPayout.length > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Yearly Income Option must not contains decimal places."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:STR_HLAWP] && maxParIncome != 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Total Percentage of %@ Option must be 100%%", msgGYI] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLTermField becomeFirstResponder];
    }    
    else if ([planChoose isEqualToString:STR_HLAWP] && cashDividend.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select Cash Dividend option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //-------HL
    else if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if (substringHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([HLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (Per 1k SA) cannot be greater than or equal to 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([HLField.text intValue] > 0 && HLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([HLTermField.text intValue] > 0 && HLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([HLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) into Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLTermField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([HLTermField.text intValue] > MOP) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",MOP] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([tempHLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if (substringTempHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([tempHLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) into Temporary Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if ([tempHLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (Per 1k SA) cannot be greater than 10000" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
        
    }
    else if ([tempHLField.text intValue] > 0 && tempHLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLTermField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
        
    }
    else if ([tempHLTermField.text intValue] > 0 && tempHLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    else if ([tempHLTermField.text intValue] > MOP) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Temporary Health Loading (per 1k SA) Term cannot be greater than %d",MOP] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLTermField becomeFirstResponder];
        validatePasses = SIMENU_HEALTH_LOADING;
    }
    //--end HL
    
    else {
        
        float num = [yearlyIncomeField.text floatValue];
        int basicSumA = num;
        
        if ((MOP == 9 && basicSumA < 1000 && ageClient >= 66 && ageClient <= 70) ||
            (MOP == 9 && basicSumA >= 1000 && ageClient >= 68 &&    ageClient <= 70) ||
            (MOP == 12 && basicSumA < 1000 && ageClient >= 59 && ageClient <= 70) ||
            (MOP == 12 && basicSumA >= 1000 && ageClient >= 61 && ageClient <= 70)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please note that the Guaranteed Benefit payout for selected plan maybe lesser than total premium outlay.\nChoose OK to proceed.\nChoose CANCEL to select other plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
            [alert setTag:1002];
            [alert show];
            
        } else {
            validatePasses = 0;
        }
    }
    return validatePasses;
}

-(BOOL)isBasicPlanSelected
{
    if([btnPlan.titleLabel.text isEqualToString:@""] || btnPlan.titleLabel.text == nil)
    {
        return NO;
    }    
    return YES;
}

#pragma mark - STORE BASIC PLAN BEFORE SAVE INTO DATABASE
-(void)storeData
{	
    if (!basicPlanSIObj) {
        basicPlanSIObj = [[SIObj alloc]init];
    }
    basicPlanSIObj.policyTerm = [self getTerm];
    basicPlanSIObj.basicSA = yearlyIncomeField.text;
    basicPlanSIObj.prePayOption = [NSString stringWithFormat:@"%d",MOP];
    basicPlanSIObj.cashDivident = cashDividend;
    basicPlanSIObj.yearlyIncome = yearlyIncome;
    basicPlanSIObj.advanceYearlyIncome = [NSString stringWithFormat:@"%d",advanceYearlyIncome];
    basicPlanSIObj.hl1kSA = HLField.text;
    basicPlanSIObj.hl1kSATerm = HLTermField.text;
    basicPlanSIObj.tempHL1kSA = tempHLField.text;
    basicPlanSIObj.temHL1KSAterm = tempHLTermField.text;
    basicPlanSIObj.updatedAt = @"datetime(\"now\", \"+8 hour\")";
    basicPlanSIObj.partialAcc = parAccField.text;
    basicPlanSIObj.partialPayout = parPayoutField.text;
    basicPlanSIObj.siNO = SINo;
    
}
#pragma mark - delegate

-(void)PlanPembelianKe:(PembeliaKe *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
{
    
    if ([aaDesc intValue]>=2){
        discountPembelian=0.05;
    }
    else{
        discountPembelian=0;
    }
    
    [_KKLKPembelianKeBtn setTitle:aaDesc forState:UIControlStateNormal];
    [self.planPopover dismissPopoverAnimated:YES];
    // getPlanCode = aaCode;

    
    [self PremiDasarActKeluargaku:FRekeunsiPembayaranMode];
    [self PremiDasarActkklk];
    PaymentDescMDKK = FRekeunsiPembayaranMode;

    PembelianKEString = aaDesc;
    [self calculateRiderPremi];

}

-(void)Planlisting:(MasaPembayaran *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
  
    [_masaPembayaranButton setTitle:aaDesc forState:UIControlStateNormal];
    [self.planPopover dismissPopoverAnimated:YES];
    // getPlanCode = aaCode;
    
    [_frekuensiPembayaranButton setTitle:@"--Please Select--" forState:UIControlStateNormal];
    
    FrekuensiPembayaranChecking = aaDesc;
    
    [_basicPremiField setText:[NSString stringWithFormat:@"%@",@"0"]];
    
    //[self PremiDasarAct];
    
}

-(void)PlanFrekuensi:(MasaPembayaran *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
{
    [_frekuensiPembayaranButton setTitle:aaDesc forState:UIControlStateNormal];
    [self.planPopover dismissPopoverAnimated:YES];
    // getPlanCode = aaCode;
    
    FRekeunsiPembayaranMode = aaDesc;
    
    if([PlanType isEqualToString:@"BCA Life Keluargaku"])
    {
        PaymentDescMDKK = aaDesc;
        [self PremiDasarActKeluargaku:aaDesc];
        //[self PremiDasarActkklk];
        [self calculateRiderPremi];
    }
    else
    {
        [self PremiDasarAct];
        [self PremiDasarActB];
        [self ExtraNumbPremi];
        [self loadHeritageCalculation];
    }
    
}

-(void)setDefaultSA
{
    yearlyIncomeField.text = [NSString stringWithFormat:@"%d",minSA];
}

-(void)loadBasic
{
    [self getExistingBasic:false];
    [self toggleExistingField];
}
#pragma mark - Heritage Calculation
-(void)loadHeritageCalculation{
    NSMutableDictionary* dictionaryBasicPlan = [[NSMutableDictionary alloc]initWithDictionary:[self setDataBasicPlan]];
    [dictionaryBasicPlan addEntriesFromDictionary:_dictionaryPOForInsert];
    
    NSNumber *myNumber = [classFormatter convertAnyNonDecimalNumberToString:[dictionaryBasicPlan valueForKey:@"Sum_Assured"]];
    if(myNumber != nil){
        [dictionaryBasicPlan setObject:myNumber forKey:@"Number_Sum_Assured"];
    }
    
    [heritageCalculation setPremiumDictionary:dictionaryBasicPlan];
    
    //premi Dasar
    NSString* premiDasar;
    NSString* extraBasicPremi;
    NSString* totalPremi;
    NSString* diskon;
    NSString* totalPremiAfterDiscount;
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if ([FRekeunsiPembayaranMode isEqualToString:@"Pembayaran Sekaligus"])
    {
        premiDasar = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarSekaligus]]];
        extraBasicPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation extraPremiSekaligus]]];
        //totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiSekaligus]]];
        
        if (IsInternalStaff==1){
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonSekaligus]]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonSekaligus] BasicPremi:[heritageCalculation getPremiDasarSekaligus]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonSekaligus] BasicPremi:[heritageCalculation getPremiDasarSekaligus]] ExtraPremi:[heritageCalculation extraPremiSekaligus]]]];
        }
        else{
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarSekaligus]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarSekaligus]] ExtraPremi:[heritageCalculation extraPremiSekaligus]]]];
        }
        
        
    }
    else if ([FRekeunsiPembayaranMode isEqualToString:@"Bulanan"])
    {
        premiDasar = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarBulanan]]];
        extraBasicPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation extraPremiBulanan]]];
        totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiBulanan]]];
        if (IsInternalStaff==1){
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonBulanan]]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonBulanan] BasicPremi:[heritageCalculation getPremiDasarBulanan]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonBulanan] BasicPremi:[heritageCalculation getPremiDasarBulanan]] ExtraPremi:[heritageCalculation extraPremiBulanan]]]];
        }
        else{
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarBulanan]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarBulanan]] ExtraPremi:[heritageCalculation extraPremiBulanan]]]];
        }
        

    }
    else if ([FRekeunsiPembayaranMode isEqualToString:@"Tahunan"])
    {
        premiDasar = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarTahunan]]];
        extraBasicPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation extraPremiTahunan]]];
        totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiTahunan]]];
        if (IsInternalStaff==1){
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonTahunan]]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonTahunan] BasicPremi:[heritageCalculation getPremiDasarTahunan]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonTahunan] BasicPremi:[heritageCalculation getPremiDasarTahunan]] ExtraPremi:[heritageCalculation extraPremiTahunan]]]];
        }
        else{
            diskon = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]];
            totalPremiAfterDiscount = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarTahunan]]]];
            totalPremi = [classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarTahunan]] ExtraPremi:[heritageCalculation extraPremiTahunan]]]];
        }
        

    }
    else{
        
    }
    [_basicPremiField setText:premiDasar];
    [_extraBasicPremiField setText:extraBasicPremi];
    [_KKLKDiskaunBtn setText:diskon];
    [_basicPremiFieldAfterDiscount setText:totalPremiAfterDiscount];
    [_totalPremiWithLoadingField setText:totalPremi];
    NSLog(@"premi dasar %@",premiDasar);
    NSLog(@"extra premi %@",extraBasicPremi);
    NSLog(@"total premi %@",totalPremi);
}

#pragma mark - Memory Management
- (void)viewDidUnload
{
    basicPlanSIObj = nil;
    
//    [self resignFirstResponder];
//    [self setPlanPopover:nil];
//    [self setPlanList:nil];
//    [self setDelegate:nil];
//    [self setRequestOccpCode:nil];
//    [self setRequestSINo:nil];
//    [self setRequestSmokerPay:nil];
//    [self setRequestSexPay:nil];
//    [self setRequestDOBPay:nil];
//    [self setRequestOccpPay:nil];
//    [self setRequestSmoker2ndLA:nil];
//    [self setRequestSex2ndLA:nil];
//    [self setRequestDOB2ndLA:nil];
//    [self setRequestOccp2ndLA:nil];
//    [self setOccpCode:nil];
//    [self setSINo:nil];
//    [self setPayorSmoker:nil];
//    [self setPayorSex:nil];
//    [self setPayorDOB:nil];
//    [self setPayorOccpCode:nil];
//    [self setSecondLASmoker:nil];
//    [self setSecondLASex:nil];
//    [self setSecondLADOB:nil];
//    [self setSecondLAOccpCode:nil];
//    [self setBtnPlan:nil];
//    [self setTermField:nil];
//    [self setYearlyIncomeField:nil];
//    [self setMinSALabel:nil];
//    [self setMaxSALabel:nil];
//    [self setHealthLoadingView:nil];
//    [self setMOPSegment:nil];
//    [self setIncomeSegment:nil];
//    [self setAdvanceIncomeSegment:nil];
//    [self setCashDividendSegment:nil];
//    [self setHLField:nil];
//    [self setHLTermField:nil];
//    [self setTempHLField:nil];
//    [self setTempHLTermField:nil];
//    [self setMyScrollView:nil];
//    [self setMyToolBar:nil];
//    [self setSIDate:nil];
//    [self setCustDate:nil];
//    [self setLACustCode:nil];
//    [self setPYCustCode:nil];
//    [self setSecondLACustCode:nil];
//    [self setNamePP:nil];
//    [self setDOBPP:nil];
//    [self setGenderPP:nil];
//    [self setOccpCodePP:nil];
//    [self setYearlyIncome:nil];
//    [self setCashDividend:nil];
//    [self setPlanCode:nil];
//    [self setGetSINo:nil];
//    [self setGetHL:nil];
//    [self setGetTempHL:nil];
//    [self setLRiderCode:nil];
//    [self setLSumAssured:nil];
//    [self setRiderCode:nil];
//    [self setLabelFive:nil];
//    [self setCashDivSgmntCP:nil];
//    [self setLabelFour:nil];
//    [self setLabelSix:nil];
//    [self setLabelSeven:nil];
//    [self setLabelFive:nil];
//    [self setLabelSix:nil];
//    [self setLabelSeven:nil];
//    [self setLabelParAcc:nil];
//    [self setLabelParPayout:nil];
//    [self setLabelPercent1:nil];
//    [self setLabelPercent2:nil];
//    [self setParAccField:nil];
//    [self setParPayoutField:nil];
//	[self setQuotationLangSegment:nil];
//	[self setOutletDone:nil];
//	[self setOutletEAPP:nil];
//    [self setLabelThree:nil];
//    [self setLabelPremiumPay:nil];
//    [self setPolicyTermSeg:nil];
    [super viewDidUnload];
}

- (IBAction)KKLKDiskon:(id)sender {
}
@end
