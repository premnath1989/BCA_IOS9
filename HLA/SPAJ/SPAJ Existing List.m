//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Existing List.h"


// DECLARATION

@interface SPAJExistingList ()



@end


// IMPLEMENTATION

@implementation SPAJExistingList

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // LAYOUT SETTING
        
        _stackViewNote.alignment = UIStackViewAlignmentTop;
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJEXISTINGLIST", nil);
        
        _labelNoteHeader.text = NSLocalizedString(@"NOTE_SPAJHEADER", nil);
        _labelNoteDetail.text = NSLocalizedString(@"NOTE_SPAJDETAIL", nil);
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldSPAJNumber.text = NSLocalizedString(@"FIELD_SPAJNUMBER", nil);
        _labelFieldSocialNumber.text = NSLocalizedString(@"FIELD_SOCIALNUMBER", nil);
        
        [_buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [_buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [_buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
    }


    // ACTION

    - (IBAction)actionGoToExistingList:(id)sender
    {
        
    };

    - (IBAction)actionGoToSubmittedList:(id)sender
    {
        
    };


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end