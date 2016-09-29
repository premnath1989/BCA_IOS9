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
#import "SIDate.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface SPAJThirdParty ()<SIDateDelegate>{
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
    SIDate *siDate;
    
    ButtonSPAJ* tempDateButton;
    
    UIPopoverController *SIDatePopover;
    
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
    [allAboutPDFFunctions createDictionaryForRadioButton];
    
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
    
    
    [TextThirdPartyCompanyNoAnggaranDasar setTextFieldName:@"TextThirdPartyCompanyNoAnggaranDasar"];
    [TextThirdPartyCompanyNoSIUP setTextFieldName:@"TextThirdPartyCompanyNoSIUP"];
    [TextThirdPartyCompanyNoTDP setTextFieldName:@"TextThirdPartyCompanyNoTDP"];
    [TextThirdPartyCompanyNoSKDP setTextFieldName:@"TextThirdPartyCompanyNoSKDP"];
    //IBOutlet TextFieldSPAJ* //textNPWP
    [TextThirdPartyCompanySector setTextFieldName:@"TextThirdPartyCompanySector"];
    [TextThirdPartyCompanyAddress setTextFieldName:@"TextThirdPartyCompanyAddress"];
    //IBOutlet TextFieldSPAJ* //TextThirdPartyCompanyAddress2//ini belum ada
    [TextThirdPartyCompanyCity setTextFieldName:@"TextThirdPartyCompanyCity"];
    [TextThirdPartyCompanyPostalCode setTextFieldName:@"TextThirdPartyCompanyPostalCode"];
    
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
                    NSString *value= [allAboutPDFFunctions GetOutputForRadioButton:[segmentTemp titleForSegmentAtIndex:segmentTemp.selectedSegmentIndex]];
                                        
                    NSString *elementID = [segmentTemp getSegmentName]?:[NSString stringWithFormat:@"seg%i",i];;
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP"];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                    NSLog(@"tf");
                    TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextFieldName]?:[NSString stringWithFormat:@"textField%i",i];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP"];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[ButtonSPAJ class]]) {
                    NSLog(@"btn");
                    ButtonSPAJ* buttonTemp = (ButtonSPAJ *)viewDetail;
                    NSString *value = buttonTemp.currentTitle;
                    NSString *elementID = [buttonTemp getButtonName]?:[NSString stringWithFormat:@"btnView%i",i];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"TP"];
                    
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
    [self savetoDB:[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]];
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

#pragma mark delegate date
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
    NSString* outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],@"ThirdParty"];
    
    NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],outputName];
    
    [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    
    UIAlertController *alertLockForm = [alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
    [self presentViewController:alertLockForm animated:YES completion:nil];
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
    [super savetoDB:params];
    [self loadReport];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
    
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
