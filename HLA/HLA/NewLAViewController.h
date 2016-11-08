//
//  NewLAViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ListingTbViewController.h"
#import "DateViewController.h"
#import "PlanList.h"
#import "BasicPlanHandler.h"
#import "OccupationList.h"
#import "SIObj.h"
#import "AppDelegate.h"
#import "RelationshipPopoverViewController.h"
#import "SecondLAViewController.h"
#import "ModelSIPOData.h"

@class NewLAViewController;
@protocol NewLAViewControllerDelegate
-(void) LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker DiffClient:(BOOL)DiffClient bEDDCase:(BOOL)aaEDDCase;

-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan  planName:(NSString *)planName;
-(void)dismissEApp;
-(void) RiderAdded;
-(void)secondLADelete;
-(void)PayorDeleted;
-(void)saveAll;
-(void)deleteSecondLAFromDB;
-(void)setQuickQuoteValue:(BOOL)value;
-(void)saveNewLA:(NSDictionary *)dataPO;
-(void)setPODictionaryWhenLoadFromList:(NSDictionary *)dataPO;
@end

@interface NewLAViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate,ListingTbViewControllerDelegate,DateViewControllerDelegate,OccupationListDelegate,PlanListDelegate,RelationshipPopoverViewControllerDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *_planPopover;
    UIPopoverController *popOverController;
    UIPopoverController *_prospectPopover;
    UIPopoverController *_datePopover;
    UIPopoverController *_dobPopover;
    UIPopoverController *_OccupationListPopover;
    NSDictionary* dictPOData;
    
    ModelSIPOData *_modelSIPOData;
    
    SecondLAViewController *_SecondLAController;
    PlanList *_planList;
    ListingTbViewController *_ProspectList;
    DateViewController *_LADate;
    OccupationList *_OccupationList;
    id <NewLAViewControllerDelegate> _delegate;
    BOOL Saved;
    BOOL Inserted;
    BOOL useExist;
    BOOL AgeLess;
    BOOL AgeExceed189Days;
    BOOL EDDCase;
    BOOL DiffClient;
    BOOL AgeChanged;
    BOOL JobChanged;
    BOOL date1;
    BOOL date2;
    BOOL DAteTanggal;
    NSString *SINOBCA;
    //BOOL isNewClient;
	BOOL QQProspect;
	SIObj* siObj;
	
    NSString *tempSmoker;
    NSString *tempSex;
    NSString *tempDOB;
    int tempAge;
    NSString* tempOccCode;
    int tempIndexNo;
    NSString *tempCommDate;
    int tempIdProfile;
    NSMutableDictionary * tempSIDict;
    AppDelegate* appDelegate;
	BOOL Editable;
    int prevIndexNo;
    int savedIndexNo;
    NSString *OccuCatCode;
    BOOL QuickQuoteBool;
    
    UIColor *themeColour;
    IBOutlet UIScrollView* scrollLA;
    NSString *Relationship;
}

@property (nonatomic, strong) RelationshipPopoverViewController *RshipTypePicker;
@property (nonatomic, strong) UIPopoverController *RshipTypePickerPopover;
@property (nonatomic, retain) SIObj* siObj;
@property (nonatomic, retain) PlanList *planList;
@property (strong, nonatomic) NSMutableArray *dataInsert;
@property (strong, nonatomic) NSMutableArray *dataInsert2;
@property (nonatomic,strong) BasicPlanHandler *laBH;
@property (nonatomic,strong) id <NewLAViewControllerDelegate> delegate;
@property (nonatomic, retain) SecondLAViewController *SecondLAController;

//--request
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestIndexNo;
@property (nonatomic, assign,readwrite) int requestLastIDPay;
@property (nonatomic, assign,readwrite) int requestLastIDProf;
@property (nonatomic,strong) id requestCommDate;
@property (nonatomic,strong) id requestSex;
@property (nonatomic,strong) id requestSmoker;
@property (nonatomic,strong) id EAPPorSI;
@property (nonatomic,strong) id requesteProposalStatus;

@property (nonatomic, copy) NSString *getSINo, *Relationship;
//--
@property (nonatomic, retain) OccupationList *OccupationList;
@property (nonatomic, retain) ListingTbViewController *ProspectList;
@property (nonatomic, retain) DateViewController *LADate;
@property (nonatomic, retain) UIPopoverController *planPopover;
@property (nonatomic, retain) UIPopoverController *prospectPopover;
@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) UIPopoverController *dobPopover;
@property (nonatomic, retain) UIPopoverController *OccupationListPopover;
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

//LA Field
@property (retain, nonatomic) IBOutlet UILabel *labelQuickQuote;
@property (retain, nonatomic) IBOutlet UITextField *LANameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *LAAgeField;
@property (retain, nonatomic) IBOutlet UITextField *LAOccLoadingField;
@property (retain, nonatomic) IBOutlet UITextField *LACPAField;
@property (retain, nonatomic) IBOutlet UITextField *LAPAField;
@property (retain, nonatomic) IBOutlet UITextField *LAHbgTertanggung;
@property (retain, nonatomic) IBOutlet UITextField *LAProductName;
@property (strong, nonatomic) IBOutlet UIButton *btnCommDate;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnDOB;
@property (strong, nonatomic) IBOutlet UIButton *btnOccp;
@property (strong, nonatomic) IBOutlet UIButton *btnProspect;
@property (strong, nonatomic) IBOutlet UIButton *btnEnabled;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnToEAPP;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletDone;
@property (strong, nonatomic) IBOutlet UIButton *NamaProduk;
@property (strong, nonatomic) IBOutlet UIButton *BtnHubungan;
@property (nonatomic, assign)BOOL QuickQuoteBool;

@property (nonatomic, copy) NSString *SINo, *SINOBCA;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic,strong) NSString *planChoose;

@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *occuCode;
@property (nonatomic, copy) NSString *occuDesc;
@property (nonatomic, copy) NSString *occLoading;
@property (nonatomic, copy) NSString *strPA_CPA;
@property (nonatomic, assign,readwrite) int occuClass;
@property(nonatomic , assign,readwrite) int occCPA_PA;
@property(nonatomic , assign,readwrite) int occPA;
@property (nonatomic, assign,readwrite) int IndexNo;
@property (nonatomic, assign,readwrite) int idPayor;
@property (nonatomic, assign,readwrite) int idProfile;
@property (nonatomic, assign,readwrite) int idProfile2;
@property (nonatomic, assign,readwrite) int lastIdPayor;
@property (nonatomic, assign,readwrite) int lastIdProfile;

@property (nonatomic,strong) NSString *basicSINo;
@property (nonatomic,assign,readwrite) int getPolicyTerm;
@property (nonatomic,assign,readwrite) double getSumAssured;
@property (nonatomic,copy) NSString *getHL;
@property (nonatomic,copy) NSString *getTempHL;
@property (nonatomic,assign,readwrite) int getTempHLTerm;
@property (nonatomic,assign,readwrite) int getHLTerm;
@property (nonatomic, assign,readwrite) int MOP;
@property (nonatomic, copy) NSString *yearlyIncome;
@property (nonatomic, copy) NSString *cashDividend;
@property (nonatomic, assign,readwrite) int advanceYearlyIncome;
@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic,strong) NSString *planCode;
@property (nonatomic,strong) NSString *planName;
@property (weak, nonatomic) IBOutlet UITextField *SINumberBCA;
@property (weak, nonatomic) IBOutlet UIButton *ProdukBtn;
@property (weak, nonatomic) IBOutlet UIButton *TanggalIllustrasi;
@property (weak, nonatomic) IBOutlet UIButton *NamaHubungan;

//declare for store in DB
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *Hubungan;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *commDate;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property (nonatomic, copy) NSString *CustCode2;
@property (nonatomic, copy) NSString *payorSINo;
@property (nonatomic, copy) NSString *payorCustCode;
@property (nonatomic, assign,readwrite) int payorAge;

//for occupation
@property(nonatomic , retain) NSMutableArray *occDesc;
@property(nonatomic , retain) NSMutableArray *occCode;


@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;
- (IBAction)QuickQuoteFunc:(id)sender;
- (IBAction)InternalStaffFunc:(id)sender;

@property (retain, nonatomic) NSMutableArray *arrExistRiderCode;
@property (retain, nonatomic) NSMutableArray *arrExistPlanChoice;
@property (nonatomic, retain) NSMutableArray *ridCode;
@property(nonatomic , retain) NSMutableArray *atcRidCode;
@property(nonatomic , retain) NSMutableArray *atcPlanChoice;
@property (strong, nonatomic) IBOutlet UISwitch *quickQuoteFlag;
@property (strong, nonatomic) IBOutlet UISwitch *switchInternalStaff;
//@property (nonatomic, retain) SIObj* siObj;

- (IBAction)sexSegmentPressed:(id)sender;
- (IBAction)NamaProdukDropDown:(id)sender;
- (IBAction)smokerSegmentPressed:(id)sender;
- (IBAction)doSave:(id)sender;
- (IBAction)selectProspect:(id)sender;
- (IBAction)btnCommDatePressed:(id)sender;
- (IBAction)enableFields:(id)sender;
- (IBAction)btnDOBPressed:(UIButton *)sender;
- (IBAction)btnTanggalIllustrasiPressed:(UIButton *)sender;
- (IBAction)btnOccpPressed:(id)sender;
- (IBAction)ActionEAPP:(id)sender;
- (IBAction)Hubungan:(id)sender;
- (BOOL)validateSave;
- (BOOL)updateData:(NSString *) SiNo;
- (BOOL)performSaveData;
- (void)updateSINO:(NSString *)newSINO;

-(void)processLifeAssured;
-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

-(BOOL)validateSave;
-(void)loadDataFromList;
-(void)loadDataAfterSaveAs:(NSString *)SINO;
-(NSDictionary *)setDictionaryLA;
@end


