//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//
NSString* const statePDF = @"PDF";
NSString* const stateIMG = @"IMG";

NSString* const SPAJ = @"SPAJ";
NSString* const Ringkasan = @"page_ringkasan_pembelian";
//NSString* const PemegangPolis = @"PemegangPolis";

// IMPORT
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
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
#import "ModelSPAJHtml.h"
#import "SPAJPDFAutopopulateData.h"
#import "ModelSPAJTransaction.h"
#import "ModelSPAJAnswers.h"
#import "AllAboutPDFFunctions.h"


// DECLARATION

@interface SPAJFormGeneration ()<PDFGenerationDelegate>



@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

// IMPLEMENTATION

@implementation SPAJFormGeneration{
    Formatter* formatter;
    SPAJPDFAutopopulateData* spajPDFData;
    SPAJPDFWebViewController* spajPDFWebView;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelProspectProfile* modelProspectProfile;
    ModelAgentProfile* modelAgentProfile;
    ModelSIPOData* modelSIPOData;
    ModelSPAJAnswers* modelSPAJAnswers;
    Model_SI_Master* modelSIMaster;
    NDHTMLtoPDF *PDFCreator;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    ModelSPAJTransaction *modelSPAJTransaction;
    AllAboutPDFGeneration *allAboutPDFGeneration;
    AllAboutPDFFunctions *allAboutPDFFunctions;
   
    
    SPAJFilesViewController* spajFilesViewController;
    Alert* alert;
    
    UserInterface *objectUserInterface;
    
    NSMutableArray *listArrayFiles;
    
    //for image creation from webview
    NSMutableArray* images;
    UIImage *newImage;
    UIImage *resultImage;
    NSData *thumbnailData;
    
    BOOL boolSPAJPDF;
    BOOL boolTenagaPenjualSigned;
    
    NSMutableArray *arrayPDFHealthQuestionairreName;
    NSMutableArray *arrayPDFHealthQuestionairreTranslateName;
    int indexPDFForIMGGeneration;
    
    NSMutableArray *arrayHTMLName;
    int indexForPDFGeneration;
    
    NSMutableArray *arrayIMGName;
    NSMutableArray *arrayIMGTranslateName;
    int indexImgForPDFGeneration;
    
    NSString* stateGeneration;
    
    BOOL boolConvertToImage;
    
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
    
    NSString* outputName;
}
    @synthesize dictTransaction;
    @synthesize viewActivityIndicator;
    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;
@synthesize labelActivityIncdicator;

    // DID LOAD
    -(void)viewWillAppear:(BOOL)animated{
        [self voidCheckBooleanLastState];
    }

    - (void)viewDidAppear:(BOOL)animated{
        [labelActivityIncdicator setText:@"Loading Data"];
        //[viewActivityIndicator setHidden:NO];
        //[self loadHTMLFile:@"SPAJHtmlName"];
        [self voidCheckBooleanLastState];
        
        
    }

    -(void)viewWillDisappear:(BOOL)animated{
        boolConvertToImage = false;
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webview loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    }

    -(void)viewDidDisappear:(BOOL)animated{
        indexImgForPDFGeneration=0;
        [allAboutPDFGeneration removeSPAJFolder:dictTransaction];
    }

    - (void)viewDidLoad
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        //define the webview coordinate
        //webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1035,728)];
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 960,728)];
        webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //[webview setHidden:YES];
        [super viewDidLoad];
        
        // Do any additional setup after loading the view, typically from a nib.
        for (int i=0; i<[[self.view subviews] count];i++){
            [self.view sendSubviewToBack:webview];
        }
        
        // INITIALIZATION
        boolConvertToImage = false;
        alert = [[Alert alloc]init];
        formatter = [[Formatter alloc]init];
        spajPDFData = [[SPAJPDFAutopopulateData alloc]init];
        modelSPAJHtml = [[ModelSPAJHtml alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        modelAgentProfile = [[ModelAgentProfile alloc]init];
        modelProspectProfile = [[ModelProspectProfile alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelSIMaster = [[Model_SI_Master alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
        allAboutPDFFunctions = [[AllAboutPDFFunctions alloc]init];
        modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
        
        allAboutPDFFunctions.delegatePDFFunctions = self;
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
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP3", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER2", nil);
        
        //_labelStep3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP3", nil);
        _labelStep3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP2", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER3", nil);
        
        [_buttonGenerate setTitle:NSLocalizedString(@"BUTTON_GENERATEFORM", nil) forState:UIControlStateNormal];
        
        dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
        
        boolSPAJPDF = false;
        dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:[dictTransaction valueForKey:@"SPAJSINO"]]];
        dictionarySIMaster = [[NSDictionary alloc]initWithDictionary:[modelSIMaster getIlustrationDataForSI:[dictTransaction valueForKey:@"SPAJSINO"]]];
        
        spajFilesViewController = [[SPAJFilesViewController alloc]initWithNibName:@"SPAJFilesViewController" bundle:nil];
        spajPDFWebView = [[SPAJPDFWebViewController alloc]initWithNibName:@"SPAJPDFWebViewController" bundle:nil];
    }

    -(void)generateAllPDF{
        stateGeneration = statePDF;
        
        indexForPDFGeneration = 0;
        //arrayHTMLName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PDF"]];
        arrayHTMLName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PDF" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        
        if ([arrayHTMLName count]>0){
            @autoreleasepool {
                [self loadSPAJPDFHTML:[arrayHTMLName objectAtIndex:indexForPDFGeneration] WithArrayIndex:indexForPDFGeneration];
            }
        }
    }

    -(void)generateAllIMGPDF{
        [allAboutPDFGeneration removeActivityAndHealthQuestionaireJPGFiles:dictTransaction];
        
        stateGeneration = stateIMG;
        arrayPDFHealthQuestionairreName = [[NSMutableArray alloc]init];
        arrayPDFHealthQuestionairreTranslateName = [[NSMutableArray alloc]init];
        
        indexImgForPDFGeneration = 0;
        if ([[dictionaryPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
            //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
            //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"TP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
            arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"FRG_PH\",\"TP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
            
            arrayIMGTranslateName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlTranslateName" SPAJSection:@"IMG_PH\",\"FRG_PH\",\"TP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        }
        else{
            //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_IN" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
            //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"IMG_IN"]];
            arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"IMG_IN\",\"FRG_PH\",\"FRG_IN\",\"TP"]];
            
            arrayIMGTranslateName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlTranslateName" SPAJSection:@"IMG_PH\",\"IMG_IN\",\"FRG_PH\",\"FRG_IN\",\"TP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        }
        
        //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"IMG_IN"]];
        if ([arrayIMGName count]>0){
            [self loadSPAJPDFHTML:[arrayIMGName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
        }
    }

    -(void)createImageFromPDF{
        if ([arrayPDFHealthQuestionairreName count]>0){
            boolConvertToImage = true;
            
            indexPDFForIMGGeneration = 0;
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]];
                //outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]]];
            
                outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreTranslateName objectAtIndex:indexPDFForIMGGeneration]]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [webview loadRequest:request];
        }
        else{
            [allAboutPDFGeneration removeSPAJSigned:dictTransaction];
            [allAboutPDFGeneration removeUnNecesaryPDFFiles:dictTransaction];
            
            indexImgForPDFGeneration = 0;
            indexPDFForIMGGeneration = 0;
            indexForPDFGeneration = 0;
            
            UIAlertController *alertLockForm = [alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            [viewActivityIndicator setHidden:YES];
        }
    }

    -(void)loadHTMLFile:(NSString *)HTMLName{
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:HTMLName SPAJSection:@"PDF"];
        [self loadSPAJPDFHTML:stringHTMLName];
    }

    -(void)loadSPAJPDFHTML:(NSString*)stringHTMLName{
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        
        NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
        NSString *localURL = [[NSString alloc] initWithString:
                              [docsDir stringByAppendingPathComponent: htmlfilePath]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
        [webview loadRequest:urlRequest];
    }

    -(void)loadSPAJPDFHTML:(NSString*)stringHTMLName WithArrayIndex:(int)intArrayIndex{
        if ([allAboutPDFGeneration doesString:stringHTMLName containCharacter:@"thirdparty"]){
            [webview setFrame:CGRectMake(0, 0, 1035, 728)];
        }
        else{
            [webview setFrame:CGRectMake(0, 0, 960, 728)];
        }
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        
        NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
        NSString *localURL = [[NSString alloc] initWithString:
                              [docsDir stringByAppendingPathComponent: htmlfilePath]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
        [webview loadRequest:urlRequest];
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

    -(void)voidCheckBooleanLastState {
        boolSPAJPDF = [modelSPAJFormGeneration voidCertainFormGenerateCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] FormType:@"SPAJFormGeneration1"];
        boolTenagaPenjualSigned = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty4"];
        [self voidTableCellLastStateChecker:boolSPAJPDF];
    }

    -(void)voidTableCellLastStateChecker:(BOOL)boolPDF{
        if (boolSPAJPDF){
            [_viewStep1 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            [_viewStep1 setUserInteractionEnabled:YES];
            
            [_viewStep3 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            [_viewStep3 setUserInteractionEnabled:YES];
            
            [_viewStep2 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            [_viewStep2 setUserInteractionEnabled:YES];
        }
        else{
            [_viewStep1 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
            [_viewStep1 setUserInteractionEnabled:NO];
            
            [_viewStep3 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
            [_viewStep3 setUserInteractionEnabled:NO];
            
            [_viewStep2 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
            [_viewStep2 setUserInteractionEnabled:NO];
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
        
        [spajPDFWebView setDictTransaction:dictTransaction];
        spajPDFWebView.modalPresentationStyle = UIModalPresentationFormSheet;
        //spajPDFWebView.preferredContentSize = CGSizeMake(950, 768);
        [self presentViewController:spajPDFWebView animated:YES completion:nil];
        //spajPDFWebView.view.superview.frame = CGRectMake(0, 0, 950, 768);
        //pajPDFWebView.view.superview.center = self.view.center;
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        
        [spajFilesViewController setDictTransaction:dictTransaction];
        [spajFilesViewController setBoolThirdParty:YES];
        [spajFilesViewController setBoolHealthQuestionairre:NO];
        spajFilesViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:spajFilesViewController animated:YES completion:nil];
        [spajFilesViewController.buttonSubmit setHidden:YES];
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        // CHANGE PAGE
        
        /*  SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
            [self presentViewController:viewController animated:true completion:nil]; */
        
        //[_delegateSPAJMain voidGoToAddDetail];
        
        [spajFilesViewController setDictTransaction:dictTransaction];
        [spajFilesViewController setBoolHealthQuestionairre:YES];
        [spajFilesViewController setBoolThirdParty:NO];
        spajFilesViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:spajFilesViewController animated:YES completion:nil];
        [spajFilesViewController.buttonSubmit setHidden:YES];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {
        if (!boolTenagaPenjualSigned){
            boolConvertToImage = false;
                listArrayFiles = [[NSMutableArray alloc]initWithArray:[allAboutPDFFunctions createImageSignatureForEapp:dictTransaction]];
                [viewActivityIndicator setHidden:NO];
                 //dispatch_sync(dispatch_get_main_queue(), ^{
//                     [self generateAllPDF];
            
                 //});
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
        
        CGRect printableRect;
        CGRect paperRect;
        
        NSString* htmlFileName = [allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexImgForPDFGeneration]];
        
        if ([htmlFileName length]>0){
            if ([allAboutPDFGeneration doesString:htmlFileName containCharacter:@"thirdparty"]){
                printableRect = CGRectMake(leftPadding,
                                           topPadding,
                                           825,
                                           kPaperSizeA4Portrait.height-topPadding-bottomPadding);
                paperRect = CGRectMake(0, 0, 825, kPaperSizeA4Portrait.height);
            }
            else{
                printableRect = CGRectMake(leftPadding,
                                           topPadding,
                                           kPaperSizeA4Portrait.width-leftPadding-rightPadding,
                                           kPaperSizeA4Portrait.height-topPadding-bottomPadding);
                paperRect = CGRectMake(0, 0, kPaperSizeA4Portrait.width, kPaperSizeA4Portrait.height);
            }
        }
        else{
            printableRect = CGRectMake(leftPadding,
                                       topPadding,
                                       kPaperSizeA4Portrait.width-leftPadding-rightPadding,
                                       kPaperSizeA4Portrait.height-topPadding-bottomPadding);
            paperRect = CGRectMake(0, 0, kPaperSizeA4Portrait.width, kPaperSizeA4Portrait.height);
        }
        
        
        [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
        
        NSData *pdfData = [render printToPDF];
        
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        if (pdfData) {
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJFormGeneration1=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJFormGeneration updateSPAJFormGeneration:stringUpdate];
            [self voidCheckBooleanLastState];
            
            if ([stateGeneration isEqualToString:statePDF]){
                [pdfData writeToFile:[NSString stringWithFormat:@"%@/SPAJ/%@/%@_%i.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],indexForPDFGeneration] atomically:YES];
                indexForPDFGeneration ++;
                if (indexForPDFGeneration < [arrayHTMLName count]){
                    [self loadSPAJPDFHTML:[arrayHTMLName objectAtIndex:indexForPDFGeneration] WithArrayIndex:indexForPDFGeneration];
                }
                else{
                    @autoreleasepool {
                        [self joinSPAJPDF];
                    }
                    
                }
            }
            else{
                NSString* fileName = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_%@.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexImgForPDFGeneration]]];
                
                NSString* fileNameTranslate = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_%@.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGTranslateName objectAtIndex:indexImgForPDFGeneration]]];
                
                [pdfData writeToFile:fileName atomically:YES];
                [arrayPDFHealthQuestionairreName addObject:fileName];
                
                //[pdfData writeToFile:fileName atomically:YES];
                [arrayPDFHealthQuestionairreTranslateName addObject:fileNameTranslate];
                
                indexImgForPDFGeneration ++;
                if (indexImgForPDFGeneration < [arrayIMGName count]){
                    [self loadSPAJPDFHTML:[arrayIMGName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
                    
                    //[self loadSPAJPDFHTML:[arrayIMGTranslateName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
                }
                else{
                    [self createImageFromPDF];
                }
            }
        }
        else
        {
            NSLog(@"PDF couldnot be created");
        }
    }

    -(void)joinSPAJPDF{
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        
        NSMutableArray *arrayPDFPath = [[NSMutableArray alloc]init];
        NSMutableArray *arrayPDFURLRef = [[NSMutableArray alloc]init];
        NSMutableArray *arrayPDFDocumentRef = [[NSMutableArray alloc]init];
        NSMutableArray *arrayNumberOfPageFile = [[NSMutableArray alloc]init];
        
        for (int i=0;i<[arrayHTMLName count];i++){
            NSString* filePDFPath =[NSString stringWithFormat:@"%@/SPAJ/%@/%@_%i.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],i];
            [arrayPDFPath addObject:filePDFPath];
        }
        
        for (int i=0;i<[arrayPDFPath count];i++){
            CFURLRef pdfURLFilePath = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)[arrayPDFPath objectAtIndex:i]];
            [arrayPDFURLRef addObject:(__bridge id _Nonnull)(pdfURLFilePath)];
        }
        
        for (int i=0;i<[arrayPDFURLRef count];i++){
            CGPDFDocumentRef pdfRefFilePath = CGPDFDocumentCreateWithURL((CFURLRef)[arrayPDFURLRef objectAtIndex:i]);
            [arrayPDFDocumentRef addObject:(__bridge id _Nonnull)(pdfRefFilePath)];
        }
        
        for (int i=0;i<[arrayPDFDocumentRef count];i++){
            NSInteger numberOfPagesFilePath = CGPDFDocumentGetNumberOfPages((__bridge CGPDFDocumentRef)([arrayPDFDocumentRef objectAtIndex:i]));
            [arrayNumberOfPageFile addObject:[NSNumber numberWithInteger:numberOfPagesFilePath]];
        }
        
        NSString* filePathSPAJ = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathOutput = filePathSPAJ;
        CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
        // Create the output context
        CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        for (int i=0;i<[arrayHTMLName count];i++){
            for (int j=1; j<=[(NSNumber *)[arrayNumberOfPageFile objectAtIndex:i] integerValue]; j++) {
                page = CGPDFDocumentGetPage((__bridge CGPDFDocumentRef)([arrayPDFDocumentRef objectAtIndex:i]), j);
                mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
                CGContextBeginPage(writeContext, &mediaBox);
                CGContextDrawPDFPage(writeContext, page);
                CGContextEndPage(writeContext);
            }
        }
        CGPDFContextClose(writeContext);
        CFRelease(pdfURLOutput);
        CGContextRelease(writeContext);
        
        if ([stateGeneration isEqualToString:statePDF]){
            [self generateAllIMGPDF];
        }
        else{
            /*UIAlertController *alertLockForm = [alert alertInformation:@"Berhasil" stringMessage:@"File SPAJ.pdf berhasil dibuat"];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            [viewActivityIndicator setHidden:YES];*/
        }
    }

    -(void)voidCreateImageFromWebView:(NSString *)fileName{
        //[self.view bringSubviewToFront:webview];
        
        int currentWebViewHeight = webview.scrollView.contentSize.height;
        int scrollByY = webview.frame.size.height;
        
        [webview.scrollView setContentOffset:CGPointMake(0, 0)];
        
        images = [[NSMutableArray alloc] init];
        
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
            
            newImage = UIGraphicsGetImageFromCurrentImageContext();
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
        
        //resultImage;
        
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
        
        thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
        BOOL written = [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
        
        if (!written){
            UIAlertController *alertFailedGenerate = [UIAlertController alertControllerWithTitle:@"Kesalahan Generate File" message:@"Terjadi kegagalan dalam pembuatan file. Aplikasi akan menutup menu SPAJ. Silahkan melakukan generate ulang " preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* alertActionClose = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"GOTOHOME" object:self];
                exit(0);
            }];
            
            [alertFailedGenerate addAction: alertActionClose];
            
            [self presentViewController:alertFailedGenerate animated:YES completion:nil];
        }
        
        thumbnailData = nil;
        resultImage = nil;
        images = nil;
        
        indexPDFForIMGGeneration++;
        if (indexPDFForIMGGeneration<[arrayPDFHealthQuestionairreName count]){
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]];
            //outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexPDFForIMGGeneration]]];
            
            //outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]]];
            outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreTranslateName objectAtIndex:indexPDFForIMGGeneration]]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [webview loadRequest:request];
        }
        else{
            [allAboutPDFGeneration removeSPAJSigned:dictTransaction];
            [allAboutPDFGeneration removeUnNecesaryPDFFiles:dictTransaction];
            
            indexImgForPDFGeneration = 0;
            indexPDFForIMGGeneration = 0;
            indexForPDFGeneration = 0;
            
            UIAlertController *alertLockForm = [alert alertInformation:@"Berhasil" stringMessage:@"Form berhasil dibuat"];
            [self presentViewController:alertLockForm animated:YES completion:nil];
            [viewActivityIndicator setHidden:YES];
        }
    }

    - (IBAction)actionGoToStep5:(id)sender
    {

    };

    - (IBAction)actionGoToStep6:(id)sender
    {
        [_delegateSPAJMain voidGoToAddSignature];
    };

    #pragma mark delegate
    -(void)allSignatureCreated{
        [self generateAllPDF];
    }

    #pragma mark create additional dictionary

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


    - (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
        if (stateGeneration == stateIMG){
            NSString* htmlFileName = [allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexImgForPDFGeneration]];
            
            NSString *stringName = [allAboutPDFGeneration getWordFromString:htmlFileName IndexWord:2];
            int countElement;
            
            if (([allAboutPDFGeneration doesString:htmlFileName containCharacter:@"_IN"])||(([allAboutPDFGeneration doesString:htmlFileName containCharacter:@"tertanggung"]))){
                if ([allAboutPDFGeneration doesString:stringName containCharacter:@"gland"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"thyroid" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_IN"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"respiratory"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"respiratorydetail" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_IN"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"digestion"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"digestdetail" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_IN"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"oilgas"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"mining" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_IN"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"foreigner"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"Foreigner" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TR"];
                }
                else{
                    countElement = [modelSPAJAnswers getCountElementID:stringName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_IN"];
                }
            }
            else if (([allAboutPDFGeneration doesString:htmlFileName containCharacter:@"thirdparty"])||([allAboutPDFGeneration doesString:htmlFileName containCharacter:@"pihakketiga"])){
                countElement = [modelSPAJAnswers getCountElementID:stringName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"TP"];
            }
            else{
                if ([allAboutPDFGeneration doesString:stringName containCharacter:@"gland"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"thyroid" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_PH"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"respiratory"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"respiratorydetail" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_PH"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"digestion"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"digestdetail" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_PH"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"oilgas"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"mining" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_PH"];
                }
                else if ([allAboutPDFGeneration doesString:stringName containCharacter:@"foreigner"]){
                    countElement = [modelSPAJAnswers getCountElementID:@"Foreigner" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"PO"];
                }
                else{
                    countElement = [modelSPAJAnswers getCountElementID:stringName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue] Section:@"KS_PH"];
                }
            }
            
            NSLog(@"count %@ %i",stringName,countElement);
            
            if (countElement >0){
                @autoreleasepool {
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
                    
                    [dictOriginal setObject:modifieArray forKey:@"readFromDB"];
                    //return [super readfromDB:finalDictionary];
                    [self callSuccessCallback:[params valueForKey:@"successCallBack"] withRetValue:dictOriginal];
                    //  [viewActivityIndicator setHidden:YES];
                    
                    [self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:1.0];
                    
                    //[self voidCreateThePDF];
                    return dictOriginal;
                }
            }
            else{
                indexImgForPDFGeneration ++;
                if (indexImgForPDFGeneration < [arrayIMGName count]){
                    [self loadSPAJPDFHTML:[arrayIMGName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
                }
                else{
                    [self createImageFromPDF];
                }
                return params;
            }
            //if ([arrayIMGName objectAtIndex:indexImgForPDFGeneration])
        }
        else{
            @autoreleasepool {
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
                
                [dictOriginal setObject:modifieArray forKey:@"readFromDB"];
                //return [super readfromDB:finalDictionary];
                [self callSuccessCallback:[params valueForKey:@"successCallBack"] withRetValue:dictOriginal];
                //  [viewActivityIndicator setHidden:YES];
                
                [self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:1.0];
                
                //[self voidCreateThePDF];
                return dictOriginal;
            }
        }
    }

    -(void)performReadFromDB{
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
    }

    - (void)webViewDidFinishLoad:(UIWebView *)webView{
        
        if (boolConvertToImage){
            @autoreleasepool {
                [self performSelector:@selector(voidCreateImageFromWebView:) withObject:outputName afterDelay:0.3];
            }
        }
        else{
            if (stateGeneration == stateIMG){

                if ([[arrayIMGName objectAtIndex:indexImgForPDFGeneration]rangeOfString:@"amandment"].location != NSNotFound){
                    NSString *functionCall = [NSString stringWithFormat:@"setSignatureImage([%@])", [listArrayFiles componentsJoinedByString:@","]];
                    [webview stringByEvaluatingJavaScriptFromString:functionCall];
                    [self performSelector:@selector(performReadFromDB) withObject:nil afterDelay:0.5];
                }
                else if ([[arrayIMGName objectAtIndex:indexImgForPDFGeneration]rangeOfString:@"foreigner"].location != NSNotFound){
                    NSString *functionCall = [NSString stringWithFormat:@"setSignatureImage([%@])", [listArrayFiles componentsJoinedByString:@","]];
                    [webview stringByEvaluatingJavaScriptFromString:functionCall];
                    [self performSelector:@selector(performReadFromDB) withObject:nil afterDelay:0.5];
                }
                else{
                    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
                }
            }
            else{
                [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
            }
            
        }
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        NSLog(@"warning memory");
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    
@end