//
//  SecondLAViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/31/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ListingTbViewController.h"
#import "BasicPlanHandler.h"
#import "SecondLAHandler.h"
#import "DateViewController.h"
#import "OccupationList.h"
#import "SIObj.h"
#import "AppDelegate.h"
#import "ModelSIPOData.h"

@class SecondLAViewController;
@protocol SecondLAViewControllerDelegate
-(void) LA2ndIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode;
-(void)dismissEApp;
-(void)secondLADelete;
-(void)saved:(BOOL)aaTrue;
-(void) RiderAdded;
-(void)saveAll;
-(void)setIsSecondLaNeeded:(BOOL)temp;
-(NSDictionary *)getDataPO;
-(void)saveSecondLA:(NSDictionary *)dataLA;
@end

@interface SecondLAViewController : UIViewController <ListingTbViewControllerDelegate,UIPopoverControllerDelegate, DateViewControllerDelegate, OccupationListDelegate, UITextFieldDelegate> {
    NSString *databasePath,*msgAge;
    sqlite3 *contactDB;
    UIPopoverController *popOverController;
    UIPopoverController *_dobPopover;
    UIPopoverController *_OccupationListPopover;
    UIPopoverController *_prospectPopover;
    
    ModelSIPOData *_modelSIPOData;
    ListingTbViewController *_ProspectList;
    OccupationList *_OccupationList;
    
    DateViewController *_LADate;
    BOOL inserted;
    BOOL saved;
    BOOL date1;
    //BOOL isNewClient;
	BOOL QQProspect;
    id <SecondLAViewControllerDelegate> _delegate;
	SIObj* siObj;
    AppDelegate* appDelegate;
	BOOL Editable;
	
    int prevIndexNo;
    NSDictionary* dictionaryPO;
}

@property (strong, nonatomic)NSDictionary *poDictionaryPO;

@property (nonatomic,strong) BasicPlanHandler *basicHand;
@property (nonatomic,strong) SecondLAHandler *la2ndHand;
@property (strong, nonatomic) NSMutableArray *dataInsert;

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) UIPopoverController *dobPopover;
@property (nonatomic, retain) UIPopoverController *OccupationListPopover;
@property (nonatomic, retain) OccupationList *OccupationList;
@property (nonatomic, retain) ListingTbViewController *ProspectList;
@property (nonatomic, retain) DateViewController *LADate;
@property (nonatomic,strong) id <SecondLAViewControllerDelegate> delegate;

@property (nonatomic,strong) id EAPPorSI;

//--request
@property (nonatomic, assign,readwrite) int requestLAIndexNo;
@property (nonatomic, assign,readwrite) int diffDaysValiation;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) id requestCommDate;
@property (nonatomic, assign,readwrite) int getLAIndexNo;
@property (nonatomic, assign,readwrite) BOOL saved2ndLA;
@property(nonatomic , retain) NSString *getSINo;
@property (nonatomic, copy) NSString *getCommDate,*msgAge;
@property (nonatomic,strong) id requesteProposalStatus;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
//--

@property (strong, nonatomic) IBOutlet UIButton *BtnTanggalLahir;
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *ageField;
@property (retain, nonatomic) IBOutlet UITextField *OccpLoadField;
@property (retain, nonatomic) IBOutlet UITextField *CPAField;
@property (retain, nonatomic) IBOutlet UITextField *PAField;
@property (strong, nonatomic) IBOutlet UITextField *DOBField;
@property (strong, nonatomic) IBOutlet UITextField *OccpField;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnDOB;
@property (strong, nonatomic) IBOutlet UIButton *btnOccp;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletDone;
@property (weak, nonatomic) IBOutlet UIButton *outletProspect;
@property (weak, nonatomic) IBOutlet UIButton *outletQQ;
@property (nonatomic, retain) UIPopoverController *prospectPopover;

@property (nonatomic, assign,readwrite) int IndexNo;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property (nonatomic, copy) NSString *occuCode;
@property (nonatomic, copy) NSString *occuDesc;
@property(nonatomic , retain) NSString *OccpCode;
@property(nonatomic , retain) NSString *occLoading;
@property(nonatomic , assign,readwrite) int occCPA_PA;
@property(nonatomic , assign,readwrite) int occPA;
@property (nonatomic, assign,readwrite) int occuClass;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property(nonatomic , retain) NSString *SINo;
@property (nonatomic, copy) NSString *CustDate;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, assign,readwrite) int clientID;
@property (nonatomic, copy) NSString *OccpDesc;
@property (nonatomic, copy) NSString *CheckRiderCode;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletEAPP;

- (IBAction)ActionEAPP:(id)sender;

- (IBAction)doSelectProspect:(id)sender;
- (IBAction)sexSegmentChange:(id)sender;
- (IBAction)smokerSegmentChange:(id)sender;
- (IBAction)doSave:(id)sender;
- (IBAction)doDelete:(id)sender;
- (IBAction)btnDOBPressed:(UIButton *)sender;
- (IBAction)btnOccpPressed:(id)sender;
- (IBAction)enableFields:(id)sender;
-(BOOL)validateSave;
-(BOOL)performUpdateData;
-(void)deleteSecondLA;
-(void)deleteLA;
-(void)resetField;
//-(void)testing :(NSString *)testing;
-(void)setElementActive :(BOOL)active;

@property(nonatomic , retain) NSString *Change;
@property(nonatomic , retain) NSString *LAView;

//added by faiz
@property (nonatomic, assign,readwrite) BOOL quickQuoteEnabled;
- (bool)validationDataLifeAssured;
-(void)initialPOData;
-(void)setPODictionaryFromRoot:(NSMutableDictionary *)dictionaryRootPO originalRelation:(NSString *)OriginalRelation;
-(void)setPODictionaryRegular:(NSMutableDictionary *)dictionaryRootPO;
-(NSMutableDictionary *)setDictionarySecondLA;
//end of added by faiz
@end
