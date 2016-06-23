//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Add Menu.h"


// DECLARATION

@interface SPAJAddMenu ()



@end


// IMPLEMENTATION

@implementation SPAJAddMenu

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
        _labelMenuHint.text = NSLocalizedString(@"NOTE_GUIDEMENU", nil);
        
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
        _labelPropertyCustomerSignature.text = NSLocalizedString(@"STATE_CAPTURED", nil);
        _labelPropertyDateTime.text = dateCurrent;
        _labelPropertyExpiredDate.text = dateCurrent;
        _labelPropertyLastUpdate.text = dateCurrent;
        _labelPropertyTimeRemining.text = dateCurrent;
    }


    // ACTION

    - (IBAction)actionGoToStep1:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep3:(id)sender
    {

    };

    - (IBAction)actionGoToStep4:(id)sender
    {

    };

    - (IBAction)actionGoToStep5:(id)sender
    {

    };

    - (IBAction)actionGoToStep6:(id)sender
    {

    };


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end