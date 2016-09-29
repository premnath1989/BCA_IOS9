//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//

NSString* const statePDFGeneration = @"PDF";
NSString* const stateIMGGeneration = @"IMG";

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
// IMPORT
#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeA4Portrait CGSizeMake(750,1250)

#import <objc/runtime.h>

#import "NDHTMLtoPDF.h"
#import "SPAJ Add Menu.h"
#import "SPAJ Add Detail.h"
#import "String.h"
#import "SPAJ Main.h"
#import "CFFAPIController.h"
#import "SIListingPopOver.h"
#import "ModelSIPOData.h"
#import "ModelSPAJTransaction.h"
#import "SPAJ Add Detail.h"
#import "SPAJ Capture Identification.h"
#import "SPAJ Add Signature.h"
#import "SPAJ Form Generation.h"
#import "ModelSPAJSignature.h"
#import "ModelSPAJIDCapture.h"
#import "ModelSPAJDetail.h"
#import "ModelSPAJFormGeneration.h"
#import "ModelSPAJHtml.h"
#import "ModelSPAJAnswers.h"
#import "Formatter.h"
#import "Layout.h"
#import "User Interface.h"
#import "LoginDBManagement.h"
#import "SPAJPDFAutopopulateData.h"
#import "Model_SI_Master.h"
#import "ModelProspectProfile.h"
#import "Alert.h"
#import "ModelAgentProfile.h"
#import "ClassImageProcessing.h"
#import "AllAboutPDFGeneration.h"
// DECLARATION

@interface SPAJAddMenu ()<PDFGenerationDelegate,SIListingDelegate,UIPopoverPresentationControllerDelegate>



@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end


// IMPLEMENTATION

@implementation SPAJAddMenu {
    NDHTMLtoPDF *PDFCreator;
    SIListingPopOver *siListingPopOver;
    SPAJPDFAutopopulateData* spajPDFData;
    ModelSIPOData *modelSIPOData;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJSignature *modelSPAJSignature;
    ModelSPAJIDCapture *modelSPAJIDCapture;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelSPAJDetail* modelSPAJDetail;
    ModelSPAJHtml *modelSPAJHtml;
    ModelSPAJAnswers *modelSPAJAnswers;
    Model_SI_Master* modelSIMaster;
    ModelProspectProfile* modelProspectProfile;
    ModelAgentProfile* modelAgentProfile;
    Formatter* formatter;
    ClassImageProcessing *classImageProcessing;
    AllAboutPDFGeneration *allAboutPDFGeneration;
    
    SPAJFormGeneration* viewControllerFormGeneration;
    
    UserInterface *objectUserInterface;
    
    NSMutableArray *arrayPDFHealthQuestionairreName;
    int indexPDFForIMGGeneration;
    
    NSMutableArray *arrayHTMLName;
    int indexForPDFGeneration;
    
    NSMutableArray *arrayIMGName;
    int indexImgForPDFGeneration;
    
    NSString* stateGeneration;
    NSString* outputName;
    
    BOOL boolConvertToImage;
    
    NSDictionary* dictionaryPOData;
    NSString *stringSINO;
    
    Alert* alert;
    
    NSMutableDictionary* dictAgentProfile;
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

    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;
    @synthesize stringEAPPNumber;
    @synthesize dictTransaction;
    @synthesize viewActivityIndicator;

    // DID LOAD
    -(void)viewWillAppear:(BOOL)animated{
        [self voidLoadSIInformation];
        [self voidCheckListCompletion];
        [self voidGetFooterInformation];
    }

    -(void)viewDidAppear:(BOOL)animated{
        
        [self renameSPAJPDF];
    }

    - (void)viewDidLoad
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString:
                        [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        //define the webview coordinate
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 960,728)];
        webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //[webview setHidden:YES];
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // DATE
        boolConvertToImage = false;
        modelProspectProfile = [[ModelProspectProfile alloc]init];
        modelSIMaster = [[Model_SI_Master alloc]init];
        spajPDFData = [[SPAJPDFAutopopulateData alloc]init];
        modelSPAJHtml = [[ModelSPAJHtml alloc]init];
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        modelSPAJDetail = [[ModelSPAJDetail alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        modelAgentProfile = [[ModelAgentProfile alloc]init];
        modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
        classImageProcessing = [[ClassImageProcessing alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
        
        allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
        allAboutPDFGeneration.delegatePDFGeneration = self;
        
        formatter = [[Formatter alloc]init];
        alert = [[Alert alloc]init];
        
        [self setNavigationBar];
        
        viewControllerFormGeneration = [[SPAJFormGeneration alloc] initWithNibName:@"SPAJ Form Generation" bundle:nil];
        
        NSLocale* currentLocale = [NSLocale currentLocale];
        [[NSDate date] descriptionWithLocale:currentLocale];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        NSString* dateCurrent = [dateFormatter stringFromDate:[NSDate date]];
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJEXISTINGLIST", nil);
        _labelMenuHint.text = NSLocalizedString(@"NOTE_GUIDEMENU", nil).uppercaseString;
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER1", nil);
        _labelDetail1.text = NSLocalizedString(@"GUIDE_SPAJMENU_DETAIL1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER2", nil);
        _labelDetail2.text = NSLocalizedString(@"GUIDE_SPAJMENU_DETAIL2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER3", nil);
        
        _labelStep4.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP4", nil);
        _labelHeader4.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER4", nil);
        
        _labelStep5.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP5", nil);
        _labelHeader5.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER5", nil);
        
        _labelStep6.text = NSLocalizedString(@"GUIDE_SPAJMENU_STEP6", nil);
        _labelHeader6.text = NSLocalizedString(@"GUIDE_SPAJMENU_HEADER6", nil);
        
        [_buttonConfirmSPAJ setTitle:NSLocalizedString(@"BUTTON_CONFIRMSPAJ", nil) forState:UIControlStateNormal];
        
        _labelTitleImportantInformation.text = NSLocalizedString(@"TITLE_IMPORTANTINFORMATION", nil);
        _labelFieldCustomerSignature.text = NSLocalizedString(@"FIELD_CUSTOMERSIGNATURE", nil);
        _labelFieldDateTime.text = NSLocalizedString(@"FIELD_DATETIME", nil);
        _labelFieldExpiredDate.text = NSLocalizedString(@"FIELD_SPAJEXPIRED", nil);
        _labelFieldLastUpdate.text = NSLocalizedString(@"FIELD_SPAJLASTUPDATED", nil);
        _labelFieldTimeRemaining.text = NSLocalizedString(@"FIELD_TIMEREMAINING", nil);
        _labelPropertyCustomerSignature.text = [CHARACTER_DOUBLEDOT stringByAppendingString:NSLocalizedString(@"STATE_CAPTURED", nil)];
        _labelPropertyDateTime.text = [CHARACTER_DOUBLEDOT stringByAppendingString:dateCurrent];
        _labelPropertyExpiredDate.text = [CHARACTER_DOUBLEDOT stringByAppendingString:dateCurrent];
        _labelPropertyLastUpdate.text = [CHARACTER_DOUBLEDOT stringByAppendingString:dateCurrent];
        _labelPropertyTimeRemining.text = [CHARACTER_DOUBLEDOT stringByAppendingString:dateCurrent];
        
        dictAgentProfile=[[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
        dictionarySIMaster = [[NSDictionary alloc]initWithDictionary:[modelSIMaster getIlustrationDataForSI:[dictTransaction valueForKey:@"SPAJSINO"]]];
        
        [self arrayInitializeReferral];
        [self arrayInitializeAgentProfile];
        [self arrayInitializePOData];
        [self arrayInitializeSIMaster];
        [self arrayInitializeSignature];
        
        [super viewDidLoad];
        
        for (int i=0; i<[[self.view subviews] count];i++){
            [self.view sendSubviewToBack:webview];
        }
    }


    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"eApplication Checklist"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    -(void)voidCheckListCompletion{
        NSString* stringRelation = [dictionaryPOData valueForKey:@"RelWithLA"];
        int laAge = [[dictionaryPOData valueForKey:@"LA_Age"] intValue];
        
        bool signatureCaptured  = [modelSPAJSignature voidSignatureCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] Relationship:stringRelation LAAge:laAge];
        bool idCaptured = [modelSPAJIDCapture voidIDCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] Relationship:stringRelation LAAge:laAge];
        bool detailCapture = [modelSPAJDetail voidDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        bool formGeneration = [modelSPAJFormGeneration voidFormGenerated:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        
        if (signatureCaptured){
            [_viewStep6 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            [_viewStep6 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
        }

        if (idCaptured){
            [_viewStep5 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            [_viewStep5 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
        }

        if (formGeneration){
            [_viewStep4 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            [_viewStep4 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
        }

        if (detailCapture){
            [_viewStep3 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            [_viewStep3 setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0]];
        }
        
        if ((detailCapture)&&(formGeneration)&&(idCaptured)&&(signatureCaptured)){
            [_buttonConfirmSPAJ setEnabled:YES];
        }
        else{
            [_buttonConfirmSPAJ setEnabled:NO];
        }
        [self checkViewEnabled:detailCapture BOOLForm:formGeneration BOOLIDCaptured:idCaptured BOOLSignature:signatureCaptured];
    }

    -(void)checkViewEnabled:(bool)boolDetail BOOLForm:(bool)boolForm BOOLIDCaptured:(bool)boolIDCaptured BOOLSignature:(bool)boolSignature{
        [_viewStep3 setUserInteractionEnabled:false];
        [_viewStep4 setUserInteractionEnabled:false];
        [_viewStep5 setUserInteractionEnabled:false];
        [_viewStep6 setUserInteractionEnabled:false];
        if (boolDetail){
            if (boolForm){
                if (boolIDCaptured){
                    if (boolSignature){
                        [_viewStep3 setUserInteractionEnabled:true];
                        [_viewStep4 setUserInteractionEnabled:true];
                        [_viewStep5 setUserInteractionEnabled:true];
                        [_viewStep6 setUserInteractionEnabled:true];
                    }
                    else{
                        [_viewStep3 setUserInteractionEnabled:true];
                        [_viewStep4 setUserInteractionEnabled:true];
                        [_viewStep5 setUserInteractionEnabled:true];
                        [_viewStep6 setUserInteractionEnabled:true];
                    }
                }
                else{
                    [_viewStep3 setUserInteractionEnabled:true];
                    [_viewStep4 setUserInteractionEnabled:true];
                    [_viewStep5 setUserInteractionEnabled:true];
                    [_viewStep6 setUserInteractionEnabled:false];
                }
            }
            else{
                [_viewStep3 setUserInteractionEnabled:true];
                [_viewStep4 setUserInteractionEnabled:true];
                [_viewStep5 setUserInteractionEnabled:false];
                [_viewStep6 setUserInteractionEnabled:false];
            }

        }
        else{
            [_viewStep3 setUserInteractionEnabled:true];
            [_viewStep4 setUserInteractionEnabled:false];
            [_viewStep5 setUserInteractionEnabled:false];
            [_viewStep6 setUserInteractionEnabled:false];
        }
    }

    -(void)voidGetFooterInformation{
        NSDictionary* dictFooter = [[NSDictionary alloc]initWithDictionary:[modelSPAJSignature voidSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty1"]];
        bool customerSignatureCaptured = [[dictFooter valueForKey:@"SignatureCaptured"] boolValue];
        
        if (customerSignatureCaptured>0){
            [_labelPropertyCustomerSignature setText:[CHARACTER_DOUBLEDOT stringByAppendingString:@"Captured"]];
        }
        else{
            [_labelPropertyCustomerSignature setText:[CHARACTER_DOUBLEDOT stringByAppendingString:@"Not Captured"]];
        }
        NSString* stringSignatureCapture = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy (HH:mm)" DateValue:[dictFooter valueForKey:@"SPAJDateSignatureParty1"]];
        [_labelPropertyDateTime setText:[CHARACTER_DOUBLEDOT stringByAppendingString:stringSignatureCapture?:@""]];
        
        NSString* dateModified = [modelSPAJTransaction getSPAJTransactionData:@"SPAJDateModified" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        NSString* dateExpired = [modelSPAJTransaction getSPAJTransactionData:@"SPAJDateExpired" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        
        NSString* stringLastUpdate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy (HH:mm)" DateValue:dateModified];
        NSString* stringExpirationDate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy (HH:mm)" DateValue:dateExpired];
        
        [_labelPropertyExpiredDate setText:[CHARACTER_DOUBLEDOT stringByAppendingString:stringExpirationDate?:@""]];
        [_labelPropertyLastUpdate setText:[CHARACTER_DOUBLEDOT stringByAppendingString:stringLastUpdate?:@""]];
        [_labelPropertyTimeRemining setText:[CHARACTER_DOUBLEDOT stringByAppendingString:[formatter calculateTimeRemaining:[dictTransaction valueForKey:@"SPAJDateExpired"]]?:@""]];
    }

    // VOID
    -(void)voidLoadSIInformation{
        stringSINO = [dictTransaction valueForKey:@"SPAJSINO"];
        dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:stringSINO]];
        
        NSString *stringLAName = [dictionaryPOData valueForKey:@"LA_Name"];
        NSString *stringProduct = [dictionaryPOData valueForKey:@"ProductName"];
        
        NSString* stringLabelDetail = [NSString stringWithFormat:@"Nomor SI : %@    Tertanggung Polis : %@    Produk : %@",stringSINO,stringLAName,stringProduct];
        
        [_labelDetail1 setText:stringLabelDetail];
    }

    // ACTION

    - (IBAction)actionGoToStep1:(UIButton *)sender
    {
        /*if (siListingPopOver == nil) {
            siListingPopOver = [[SIListingPopOver alloc] initWithStyle:UITableViewStylePlain];
            siListingPopOver.delegate = self;
            
        }
        siListingPopOver.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:siListingPopOver animated:YES completion:nil];
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [siListingPopOver popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.sourceRect = sender.bounds;
        popController.sourceView = sender;
        popController.delegate = self;*/
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        // CHANGE PAGE
        
        /*  SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
            [self presentViewController:viewController animated:true completion:nil]; */
        
        //[_delegateSPAJMain voidGoToAddDetail];
        SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
        //[viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        [viewController setDictTransaction:dictTransaction];
        [self.navigationController pushViewController:viewController animated:YES];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {
        //[_delegateSPAJMain voidGoToFormGeneration];
        //SPAJFormGeneration* viewController = [[SPAJFormGeneration alloc] initWithNibName:@"SPAJ Form Generation" bundle:nil];
        [viewControllerFormGeneration setDictTransaction:dictTransaction];
        [self.navigationController pushViewController:viewControllerFormGeneration animated:YES];
    };

    - (IBAction)actionGoToStep5:(id)sender
    {
        //[_delegateSPAJMain voidGoToCaptureIdentification];
        SPAJCaptureIdentification* viewController = [[SPAJCaptureIdentification alloc] initWithNibName:@"SPAJ Capture Identification" bundle:nil];
        [viewController setDictTransaction:dictTransaction];
        //[viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        //[viewController setDictTransaction:[arraySPAJTransaction objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    };

    - (IBAction)actionGoToStep6:(id)sender
    {
        //[_delegateSPAJMain voidGoToAddSignature];
        SPAJ_Add_Signature* viewController = [[SPAJ_Add_Signature alloc] initWithNibName:@"SPAJ Add Signature" bundle:nil];
        [viewController setDictTransaction:dictTransaction];
        //[viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        //[viewController setDictTransaction:[arraySPAJTransaction objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    };

    - (IBAction)actionConfirmAndAssignSPAJNumber:(UIButton *)sender
    {
        NSString* SPAJNumber  = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        if (!([SPAJNumber length]>0)){
            LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
            long long spajNumber = [loginDB getLastActiveSPAJNum];
            if (spajNumber > 0){
                [modelSPAJTransaction updateSPAJTransaction:@"SPAJNumber" StringColumnValue:[[NSNumber numberWithLongLong:spajNumber] stringValue] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
                [modelSPAJTransaction updateSPAJTransaction:@"SPAJStatus" StringColumnValue:@"Not Submitted" StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
                boolConvertToImage = false;
                [viewActivityIndicator setHidden:NO];
                [self loadHTMLFile];
            }
            else{
                UIAlertController *alertNoSPAJNumber = [alert alertInformation:@"Peringatan" stringMessage:@"Alokasi Nomor SPAJ Bleum ada. Silahkan lakukan permintaan nomor SPAJ"];
                [self presentViewController:alertNoSPAJNumber animated:YES completion:nil];
            }
        }
        else{
            UIAlertController *alertHaveSPAJNumber = [alert alertInformation:@"Peringatan" stringMessage:@"Nomor SPAJ sudah ada"];
            [self presentViewController:alertHaveSPAJNumber animated:YES completion:nil];
        }
    };

    -(IBAction)actionGeneratePDF:(id)sender{
        NSString* fileName = @"SPAJ.pdf";
        NSString* spajOriginalPath = [NSString stringWithFormat:@"%@/%@_%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],[dictTransaction valueForKey:@"SPAJEappNumber"],fileName];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:spajOriginalPath])
        {
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:spajOriginalPath];
            [self splitPDF:fileURL withOutputName:@"AdditionalHealthQuestionaire" intoDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        }
        else
        {
            NSLog(@"File not exits");
        }
    }

    -(void)splitPDF:(NSURL *)sourcePDFUrl withOutputName:(NSString *)outputBaseName intoDirectory:(NSString *)directory
    {
        CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourcePDFUrl);
        size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:directory];
        NSError *error;
        /*if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            return;
        }*/
        for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
        {
            CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
            // CoreGraphics: MUST retain the Page-Refernce manually
            CGPDFPageRetain(SourcePDFPage);
            NSString *relativeOutputFilePath = [NSString stringWithFormat:@"SPAJ/%@/%@%d.jpg", directory, outputBaseName, currentPage];
            NSString *ImageFileName = [documentsDirectory stringByAppendingPathComponent:relativeOutputFilePath];
            CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage, kCGPDFMediaBox);
            UIGraphicsBeginPDFContextToFile(ImageFileName, sourceRect, nil);
            UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width,sourceRect.size.height));
            CGContextRef currentContext = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height); //596,842 //640×960,
            CGContextScaleCTM(currentContext, 1.0, -1.0);
            CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent: relativeOutputFilePath];
            [UIImageJPEGRepresentation(image, 1) writeToFile: imagePath atomically:YES];
        }
    }

    #pragma mark change file name
    //this function for testing Only
    -(void)renameSPAJPDF{
        NSString* fileName = @"SPAJ.pdf";
        
        NSString* spajOriginalPath = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
        NSString* spajNewPath = [NSString stringWithFormat:@"%@/%@_%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],[dictTransaction valueForKey:@"SPAJEappNumber"],fileName];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:spajOriginalPath toPath:spajNewPath error:&error];
    }

    -(void)voidChangeFileName:(long long)longSPAJNumber{
        //SPAJ Form
        NSString *filePrefix = [NSString stringWithFormat:@"%lld",longSPAJNumber];
        /*NSString* fileName = @"SPAJ.pdf";
        NSString* newSPAJFileName = [NSString stringWithFormat:@"%@_%@",filePrefix,fileName];
    
        NSString* spajOriginalPath = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
        NSString* spajNewPath = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],newSPAJFileName];*/
        
        NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSArray* directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
        
        for (int i=0;i<[directoryContent count];i++){
            NSString* originalContent = [directoryContent objectAtIndex:i];
            NSString * newString = [originalContent stringByReplacingOccurrencesOfString:[dictTransaction valueForKey:@"SPAJEappNumber"] withString:filePrefix];
            
            NSString* originalPath = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],originalContent];
            NSString* newPath = [NSString stringWithFormat:@"%@/%@",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],newString];
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtPath:originalPath toPath:newPath error:&error];
        }
    }

    #pragma mark delegate
    -(void)selectedSI:(NSString *)SINO
    {
        NSDictionary* dictionaryPODataLocal = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
        NSString *stringSINOLocal = SINO;
        NSString *stringLAName = [dictionaryPODataLocal valueForKey:@"LA_Name"];
        NSString *stringProduct = [dictionaryPODataLocal valueForKey:@"ProductName"];
        
        NSString* stringLabelDetail = [NSString stringWithFormat:@"Nomor SI : %@    Tertanggung Polis : %@    Produk : %@",stringSINO,stringLAName,stringProduct];
        
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJSINO" StringColumnValue:stringSINOLocal StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAPPNumber];
        [_labelDetail1 setText:stringLabelDetail];
        
        [siListingPopOver dismissViewControllerAnimated:YES completion:nil];
    }
    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    #pragma mark draw signature from pdf
    -(void)voidSaveSignatureToPDF{
        NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
        NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
        NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
        NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
        
        NSData* imageParty1=[[NSData alloc]
                             initWithBase64EncodedString:base64StringImageParty1 options:0];;
        NSData* imageParty2=[[NSData alloc]
                             initWithBase64EncodedString:base64StringImageParty2 options:0];;
        NSData* imageParty3=[[NSData alloc]
                             initWithBase64EncodedString:base64StringImageParty3 options:0];;
        NSData* imageParty4=[[NSData alloc]
                             initWithBase64EncodedString:base64StringImageParty4 options:0];;
        
        UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
        UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
        UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
        UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
        
        
        UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
        UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
        UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
        UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
        UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawSignatureInPDF:imageConverted1 Image2:imageConverted2 Image3:imageConverted3 Image4:imageConverted4];
        });
    }

    -(void)drawSignatureInPDF:(UIImage *)signatureImage1 Image2:(UIImage *)signatureImage2 Image3:(UIImage *)signatureImage3 Image4:(UIImage *)signatureImage4{
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString* filePathSPAJ = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePathSPAJ];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePathSPAJ]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addSignatureForPage1:signatureImage1 onPDFData:data];
                [self addSignatureForPage8:signatureImage1 UIImage2:signatureImage2 UIImage3:signatureImage3 UIImage4:signatureImage4 onPDFData:data];
                [self addSignatureForPage9:signatureImage1 UIImage2:signatureImage2 UIImage3:signatureImage3 UIImage4:signatureImage4 onPDFData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self joinMultiplePDF];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //[self removeSPAJSigned];
                            [allAboutPDFGeneration removeSPAJSigned:dictTransaction];
                            NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
                            
                            long long longSPAJNumber = [spajNumber longLongValue];
                            /*UIAlertController *alertNoSPAJNumber = [alert alertInformation:@"Sukses" stringMessage:[NSString stringWithFormat:@"Nomor SPAJ anda adalah %lli",longSPAJNumber]];
                            [self presentViewController:alertNoSPAJNumber animated:YES completion:nil];*/
                            //[self voidChangeFileName:longSPAJNumber];
                            [self generateAllIMGPDF];
                            //[_delegateSPAJMain actionGoToExistingList:nil];
                            /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // handle completion here
                                });
                            });*/
                            
                        });
                    });
                });
            });
        }
    }
    -(void)removeSPAJSigned{
        //NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // File paths
        NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathPage1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathPage9 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathPage9_1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:pdfPath1 error:&error];
        BOOL successPage1 = [fileManager removeItemAtPath:pdfPathPage1 error:&error];
        BOOL successPage9 = [fileManager removeItemAtPath:pdfPathPage9 error:&error];
        BOOL successPage9_1 = [fileManager removeItemAtPath:pdfPathPage9_1 error:&error];
        if (success) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
        if (successPage1) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
        if (successPage9) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }

        if (successPage9_1) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }

    -(void) addSignatureForPage8:(UIImage *)imgSignature1 UIImage2:(UIImage *)imgSignature2 UIImage3:(UIImage *)imgSignature3 UIImage4:(UIImage *)imgSignature4 onPDFData:(NSData *)pdfData {
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pdfFilePath =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSMutableData* outputPDFData = [[NSMutableData alloc] init];
        CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFData);
        
        CFMutableDictionaryRef attrDictionary = NULL;
        attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, CFSTR("My Doc"));
        CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
        CFRelease(dataConsumer);
        CFRelease(attrDictionary);
        CGRect pageRect;
        
        // Draw the old "pdfData" on pdfContext
        CFDataRef myPDFData = (__bridge CFDataRef) pdfData;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 8);
        pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(pdfContext, &pageRect);
        CGContextDrawPDFPage(pdfContext, page);
        
        // Draw the signature on pdfContext
        pageRect = CGRectMake(67, 486,96 , 53);
        CGImageRef pageImage1 = [imgSignature1 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage1);
        
        pageRect = CGRectMake(239, 486,96 , 53);
        CGImageRef pageImage2 = [imgSignature2 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage2);
        
        pageRect = CGRectMake(407, 486,96 , 53);
        CGImageRef pageImage3 = [imgSignature3 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage3);
        
        pageRect = CGRectMake(575, 486,96 , 53);
        CGImageRef pageImage4 = [imgSignature4 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage4);
        
        // release the allocated memory
        CGPDFContextEndPage(pdfContext);
        CGPDFContextClose(pdfContext);
        CGContextRelease(pdfContext);
        
        // write new PDFData in "outPutPDF.pdf" file in document directory
        [outputPDFData writeToFile:pdfFilePath atomically:YES];
    }

    -(void) addSignatureForPage9:(UIImage *)imgSignature1 UIImage2:(UIImage *)imgSignature2 UIImage3:(UIImage *)imgSignature3 UIImage4:(UIImage *)imgSignature4 onPDFData:(NSData *)pdfData {
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pdfFilePath =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSMutableData* outputPDFData = [[NSMutableData alloc] init];
        CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFData);
        
        CFMutableDictionaryRef attrDictionary = NULL;
        attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, CFSTR("My Doc"));
        CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
        CFRelease(dataConsumer);
        CFRelease(attrDictionary);
        CGRect pageRect;
        
        // Draw the old "pdfData" on pdfContext
        CFDataRef myPDFData = (__bridge CFDataRef) pdfData;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
        CGDataProviderRelease(provider);
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 9);
        pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(pdfContext, &pageRect);
        CGContextDrawPDFPage(pdfContext, page);
        
        // Draw the signature on pdfContext
        pageRect = CGRectMake(67, 376,96 , 53);
        CGImageRef pageImage1 = [imgSignature1 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage1);
        
        pageRect = CGRectMake(575, 376,96 , 53);
        CGImageRef pageImage4 = [imgSignature4 CGImage];
        CGContextDrawImage(pdfContext, pageRect, pageImage4);
        
        // release the allocated memory
        CGPDFContextEndPage(pdfContext);
        CGPDFContextClose(pdfContext);
        CGContextRelease(pdfContext);
        
        // write new PDFData in "outPutPDF.pdf" file in document directory
        [outputPDFData writeToFile:pdfFilePath atomically:YES];
    }

    -(void) addSignatureForPage1:(UIImage *)imgSignature onPDFData:(NSData *)pdfData{
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pdfFilePathPage1 =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSMutableData* outputPDFDataPage1 = [[NSMutableData alloc] init];
        CGDataConsumerRef dataConsumerPage1 = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFDataPage1);
        
        CFMutableDictionaryRef attrDictionaryPage1 = NULL;
        attrDictionaryPage1 = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(attrDictionaryPage1, kCGPDFContextTitle, CFSTR("My Doc"));
        CGContextRef pdfContextPage1 = CGPDFContextCreate(dataConsumerPage1, NULL, attrDictionaryPage1);
        CFRelease(dataConsumerPage1);
        CFRelease(attrDictionaryPage1);
        CGRect pageRectPage1;
        
        // Draw the old "pdfData" on pdfContext
        CFDataRef myPDFDataPage1 = (__bridge CFDataRef) pdfData;
        CGDataProviderRef providerPage1 = CGDataProviderCreateWithCFData(myPDFDataPage1);
        CGPDFDocumentRef pdfPage1 = CGPDFDocumentCreateWithProvider(providerPage1);
        CGDataProviderRelease(providerPage1);
        CGPDFPageRef pagePage1 = CGPDFDocumentGetPage(pdfPage1, 1);
        pageRectPage1 = CGPDFPageGetBoxRect(pagePage1, kCGPDFMediaBox);
        CGContextBeginPage(pdfContextPage1, &pageRectPage1);
        CGContextDrawPDFPage(pdfContextPage1, pagePage1);
        
        // Draw the signature on pdfContext
        //pageRect = CGRectMake(343, 35,101 , 43);
        pageRectPage1 = CGRectMake(617, 435,80, 37);
        CGImageRef pageImagePage1 = [imgSignature CGImage];
        CGContextDrawImage(pdfContextPage1, pageRectPage1, pageImagePage1);
        
        // release the allocated memory
        CGPDFContextEndPage(pdfContextPage1);
        CGPDFContextClose(pdfContextPage1);
        CGContextRelease(pdfContextPage1);
        
        // write new PDFData in "outPutPDF.pdf" file in document directory
        [outputPDFDataPage1 writeToFile:pdfFilePathPage1 atomically:YES];
    }

    -(void)joinMultiplePDF{
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // File paths
        NSString* filePathSPAJ = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathPage1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *pdfPathPage9 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        NSString *pdfPathOutput = filePathSPAJ;
        
        // File URLs - bridge casting for ARC
        CFURLRef pdfURLFilePath = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)filePathSPAJ];//(CFURLRef) NSURL
        CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath1];//(CFURLRef) NSURL
        CFURLRef pdfURLPage1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathPage1];//(CFURLRef) NSURL
        CFURLRef pdfURLPage9 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathPage9];//(CFURLRef)
        
        CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
        
        // File references
        CGPDFDocumentRef pdfRefFilePath = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLFilePath);
        CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
        CGPDFDocumentRef pdfRefPage1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLPage1);
        CGPDFDocumentRef pdfRefPage9 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLPage9);
        
        // Number of pages
        NSInteger numberOfPagesFilePath = CGPDFDocumentGetNumberOfPages(pdfRefFilePath);
        
        // Create the output context
        CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
        
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        // Read the first PDF and generate the output pages
        NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPagesFilePath);
        //for (int i=1; i<=numberOfPagesFilePath-1; i++) {
            page = CGPDFDocumentGetPage(pdfRefPage1, 1);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
            
            for (int i=2; i<=7; i++) {
                page = CGPDFDocumentGetPage(pdfRefFilePath, i);
                mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
                CGContextBeginPage(writeContext, &mediaBox);
                CGContextDrawPDFPage(writeContext, page);
                CGContextEndPage(writeContext);
            }
        /*}
        else{
            for (int i=1; i<=numberOfPagesFilePath-1; i++) {
                page = CGPDFDocumentGetPage(pdfRefFilePath, i);
                mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
                CGContextBeginPage(writeContext, &mediaBox);
                CGContextDrawPDFPage(writeContext, page);
                CGContextEndPage(writeContext);
            }
        }*/
        
        page = CGPDFDocumentGetPage(pdfRef1, 1);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
        
        page = CGPDFDocumentGetPage(pdfRefPage9, 1);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
        
        // Finalize the output file
        CGPDFContextClose(writeContext);
        
        // Release from memory
        CFRelease(pdfURLFilePath);
        //CFRelease(pdfURL1);
        
        CFRelease(pdfURLOutput);
        CGPDFDocumentRelease(pdfRefFilePath);
        //CGPDFDocumentRelease(pdfRef1);
        
        CGContextRelease(writeContext);
    }



    #pragma mark create pdf from html
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
        //NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        if (pdfData) {
            if ([stateGeneration isEqualToString:statePDFGeneration]){
                BOOL created = [pdfData writeToFile:[NSString stringWithFormat:@"%@/SPAJ/%@/%@_%i.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],indexForPDFGeneration] atomically:YES];
                
                /*[pdfData writeToFile:[NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]] atomically:YES];*/
                
                indexForPDFGeneration ++;
                if (indexForPDFGeneration < [arrayHTMLName count]){
                    [self loadSPAJPDFHTML:[arrayHTMLName objectAtIndex:indexForPDFGeneration] WithArrayIndex:indexForPDFGeneration];
                }
                else{
                    [allAboutPDFGeneration joinSPAJPDF:arrayHTMLName DictTransaction:dictTransaction];
                }
            }
            else{
                NSString* fileName = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_%@.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexImgForPDFGeneration]]];
                
                [pdfData writeToFile:fileName atomically:YES];
                [arrayPDFHealthQuestionairreName addObject:fileName];
                
                indexImgForPDFGeneration ++;
                if (indexImgForPDFGeneration < [arrayIMGName count]){
                    [self loadSPAJPDFHTML:[arrayIMGName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
                }
                else{
                    [self createImageFromPDF];
                }
            }
            
            /*if (created){
                [self voidSaveSignatureToPDF];
            }*/
        }
        else
        {
            NSLog(@"PDF couldnot be created");
        }
        
    }

    -(void)createImageFromPDF{
        if ([arrayPDFHealthQuestionairreName count]>0){
            boolConvertToImage = true;
            
            indexPDFForIMGGeneration = 0;
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]];
            //outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexPDFForIMGGeneration]]];
            outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [webview loadRequest:request];
         }
     }


    #pragma mark allabout html spaj pdf
    -(void)loadHTMLFile{
        
        stateGeneration = statePDFGeneration;
        indexForPDFGeneration = 0;
        arrayHTMLName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PDF" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        
        if ([arrayHTMLName count]>0){
            [self loadSPAJPDFHTML:[arrayHTMLName objectAtIndex:indexForPDFGeneration] WithArrayIndex:indexForPDFGeneration];
        }
        
        //NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PDF"];
        //[self loadSPAJPDFHTML:stringHTMLName];
        
        //[self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:5.0];
    }

    -(void)loadSPAJPDFHTML:(NSString*)stringHTMLName WithArrayIndex:(int)intArrayIndex{
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        
        NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
        NSString *localURL = [[NSString alloc] initWithString:
                              [docsDir stringByAppendingPathComponent: htmlfilePath]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
        [webview loadRequest:urlRequest];
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

    -(void)generateAllIMGPDF{
        stateGeneration = stateIMGGeneration;
        arrayPDFHealthQuestionairreName = [[NSMutableArray alloc]init];
        
        indexImgForPDFGeneration = 0;
        if ([[dictionaryPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
            arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        }
        else{
            arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_IN" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]]];
        }
        
        if ([arrayIMGName count]>0){
            [self loadSPAJPDFHTML:[arrayIMGName objectAtIndex:indexImgForPDFGeneration] WithArrayIndex:indexImgForPDFGeneration];
        }
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
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],fileName];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
        
        indexPDFForIMGGeneration++;
        if (indexPDFForIMGGeneration<[arrayPDFHealthQuestionairreName count]){
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]];
            //outputName = [NSString stringWithFormat:@"%@_%@",[dictTransaction valueForKey:@"SPAJEappNumber"],[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexPDFForIMGGeneration]]];
            outputName = [NSString stringWithFormat:@"%@",[allAboutPDFGeneration getSPAJImageNameFromPath:[arrayPDFHealthQuestionairreName objectAtIndex:indexPDFForIMGGeneration]]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [webview loadRequest:request];
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [allAboutPDFGeneration removeUnNecesaryPDFFiles:dictTransaction];
                [allAboutPDFGeneration removeSPAJSigned:dictTransaction];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
                /*dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
                    
                    long long longSPAJNumber = [spajNumber longLongValue];
                    [self voidChangeFileName:longSPAJNumber];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [viewActivityIndicator setHidden:YES];
                        UIAlertController *alertNoSPAJNumber = [alert alertInformation:@"Sukses" stringMessage:[NSString stringWithFormat:@"Nomor SPAJ anda adalah %lli",longSPAJNumber]];
                        [self presentViewController:alertNoSPAJNumber animated:YES completion:nil];
                            [_delegateSPAJMain actionGoToExistingList:nil];
                    });
                });*/
            });
            });
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
        NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        NSMutableDictionary* dictForSignature=[[NSMutableDictionary alloc]init];
        [dictForSignature setObject:stringHTMLID forKey:@"elementID"];
        [dictForSignature setObject:spajNumber?:@"" forKey:@"Value"];
        [dictForSignature setObject:@"1" forKey:@"CustomerID"];
        [dictForSignature setObject:@"1" forKey:@"SPAJID"];
        return dictForSignature;
    }

    -(NSDictionary *)getDictionaryForVANumber:(NSString *)stringDBColumnName HTMLID:(NSString *)stringHTMLID{
        NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        NSMutableDictionary* dictForSignature=[[NSMutableDictionary alloc]init];
        [dictForSignature setObject:stringHTMLID forKey:@"elementID"];
        [dictForSignature setObject:[NSString stringWithFormat:@"02063%@",spajNumber?:@""] forKey:@"Value"];
        [dictForSignature setObject:@"1" forKey:@"CustomerID"];
        [dictForSignature setObject:@"1" forKey:@"SPAJID"];
        return dictForSignature;
    }


    - (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
        if (stateGeneration == stateIMGGeneration){
            NSString* htmlFileName = [allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:indexImgForPDFGeneration]];
            
            NSString *stringName = [allAboutPDFGeneration getWordFromString:htmlFileName IndexWord:2];
            int countElement = [modelSPAJAnswers getCountElementID:stringName SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] integerValue]];
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
        }
        else{
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
            
            //NSMutableDictionary *dictOriginal = [[NSMutableDictionary alloc]initWithDictionary:[super readfromDB:finalDictionary]];
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
            [modifieArray addObject:[self getDictionaryForVANumber:@"SPAJNumber" HTMLID:@"TextVANumber"]];
            
            [dictOriginal setObject:modifieArray forKey:@"readFromDB"];
            [self callSuccessCallback:[params valueForKey:@"successCallBack"] withRetValue:dictOriginal];
            //[webview setHidden:NO];
            //[self voidCreateThePDF];
            [self performSelector:@selector(voidCreateThePDF) withObject:nil afterDelay:1.0];
            return dictOriginal;
        }
    }

    - (void)webViewDidFinishLoad:(UIWebView *)webView{
        NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setHeader(\"%@\");",spajNumber]];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
        if (boolConvertToImage){
            [self performSelector:@selector(voidCreateImageFromWebView:) withObject:outputName afterDelay:1.0];
        }

    }

    #pragma mark delegate
    -(void)voidPDFCreated{
        [self voidSaveSignatureToPDF];
    }

    -(void)imgSigned{
        
    }

    -(void)allImgSigned{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* spajNumber = [modelSPAJTransaction getSPAJTransactionData:@"SPAJNumber" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
            
            long long longSPAJNumber = [spajNumber longLongValue];
            [self voidChangeFileName:longSPAJNumber];
            dispatch_async(dispatch_get_main_queue(), ^{
                [viewActivityIndicator setHidden:YES];
                UIAlertController *alertNoSPAJNumber = [alert alertInformation:@"Sukses" stringMessage:[NSString stringWithFormat:@"Nomor SPAJ anda adalah %lli",longSPAJNumber]];
                [self presentViewController:alertNoSPAJNumber animated:YES completion:nil];
                [_delegateSPAJMain actionGoToExistingList:nil];
            });
        });
    }



@end