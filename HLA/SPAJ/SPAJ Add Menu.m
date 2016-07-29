//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Add Menu.h"
#import "SPAJ Add Detail.h"
#import "String.h"
#import "SPAJ Main.h"
#import "CFFAPIController.h"
#import "SIListingPopOver.h"
#import "ModelSIPOData.h"
#import "ModelSPAJTransaction.h"

// DECLARATION

@interface SPAJAddMenu ()<SIListingDelegate,UIPopoverPresentationControllerDelegate>



@end


// IMPLEMENTATION

@implementation SPAJAddMenu {
    SIListingPopOver *siListingPopOver;
    ModelSIPOData *modelSIPOData;
    ModelSPAJTransaction *modelSPAJTransaction;
}

    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;
    @synthesize stringEAPPNumber;


    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // DATE
        
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
        
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    }


    // ACTION

    - (IBAction)actionGoToStep1:(UIButton *)sender
    {
        if (siListingPopOver == nil) {
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
        popController.delegate = self;
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
        [_delegateSPAJMain voidGoToFormGeneration];
    };

    - (IBAction)actionGoToStep5:(id)sender
    {
        [_delegateSPAJMain voidGoToCaptureIdentification];
    };

    - (IBAction)actionGoToStep6:(id)sender
    {
        [_delegateSPAJMain voidGoToAddSignature];
    };

    - (IBAction)actionConfirmAndAssignSPAJNumber:(UIButton *)sender
    {
        CFFAPIController* cffAPIController;
        cffAPIController = [[CFFAPIController alloc]init];
        [cffAPIController apiCall:@"http://192.168.0.114/E-Submission/SpajHandler.ashx?operation=getRemoteFtpPath&spajNumber=60000000022&product=BCALife"];
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