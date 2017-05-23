//
//  FormTenagaPenjualViewController.m
//  BLESS
//
//  Created by Basvi on 9/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FormTenagaPenjualViewController.h"
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
#import "ModelSPAJAnswers.h"
#import "SPAJPDFAutopopulateData.h"
#import "ModelSPAJTransaction.h"
#import "AllAboutPDFGeneration.h"
#import "Alert.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface FormTenagaPenjualViewController ()<UITextFieldDelegate,UITextViewDelegate>{
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
    
    NSString *imageFileName;
    NSString *imageFileNameTranslate;
    
    NSMutableArray *arrayCollectionInsurancePurchaseReason;
    NSMutableArray *arrayCollectionInsurancePurchaseReasonID;
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
    
    NSMutableArray* valueCheckBoxReasonArray;
}

@end

@implementation FormTenagaPenjualViewController
@synthesize dictTransaction;

- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 819, 724);
//    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidLayoutSubviews{
    dispatch_async (dispatch_get_main_queue(), ^{
        [scrollViewForm setContentSize:CGSizeMake(819, 1901)];
    });
}


-(void)viewWillAppear:(BOOL)animated{
    [self voidLoadAllSalesDeclarationData];
    
    [collectionReasonInsurancePurchase reloadData];
}

- (void)viewDidLoad {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 960,728)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
    for (int i=0; i<[[self.view subviews] count];i++){
        [self.view sendSubviewToBack:webview];
    }
    
    functionUserInterface = [[UserInterface alloc] init];
    allAboutPDFFunctions = [[AllAboutPDFFunctions alloc]init];
    
    [collectionReasonInsurancePurchase registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    formatter = [[Formatter alloc]init];
    spajPDFData = [[SPAJPDFAutopopulateData alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
    modelAgentProfile = [[ModelAgentProfile alloc]init];
    modelProspectProfile = [[ModelProspectProfile alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSIMaster = [[Model_SI_Master alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
    
    [allAboutPDFFunctions createDictionaryForRadioButton];
    [allAboutPDFFunctions createDictionaryRevertForRadioButton];
    [allAboutPDFFunctions createArrayRevertForRadioButton];
    
    alert = [[Alert alloc]init];
    
    [self intializeArrayInsuranceReason];
    
    [self arrayInitializeReferral];
    [self arrayInitializeAgentProfile];
    [self arrayInitializePOData];
    [self arrayInitializeSIMaster];
    [self arrayInitializeSignature];
    
    [TextSalesDeclarationIncomeBruto addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    
    [textFieldPolicyHolder setTextFieldName:@"textFieldPolicyHolder"];
    [textFieldInsured setTextFieldName:@"textFieldInsured"];
    [textFieldSPAJNumber setTextFieldName:@"textFieldSPAJNumber"];
    
    [TextSalesDeclarationRelationshipWithProspectiveInsuredOther setTextFieldName:@"TextSalesDeclarationRelationshipWithProspectiveInsuredOther"];
    
    [TextSalesDeclarationPurposeOther setTextFieldName:@"TextSalesDeclarationPurposeOther"];
    
    [RadioButtonSalesDeclarationRelationshipWithProspectiveInsured setSegmentName:@"RadioButtonSalesDeclarationRelationshipWithProspectiveInsured"];
    [RadioButtonSalesDeclarationKnowProspectiveInsured setSegmentName:@"RadioButtonSalesDeclarationKnowProspectiveInsured"];
    [RadioButtonSalesDeclarationHealth setSegmentName:@"RadioButtonSalesDeclarationHealth"];
    [RadioButtonSalesDeclarationWithoutSecrecy setSegmentName:@"RadioButtonSalesDeclarationWithoutSecrecy"];
    [RadioButtonSalesDeclarationDenyClaim setSegmentName:@"RadioButtonSalesDeclarationDenyClaim"];
    [RadioButtonSalesDeclarationStillConsideration setSegmentName:@"RadioButtonSalesDeclarationStillConsideration"];
    [RadioButtonSalesDeclarationFaceToFace setSegmentName:@"RadioButtonSalesDeclarationFaceToFace"];
    [RadioButtonSalesDeclaration60DaysLimit setSegmentName:@"RadioButtonSalesDeclaration60DaysLimit"];
    [RadioButtonSalesDeclarationSelfVerified setSegmentName:@"RadioButtonSalesDeclarationSelfVerified"];
    [RadioButtonSalesDeclarationThirdParty setSegmentName:@"RadioButtonSalesDeclarationThirdParty"];
    [RadioButtonSalesDeclarationConsitution setSegmentName:@"RadioButtonSalesDeclarationConsitution"];
    [RadioButtonSalesDeclaration90DaysLimit setSegmentName:@"RadioButtonSalesDeclaration90DaysLimit"];
    [RadioButtonSalesDeclarationBasicSumAssured setSegmentName:@"RadioButtonSalesDeclarationBasicSumAssured"];
    
    [TextSalesDeclarationIncomeSource setTextFieldName:@"TextSalesDeclarationIncomeSource"];
    [TextSalesDeclarationIncomeBruto setTextFieldName:@"TextSalesDeclarationIncomeBruto"];
    
    [AreaSalesDeclarationAdditionalInformation setTextViewName:@"AreaSalesDeclarationAdditionalInformation"];
    
    dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
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


-(void)loadTenagaPenjualPDFHTML:(NSString*)stringHTMLName WithArrayIndex:(int)intArrayIndex{
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
    imageFileName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"AF" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
    imageFileNameTranslate = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlTranslateName" SPAJSection:@"AF" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
    [self loadTenagaPenjualPDFHTML:imageFileName WithArrayIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)intializeArrayInsuranceReason{
    arrayCollectionInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Tabungan",@"Proteksi",@"Investasi",@"Pendidikan",@"Lainnya", nil];
    
    arrayCollectionInsurancePurchaseReasonID = [[NSMutableArray alloc]initWithObjects:@"CheckboxSalesDeclarationPurposeSaving",@"CheckboxSalesDeclarationPurposeProtection",@"CheckboxSalesDeclarationPurposeInvestment",@"CheckboxSalesDeclarationPurposeEducation",@"CheckboxSalesDeclarationPurposeOther", nil];
    
    arrayCollectionSelectedInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",nil];
}

-(IBAction)actionCloseForm:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionButtonInsuranceReasonTapped:(ButtonSPAJ *)sender{
    if ([sender isSelected]){
        [sender setSelected:NO];
        [arrayCollectionSelectedInsurancePurchaseReason replaceObjectAtIndex:sender.tag withObject:@"Not Checked"];
    }
    else{
        [arrayCollectionSelectedInsurancePurchaseReason replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        [sender setSelected:YES];
    }
    NSLog(@"array value %@",arrayCollectionSelectedInsurancePurchaseReason);
}

-(void)loadCheckBoxReasonData:(ButtonSPAJ *)sender{
    if ([valueCheckBoxReasonArray count]>0){
        if ([[[valueCheckBoxReasonArray objectAtIndex:sender.tag] valueForKey:@"Value"] isEqualToString:@"Not Checked"]){
            [sender setSelected:NO];
        }
        else{
            [sender setSelected:YES];
            NSLog(@"reason %@",[[valueCheckBoxReasonArray objectAtIndex:sender.tag] valueForKey:@"Value"]);
            [arrayCollectionSelectedInsurancePurchaseReason replaceObjectAtIndex:sender.tag withObject:sender.currentTitle];
        }
    }
    
    if (([sender tag]+1)==[valueCheckBoxReasonArray count]){
        valueCheckBoxReasonArray = [[NSMutableArray alloc]init];
    }
}

-(void)voidLoadAllSalesDeclarationData{
    @try {
        int i=1;
        for (UIView *view in [stackViewForm subviews]) {
            if (view.tag == 1){
                for (UIView *viewDetail in [view subviews]) {
                    if ([viewDetail isKindOfClass:[SegmentSPAJ class]]) {
                        SegmentSPAJ* segmentTemp = (SegmentSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[segmentTemp getSegmentName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"AF"]];
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
                                //else {Do Nothing - these are not the droi, err, segment we are looking for}
                            }
                        }
                        else{
                            [self actionSegmentSPAJ:segmentTemp];
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                        TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[textTemp getTextFieldName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"AF"]];
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
                        NSMutableArray* valueArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerValue:[textTemp getTextViewName] SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"AF"]];
                        if ([valueArray count]>0){
                            NSString* stringValue = [valueArray objectAtIndex:0];
                            [textTemp setText:stringValue];
                        }
                        else if ([valueArray count]>1){
                            
                        }
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[collectionReasonInsurancePurchase class]]) {
                        valueCheckBoxReasonArray = [[NSMutableArray alloc]initWithArray:[modelSPAJAnswers getSPAJAnswerElementValue:@"CheckboxSalesDeclarationPurpose" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"AF"]];
                        if ([valueCheckBoxReasonArray count]>0){
                            NSLog(@"ElementValue %@",valueCheckBoxReasonArray);
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

-(IBAction)getUISwitchValue:(UIButton *)sender{
    @try {
        NSMutableArray* arrayFormAnswers = [[NSMutableArray alloc]init];
        [buttonSubmit setEnabled:false];
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
                        
                        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"AF"] valueForKey:@"SPAJHtmlID"]];
                        
                        [arrayFormAnswers addObject:dictAnswer];
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                        TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                        NSString *value = textTemp.text;
                        NSString *elementID = [textTemp getTextFieldName];
                        
                        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"AF"] valueForKey:@"SPAJHtmlID"]];
                        
                        [arrayFormAnswers addObject:dictAnswer];
                        i++;
                    }
                    
                    if ([viewDetail isKindOfClass:[TextViewSPAJ class]]) {
                        TextViewSPAJ* textTemp = (TextViewSPAJ *)viewDetail;
                        NSString *value = textTemp.text;
                        NSString *elementID = [textTemp getTextViewName];
                        
                        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"AF"] valueForKey:@"SPAJHtmlID"]];
                        
                        [arrayFormAnswers addObject:dictAnswer];
                        i++;
                    }
                }
            }
        }
        
        for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReason count];x++){
            NSString *value = [allAboutPDFFunctions GetOutputForInsurancePurposeCheckBox:[arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x]];
            NSString *elementID = [arrayCollectionInsurancePurchaseReasonID objectAtIndex:x];
            
            NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF" SPAJHtmlID:[[modelSPAJHtml selectActiveHtmlForSection:@"AF"] valueForKey:@"SPAJHtmlID"]];
            
            [arrayFormAnswers addObject:dictAnswer];
        }
        
        NSLog(@"answers %@",[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]);
        [self savetoDB:[allAboutPDFFunctions createDictionaryForSave:arrayFormAnswers]];
    } @catch (NSException *exception) {
        [buttonSubmit setEnabled:true];
        NSLog(@"error %@",exception);
        UIAlertController *alertLockForm = [alert alertInformation:@"Data Tidak Lengkap" stringMessage:@"Mohon lengkapi data tenaga penjual terlbih dahulu"];
        [self presentViewController:alertLockForm animated:YES completion:nil];
    } @finally {
        
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
    NSString* outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:fileName]];
    
    NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],outputName];
    
    BOOL written = [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    
    if (!written){
        UIAlertController *alertFailedGenerate = [UIAlertController alertControllerWithTitle:@"Kesalahan Generate File" message:@"Terjadi kegagalan dalam pembuatan file. Aplikasi akan menutup secara otomatis. Silahkan membuka ulang aplikasi BLESS dan megisi data tenaga penjual kembali." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            exit(0);
        }];
        
        [alertFailedGenerate addAction: alertActionClose];
        
        [self presentViewController:alertFailedGenerate animated:YES completion:nil];
    }
    [buttonSubmit setEnabled:true];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [allAboutPDFGeneration voidSaveSignatureForSingleImage:dictTransaction StringFileName:[allAboutPDFGeneration getSPAJImageNameFromPath:fileName]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIAlertController *alertLockForm = [UIAlertController alertControllerWithTitle:@"Berhasil" message:@"Form berhasil dibuat" preferredStyle:UIAlertControllerStyleAlert];[alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
            UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:NSLocalizedString(@"BUTTON_CLOSE", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertLockForm addAction: alertActionClose];
            [self presentViewController:alertLockForm animated:YES completion:nil];
        });
    });
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
    [self performSelector:@selector(voidCreateImageFromWebView:) withObject:imageFileNameTranslate afterDelay:1.0];
    return dictOriginal;
}

- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='AF' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //add another key to db
            [super savetoDB:params];
        });
    });
    
    [self loadReport];
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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    activeField = nil;
    activeView = nil;
}

-(IBAction)actionSegmentSPAJ:(SegmentSPAJ *)sender{
    if (sender==RadioButtonSalesDeclarationRelationshipWithProspectiveInsured){
        if (sender.selectedSegmentIndex == [sender numberOfSegments]-1){
            [self setTextFieldEnabled:TextSalesDeclarationRelationshipWithProspectiveInsuredOther BoolEnabled:YES];
        }
        else{
            [self setTextFieldEnabled:TextSalesDeclarationRelationshipWithProspectiveInsuredOther BoolEnabled:NO];
        }
    
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField==TextSalesDeclarationIncomeBruto){
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
}

-(void)RealTimeFormat:(UITextField *)sender{
    NSNumber *plainNumber = [formatter convertAnyNonDecimalNumberToString:sender.text];
    [sender setText:[formatter numberToCurrencyDecimalFormatted:plainNumber]];
}


/*-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    activeView = textView;
    return true;//textView.text.length + (text.length - range.length) <= 500   ;
}*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrayCollectionInsurancePurchaseReason.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //UIButton* buttonInsurancePurchaseReason = (UIButton *)[cell viewWithTag:indexPath.row];
    ButtonSPAJ* buttonInsurancePurchaseReason = [[ButtonSPAJ alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [buttonInsurancePurchaseReason setButtonName:@"CheckboxSalesDeclarationPurpose"];
    buttonInsurancePurpose = [buttonInsurancePurchaseReason getButtonName];
    
    [buttonInsurancePurchaseReason setTag:indexPath.row];
    [buttonInsurancePurchaseReason setTitle:[arrayCollectionInsurancePurchaseReason objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]  forState:UIControlStateNormal];
    [buttonInsurancePurchaseReason setBackgroundImage:[self imageWithColor:[functionUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]]  forState:UIControlStateSelected];
    
    [buttonInsurancePurchaseReason.titleLabel setFont:[UIFont fontWithName:@"BPReplay" size:17]];
    [buttonInsurancePurchaseReason setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonInsurancePurchaseReason setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    
    [buttonInsurancePurchaseReason addTarget:self
                                              action:@selector(actionButtonInsuranceReasonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadCheckBoxReasonData:buttonInsurancePurchaseReason];
    [cell.contentView addSubview:buttonInsurancePurchaseReason];
    
    return cell;
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

-(void)keyboardDidShow:(NSNotification *)notification
{
    
    
    /*added by faiz*/
    // Step 1: Get the size of the keyboard.
    
    /*NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+44, 0.0);
    scrollViewForm.contentInset = contentInsets;
    scrollViewForm.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (activeView != nil){
        // make sure the scrollview content size width and height are greater than 0
        [scrollViewForm setContentSize:CGSizeMake (scrollViewForm.frame.size.width, scrollViewForm.contentSize.height)];
        // scroll to the text view
        [scrollViewForm scrollRectToVisible:activeView.superview.frame animated:YES];
    }
    else{
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - (kbSize.height-15));
            [scrollViewForm setContentOffset:scrollPoint animated:YES];
        }
    }*/
    
    /*end of added by faiz*/
    if (activeView){
        // keyboard frame is in window coordinates
        NSDictionary *userInfo = [notification userInfo];
        CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // get the height of the keyboard by taking into account the orientation of the device too
        CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
        CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
        CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
        
        // add the keyboard height to the content insets so that the scrollview can be scrolled
        UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
        scrollViewForm.contentInset = contentInsets;
        scrollViewForm.scrollIndicatorInsets = contentInsets;
        
        // make sure the scrollview content size width and height are greater than 0
        [scrollViewForm setContentSize:CGSizeMake (scrollViewForm.frame.size.width, scrollViewForm.contentSize.height)];
        
        // scroll to the text view
        [scrollViewForm scrollRectToVisible:activeView.superview.frame animated:YES];
    }
    else{
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
    }
}


-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    //[scrollViewForm setContentSize:CGSizeMake(stackViewForm.frame.size.width, stackViewForm.frame.size.height)];
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    UIScrollView *someScrollView = scrollViewForm;
    
    [someScrollView setContentInset:tableViewInsets];
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
