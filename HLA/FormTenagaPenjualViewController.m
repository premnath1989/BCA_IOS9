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
#import "SPAJPDFAutopopulateData.h"
#import "ModelSPAJTransaction.h"
#import "AllAboutPDFGeneration.h"
#import "Alert.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface FormTenagaPenjualViewController (){
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

@implementation FormTenagaPenjualViewController
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
    
    [collectionReasonInsurancePurchase registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
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
    
    [self intializeArrayInsuranceReason];
    
    [self arrayInitializeReferral];
    [self arrayInitializeAgentProfile];
    [self arrayInitializePOData];
    [self arrayInitializeSIMaster];
    [self arrayInitializeSignature];
    
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
    [self loadTenagaPenjualPDFHTML:imageFileName WithArrayIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)intializeArrayInsuranceReason{
    arrayCollectionInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Tabungan",@"Proteksi",@"Investasi",@"Pendidikan",@"Lainnya", nil];
    arrayCollectionSelectedInsurancePurchaseReason = [[NSMutableArray alloc]initWithObjects:@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",@"Not Checked",nil];
}

-(IBAction)actionCloseForm:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionButtonInsuranceReasonTapped:(ButtonSPAJ *)sender{
    
    for (int i=0;i<[arrayCollectionSelectedInsurancePurchaseReason count];i++){
        if ([[arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:i] isEqualToString:@"Not Checked"]){
            [arrayCollectionSelectedInsurancePurchaseReason removeObjectAtIndex:i];
        }
    }
    
    if ([sender isSelected]){
        [sender setSelected:NO];
        int indexToClear = [arrayCollectionSelectedInsurancePurchaseReason indexOfObject:sender.currentTitle];
        [arrayCollectionSelectedInsurancePurchaseReason removeObjectAtIndex:indexToClear];
    }
    else{
        [arrayCollectionSelectedInsurancePurchaseReason addObject:sender.currentTitle];
        [sender setSelected:YES];
    }
    
    for (int i=0;i<[arrayCollectionInsurancePurchaseReason count];i++){
        if (i >= [arrayCollectionSelectedInsurancePurchaseReason count]){
            [arrayCollectionSelectedInsurancePurchaseReason addObject:@"Not Checked"];
        }
    }
    
    
    NSLog(@"array value %@",arrayCollectionSelectedInsurancePurchaseReason);
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
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF"];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextFieldSPAJ class]]) {
                    TextFieldSPAJ* textTemp = (TextFieldSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextFieldName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF"];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
                
                if ([viewDetail isKindOfClass:[TextViewSPAJ class]]) {
                    TextViewSPAJ* textTemp = (TextViewSPAJ *)viewDetail;
                    NSString *value = textTemp.text;
                    NSString *elementID = [textTemp getTextViewName];
                    
                    NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF"];
                    
                    [arrayFormAnswers addObject:dictAnswer];
                    i++;
                }
            }
        }
    }
    
    for (int x=0;x<[arrayCollectionSelectedInsurancePurchaseReason count];x++){
        //NSString *value = [arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x];
        NSString *value = [allAboutPDFFunctions GetOutputForInsurancePurposeCheckBox:[arrayCollectionSelectedInsurancePurchaseReason objectAtIndex:x]];
        NSString *elementID = buttonInsurancePurpose;
        
        NSMutableDictionary *dictAnswer = [allAboutPDFFunctions dictAnswers:dictTransaction ElementID:elementID Value:value Section:@"AF"];
        
        [arrayFormAnswers addObject:dictAnswer];
    }
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
