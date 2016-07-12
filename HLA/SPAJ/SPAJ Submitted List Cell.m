//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Submitted List Cell.h"


// IMPLEMENTATION

@implementation SPAJSubmittedListCell

    // OUTLET

    @synthesize tableViewCell = _tableViewCell;
    @synthesize labelName = _labelName;
    @synthesize labelSocialNumber = _labelSocialNumber;
    @synthesize labelSPAJNumber = _labelSPAJNumber;
    @synthesize labelUpdatedOnDate = _labelUpdatedOnDate;
    @synthesize labelUpdatedOnTime = _labelUpdatedOnTime;
    @synthesize labelProduct = _labelProduct;
    @synthesize labelState = _labelState;
    @synthesize buttonView = _buttonView;
    @synthesize intID = _intID;


    // DID LOAD

    - (void)awakeFromNib
    {
        [[_buttonView titleLabel]setText:NSLocalizedString(@"BUTTON_VIEW", nil)];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)setSelected:(BOOL)selected animated:(BOOL)animated
    {
        [super setSelected:selected animated:animated];
    }

@end