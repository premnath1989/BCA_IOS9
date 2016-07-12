//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ E Application List Cell.h"


// IMPLEMENTATION

@implementation SPAJEApplicationListCell

    // OUTLET

    @synthesize tableViewCell = _tableViewCell;
    @synthesize labelName = _labelName;
    @synthesize labelSocialNumber = _labelSocialNumber;
    @synthesize labelEApplicationNumber = _labelEApplicationNumber;
    @synthesize labelUpdatedOnDate = _labelUpdatedOnDate;
    @synthesize labelUpdatedOnTime = _labelUpdatedOnTime;
    @synthesize labelState = _labelState;
    @synthesize labelSPAJNumber = _labelSPAJNumber;
    @synthesize intID = _intID;


    // AWAKE FROM NIB

    - (void) awakeFromNib
    {
        
    }


    // SET SELECTED

    - (void) setSelected:(BOOL)selected animated:(BOOL)animated
    {
        [super setSelected:selected animated:animated];
    }

@end