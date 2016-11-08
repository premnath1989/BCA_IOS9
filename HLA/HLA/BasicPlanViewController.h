//
//  BasicPlanViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PlanList.h"
#import "MasaPembayaran.h"
#import "Frekeunsi.h"
#import "Pembelianke.h"
#import "BasicPlanHandler.h"
#import "PayorHandler.h"
#import "SecondLAHandler.h"
#import "AppDelegate.h"
#import "SIObj.h"
#import "Model_SI_Premium.h"
#import "ModelSIPOData.h"
#import "ColorHexCode.h"
#import "Formatter.h"
#import "RiderCalculation.h"
#import "HeritageCalculation.h"

@class BasicPlanViewController;
@protocol BasicPlanViewControllerDelegate
-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan planName:(NSString *)planName;
-(void)dismissEApp;
-(void)RiderAdded;
-(void)BasicSARevised:(NSString *)aabasicSA;
-(void)saveAll;
-(void)isSaveBasicPlan:(BOOL)temp;
-(void)clearSecondLA;
-(void)clearPayor;
-(void)setNewPlan:(NSString*)planChoose;
-(void)SwitchToRiderTab;
-(void)brngSubview:(NSString *)view;
-(void)saveBasicPlan:(NSDictionary *)basicPlan;
-(void)setBasicPlanDictionaryWhenLoadFromList:(NSDictionary *)basicPlan;
@end

@interface BasicPlanViewController : UIViewController <UITextFieldDelegate,PlanListDelegate,MasaPembayaranDelegate,FrekeunsiDelegate,PembeliaKeDelegate>{
    Formatter* classFormatter;
    HeritageCalculation* heritageCalculation;
    
    NSString *databasePath;
    NSString *RatesDatabasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *_planPopover;
    NSString *PaymentDescMDKK;
    ModelSIPOData *_modelSIPOData;
    Model_SI_Premium *_modelSIPremium;
    RiderCalculation *riderCalculation;
    PlanList *_planList;
    MasaPembayaran*_masaPembayaran;
    Frekeunsi*_frekuensi;
    PembeliaKe*_Pembelianke;
    NSString *MBKKPremium;
    BOOL showHL;
    BOOL useExist;
    BOOL newSegment;
    id <BasicPlanViewControllerDelegate> _delegate;
	SIObj* basicPlanSIObj;
	AppDelegate* appDelegate;
	BOOL Editable;
    double maxSAFactor;
    double AnuityRt;
    //long long ExtraPremiTotal;
    double ExtraPremiTotal;
    //long long ExtraPrecenttotal;
    double ExtraPrecenttotal;
    long long totalDivide;
    double DiskounPremi;
    double DiscountCalculation;
    double MDBKK;
    NSMutableArray *arrExistRiderCode;
    NSMutableArray *arrExistPlanChoice;
    
    BOOL planChanged;
    
    NSString *prevPlanChoose;
    NSString *planHSPII;
    NSString *OccpCat,*FrekuensiPembayaranChecking,*FRekeunsiPembayaranMode,*PembeliaKeBayaranChecking;
    NSString *YearlyIncm;
    
    int policyTermSegInt;
    int maxGycc;
    int PAymentModeForInt;
    
    NSMutableArray *LRidHL1KTerm;
    NSMutableArray *LRidHL100Term;
    NSMutableArray *LRidHLPTerm;
    NSMutableArray *LTempRidHL1KTerm;
    double dblGrossPrem;
    
    UIColor *themeColour;
    NSString *premiType;
    NSString *PlanType;
    NSString *PembelianKEString;
    
    IBOutlet UILabel* labelDiscount;
    IBOutlet UILabel* labelbasicPremi;
    IBOutlet UILabel* labelTotalPremiAfterDiscount;
    IBOutlet UILabel* labelExtraPremi;
    IBOutlet UILabel* labelTotalPremi;
}

@property (nonatomic, retain) UIPopoverController *planPopover;
@property (nonatomic, retain) PlanList *planList;
@property (nonatomic, retain) MasaPembayaran *_masaPembayaran;
@property (nonatomic, retain) Frekeunsi*_frekuensi;
@property (nonatomic, retain) PembeliaKe*Pembelianke;
@property (nonatomic,strong) id <BasicPlanViewControllerDelegate> delegate;
@property (nonatomic,strong) BasicPlanHandler *basicBH;
@property (nonatomic,strong) PayorHandler *basicPH;
@property (nonatomic,strong) SecondLAHandler *basicLa2ndH;
@property (strong, nonatomic) NSMutableArray *dataInsert;
@property (nonatomic,strong) id EAPPorSI;

//--request from previous
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestOccpCode;
@property (nonatomic, assign,readwrite) int requestOccpClass;
@property (nonatomic, assign,readwrite) int PAymentModeForInt;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestIDProf;
@property (nonatomic, assign,readwrite) int requestIDPay;
@property (nonatomic, assign,readwrite) int requestIndexPay;
@property (nonatomic,strong) id requestSmokerPay;
@property (nonatomic,strong) id requestSexPay;
@property (nonatomic,strong) id requestDOBPay;
@property (nonatomic, assign,readwrite) int requestAgePay;
@property (nonatomic,strong) id requestOccpPay;
@property (nonatomic, assign,readwrite) int requestIndex2ndLA;
@property (nonatomic,strong) id requestSmoker2ndLA;
@property (nonatomic,strong) id requestSex2ndLA;
@property (nonatomic,strong) id requestDOB2ndLA;
@property (nonatomic, assign,readwrite) int requestAge2ndLA;
@property (nonatomic,strong) id requestOccp2ndLA;
@property (nonatomic,strong) id requesteProposalStatus;
@property (nonatomic, assign) BOOL requestEDD;
@property (nonatomic, assign,readwrite)float percentPaymentMode;

@property (nonatomic, assign,readwrite) int ageClient;
@property (nonatomic, assign,readwrite) long long BasisSumAssured;
@property (nonatomic, assign,readwrite) long long totalDivide;
//@property (nonatomic, assign,readwrite) long long ExtraPremiTotal;
@property (nonatomic, assign,readwrite) double ExtraPremiTotal;
//@property (nonatomic, assign,readwrite) long long ExtraPrecenttotal;
@property (nonatomic, assign,readwrite) double ExtraPrecenttotal;
@property(nonatomic , retain) NSString *OccpCode;
@property (nonatomic, assign,readwrite) int OccpClass;
@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, assign,readwrite) int idPay;
@property (nonatomic, assign,readwrite) int idProf;
@property (nonatomic, assign,readwrite) int PayorIndexNo;
@property (nonatomic, copy) NSString *PayorSmoker,*FrekuensiPembayaranChecking,*FRekeunsiPembayaranMode,*YearlyIncm;
@property (nonatomic, copy) NSString *PayorSex;
@property (nonatomic, copy) NSString *LASex;
@property (nonatomic, copy) NSString *PremiType;
@property (nonatomic, copy) NSString *PayorDOB;
@property (nonatomic, copy) NSString *RelWithLA,*PaymentDescMDKK;
@property (nonatomic, assign,readwrite) int PayorAge;
@property (nonatomic, assign,readwrite) int LAAge;
@property (nonatomic, copy) NSString *PayorOccpCode;
@property (nonatomic, assign,readwrite) int secondLAIndexNo;
@property (nonatomic, copy) NSString *secondLASmoker;
@property (nonatomic, copy) NSString *secondLASex, *MBKKPremium;
@property (nonatomic, copy) NSString *secondLADOB;
@property (nonatomic, assign,readwrite) int secondLAAge;
@property (nonatomic, copy) NSString *secondLAOccpCode;
@property (nonatomic, copy) NSString *PembelianKEString;
//--
@property (strong, nonatomic) IBOutlet UIButton *btnPlan;
@property (retain, nonatomic) IBOutlet UITextField *termField;
@property (strong, nonatomic) IBOutlet UITextField *yearlyIncomeField;
@property (retain, nonatomic) IBOutlet UILabel *minSALabel;
@property (retain, nonatomic) IBOutlet UILabel *maxSALabel;
@property (retain, nonatomic) IBOutlet UIView *healthLoadingView;
@property (retain, nonatomic) IBOutlet UITextField *HLField;
@property (retain, nonatomic) IBOutlet UITextField *HLTermField;
@property (retain, nonatomic) IBOutlet UITextField *tempHLField;
@property (retain, nonatomic) IBOutlet UITextField *tempHLTermField;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UILabel *labelPremiumPay;
@property (strong, nonatomic) IBOutlet UILabel *labelFour;
@property (strong, nonatomic) IBOutlet UILabel *labelFive;
@property (strong, nonatomic) IBOutlet UILabel *labelSix;
@property (strong, nonatomic) IBOutlet UILabel *labelSeven;
@property (strong, nonatomic) IBOutlet UILabel *labelParAcc;
@property (strong, nonatomic) IBOutlet UILabel *labelParPayout;
@property (strong, nonatomic) IBOutlet UILabel *labelPercent1;
@property (strong, nonatomic) IBOutlet UILabel *labelPercent2;
@property (strong, nonatomic) IBOutlet UITextField *parAccField;
@property (strong, nonatomic) IBOutlet UITextField *parPayoutField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *MOPSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *S100MOPSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *incomeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *cashDividendSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *advanceIncomeSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *cashDivSgmntCP;
@property (weak, nonatomic) IBOutlet UISegmentedControl *quotationLangSegment;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletDone;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *ExtraPremiDasarLBL;
@property (weak, nonatomic) IBOutlet UILabel *MasaExtraPremiLBL;
@property (weak, nonatomic) IBOutlet UILabel *ExtraPremiDasarNumberLBL;
@property (weak, nonatomic) IBOutlet UILabel *KKLKExtraPremiDasarLBL;
@property (weak, nonatomic) IBOutlet UIButton *KKLKPembelianKeBtn;
@property (weak, nonatomic) IBOutlet UILabel *KKLKPembelianKeLbl;

@property (weak, nonatomic) IBOutlet UITextField *KKLKDiskaunBtn;
@property (weak, nonatomic) IBOutlet UITextField *KKLKMasaPembayaran;


@property (weak, nonatomic) IBOutlet UILabel *KKLKDiskaunLbl;

//Added by faiz
@property (retain, nonatomic) NSMutableDictionary* dictionaryPOForInsert;
@property (strong, nonatomic) IBOutlet UITextField *basicPremiField;
@property (strong, nonatomic) IBOutlet UITextField *basicPremiFieldAfterDiscount;
@property (strong, nonatomic) IBOutlet UITextField *extraPremiPercentField;
@property (strong, nonatomic) IBOutlet UITextField *extraPremiNumberField;
@property (strong, nonatomic) IBOutlet UITextField *masaExtraPremiField;
@property (strong, nonatomic) IBOutlet UITextField *extraBasicPremiField;
@property (strong, nonatomic) IBOutlet UITextField *totalPremiWithLoadingField;
@property (strong, nonatomic) IBOutlet UIButton *masaPembayaranButton;
@property (strong, nonatomic) IBOutlet UIButton *frekuensiPembayaranButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

-(NSMutableDictionary *)setDataBasicPlan;
- (IBAction)tempNext:(id)sender;
- (IBAction)tempNext1:(id)sender;
-(IBAction)actionMasaPembayaran:(id)sender;
-(IBAction)actionFrekuensiPembayaran:(id)sender;
-(IBAction)ExtraPremiDasarLBLFunc:(id)sender;
-(IBAction)ExtraPremiDasarNumberLBLFunc:(id)sender;
-(IBAction)MasaExtraPremiTextFieldDidBegin:(UITextField *)sender;
-(IBAction)MasaExtraPremiTextFieldDidEnd:(UITextField *)sender;
-(IBAction)validationExtraPremiField:(UITextField *)sender;
- (bool)validationDataBasicPlan;
-(void)setPODictionaryFromRoot:(NSMutableDictionary *)dictionaryRootPO;
-(void)calculateValue;
//end of added by faiz

//for SINo
@property (nonatomic, assign,readwrite) int SILastNo;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property (nonatomic, copy) NSString *SalesIlustrationDate;
@property (nonatomic, copy) NSString *CustDate;

@property (nonatomic, copy) NSString *LACustCode;
@property (nonatomic, copy) NSString *PYCustCode;
@property (nonatomic, copy) NSString *secondLACustCode;
@property (nonatomic, assign,readwrite) int IndexNo;

@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic, assign,readwrite) int maxAge;
@property (nonatomic, assign,readwrite) int minSA;
@property (nonatomic, assign,readwrite) int maxSA;
@property (nonatomic,strong) NSString *planChoose;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

//use to calculate
@property (nonatomic, assign,readwrite) int MOP;
@property (nonatomic, assign,readwrite) int SavedMOP;
@property (nonatomic, copy) NSString *yearlyIncome;
@property (nonatomic, copy) NSString *yearlyIncomeHLAIB;
@property (nonatomic, copy) NSString *cashDividend;
@property (nonatomic, copy) NSString *cashDividendHLAIB;
@property (nonatomic, copy) NSString *cashDividendHLACP;
@property (nonatomic, assign,readwrite) int advanceYearlyIncome;
@property (nonatomic, assign,readwrite) int advanceYearlyIncomeHLAIB;
@property (nonatomic, assign,readwrite) int advanceYearlyIncomeHLACP;
@property (nonatomic, assign,readwrite) double basicRate;
@property (nonatomic, assign,readwrite) double MDBKK;
@property (nonatomic, assign,readwrite) double MDBKK_Mil;
@property (nonatomic, assign,readwrite) double DiskounPremi;
@property (nonatomic, assign,readwrite) double DiscountCalculation;
@property (nonatomic, assign,readwrite) double TotalA;
@property (nonatomic,strong) NSString *planCode;
@property (nonatomic, copy) NSString *quotationLang;


//to display
@property (nonatomic,strong) NSString *getSINo;
@property (nonatomic,assign,readwrite) int getPolicyTerm;
@property (nonatomic,assign,readwrite) double getSumAssured;
@property (nonatomic,copy) NSString *getHL;
@property (nonatomic,copy) NSString *getTempHL;
@property (nonatomic,copy) NSString *PlanType;
@property (nonatomic,assign,readwrite) int getTempHLTerm;
@property (nonatomic,assign,readwrite) int getHLTerm;
@property (nonatomic,assign,readwrite) int getParAcc;
@property (nonatomic,assign,readwrite) int getParPayout;

@property (retain, nonatomic) NSMutableArray *LRiderCode;
@property (retain, nonatomic) NSMutableArray *LSumAssured;
@property (retain, nonatomic) NSMutableArray *LTerm;
@property (retain, nonatomic) NSMutableArray *LPlanOpt;
@property (retain, nonatomic) NSMutableArray *LUnits;
@property(nonatomic , retain) NSMutableArray *LDeduct;
@property(nonatomic , retain) NSMutableArray *LOccpCode;
@property(nonatomic , retain) NSMutableArray *LRidHL1K;
@property(nonatomic , retain) NSMutableArray *LRidHL100;
@property(nonatomic , retain) NSMutableArray *LRidHLP;
@property(nonatomic , retain) NSMutableArray *LSmoker;
@property(nonatomic , retain) NSMutableArray *LSex;
@property(nonatomic , retain) NSMutableArray *LAge;
@property(nonatomic , retain) NSMutableArray *LTempRidHL1K;

@property (nonatomic, assign,readwrite) int age;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic, assign,readwrite) double riderRate;
@property (nonatomic, assign,readwrite) double AnuityRt;
@property (nonatomic,copy) NSString *pTypeOccp;
@property (nonatomic, assign,readwrite) int occLoadRider;
@property (nonatomic, assign,readwrite) double riderPrem;
@property (nonatomic, assign,readwrite) double medRiderPrem;
@property (nonatomic,strong) NSMutableArray *waiverRiderAnn;
@property (nonatomic,strong) NSMutableArray *waiverRiderQuar;
@property (nonatomic,strong) NSMutableArray *waiverRiderHalf;
@property (nonatomic,strong) NSMutableArray *waiverRiderMonth;
@property (nonatomic,strong) NSMutableArray *waiverRiderAnn2;
@property (nonatomic,strong) NSMutableArray *waiverRiderQuar2;
@property (nonatomic,strong) NSMutableArray *waiverRiderHalf2;
@property (nonatomic,strong) NSMutableArray *waiverRiderMonth2;
@property (nonatomic,strong) NSMutableArray *annualMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *quarterMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *halfMedRiderPrem;
@property (nonatomic,strong) NSMutableArray *monthMedRiderPrem;
@property (nonatomic, assign,readwrite) double annualRiderSum;
@property (nonatomic, assign,readwrite) double halfRiderSum;
@property (nonatomic, assign,readwrite) double quarterRiderSum;
@property (nonatomic, assign,readwrite) double monthRiderSum;
@property (nonatomic, assign,readwrite) double annualMedRiderSum;
@property (nonatomic, assign,readwrite) double halfMedRiderSum;
@property (nonatomic, assign,readwrite) double quarterMedRiderSum;
@property (nonatomic, assign,readwrite) double monthMedRiderSum;

@property (nonatomic,copy) NSString *riderCode;
@property (nonatomic, assign,readwrite) int expAge;
@property (nonatomic, assign,readwrite) int minSATerm;
@property (nonatomic, assign,readwrite) int maxSATerm;
@property (nonatomic, assign,readwrite) int minTerm;
@property (nonatomic, assign,readwrite) int maxTerm;
@property (nonatomic, assign,readwrite) double _maxRiderSA;
@property (nonatomic, assign,readwrite) double maxRiderSA;
@property (nonatomic, assign,readwrite) int GYI;
@property (nonatomic, assign,readwrite) int occLoad;
@property(nonatomic , assign,readwrite) int occCPA_PA;
@property (nonatomic, assign,readwrite) double LSDRate;
@property (nonatomic, assign,readwrite) double basicPremAnn;
@property (nonatomic, assign,readwrite) double basicPremHalf;
@property (nonatomic, assign,readwrite) double basicPremQuar;
@property (nonatomic, assign,readwrite) double basicPremMonth;

@property (nonatomic, assign) BOOL isFirstSaved;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletEAPP;

- (IBAction)ActionEAPP:(id)sender;
- (void)KeluargakuEnable;
- (IBAction)btnPlanPressed:(id)sender;
- (IBAction)doSavePlan:(id)sender;
- (IBAction)S100MOPSegmentPressed:(id)sender;
- (IBAction)MOPSegmentPressed:(id)sender;
- (IBAction)incomeSegmentPressed:(id)sender;
- (IBAction)advanceIncomeSegmentPressed:(id)sender;
- (IBAction)cashDividendSegmentPressed:(id)sender;
- (IBAction)cashDivSgmntCPPressed:(id)sender;
- (IBAction)quotationLangSegmentPressed:(id)sender;
- (IBAction)KKLKPembelianKe:(id)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *policyTermSeg;

- (int)validateSave;
-(BOOL)checkingSave:(NSString *) getSex;
-(void)checkingExisting;//added by Edwin
-(void)loadData;
-(BOOL)isBasicPlanSelected;
-(void)reloadPaymentOption;
-(void)KeluargakuDisable;

@end
