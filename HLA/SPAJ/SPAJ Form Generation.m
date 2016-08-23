//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT
#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeA4Portrait CGSizeMake(750,1300)

#import "SPAJ Form Generation.h"
#import "String.h"
#import "SPAJ Main.h"
#import "Formatter.h"
#import "SPAJPDFWebViewController.h"
#import "ModelSPAJFormGeneration.h"
#import "User Interface.h"
#import "NDHTMLtoPDF.h"
#import "ModelSPAJSignature.h"
#import "Alert.h"
#import "ModelAgentProfile.h"
#import "ModelProspectProfile.h"
#import "ModelSIPOData.h"
#import "Model_SI_Master.h"
// DECLARATION

@interface SPAJFormGeneration ()



@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

// IMPLEMENTATION

@implementation SPAJFormGeneration{
    Formatter* formatter;
    SPAJPDFWebViewController* spajPDFWebView;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelProspectProfile* modelProspectProfile;
    ModelAgentProfile* modelAgentProfile;
    ModelSIPOData* modelSIPOData;
    Model_SI_Master* modelSIMaster;
    NDHTMLtoPDF *PDFCreator;
    ModelSPAJSignature* modelSPAJSignature;
    Alert* alert;
    
    UserInterface *objectUserInterface;
    BOOL boolSPAJPDF;
    BOOL boolTenagaPenjualSigned;
    
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
    @synthesize dictTransaction;
    @synthesize viewActivityIndicator;
    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;


    // DID LOAD
    - (void)viewDidAppear:(BOOL)animated{
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"page_spaj_pdf" ofType:@"html" inDirectory:@"Build/Page/HTML"]];
        //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"20160803113501" ofType:@"html" inDirectory:@"Build/Page/HTML"]];
        [webview loadRequest:[NSURLRequest requestWithURL:url]];
    }

    - (void)viewDidLoad
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        //define the webview coordinate
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 960,728)];
        webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [webview setHidden:YES];
        
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // INITIALIZATION
        alert = [[Alert alloc]init];
        formatter = [[Formatter alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        modelAgentProfile = [[ModelAgentProfile alloc]init];
        modelProspectProfile = [[ModelProspectProfile alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelSIMaster = [[Model_SI_Master alloc]init];

        [self setNavigationBar];
        
        
        [self arrayInitializeReferral];
        [self arrayInitializeAgentProfile];
        [self arrayInitializePOData];
        [self arrayInitializeSIMaster];
        [self arrayInitializeSignature];
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_FORMGENERATION", nil);
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER2", nil);
        
        //_labelStep3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP3", nil);
        _labelStep3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP2", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER3", nil);
        
        [_buttonGenerate setTitle:NSLocalizedString(@"BUTTON_GENERATEFORM", nil) forState:UIControlStateNormal];
        
        dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
        
        boolSPAJPDF = false;
        dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:[dictTransaction valueForKey:@"SPAJSINO"]]];
        dictionarySIMaster = [[NSDictionary alloc]initWithDictionary:[modelSIMaster getIlustrationDataForSI:[dictTransaction valueForKey:@"SPAJSINO"]]];
        [self voidCheckBooleanLastState];
    }

    #pragma mark arrayInitialization
    -(void)arrayInitializeAgentProfile{
        arrayDBAgentID =[[NSMutableArray alloc]init];
        [arrayDBAgentID addObject:@"AgentName"];
        [arrayDBAgentID addObject:@"AgentCode"];
        [arrayDBAgentID addObject:@""];
        [arrayDBAgentID addObject:@"AgentName"];
        [arrayDBAgentID addObject:@"AgentCode"];
        
        arrayHTMLAgentID =[[NSMutableArray alloc]init];
        [arrayHTMLAgentID addObject:@"TextAgentName"];
        [arrayHTMLAgentID addObject:@"TextAgentCode"];
        [arrayHTMLAgentID addObject:@"TextLicenseNumber"];
        [arrayHTMLAgentID addObject:@"BoxIllustrationAgentName"];
        [arrayHTMLAgentID addObject:@"BoxIllustrationAgentCode"];
    }

    -(void)arrayInitializeReferral{
        arrayDBReferral =[[NSMutableArray alloc]init];
        [arrayDBReferral addObject:@"ReferralName"];
        [arrayDBReferral addObject:@"BranchName"];
        [arrayDBReferral addObject:@"BranchCode"];
        [arrayDBReferral addObject:@"Kanwil"];
        [arrayDBReferral addObject:@"NIP"];
        
        arrayHTMLReferal =[[NSMutableArray alloc]init];
        [arrayHTMLReferal addObject:@"TextReferenceName"];
        [arrayHTMLReferal addObject:@"TextBranchName"];
        [arrayHTMLReferal addObject:@"TextBranchCode"];
        [arrayHTMLReferal addObject:@"TextArea"];
        [arrayHTMLReferal addObject:@"TextAgentID"];
    }

    -(void)arrayInitializePOData{
        arrayDBPOData =[[NSMutableArray alloc]init];
        [arrayDBPOData addObject:@"ProductName"];
        [arrayDBPOData addObject:@"ProductCode"];
        
        arrayHTMLPOData =[[NSMutableArray alloc]init];
        [arrayHTMLPOData addObject:@"TextProductName"];
        [arrayHTMLPOData addObject:@"TextProductCode"];
    }


    -(void)arrayInitializeSIMaster{ //premnath Vijaykumar
         arrayDBSIData=[[NSMutableArray alloc]init];
        [arrayDBSIData addObject:@"SINO"];
        [arrayDBSIData addObject:@"CreatedDate"];
        arrayHTMLSIData =[[NSMutableArray alloc]init];
        [arrayHTMLSIData addObject:@"TextIllustrationNumber"];
        [arrayHTMLSIData addObject:@"BoxIllustrationDateDay"];
    }

    -(void)arrayInitializeSignature{ //premnath Vijaykumar
        arrayDBSignature=[[NSMutableArray alloc]init];
        [arrayDBSignature addObject:@"SPAJSignatureLocation"];
        [arrayDBSignature addObject:@"SPAJDateSignatureParty4"];
        arrayHTMLSignature =[[NSMutableArray alloc]init];
        [arrayHTMLSignature addObject:@"LineSignedPlace"];
        [arrayHTMLSignature addObject:@"LineSignedDateDay"];
    }






    -(void)voidCheckBooleanLastState {
        boolSPAJPDF = [modelSPAJFormGeneration voidCertainFormGenerateCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] FormType:@"SPAJFormGeneration1"];
        boolTenagaPenjualSigned = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty4"];
        [self voidTableCellLastStateChecker:boolSPAJPDF];
    }

    -(void)voidTableCellLastStateChecker:(BOOL)boolPDF{
        if (boolSPAJPDF){
            [_viewStep1 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            [_viewStep1 setUserInteractionEnabled:YES];
        }
        else{
            [_viewStep1 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
            [_viewStep1 setUserInteractionEnabled:NO];
        }
    }


    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"eApplication Forms Generation"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    // ACTION

    - (IBAction)actionGoToStep1:(id)sender
    {
        spajPDFWebView = [[SPAJPDFWebViewController alloc]initWithNibName:@"SPAJPDFWebViewController" bundle:nil];
        [spajPDFWebView setDictTransaction:dictTransaction];
        spajPDFWebView.modalPresentationStyle = UIModalPresentationFormSheet;
        //spajPDFWebView.preferredContentSize = CGSizeMake(950, 768);
        [self presentViewController:spajPDFWebView animated:YES completion:nil];
        //spajPDFWebView.view.superview.frame = CGRectMake(0, 0, 950, 768);
        //pajPDFWebView.view.superview.center = self.view.center;
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        // CHANGE PAGE
        
        /*  SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
            [self presentViewController:viewController animated:true completion:nil]; */
        
        [_delegateSPAJMain voidGoToAddDetail];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {
        if (!boolTenagaPenjualSigned){
            [viewActivityIndicator setHidden:NO];
            [self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:2.0];
        }
        else{
            UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_LOCK", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_LOCK", nil)];
            [self presentViewController:alertLockForm animated:YES completion:nil];
        }

    };

    -(void)voidCreateThePDF{
        UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
        [render addPrintFormatter:webview.viewPrintFormatter startingAtPageAtIndex:0];
        //increase these values according to your requirement
        float topPadding = 0.0f;
        float bottomPadding = 0.0f;
        float leftPadding = 0.0f;
        float rightPadding = 0.0f;
        NSLog(@"size %@",NSStringFromCGSize(kPaperSizeA4Portrait));
        CGRect printableRect = CGRectMake(leftPadding,
                                          topPadding,
                                          kPaperSizeA4Portrait.width-leftPadding-rightPadding,
                                          kPaperSizeA4Portrait.height-topPadding-bottomPadding);
        CGRect paperRect = CGRectMake(0, 0, kPaperSizeA4Portrait.width, kPaperSizeA4Portrait.height);
        [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
        
        NSData *pdfData = [render printToPDF];
        
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        if (pdfData) {
            [pdfData writeToFile:[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]] atomically:YES];
            //NSLog(@"datat %@",[NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"PO_Name"],[_dictionaryPOForInsert valueForKey:@"SINO"]]);
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJFormGeneration1=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJFormGeneration updateSPAJFormGeneration:stringUpdate];
            
            
            UIAlertController *alertLockForm = [alert alertInformation:@"Berhasil" stringMessage:@"File SPAJ.pdf berhasil dibuat"];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            [viewActivityIndicator setHidden:YES];
            
            [self voidCheckBooleanLastState];
        }
        else
        {
            NSLog(@"PDF couldnot be created");
        }

    }

    - (IBAction)actionGoToStep5:(id)sender
    {

    };

    - (IBAction)actionGoToStep6:(id)sender
    {
        [_delegateSPAJMain voidGoToAddSignature];
    };

    #pragma mark create additional dictionary

    -(NSDictionary *)getDictionaryForAgentData:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
    
        NSMutableDictionary* dictAgentData=[[NSMutableDictionary alloc]init];
        [dictAgentData setObject:stringHTMLID forKey:@"elementID"];
        [dictAgentData setObject:[dictAgentProfile valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
        [dictAgentData setObject:@"1" forKey:@"CustomerID"];
        [dictAgentData setObject:@"1" forKey:@"SPAJID"];
        return dictAgentData;
    }

    -(NSDictionary *)getDictionaryForReferralData:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
        NSMutableDictionary* dictReferralData=[[NSMutableDictionary alloc]init];
        [dictReferralData setObject:stringHTMLID forKey:@"elementID"];
        [dictReferralData setObject:[modelProspectProfile selectProspectData:stringDBColumnName ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]]?:@"" forKey:@"Value"];
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
        [dictSIMaster setObject:[dictionarySIMaster valueForKey:stringDBColumnName]?:@"" forKey:@"Value"];
        [dictSIMaster setObject:@"1" forKey:@"CustomerID"];
        [dictSIMaster setObject:@"1" forKey:@"SPAJID"];
        return dictSIMaster;
    }


    -(NSDictionary *)getDictionaryForSignature:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
        NSMutableDictionary* dictForSignature=[[NSMutableDictionary alloc]init];
        [dictForSignature setObject:stringHTMLID forKey:@"elementID"];
        [dictForSignature setObject:[modelSPAJSignature selectSPAJSignatureData:stringDBColumnName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"" forKey:@"Value"];
        [dictForSignature setObject:@"1" forKey:@"CustomerID"];
        [dictForSignature setObject:@"1" forKey:@"SPAJID"];
        return dictForSignature;
    }


    -(NSDictionary *)getDictionaryForIllustrationData{
        NSMutableDictionary* dictIllustration=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
        NSMutableDictionary* dictIllustrationData=[[NSMutableDictionary alloc]init];
        [dictIllustrationData setObject:[dictIllustration valueForKey:@""] forKey:@""];
        return dictIllustrationData;
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
        
        NSMutableDictionary *dictOriginal = [[NSMutableDictionary alloc]initWithDictionary:[super readfromDB:finalDictionary]];
        
        NSMutableArray *modifieArray = [[NSMutableArray alloc]initWithArray:[dictOriginal valueForKey:@"readFromDB"]];
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

        [dictOriginal setObject:modifieArray forKey:@"readFromDB"];
        //return [super readfromDB:finalDictionary];
        [self callSuccessCallback:[params valueForKey:@"successCallBack"] withRetValue:dictOriginal];
        return dictOriginal;
    }

    - (void)webViewDidFinishLoad:(UIWebView *)webView{
       //[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('read').click()"]];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end