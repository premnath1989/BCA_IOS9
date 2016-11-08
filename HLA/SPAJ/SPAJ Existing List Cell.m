//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Existing List Cell.h"


// IMPLEMENTATION

@implementation SPAJExistingListCell

    // OUTLET

    @synthesize tableViewCell = _tableViewCell;
    @synthesize labelName = _labelName;
    @synthesize labelSocialNumber = _labelSocialNumber;
    @synthesize labelSPAJNumber = _labelSPAJNumber;
    @synthesize labelUpdatedOnDate = _labelUpdatedOnDate;
    @synthesize labelUpdatedOnTime = _labelUpdatedOnTime;
    @synthesize labelSalesIllustration = _labelSalesIllustration;
    @synthesize labelTimeRemaining = _labelTimeRemaining;
    @synthesize buttonView = _buttonView;
    @synthesize intID = _intID;
    @synthesize buttonAgentForm = _buttonAgentForm;
    @synthesize buttonPaymentReceipt = _buttonPaymentReceipt;

    // AWAKE FROM NIB

    - (void) awakeFromNib
    {
        [[_buttonView titleLabel]setText:NSLocalizedString(@"BUTTON_VIEW", nil)];
    }


    // SET SELECTED

    - (void) setSelected:(BOOL)selected animated:(BOOL)animated
    {
        [super setSelected:selected animated:animated];
    }

@end