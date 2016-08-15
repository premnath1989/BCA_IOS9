//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT
#import <objc/runtime.h>

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
#import "Formatter.h"
#import "Layout.h"
#import "User Interface.h"
#import "LoginDBManagement.h"
// DECLARATION

@interface SPAJAddMenu ()<SIListingDelegate,UIPopoverPresentationControllerDelegate>



@end


// IMPLEMENTATION

@implementation SPAJAddMenu {
    SIListingPopOver *siListingPopOver;
    ModelSIPOData *modelSIPOData;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJSignature *modelSPAJSignature;
    ModelSPAJIDCapture *modelSPAJIDCapture;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelSPAJDetail* modelSPAJDetail;
    Formatter* formatter;
    
    UserInterface *objectUserInterface;
    
    NSDictionary* dictionaryPOData;
    NSString *stringSINO;
}

    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;
    @synthesize stringEAPPNumber;
    @synthesize dictTransaction;

    // DID LOAD
    -(void)viewWillAppear:(BOOL)animated{
        [self voidCheckListCompletion];
        [self voidGetFooterInformation];
    }

    -(void)viewDidAppear:(BOOL)animated{
        [self voidLoadSIInformation];
    }

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // DATE
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        modelSPAJDetail = [[ModelSPAJDetail alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
        
        formatter = [[Formatter alloc]init];
        
        [self setNavigationBar];
        
        
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
    }

    -(void)voidGetFooterInformation{
        NSDictionary* dictFooter = [[NSDictionary alloc]initWithDictionary:[modelSPAJSignature voidSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJEappNumber"] intValue] SignatureParty:@"SPAJSignatureParty1"]];
        bool customerSignatureCaptured = [[dictFooter valueForKey:@"SignatureCaptured"] boolValue];
        
        if (customerSignatureCaptured>0){
            [_labelPropertyCustomerSignature setText:[CHARACTER_DOUBLEDOT stringByAppendingString:@"Captured"]];
        }
        else{
            [_labelPropertyCustomerSignature setText:[CHARACTER_DOUBLEDOT stringByAppendingString:@"Not Captured"]];
        }
        [_labelPropertyDateTime setText:[CHARACTER_DOUBLEDOT stringByAppendingString:[dictFooter valueForKey:@"SPAJDateSignatureParty1"]]];
        
        NSString* stringLastUpdate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy (HH:mm)" DateValue:[dictTransaction valueForKey:@"SPAJDateModified"]];
        NSString* stringExpirationDate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy (HH:mm)" DateValue:[dictTransaction valueForKey:@"SPAJDateExpired"]];
        
        [_labelPropertyExpiredDate setText:[CHARACTER_DOUBLEDOT stringByAppendingString:stringExpirationDate]];
        [_labelPropertyLastUpdate setText:[CHARACTER_DOUBLEDOT stringByAppendingString:stringLastUpdate]];
        [_labelPropertyTimeRemining setText:[CHARACTER_DOUBLEDOT stringByAppendingString:[formatter calculateTimeRemaining:[dictTransaction valueForKey:@"SPAJDateExpired"]]]];
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
        SPAJFormGeneration* viewController = [[SPAJFormGeneration alloc] initWithNibName:@"SPAJ Form Generation" bundle:nil];
        [viewController setDictTransaction:dictTransaction];
        //[viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        //[viewController setDictTransaction:[arraySPAJTransaction objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
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
        /*CFFAPIController* cffAPIController;
        cffAPIController = [[CFFAPIController alloc]init];
        [cffAPIController apiCall:@"http://192.168.0.114/E-Submission/SpajHandler.ashx?operation=getRemoteFtpPath&spajNumber=60000000022&product=BCALife"];*/
        
        LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJNumber" StringColumnValue:[[NSNumber numberWithLongLong:[loginDB getLastActiveSPAJNum]] stringValue] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJStatus" StringColumnValue:@"ExistingList" StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
    };


    #pragma mark delegate
    -(void)selectedSI:(NSString *)SINO
    {
        NSDictionary* dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
        NSString *stringSINO = SINO;
        NSString *stringLAName = [dictionaryPOData valueForKey:@"LA_Name"];
        NSString *stringProduct = [dictionaryPOData valueForKey:@"ProductName"];
        
        NSString* stringLabelDetail = [NSString stringWithFormat:@"Nomor SI : %@    Tertanggung Polis : %@    Produk : %@",stringSINO,stringLAName,stringProduct];
        
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJSINO" StringColumnValue:stringSINO StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAPPNumber];
        [_labelDetail1 setText:stringLabelDetail];
        
        [siListingPopOver dismissViewControllerAnimated:YES completion:nil];
    }
    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end