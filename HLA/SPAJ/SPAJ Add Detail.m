//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Add Detail.h"
#import "String.h"


// DECLARATION

@interface SPAJAddDetail ()



@end


// IMPLEMENTATION

@implementation SPAJAddDetail

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // LOCALIZATION
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER3", nil);
        
        _labelStep4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP4", nil);
        _labelHeader4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER4", nil);
        
        _labelStep5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP5", nil);
        _labelHeader5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER5", nil);
        
        _labelStep6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP6", nil);
        _labelHeader6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER6", nil);
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
        NSLog(@"test");
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