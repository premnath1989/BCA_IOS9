//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Form Generation.h"
#import "String.h"
#import "SPAJ Main.h"


// DECLARATION

@interface SPAJFormGeneration ()



@end


// IMPLEMENTATION

@implementation SPAJFormGeneration

    // SYNTHESIZE

    @synthesize delegateSPAJMain = _delegateSPAJMain;


    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_FORMGENERATION", nil);
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_FORMGENERATION_HEADER3", nil);
        
        [_buttonGenerate setTitle:NSLocalizedString(@"BUTTON_GENERATEFORM", nil) forState:UIControlStateNormal];
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
        // CHANGE PAGE
        
        /*  SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
            [self presentViewController:viewController animated:true completion:nil]; */
        
        [_delegateSPAJMain voidGoToAddDetail];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {

    };

    - (IBAction)actionGoToStep5:(id)sender
    {

    };

    - (IBAction)actionGoToStep6:(id)sender
    {
        [_delegateSPAJMain voidGoToAddSignature];
    };


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end