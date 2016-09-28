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
#import "Model_SI_Master.h"
#import "ModelSPAJHtml.h"
#import "SPAJPDFAutopopulateData.h"
#import "ModelSPAJTransaction.h"
#import "AllAboutPDFGeneration.h"
#import "Alert.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface SPAJThirdParty (){
    Formatter* formatter;
    SPAJPDFAutopopulateData* spajPDFData;
    SPAJPDFWebViewController* spajPDFWebView;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelProspectProfile* modelProspectProfile;
    ModelAgentProfile* modelAgentProfile;
    ModelSIPOData* modelSIPOData;
    Model_SI_Master* modelSIMaster;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    ModelSPAJTransaction *modelSPAJTransaction;
    AllAboutPDFGeneration *allAboutPDFGeneration;
    Alert* alert;
    
    NSString *imageFileName;
    
    NSMutableArray *arrayCollectionInsurancePurchaseReason;
    NSMutableArray *arrayCollectionSelectedInsurancePurchaseReason;
    
    NSString* buttonInsurancePurpose;
    
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

- (void)viewDidLoad {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 960,728)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [super viewDidLoad];
    for (int i=0; i<[[self.view subviews] count];i++){
        [self.view sendSubviewToBack:webview];
    }
    
    functionUserInterface = [[UserInterface alloc] init];
    allAboutPDFFunctions = [[AllAboutPDFFunctions alloc]init];
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
    allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
    alert = [[Alert alloc]init];
    
    [self arrayInitializeReferral];
    [self arrayInitializeAgentProfile];
    [self arrayInitializePOData];
    [self arrayInitializeSIMaster];
    [self arrayInitializeSignature];
    
    dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    
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
    //IBOutlet SegmentSPAJ*
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
    [DateThridPartyBirth setButtonName:@"DateThridPartyBirth"];
    //IBOutlet ButtonSPAJ* //tanggal npwp
    
    //IBOutlet TextFieldSPAJ* //textSebutkanjenisidentitas
    [TextThirdPartyBeneficiaryNationalityWNA setTextFieldName:@"TextThirdPartyBeneficiaryNationalityWNA"];//textSebutkan
    [LineThirdPartyOtherRelationship setTextFieldName:@"LineThirdPartyOtherRelationship"];//textSebutkan
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
    
    //IBOutlet TextFieldSPAJ* //textOffice1
    //IBOutlet TextFieldSPAJ* //textOffice2
    //IBOutlet TextFieldSPAJ* //textOfficeKodePos
    //IBOutlet TextFieldSPAJ* //textOfficeKota
    //IBOutlet TextFieldSPAJ* //textNomorNPWP
    [TextThirdPartySource setTextFieldName:@"TextThirdPartySource"];
    //IBOutlet TextFieldSPAJ* //textSumberDanaPembelianAsuransi
    
    //view D
    [RadioButtonThirdPartyCompanyType setSegmentName:@"RadioButtonThirdPartyCompanyType"];
    [RadioButtonThirdPartyCompanyAsset setSegmentName:@"RadioButtonThirdPartyCompanyAsset"];
    
    [RadioButtonThirdPartyCompanyRevenue setSegmentName:@"RadioButtonThirdPartyCompanyRevenue"];
    //IBOutlet SegmentSPAJ* RadioButtonRelationWithInsured
    
    
    [DateThirdPartyCompanyNoAnggaranDasarExpired setButtonName:@"DateThirdPartyCompanyNoAnggaranDasarExpired"];
    [DateThirdPartyCompanySIUPExpired setButtonName:@"DateThirdPartyCompanySIUPExpired"];
    [DateThirdPartyCompanyNoTDPExpired setButtonName:@"DateThirdPartyCompanyNoTDPExpired"];
    [DateThirdPartyCompanyNoSKDPExpired setButtonName:@"DateThirdPartyCompanyNoSKDPExpired"];
    //IBOutlet ButtonSPAJ* //tanggalNPWP
    
    [TextThirdPartyCompanyTypeOther setTextFieldName:@"TextThirdPartyCompanyTypeOther"];//textSebutkan
    //IBOutlet TextFieldSPAJ* //textHubunganCalonTertanggung//textSebutkan
    //IBOutlet TextFieldSPAJ* //textSebutkanTujuanPembelianAsuransi//textSebutkan
    
    
    [TextThirdPartyCompanyNoAnggaranDasar setTextFieldName:@""];
    [TextThirdPartyCompanyNoSIUP setTextFieldName:@""];
    [TextThirdPartyCompanyNoTDP setTextFieldName:@""];
    [TextThirdPartyCompanyNoSKDP setTextFieldName:@""];
    //IBOutlet TextFieldSPAJ* //textNPWP
    [TextThirdPartyCompanySector setTextFieldName:@""];
    [TextThirdPartyCompanyAddress setTextFieldName:@""];
    //IBOutlet TextFieldSPAJ* //TextThirdPartyCompanyAddress2//ini belum ada
    [TextThirdPartyCompanyCity setTextFieldName:@""];
    [TextThirdPartyCompanyPostalCode setTextFieldName:@""];
    
    //IBOutlet TextFieldSPAJ*
    //IBOutlet TextFieldSPAJ*
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionCloseForm:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)getUISwitchValue:(UIButton *)sender{
    NSMutableArray* arrayFormAnswers = [[NSMutableArray alloc]init];
    
    int i=1;
    for (UIView *view in [stackViewForm subviews]) {
        if (view.tag == 1){
            for (UIView *viewDetail in [view subviews]) {
                if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                    SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                    NSString *value;
                    if (segmentTemp.tag == 0){
                        value = [allAboutPDFFunctions GetOutputForYaTidakRadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                    }
                    else if (segmentTemp.tag == 1){
                        value = [allAboutPDFFunctions GetOutputForRelationWithPORadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                    }
                    else if (segmentTemp.tag == 2){
                        value = [allAboutPDFFunctions GetOutputForDurationKnowPORadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                    }
                    
                    NSString *elementID = [segmentTemp getSegmentName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                    TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextFieldName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextViewSPAJ class]]) {
                    TextViewSPAJ* textTemp = (TextViewSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextViewName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
            }
        }
    }
    
    /*for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReason count];x++){
        //NSString *value = [arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x];
        NSString *value = [allAboutPDFFunctions GetOutputForInsurancePurposeCheckBox:[arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x]];
        NSString *elementID = buttonInsurancePurpose;
        
        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value];
        
        [arrayFormAnswers addObject:dictAnswer];
    }*/
    
    NSLog(@"answers %@",[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]);
    //[self savetoDB:[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
