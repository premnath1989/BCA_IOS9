//
//  SPAJThirdParty.m
//  BLESS
//
//  Created by Basvi on 9/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJThirdParty.h"
#import "Formatter.h"
#import "SPAJPDFWebViewController.h"
#import "ModelSPAJFormGeneration.h"
#import "User Interface.h"
#import "ModelSPAJSignature.h"
#import "ModelAgentProfile.h"
#import "ModelProspectProfile.h"
#import "ModelSIPOData.h"
#import "ModelSPAJAnswers.h"
#import "Model_SI_Master.h"
#import "ModelSPAJHtml.h"
#import "SPAJPDFAutopopulateData.h"
#import "ModelSPAJTransaction.h"
#import "AllAboutPDFGeneration.h"
#import "Alert.h"
#import "SIDate.h"

#define NUMBERS_ONLY @"0123456789"
#define NUMBERS_MONEY @"0123456789."
#define CHARACTER_LIMIT_PC_F 12
#define CHARACTER_LIMIT_FULLNAME 40
#define CHARACTER_LIMIT_OtherID 20
#define CHARACTER_LIMIT_Bussiness 60
#define CHARACTER_LIMIT_ExactDuties 40
#define CHARACTER_LIMIT_Address 30
#define CHARACTER_LIMIT_POSTCODE 6
#define CHARACTER_LIMIT_FOREIGN_POSTCODE 12
#define CHARACTER_LIMIT_ANNUALINCOME 15
#define CHARACTER_LIMIT_GSTREGNO 15
#define CHARACTER_LIMIT_30 30

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface SPAJThirdParty ()<SIDateDelegate,UITextFieldDelegate>{
    Formatter* formatter;
    SPAJPDFAutopopulateData* spajPDFData;
    SPAJPDFWebViewController* spajPDFWebView;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelProspectProfile* modelProspectProfile;
    ModelAgentProfile* modelAgentProfile;
    ModelSIPOData* modelSIPOData;
    ModelSPAJAnswers* modelSPAJAnswers;
    Model_SI_Master* modelSIMaster;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    ModelSPAJTransaction *modelSPAJTransaction;
    AllAboutPDFGeneration *allAboutPDFGeneration;
    Alert* alert;
    SIDate *siDate;
    
    ButtonSPAJ* tempDateButton;
    
    UIPopoverController *SIDatePopover;
    
    NSMutableArray *arrayCollectionInsurancePurchaseReasonC;
    NSMutableArray *arrayCollectionInsurancePurchaseReasonIDC;
    NSMutableArray *arrayCollectionSelectedInsurancePurchaseReasonC;
    
    NSMutableArray *arrayCollectionInsurancePurchaseReasonD;
    NSMutableArray *arrayCollectionInsurancePurchaseReasonIDD;
    NSMutableArray *arrayCollectionSelectedInsurancePurchaseReasonD;
    
    NSString *imageFileName;
    
    NSMutableArray *arrayCollectionInsurancePurchaseReason;
    NSMutableArray *arrayCollectionSelectedInsurancePurchaseReason;
    
    NSString* buttonInsurancePurpose;
    
    NSString* buttonInsurancePurposeC;
    NSString* buttonInsurancePurposeD;
    
    NSMutableDictionary* dictAgentProfile;
    NSDictionary *dictionaryPOData;
    NSDictionary *dictionarySIMaster;
    
    NSMutableArray * arrayDBAgentID;
    NSMutableArray * arrayHTMLAgentID;
    
    NSMutableArray * arrayDBReferral;
    NSMutableArray * arrayHTMLReferal;
    
    NSMutableArray * arrayDBPOData;
    NSMutableArray * arrayHTMLPOData;
    
    NSMutableArray * arrayDBSIData;
    NSMutableArray * arrayHTMLSIData;
    
    NSMutableArray * arrayDBSignature;
    NSMutableArray * arrayHTMLSignature;
    
    NSMutableArray* valueCheckBoxReasonArrayC;
    NSMutableArray* valueCheckBoxReasonArrayD;
}

@end

@implementation SPAJThirdParty
@synthesize dictTransaction;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 819, 724);
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidLayoutSubviews{
    [scrollViewForm setContentSize:CGSizeMake(stackViewForm.frame.size.width, stackViewForm.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated{

    [self voidCreateDotInLine:viewBorder];

    [self voidLoadAllThirdPartyData];
    
    [collectionReasonInsurancePurchaseC reloadData];
    [collectionReasonInsurancePurchaseD reloadData];
}

-(void)voidCreateDotInLine:(UIView *)sender {
    CGFloat lineWidth = sender.frame.size.width;
    CGFloat dotWidth = 5;
    int numberOfDot = (lineWidth/2);
    int xStart=0;
    for (int i=0;i<numberOfDot;i++){
        UIView* viewDot = [[UIView alloc]initWithFrame:CGRectMake(xStart, 0, dotWidth, 1)];
        [viewDot setBackgroundColor:[UIColor blackColor]];
        [sender addSubview:viewDot];
        xStart = dotWidth * i * 2;
    }
}

- (void)viewDidLoad {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 1035,728)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [collectionReasonInsurancePurchaseC registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [collectionReasonInsurancePurchaseD registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    for (int i=0; i<[[self.view subviews] count];i++){
        [self.view sendSubviewToBack:webview];
    }
    
    functionUserInterface = [[UserInterface alloc] init];
    
    allAboutPDFFunctions = [[AllAboutPDFFunctions alloc]init];
    [allAboutPDFFunctions createDictionaryForRadioButton];
    [allAboutPDFFunctions createDictionaryRevertForRadioButton];
    [allAboutPDFFunctions createArrayRevertForRadioButton];
    
    formatter = [[Formatter alloc]init];
    spajPDFData = [[SPAJPDFAutopopulateData alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
    modelAgentProfile = [[ModelAgentProfile alloc]init];
    modelProspectProfile = [[ModelProspectProfile alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSIMaster = [[Model_SI_Master alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
    allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
    alert = [[Alert alloc]init];
    
    [self arrayInitializeReferral];
    [self arrayInitializeAgentProfile];
    [self arrayInitializePOData];
    [self arrayInitializeSIMaster];
    [self arrayInitializeSignature];
    
    [self intializeArrayInsuranceReasonC];
    [self intializeArrayInsuranceReasonD];
    
    dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    
    [TextThirdPartySalary addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    [TextThirdPartyRevenue addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    [TextThirdPartyOtherIncome addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    
    //view B
    [RadioButtonThirdPartyAsking setSegmentName:@"RadioButtonThirdPartyAsking"];
    [RadioButtonThirdPartyAskingRelationship setSegmentName:@"RadioButtonThirdPartyAskingRelationship"];
    
    [RadioButtonThirdPartyPremiPayor setSegmentName:@"RadioButtonThirdPartyPremiPayor"];
    [RadioButtonThirdPartyPremiPayorRelationship setSegmentName:@"RadioButtonThirdPartyPremiPayorRelationship"];
    
    [RadioButtonThirdPartyBeneficiary setSegmentName:@"RadioButtonThirdPartyBeneficiary"];
    [RadioButtonThirdPartyBeneficiaryRelationship setSegmentName:@"RadioButtonThirdPartyBeneficiaryRelationship"];
    
    [TextThirdPartyAskingRelationshipOther setTextFieldName:@"TextThirdPartyAskingRelationshipOther"]; //textSebutkan
    [TextThirdPartyPremiPayorRelationshipOther setTextFieldName:@"TextThirdPartyPremiPayorRelationshipOther"];//textSebutkan
    [TextThirdPartyBeneficiaryRelationshipOther setTextFieldName:@"TextThirdPartyBeneficiaryRelationshipOther"]; //textSebutkan
    
    //view C
    [RadioButtonThirdPartyIDType setSegmentName:@"RadioButtonThirdPartyIDType"];
    [RadioButtonThirdPartyNationality setSegmentName:@"RadioButtonThirdPartyNationality"];
    
    [RadioButtonThirdPartyUSACitizen setSegmentName:@"RadioButtonThirdPartyUSACitizen"];
    [RadioButtonThirdPartySex setSegmentName:@"RadioButtonThirdPartySex"];
    
    [RadioButtonThirdPartyMaritalStatus setSegmentName:@"RadioButtonThirdPartyMaritalStatus"];
    [RadioButtonThirdPartyReligion setSegmentName:@"RadioButtonThirdPartyReligion"];
    
    [RadioButtonThirdPartyCorrespondanceAddress setSegmentName:@"RadioButtonThirdPartyCorrespondanceAddress"];
    [RadioButtonThirdPartyRelationAssured setSegmentName:@"RadioButtonThirdPartyRelationAssured"];
    
    [RadioButtonThirdPartySalary setSegmentName:@"RadioButtonThirdPartySalary"];
    [RadioButtonThirdPartyRevenue setSegmentName:@"RadioButtonThirdPartyRevenue"];
    
    [RadioButtonThirdPartyOtherIncome setSegmentName:@"RadioButtonThirdPartyOtherIncome"];
    
    [DateThirdPartyActive setButtonName:@"DateThirdPartyActive"];
    [DateThirdPartyBirth setButtonName:@"DateThirdPartyBirth"];
    [DateThirdPartyNPWPActive setButtonName:@"DateThirdPartyNPWPActive"];//tanggal npwp
    
    [TextThirdPartyIDTypeOther setTextFieldName:@"TextThirdPartyIDTypeOther"];
    [TextThirdPartyBeneficiaryNationalityWNA setTextFieldName:@"TextThirdPartyBeneficiaryNationalityWNA"];//textSebutkan
    [LineThirdPartyOtherRelationship setTextFieldName:@"TextThirdPartyOtherRelationship"];//textSebutkan
    [TextThirdPartyInsurancePurposeOther setTextFieldName:@"TextThirdPartyInsurancePurposeOther"];//textSebutkan
    
    [TextThirdPartySalary setTextFieldName:@"TextThirdPartySalary"];//penghasilan/tahun
    [TextThirdPartyRevenue setTextFieldName:@"TextThirdPartyRevenue"];//penghasilan/tahun
    [TextThirdPartyOtherIncome setTextFieldName:@"TextThirdPartyOtherIncome"];//penghasilan/tahun
    
    [TextThirdPartyCIN setTextFieldName:@"TextThirdPartyCIN"];
    [TextThirdPartyFullName setTextFieldName:@"TextThirdPartyFullName"];
    [TextThirdPartyFullName2nd setTextFieldName:@"TextThirdPartyFullName2nd"];
    [TextThirdPartyIDNumber setTextFieldName:@"TextThirdPartyIDNumber"];
    [TextThirdPartyBirthPlace setTextFieldName:@"TextThirdPartyBirthPlace"];
    [TextThirdPartyCompany setTextFieldName:@"TextThirdPartyCompany"];
    [TextThirdPartyMainJob setTextFieldName:@"TextThirdPartyMainJob"];
    [TextThirdPartyWorkScope setTextFieldName:@"TextThirdPartyWorkScope"];
    [TextThirdPartyPosition setTextFieldName:@"TextThirdPartyPosition"];
    [TextThirdPartyJobDescription setTextFieldName:@"TextThirdPartyJobDescription"];
    [TextThirdPartySideJob setTextFieldName:@"TextThirdPartySideJob"];
    [TextThirdPartyHomeAddress setTextFieldName:@"TextThirdPartyHomeAddress"];
    [TextThirdPartyHomeAddress2nd setTextFieldName:@"TextThirdPartyHomeAddress2nd"];
    [TextThirdPartyHomeCity setTextFieldName:@"TextThirdPartyHomeCity"];
    [TextThirdPartyHomePostalCode setTextFieldName:@"TextThirdPartyHomePostalCode"];
    [TextThirdPartyHomeTelephonePrefix setTextFieldName:@"TextThirdPartyHomeTelephonePrefix"];
    [TextThirdPartyHomeTelephoneSuffix setTextFieldName:@"TextThirdPartyHomeTelephoneSuffix"];
    [TextThirdPartyHandphone1 setTextFieldName:@"TextThirdPartyHandphone1"];
    [TextThirdPartyHandphone2 setTextFieldName:@"TextThirdPartyHandphone2"];
    [TextThirdPartyEmail setTextFieldName:@"TextThirdPartyEmail"];
    
    [TextThirdPartyOfficeAddress1 setTextFieldName:@"TextThirdPartyOfficeAddress1"];//textOffice1
    [TextThirdPartyOfficeAddress2 setTextFieldName:@"TextThirdPartyOfficeAddress2"];//textOffice2
    [TextThirdPartyOfficePostalCode setTextFieldName:@"TextThirdPartyOfficePostalCode"];//textOfficeKodePos
    [TextThirdPartyOfficeCity setTextFieldName:@"TextThirdPartyOfficeCity"];//textOfficeKota
    
    [TextThirdPartyNPWPNumber setTextFieldName:@"TextThirdPartyNPWPNumber"];//textNomorNPWP
    [TextThirdPartySource setTextFieldName:@"TextThirdPartySource"];
    [TextThirdPartyFundingSource setTextFieldName:@"TextThirdPartyFundingSource"]; //textSumberDanaPembelianAsuransi
    
    //view D
    [RadioButtonThirdPartyCompanyType setSegmentName:@"RadioButtonThirdPartyCompanyType"];
    [RadioButtonThirdPartyCompanyAsset setSegmentName:@"RadioButtonThirdPartyCompanyAsset"];
    
    [RadioButtonThirdPartyCompanyRevenue setSegmentName:@"RadioButtonThirdPartyCompanyRevenue"];
    [RadioButtonThirdPartyCompanyRelationAssured setSegmentName:@"RadioButtonThirdPartyCompanyRelationAssured"];
    
    
    [DateThirdPartyCompanyNoAnggaranDasarExpired setButtonName:@"DateThirdPartyCompanyNoAnggaranDasarExpired"];
    [DateThirdPartyCompanySIUPExpired setButtonName:@"DateThirdPartyCompanySIUPExpired"];
    [DateThirdPartyCompanyNoTDPExpired setButtonName:@"DateThirdPartyCompanyNoTDPExpired"];
    [DateThirdPartyCompanyNoSKDPExpired setButtonName:@"DateThirdPartyCompanyNoSKDPExpired"];
    [DateThirdPartyCompanyNoNPWP setButtonName:@"DateThirdPartyCompanyNoNPWP"];//tanggalNPWP
    
    [TextThirdPartyCompanyTypeOther setTextFieldName:@"TextThirdPartyCompanyTypeOther"];//textSebutkan
    [TextThirdPartyNonPersonOtherRelationship setTextFieldName:@"TextThirdPartyNonPersonOtherRelationship"];
    [TextThirdPartyNonPersonInsurancePurposeOther setTextFieldName:@"TextThirdPartyNonPersonInsurancePurposeOther"];
    
    [TextThirdPartyCompanyName setTextFieldName:@"TextThirdPartyCompanyName"];
    [TextThirdPartyCompanyDirectorName setTextFieldName:@"TextThirdPartyCompanyDirectorName"];
    [TextThirdPartyCompanyDirectorName2 setTextFieldName:@"TextThirdPartyCompanyDirectorName2nd"];
    [TextThirdPartyCompanyNoAnggaranDasar setTextFieldName:@"TextThirdPartyCompanyNoAnggaranDasar"];
    [TextThirdPartyCompanyNoSIUP setTextFieldName:@"TextThirdPartyCompanyNoSIUP"];
    [TextThirdPartyCompanyNoTDP setTextFieldName:@"TextThirdPartyCompanyNoTDP"];
    [TextThirdPartyCompanyNoSKDP setTextFieldName:@"TextThirdPartyCompanyNoSKDP"];
    [TextThirdPartyCompanyNoNPWP setTextFieldName:@"TextThirdPartyCompanyNoNPWP"];
    [TextThirdPartyCompanySector setTextFieldName:@"TextThirdPartyCompanySector"];
    [TextThirdPartyCompanyAddress setTextFieldName:@"TextThirdPartyCompanyAddress"];
    [TextThirdPartyCompanyAddress2nd setTextFieldName:@"TextThirdPartyCompanyAddress2nd"]; //ini belum ada
    [TextThirdPartyCompanyCity setTextFieldName:@"TextThirdPartyCompanyCity"];
    [TextThirdPartyCompanyPostalCode setTextFieldName:@"TextThirdPartyCompanyPostalCode"];
    
    //IBOutlet TextFieldSPAJ*
    //IBOutlet TextFieldSPAJ*
    
    [RadioButtonThirdPartyAskingRelationship addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    [RadioButtonThirdPartyPremiPayorRelationship addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    [RadioButtonThirdPartyBeneficiaryRelationship addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    /*else if (sender==RadioButtonThirdPartyAskingRelationship){
     
    }*///Jenis Identitas Diri
    
    
    //view E
    [TextThirdPartyAccountHolder setTextFieldName:@"TextThirdPartyAccountHolder"];
    [TextThirdPartyAccountNumber setTextFieldName:@"TextThirdPartyAccountNumber"];
    [TextThirdPartyBankName setTextFieldName:@"TextThirdPartyBankName"];
    [TextThirdPartyBankBranch setTextFieldName:@"TextThirdPartyBankBranch"];
    
    [RadioButtonThirdPartyIDType addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    [RadioButtonThirdPartyNationality addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    [RadioButtonThirdPartyRelationAssured addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    [RadioButtonThirdPartyCompanyType addTarget:self action:@selector(actionSegmentSPAJ:) forControlEvents:UIControlEventValueChanged];
    
    [self setTextFieldProperties];
    // Do any additional setup after loading the view from its nib.
}

-(void)setTextFieldProperties{
    for (UIView *view in [stackViewForm subviews]) {
        if (view.tag == 1){
            for (UIView *viewDetail in [view subviews]) {
                if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                    TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                    [textTemp setDelegate:self];
                }
            }
        }
    }
}

#pragma mark clear all value
-(void)clearAllValues{
    @try {
        for (UIView *view in [stackViewForm subviews]) {
            if (view.tag == 1){
                for (UIView *viewDetail in [view subviews]) {
                    if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                        SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                        [segmentTemp setSelectedSegmentIndex:UISegmentedControlNoSegment];
                        
                    }
                    
                    if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                        TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                        [textTemp setText:@""];
                    }
                    
                    if ([viewDetail isKindOfClass:[TextViewSPAJ class]]) {
                        TextViewSPAJ* textTemp = (TextViewSPAJ *)viewDetail;
                        [textTemp setText:@""];
                    }
                    
                    if ([viewDetail isKindOfClass:[ButtonSPAJ class]]) {
                        ButtonSPAJ* buttonTemp = (ButtonSPAJ *)viewDetail;
                        [buttonTemp setTitle:@"(Tanggal / Bulan / Tahun)" forState:UIControlStateNormal];
                    }
                    
                    if ([viewDetail isKindOfClass:[collectionReasonInsurancePurchaseC class]]) {
                        valueCheckBoxReasonArrayC = [[NSMutableArray alloc]init];
                    }
                    
                    if ([viewDetail isKindOfClass:[collectionReasonInsurancePurchaseD class]]) {
                        valueCheckBoxReasonArrayD = [[NSMutableArray alloc]init];
                    }
                }
            }
        }
        [collectionReasonInsurancePurchaseC reloadData];
        [collectionReasonInsurancePurchaseD reloadData];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}


#pragma mark arrayInitialization
-(void)arrayInitializeAgentProfile{
    arrayDBAgentID =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeAgentProfileDB]];
    arrayHTMLAgentID =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeAgentProfileHTML]];
}

-(void)arrayInitializeReferral{
    arrayDBReferral =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeReferralDB]];
    arrayHTMLReferal =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeReferralHTML]];
}

-(void)arrayInitializePOData{
    arrayDBPOData =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializePODataDB]];
    arrayHTMLPOData =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializePODataHTML]];
}


-(void)arrayInitializeSIMaster{ //premnath Vijaykumar
    arrayDBSIData=[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeSIMasterDB]];
    arrayHTMLSIData =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeSIMasterHTML]];
}

-(void)arrayInitializeSignature{ //premnath Vijaykumar
    arrayDBSignature=[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeSignatureDB]];
    arrayHTMLSignature =[[NSMutableArray alloc]initWithArray:[spajPDFData arrayInitializeSignatureHTML]];
}

-(void)loadThirdPartyPDFHTML:(NSString*)stringHTMLName WithArrayIndex:(int)intArrayIndex{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
}

-(void)loadReport{
    //NSString* fileName = @"20160803/page_spajpdf_salesdeclaration.html";
    imageFileName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
    [self loadThirdPartyPDFHTML:imageFileName WithArrayIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)intializeArrayInsuranceReasonC{
    arrayCollectionInsurancePurchaseReasonC = [[NSMutableArray alloc]initWithObjects:@"Tabungan",@"Proteksi",@"Investasi",@"Pendidikan",@"Lainnya", nil];
    arrayCollectionInsurancePurchaseReasonIDC = [[NSMutableArray alloc]initWithObjects:@"CheckboxThirdPartyInsurancePurposeSavings",@"CheckboxThirdPartyInsurancePurposeProtection",@"CheckboxThirdPartyInsurancePurposeInvestation",@"CheckboxThirdPartyInsurancePurposeEducation",@"CheckboxThirdPartyInsurancePurposeOther", nil];
    arrayCollectionSelectedInsurancePurchaseReasonC = [[NSMutableArray alloc]initWithObjects:@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",nil];
}

- (void)intializeArrayInsuranceReasonD{
    arrayCollectionInsurancePurchaseReasonD = [[NSMutableArray alloc]initWithObjects:@"Tabungan",@"Proteksi",@"Investasi",@"Pendidikan",@"Lainnya", nil];
    arrayCollectionInsurancePurchaseReasonIDD = [[NSMutableArray alloc]initWithObjects:@"CheckboxThirdPartyCompanyInsurancePurposeSavings",@"CheckboxThirdPartyCompanyInsurancePurposeProtection",@"CheckboxThirdPartyCompanyInsurancePurposeInvestation",@"CheckboxThirdPartyCompanyInsurancePurposeEducation",@"CheckboxThirdPartyCompanyInsurancePurposeOther", nil];
    arrayCollectionSelectedInsurancePurchaseReasonD = [[NSMutableArray alloc]initWithObjects:@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",nil];
}

-(void)setTextFieldEnabled:(TextFieldSPAJ *)textFieldSPAJInput BoolEnabled:(BOOL)boolEnabled{
    if (boolEnabled){
        [textFieldSPAJInput setEnabled:YES];
        [textFieldSPAJInput setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [textFieldSPAJInput setEnabled:NO];
        [textFieldSPAJInput setBackgroundColor:[UIColor lightGrayColor]];
    }
}

-(BOOL)checkMandatoryFields{
    NSMutableArray *arrayMandatorySegment = [[NSMutableArray alloc]init];
    NSMutableArray *arrayMandatoryTextField = [[NSMutableArray alloc]init];
    
    [arrayMandatorySegment addObject:RadioButtonThirdPartyCorrespondanceAddress];
    [arrayMandatorySegment addObject:RadioButtonThirdPartyRelationAssured];
    
    [arrayMandatoryTextField addObject:TextThirdPartyCIN];
    [arrayMandatoryTextField addObject:TextThirdPartyFullName];
    [arrayMandatoryTextField addObject:TextThirdPartyIDNumber];
    [arrayMandatoryTextField addObject:TextThirdPartyHomeAddress];
    [arrayMandatoryTextField addObject:TextThirdPartyHomeCity];
    [arrayMandatoryTextField addObject:TextThirdPartyHomePostalCode];
    [arrayMandatoryTextField addObject:TextThirdPartySource];
    
    for (int x=0;x<[arrayMandatorySegment count];x++){
        SegmentSPAJ* segmentTemp = (SegmentSPAJ *)[arrayMandatorySegment objectAtIndex:x];
        if (segmentTemp.selectedSegmentIndex == UISegmentedControlNoSegment) {
            UIAlertController *alertLockForm = [alert alertInformation:@"Data Tidak Lengkap" stringMessage:[NSString stringWithFormat:@"Mohon lengkapi data %@ terlbih dahulu",[segmentTemp getSegmentName]]];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            return false;
        }
    }
    
    for (int x=0;x<[arrayMandatoryTextField count];x++){
        TextFieldSPAJ* textTemp = (TextFieldSPAJ *)[arrayMandatoryTextField objectAtIndex:x];
        if (textTemp.text.length<=0) {
            UIAlertController *alertLockForm = [alert alertInformation:@"Data Tidak Lengkap" stringMessage:[NSString stringWithFormat:@"Mohon lengkapi data %@ terlbih dahulu",[textTemp getTextFieldName]]];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            return false;
        }
    }
    
    return true;
}

-(IBAction)actionSegmentSPAJ:(SegmentSPAJ *)sender{
    if (sender==RadioButtonThirdPartyAskingRelationship){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyAskingRelationshipOther BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyAskingRelationshipOther BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyAskingRelationshipOther BoolEnabled:NO];
        }
        //TextThirdPartyAskingRelationshipOther
    }
    else if (sender==RadioButtonThirdPartyPremiPayorRelationship){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyPremiPayorRelationshipOther BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyPremiPayorRelationshipOther BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyPremiPayorRelationshipOther BoolEnabled:NO];
        }
        //TextThirdPartyPremiPayorRelationshipOther
    }
    else if (sender==RadioButtonThirdPartyBeneficiaryRelationship){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryRelationshipOther BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryRelationshipOther BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryRelationshipOther BoolEnabled:NO];
        }
        //TextThirdPartyBeneficiaryRelationshipOther
    }
    
    else if (sender==RadioButtonThirdPartyIDType){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyIDTypeOther BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyIDTypeOther BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyIDTypeOther BoolEnabled:NO];
        }
    }//Jenis Identitas Diri
    
    else if (sender==RadioButtonThirdPartyNationality){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryNationalityWNA BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryNationalityWNA BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyBeneficiaryNationalityWNA BoolEnabled:NO];
        }
        //TextThirdPartyBeneficiaryNationalityWNA
    }
    else if (sender==RadioButtonThirdPartyRelationAssured){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:LineThirdPartyOtherRelationship BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:LineThirdPartyOtherRelationship BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:LineThirdPartyOtherRelationship BoolEnabled:NO];
        }
        //LineThirdPartyOtherRelationship
    }
    
    else if (sender==RadioButtonThirdPartyCompanyType){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            //[TextThirdPartyAskingRelationshipOther setEnabled:YES];
            [self setTextFieldEnabled:TextThirdPartyCompanyTypeOther BoolEnabled:YES];
        }
        else if (sender.selectedSegmentIndex == UISegmentedControlNoSegment){
            [self setTextFieldEnabled:TextThirdPartyCompanyTypeOther BoolEnabled:NO];
        }
        else {
            //[TextThirdPartyAskingRelationshipOther setEnabled:NO];
            [self setTextFieldEnabled:TextThirdPartyCompanyTypeOther BoolEnabled:NO];
        }
        //TextThirdPartyCompanyTypeOther
    }
    /*else if (sender==RadioButtonThirdPartyAskingRelationship){
        
    }*///Hubungan Dengan Calon Tertanggung
}

- (IBAction)actionDate:(ButtonSPAJ *)sender
{
    tempDateButton = sender;
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSString *dateString;
    if ([sender.currentTitle isEqualToString:@"(Tanggal / Bulan / Tahun)"]){
        dateString= [formatter getDateToday:@"dd/MM/yyyy"];
    }
    else{
        dateString= sender.currentTitle;
    }
    
    if (siDate == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        siDate = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        siDate.delegate = self;
        SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:siDate];
    }
    siDate.ProspectDOB=dateString;
    [SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [SIDatePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

- (IBAction)btnDOBPressed:(ButtonSPAJ *)sender
{
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    LADate.delegate = self;
    LADate.btnSender = 1;
    LADate.msgDate = [formatter getDateToday:@"dd/MM/yyyy"];
    //LADate.msgDate = sender.titleLabel.text;
    
    dobPopover = [[UIPopoverController alloc] initWithContentViewController:LADate];
    [dobPopover setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [dobPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}



-(IBAction)actionCloseForm:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"Back"]){
        [UIView animateWithDuration:0.3 animations:^{
            [viewSignature setAlpha:0];
            [buttonClose setEnabled:false];
            [buttonClose setTitle:@"Close" forState:UIControlStateNormal];
        } completion:^ (BOOL completed) {
            [viewSignature setHidden:true];
            //[buttonShowSignature setHidden:false];
            [buttonClose setEnabled:true];
            [buttonSubmit setHidden:false];
        }];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(IBAction)createThirdPartySignature:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [viewSignature setHidden:false];
        [viewSignature setAlpha:1];
        [buttonClose setTitle:@"Back" forState:UIControlStateNormal];
        [buttonClose setEnabled:false];
        [buttonSubmit setHidden:true];
    } completion:^ (BOOL completed) {
        [buttonShowSignature setHidden:true];
        [buttonClose setEnabled:true];
    }];
}

-(IBAction)getUISwitchValue:(UIButton *)sender{
    @try {
        //if ([self checkMandatoryFields]){
            NSMutableArray* arrayFormAnswers = [[NSMutableArray alloc]init];
            [buttonSubmit setEnabled:false];
            int i=1;
            for (UIView *view in [stackViewForm subviews]) {
                if (view.tag == 1){
                    for (UIView *viewDetail in [view subviews]) {
                        if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                            
                            SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                            if (segmentTemp.selectedSegmentIndex != UISegmentedControlNoSegment){
                                NSString *value= [allAboutPDFFunctions GetOutputForRadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                                
                                NSString *elementID = [segmentTemp getSegmentName]?:[NSString stringWithFormat:@"seg%i",i];;
                                
                                NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"TP"] valueForKey:@"SPAJHtmlID"]];
                            
                                [arrayFormAnswers addObject:dictAnswer];
                            }
                            i++;
                        }
                        
                        if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                            NSLog(@"tf");
                            TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                            NSString *value = textTemp.text;
                            NSString *elementID = [textTemp getTextFieldName]?:[NSString stringWithFormat:@"textField%i",i];
                            
                            NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"TP"] valueForKey:@"SPAJHtmlID"]];
                            
                            [arrayFormAnswers addObject:dictAnswer];
                            i++;
                        }
                        
                        if ([viewDetail isKindOfClass:[ButtonSPAJ class]]) {
                            NSLog(@"btn");
                            ButtonSPAJ* buttonTemp = (ButtonSPAJ *)viewDetail;
                            NSString *value = buttonTemp.currentTitle;
                            NSString *elementID = [buttonTemp getButtonName]?:[NSString stringWithFormat:@"btnView%i",i];
                            
                            NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"TP"] valueForKey:@"SPAJHtmlID"]];
                            
                            [arrayFormAnswers addObject:dictAnswer];
                            i++;
                        }
                    }
                }
            }
            
            for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReasonC count];x++){
                NSString *value = [allAboutPDFFunctions GetOutputForInsurancePurposeCheckBox:[arrayCollectionSelectedInsurancePurchaseReasonC objectAtIndex:x]];
                NSString *elementID = [arrayCollectionInsurancePurchaseReasonIDC objectAtIndex:x];
                
                NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"TP"] valueForKey:@"SPAJHtmlID"]];
                
                [arrayFormAnswers addObject:dictAnswer];
            }
            
            for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReasonD count];x++){
                NSString *value = [allAboutPDFFunctions GetOutputForInsurancePurposeCheckBox:[arrayCollectionSelectedInsurancePurchaseReasonD objectAtIndex:x]];
                NSString *elementID = [arrayCollectionInsurancePurchaseReasonIDD objectAtIndex:x];
                
                NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"TP"] valueForKey:@"SPAJHtmlID"]];
                
                [arrayFormAnswers addObject:dictAnswer];
            }
            
            //NSLog(@"answers %@",[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]);
            [self savetoDB:[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]];
        //}
    } @catch (NSException *exception) {
        [buttonSubmit setEnabled:true];
        NSLog(@"error %@",exception);
        UIAlertController *alertLockForm = [alert alertInformation:@"Data Tidak Lengkap" stringMessage:@"Mohon lengkapi data pihak ketiga terlbih dahulu"];
        //[self presentViewController:alertLockForm animated:YES completion:nil];
    } @finally {
        
    }
    
}



-(IBAction)actionButtonInsuranceReasonTappedC:(ButtonSPAJ *)sender{
    if ([sender isSelected]){
        [sender setSelected:NO];
        [arrayCollectionSelectedInsurancePurchaseReasonC replaceObjectAtIndex:sender.tag withObject:@"Not Checked"];
    }
    else{
        [arrayCollectionSelectedInsurancePurchaseReasonC replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        [sender setSelected:YES];
    }
    
    
    NSLog(@"array value %@",arrayCollectionSelectedInsurancePurchaseReasonC);
}


-(void)voidLoadAllThirdPartyData{
    @try {
        int i=1;
        for (UIView *view in [stackViewForm subviews]) {
            if (view.tag == 1){
                for (UIView *viewDetail in [view subviews]) {
                    if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                        SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[segmentTemp getSegmentName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueArray count]>0){
                            NSString* stringValue = [valueArray objectAtIndex:0];
                            
                            NSArray* arrayRadioObjectReturn = [[NSArray alloc]initWithArray:[allAboutPDFFunctions filterArrayByKey:stringValue]];
                            
                            for (int i = 0; i < [segmentTemp numberOfSegments]; i++)
                            {
                                if ([[arrayRadioObjectReturn valueForKey:@"Object"] containsObject:[segmentTemp titleForSegmentAtIndex:i]])
                                {
                                    [segmentTemp setSelectedSegmentIndex:i];
                                    [self actionSegmentSPAJ:segmentTemp];
                                    break;
                                }
                                else{
                                    [self actionSegmentSPAJ:segmentTemp];
                                }
                            }
                        }
                        else{
                            [self actionSegmentSPAJ:segmentTemp];
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                        TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[textTemp getTextFieldName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueArray count]>0){
                            NSString* stringValue = [valueArray objectAtIndex:0];
                            [textTemp setText:stringValue];
                        }
                        else if ([valueArray count]>1){
                            
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[TextViewSPAJ class]]) {
                        TextViewSPAJ* textTemp = (TextViewSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[textTemp getTextViewName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueArray count]>0){
                            NSString* stringValue = [valueArray objectAtIndex:0];
                            [textTemp setText:stringValue];
                        }
                        else if ([valueArray count]>1){
                            
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[ButtonSPAJ class]]) {
                        ButtonSPAJ* buttonTemp = (ButtonSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[buttonTemp getButtonName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueArray count]>0){
                            NSString* stringValue = [valueArray objectAtIndex:0];
                            [buttonTemp setTitle:stringValue forState:UIControlStateNormal];
                        }
                        else if ([valueArray count]>1){
                            
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[collectionReasonInsurancePurchaseC class]]) {
                        valueCheckBoxReasonArrayC = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerElementValue:@"CheckboxThirdPartyInsurancePurpose" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueCheckBoxReasonArrayC count]>0){
                            NSLog(@"ElementValue %@",valueCheckBoxReasonArrayC);
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[collectionReasonInsurancePurchaseD class]]) {
                        valueCheckBoxReasonArrayD = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerElementValue:@"CheckboxThirdPartyCompanyInsurancePurpose" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"]];
                        if ([valueCheckBoxReasonArrayD count]>0){
                            NSLog(@"ElementValue %@",valueCheckBoxReasonArrayD);
                        }
                        i++;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(IBAction)actionButtonInsuranceReasonTappedD:(ButtonSPAJ *)sender{
    if ([sender isSelected]){
        [sender setSelected:NO];
        [arrayCollectionSelectedInsurancePurchaseReasonD replaceObjectAtIndex:sender.tag withObject:@"Not Checked"];
    }
    else{
        [arrayCollectionSelectedInsurancePurchaseReasonD replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        [sender setSelected:YES];
    }
    
    
    NSLog(@"array value %@",arrayCollectionSelectedInsurancePurchaseReasonD);
}

-(void)loadCheckBoxReasonDataC:(ButtonSPAJ *)sender{
    if ([valueCheckBoxReasonArrayC count]>0){
        if ([[[valueCheckBoxReasonArrayC objectAtIndex:sender.tag] valueForKey:@"Value"] isEqualToString:@"Not Checked"]){
            [sender setSelected:NO];
        }
        else{
            [sender setSelected:YES];
            NSLog(@"reason %@",[[valueCheckBoxReasonArrayC objectAtIndex:sender.tag] valueForKey:@"Value"]);
            [arrayCollectionSelectedInsurancePurchaseReasonC replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        }
    }
    
    if (([sender tag]+1)==[valueCheckBoxReasonArrayC count]){
        valueCheckBoxReasonArrayC = [[NSMutableArray alloc]init];
    }
}

- (IBAction)actionClearSign:(UIButton *)sender {
    [viewToSign clearView];
    //viewToSign.layer.sublayers = nil;
}

- (IBAction)actionCompleteSignature:(id)sender{
    //if (!boolTenagaPenjual){
        NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty5=1,SPAJDateSignatureParty5='%@',SPAJSignatureTempImageParty5='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJSignature updateSPAJSignature:stringUpdate];
            
            //update signature party3
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
                //[self voidSaveSignatureToPDF:2];
        
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self performSelectorOnMainThread:@selector(signatureSuccess)withObject:nil waitUntilDone:YES];
                });
            });
        });
    /*}
    else{
        UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_LOCK", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_LOCK", nil)];
        [self presentViewController:alertLockForm animated:YES completion:nil];
    }*/
}

-(void)signatureSuccess{
    [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateModified" StringColumnValue:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    [self actionClearSign:nil];
    
    UIAlertController *alertLockForm = [UIAlertController alertControllerWithTitle:@"Berhasil" message:@"Form berhasil dibuat" preferredStyle:UIAlertControllerStyleAlert];
    [alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
    
    UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CLOSE", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertLockForm addAction: alertActionClose];
    
    [self presentViewController:alertLockForm animated:YES completion:nil];
}

-(void)loadCheckBoxReasonDataD:(ButtonSPAJ *)sender{
    if ([valueCheckBoxReasonArrayD count]>0){
        if ([[[valueCheckBoxReasonArrayD objectAtIndex:sender.tag] valueForKey:@"Value"] isEqualToString:@"Not Checked"]){
            [sender setSelected:NO];
        }
        else{
            [sender setSelected:YES];
            NSLog(@"reason %@",[[valueCheckBoxReasonArrayD objectAtIndex:sender.tag] valueForKey:@"Value"]);
            [arrayCollectionSelectedInsurancePurchaseReasonD replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        }
    }
    
    if (([sender tag]+1)==[valueCheckBoxReasonArrayD count]){
        valueCheckBoxReasonArrayD = [[NSMutableArray alloc]init];
    }
}


-(NSDictionary *)getDictionaryForAgentData:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictAgentData=[[NSMutableDictionary alloc]init];
    [dictAgentData setObject:stringHTMLID forKey:@"elementID"];
    if ([stringDBColumnName isEqualToString:@"AgentExpiryDate"]){
        NSString* trimmedString = [[dictAgentProfile valueForKey:stringDBColumnName] substringWithRange:NSMakeRange(0, 10)];
        NSString* dateFormatted = [formatter convertDateFrom:@"yyyy-MM-dd" TargetDateFormat:@"dd/MM/yyyy" DateValue:trimmedString];
        [dictAgentData setObject:dateFormatted?:@"" forKey:@"Value"];
    }
    else{
        [dictAgentData setObject:[dictAgentProfile valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
    }
    [dictAgentData setObject:@"1" forKey:@"CustomerID"];
    [dictAgentData setObject:@"1" forKey:@"SPAJID"];
    return dictAgentData;
}

-(NSDictionary *)getDictionaryForReferralData:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictReferralData=[[NSMutableDictionary alloc]init];
    [dictReferralData setObject:stringHTMLID forKey:@"elementID"];
    if ([stringDBColumnName isEqualToString:@"ReferralSource"]){
        [dictReferralData setObject:[formatter getReferralSourceValue:[modelProspectProfile selectProspectData:stringDBColumnName ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]]]?:@"" forKey:@"Value"];
    }
    else{
        [dictReferralData setObject:[modelProspectProfile selectProspectData:stringDBColumnName ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]]?:@"" forKey:@"Value"];
    }
    
    [dictReferralData setObject:@"1" forKey:@"CustomerID"];
    [dictReferralData setObject:@"1" forKey:@"SPAJID"];
    return dictReferralData;
}

-(NSDictionary *)getDictionaryForPOData:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictReferralData=[[NSMutableDictionary alloc]init];
    [dictReferralData setObject:stringHTMLID forKey:@"elementID"];
    [dictReferralData setObject:[dictionaryPOData valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
    [dictReferralData setObject:@"1" forKey:@"CustomerID"];
    [dictReferralData setObject:@"1" forKey:@"SPAJID"];
    return dictReferralData;
}

-(NSDictionary *)getDictionaryForSIMaster:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictSIMaster=[[NSMutableDictionary alloc]init];
    [dictSIMaster setObject:stringHTMLID forKey:@"elementID"];
    if ([stringDBColumnName isEqualToString:@"CreatedDate"]){
        NSString* dateFormatted = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy" DateValue:[dictionarySIMaster valueForKey:stringDBColumnName]];
        [dictSIMaster setObject:dateFormatted?:@"" forKey:@"Value"];
    }
    else{
        [dictSIMaster setObject:[dictionarySIMaster valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
    }
    [dictSIMaster setObject:@"1" forKey:@"CustomerID"];
    [dictSIMaster setObject:@"1" forKey:@"SPAJID"];
    return dictSIMaster;
}


-(NSDictionary *)getDictionaryForSignature:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictForSignature=[[NSMutableDictionary alloc]init];
    [dictForSignature setObject:stringHTMLID forKey:@"elementID"];
    if ([stringDBColumnName isEqualToString:@"SPAJDateSignatureParty4"]){
        NSString* newDate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy" DateValue:[modelSPAJSignature selectSPAJSignatureData:stringDBColumnName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]];
        [dictForSignature setObject:newDate?:@"" forKey:@"Value"];
    }
    else{
        [dictForSignature setObject:[modelSPAJSignature selectSPAJSignatureData:stringDBColumnName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"" forKey:@"Value"];
    }
    
    [dictForSignature setObject:@"1" forKey:@"CustomerID"];
    [dictForSignature setObject:@"1" forKey:@"SPAJID"];
    return dictForSignature;
}

-(NSDictionary *)getDictionaryForSPAJNumber:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    NSMutableDictionary* dictForSignature=[[NSMutableDictionary alloc]init];
    [dictForSignature setObject:stringHTMLID forKey:@"elementID"];
    [dictForSignature setObject:[dictTransaction valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
    [dictForSignature setObject:@"1" forKey:@"CustomerID"];
    [dictForSignature setObject:@"1" forKey:@"SPAJID"];
    return dictForSignature;
}

#pragma Mark Character Limitation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    NSArray* arrayCaharacterLimit6 = [[NSArray alloc]initWithObjects:TextThirdPartyHomePostalCode,TextThirdPartyCompanyPostalCode, nil];
    
    NSArray* arrayCaharacterLimit7 = [[NSArray alloc]initWithObjects:TextThirdPartyCIN, nil];
    
    NSArray* arrayCaharacterLimit13 = [[NSArray alloc]initWithObjects:TextThirdPartyHandphone1,TextThirdPartyHandphone1,TextThirdPartyHomeTelephoneSuffix, nil];
    
    NSArray* arrayCaharacterLimit14 = [[NSArray alloc]initWithObjects:TextThirdPartySalary,TextThirdPartyRevenue,TextThirdPartyOtherIncome, nil];
    
    NSArray* arrayCaharacterLimit16 = [[NSArray alloc]initWithObjects:TextThirdPartyIDNumber, nil]; //untuk nomor identitas
    
    NSArray* arrayCaharacterLimit17 = [[NSArray alloc]initWithObjects:TextThirdPartyHomeCity,TextThirdPartyCompanyCity, nil];
    
    NSArray* arrayCaharacterLimit28 = [[NSArray alloc]initWithObjects:TextThirdPartyBirthPlace, nil];
    
    NSArray* arrayCaharacterLimit30 = [[NSArray alloc]initWithObjects:TextThirdPartyFullName,TextThirdPartyFullName2nd,TextThirdPartyCompany,TextThirdPartyMainJob,TextThirdPartyWorkScope,TextThirdPartyPosition,TextThirdPartyJobDescription,TextThirdPartySideJob,TextThirdPartyHomeAddress,TextThirdPartyHomeAddress2nd,TextThirdPartyEmail,TextThirdPartySource, nil];
    
    
    if ([arrayCaharacterLimit6 containsObject:textField]){
        return (newLength <= 6);
    }
    else if ([arrayCaharacterLimit7 containsObject:textField]){
        return (newLength <= 7);
    }
    else if ([arrayCaharacterLimit13 containsObject:textField]){
        return (newLength <= 13);
    }
    else if ([arrayCaharacterLimit14 containsObject:textField]){
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
        //return (newLength <= 14);
    }
    else if ([arrayCaharacterLimit16 containsObject:textField]){
        return (newLength <= 16);
    }
    else if ([arrayCaharacterLimit17 containsObject:textField]){
        return (newLength <= 17);
    }
    else if ([arrayCaharacterLimit28 containsObject:textField]){
        return (newLength <= 28);
    }
    else if ([arrayCaharacterLimit30 containsObject:textField]){
        return (newLength <= 30);
    }
    else if (textField == TextThirdPartyHomeTelephonePrefix){
        return (newLength <= 4);
    }
    
}

-(void)RealTimeFormat:(UITextField *)sender{
    NSNumber *plainNumber = [formatter convertAnyNonDecimalNumberToString:sender.text];
    [sender setText:[formatter numberToCurrencyDecimalFormatted:plainNumber]];
}


#pragma mark delegate date
-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *selectDate = aDate;
    NSDate *startDate = [dateFormatter dateFromString:selectDate];
    
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *endDate = [dateFormatter dateFromString:todayDate];
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    int diffDays = [difference day];
    BOOL AgeExceed189Days;
    if (diffDays >180)
    {
        AgeExceed189Days = true;
    }
    else
    {
        AgeExceed189Days = false;
    }
    
    int age = [formatter calculateAge:aDate];
    
    if (age<18){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Usia harus sama dengan atau lebih dari 18 tahun"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else{
        [DateThirdPartyBirth setTitle:aDate forState:UIControlStateNormal];
    }
    
    /*if (aDate == NULL) {
        [DateThridPartyBirth setTitle:@"" forState:UIControlStateNormal];
    }
    else {
    
    }*/
    
    //self.btnDOB.titleLabel.textColor = [UIColor blackColor];
    [dobPopover dismissPopoverAnimated:YES];
}

- (void)DateSelected:(NSString *)strDate:(NSString *) dbDate{
    [tempDateButton setTitle:strDate forState:UIControlStateNormal];
}

- (void)CloseWindow{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [SIDatePopover dismissPopoverAnimated:YES];
}

-(void)voidCreateImageFromWebView:(NSString *)fileName{
    //[self.view bringSubviewToFront:webview];
    
    int currentWebViewHeight = webview.scrollView.contentSize.height;
    int scrollByY = webview.frame.size.height;
    
    [webview.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray* images = [[NSMutableArray alloc] init];
    
    CGRect screenRect = webview.frame;
    
    int pages = currentWebViewHeight/scrollByY;
    if (currentWebViewHeight%scrollByY > 0) {
        pages ++;
    }
    
    for (int i = 0; i< pages; i++)
    {
        if (i == pages-1) {
            if (pages>1)
                screenRect.size.height = currentWebViewHeight - scrollByY;
        }
        
        if (IS_RETINA)
            UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0);
        else
            UIGraphicsBeginImageContext( screenRect.size );
        if ([webview.layer respondsToSelector:@selector(setContentsScale:)]) {
            webview.layer.contentsScale = [[UIScreen mainScreen] scale];
        }
        //UIGraphicsBeginImageContext(screenRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        [webview.layer renderInContext:ctx];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (i == 0)
        {
            scrollByY = webview.frame.size.height;
        }
        else
        {
            scrollByY += webview.frame.size.height;
        }
        [webview.scrollView setContentOffset:CGPointMake(0, scrollByY)];
        [images addObject:newImage];
    }
    
    [webview.scrollView setContentOffset:CGPointMake(0, 0)];
    
    UIImage *resultImage;
    
    if(images.count > 1) {
        //join all images together..
        CGSize size;
        for(int i=0;i<images.count;i++) {
            
            size.width = MAX(size.width, ((UIImage*)[images objectAtIndex:i]).size.width );
            size.height += ((UIImage*)[images objectAtIndex:i]).size.height;
        }
        
        if (IS_RETINA)
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        else
            UIGraphicsBeginImageContext(size);
        if ([webview.layer respondsToSelector:@selector(setContentsScale:)]) {
            webview.layer.contentsScale = [[UIScreen mainScreen] scale];
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        int y=0;
        for(int i=0;i<images.count;i++) {
            
            UIImage* img = [images objectAtIndex:i];
            [img drawAtPoint:CGPointMake(0,y)];
            y += img.size.height;
        }
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        
        resultImage = [images objectAtIndex:0];
    }
    [images removeAllObjects];
    
    NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
    
    //NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
    //NSString* outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],@"ThirdParty"];
    NSString* outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],@"pihakketiga"];
    
    NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],outputName];
    
    BOOL success = [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    
    [buttonSubmit setEnabled:true];
    
    thumbnailData = nil;
    resultImage = nil;
    images = nil;
    
    if (success){
        [self createThirdPartySignature:nil];
    }
    
    
    /*UIAlertController *alertLockForm = [UIAlertController alertControllerWithTitle:@"Berhasil" message:@"Form berhasil dibuat" preferredStyle:UIAlertControllerStyleAlert];
    [alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
    
    UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CLOSE", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertLockForm addAction: alertActionClose];

    [self presentViewController:alertLockForm animated:YES completion:nil];*/
    //[viewActivityIndicator setHidden:YES];
}


- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    NSString *SPAJTransactionID = [dictTransaction valueForKey:@"SPAJTransactionID"];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[modifiedParams valueForKey:@"SPAJAnswers"]];
    NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and SPAJID=%@ and SPAJTransactionID=%@ ",@"1",@"1",SPAJTransactionID];
    
    [tempDict setObject:stringWhere forKey:@"where"];
    [tempDict setObject:[tempDict valueForKey:@"columns"] forKey:@"columns"];
    
    NSMutableDictionary* answerDictionary = [[NSMutableDictionary alloc]init];
    [answerDictionary setObject:tempDict forKey:@"SPAJAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:answerDictionary forKey:@"data"];
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    [super readfromDB:finalDictionary];
    
    NSMutableDictionary *dictOriginal = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *modifieArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[arrayHTMLAgentID count];i++){
        [modifieArray addObject:[self getDictionaryForAgentData:[arrayDBAgentID objectAtIndex:i] HTMLID:[arrayHTMLAgentID objectAtIndex:i]]];
    }
    
    for (int i=0; i<[arrayHTMLReferal count];i++){
        [modifieArray addObject:[self getDictionaryForReferralData:[arrayDBReferral objectAtIndex:i] HTMLID:[arrayHTMLReferal objectAtIndex:i]]];
    }
    
    for (int i=0; i<[arrayHTMLPOData count];i++){
        [modifieArray addObject:[self getDictionaryForPOData:[arrayDBPOData objectAtIndex:i] HTMLID:[arrayHTMLPOData objectAtIndex:i]]];
    }
    
    for (int i=0; i<[arrayHTMLSIData count];i++){
        [modifieArray addObject:[self getDictionaryForSIMaster:[arrayDBSIData objectAtIndex:i] HTMLID:[arrayHTMLSIData objectAtIndex:i]]];
    }
    
    for (int i=0; i<[arrayHTMLSignature count];i++){
        [modifieArray addObject:[self getDictionaryForSignature:[arrayDBSignature objectAtIndex:i] HTMLID:[arrayHTMLSignature objectAtIndex:i]]];
    }
    [modifieArray addObject:[self getDictionaryForSPAJNumber:@"SPAJNumber" HTMLID:@"TextSPAJNumber"]];
    [dictOriginal setObject:modifieArray forKey:@"readFromDB"];
    [self callSuccessCallback:[params valueForKey:@"successCallBack"] withRetValue:dictOriginal];
    
    //[self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(voidCreateImageFromWebView:) withObject:imageFileName afterDelay:1.0];
    return dictOriginal;
}


- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='TP' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //add another key to db
            [super savetoDB:params];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //add another key to db
                    [self loadReport];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                        });
                    });
                    
                    
                });
            });
        });
    });

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    activeView = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField = nil;
    activeView = textView;
}


/*-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
 activeView = textView;
 return true;//textView.text.length + (text.length - range.length) <= 500   ;
 }*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == collectionReasonInsurancePurchaseC){
        return arrayCollectionInsurancePurchaseReasonC.count;
    }
    else{
        return arrayCollectionInsurancePurchaseReasonD.count;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == collectionReasonInsurancePurchaseC){
        static NSString *identifier = @"Cell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        //UIButton* buttonInsurancePurchaseReason = (UIButton *)[cell viewWithTag:indexPath.row];
        ButtonSPAJ* buttonInsurancePurchaseReason = [[ButtonSPAJ alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        [buttonInsurancePurchaseReason setButtonName:@"CheckboxThirdPartyPurposeC"];
        buttonInsurancePurposeC = [buttonInsurancePurchaseReason getButtonName];
        [buttonInsurancePurchaseReason setTag:indexPath.row];
        [buttonInsurancePurchaseReason setTitle:[arrayCollectionInsurancePurchaseReasonC objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]  forState:UIControlStateNormal];
        [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[functionUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]]  forState:UIControlStateSelected];
        
        [buttonInsurancePurchaseReason.titleLabel setFont:[UIFont fontWithName:@"BPReplay" size:17]];
        [buttonInsurancePurchaseReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonInsurancePurchaseReason setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        [buttonInsurancePurchaseReason addTarget:self
                                          action:@selector(actionButtonInsuranceReasonTappedC:) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadCheckBoxReasonDataC:buttonInsurancePurchaseReason];
        [cell.contentView addSubview:buttonInsurancePurchaseReason];
        
        return cell;
    }
    else{
        static NSString *identifier = @"Cell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        //UIButton* buttonInsurancePurchaseReason = (UIButton *)[cell viewWithTag:indexPath.row];
        ButtonSPAJ* buttonInsurancePurchaseReason = [[ButtonSPAJ alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        [buttonInsurancePurchaseReason setButtonName:@"CheckboxThirdPartyPurposeD"];
        buttonInsurancePurposeD = [buttonInsurancePurchaseReason getButtonName];
        [buttonInsurancePurchaseReason setTag:indexPath.row];
        [buttonInsurancePurchaseReason setTitle:[arrayCollectionInsurancePurchaseReasonD objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]  forState:UIControlStateNormal];
        [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[functionUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]]  forState:UIControlStateSelected];
        
        [buttonInsurancePurchaseReason.titleLabel setFont:[UIFont fontWithName:@"BPReplay" size:17]];
        [buttonInsurancePurchaseReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonInsurancePurchaseReason setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        [buttonInsurancePurchaseReason addTarget:self
                                          action:@selector(actionButtonInsuranceReasonTappedD:) forControlEvents:UIControlEventTouchUpInside];
        
        [self loadCheckBoxReasonDataD:buttonInsurancePurchaseReason];
        [cell.contentView addSubview:buttonInsurancePurchaseReason];
        
        return cell;
    }
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    UIScrollView *someScrollView = scrollViewForm;
    
    [someScrollView setContentInset:tableViewInsets];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    UIScrollView *someScrollView = scrollViewForm;
    
    CGPoint tableViewBottomPoint = CGPointMake(0, CGRectGetMaxY([someScrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [someScrollView convertPoint:tableViewBottomPoint
                                                                  toView:keyWindow];
    
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    
    if (keyboardOverlappedSpaceHeight > 0)
    {
        UIEdgeInsets tableViewInsets = UIEdgeInsetsMake(0, 0, keyboardOverlappedSpaceHeight, 0);
        [someScrollView setContentInset:tableViewInsets];
    }

   /*end of added by faiz*/
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
