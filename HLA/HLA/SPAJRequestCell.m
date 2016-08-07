//
//  ProspectListingTableViewCell.m
//  MPOS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJRequestCell.h"

@implementation SPAJRequestCell

@synthesize labelDate;
@synthesize labelPackID;
@synthesize labelTotal;
@synthesize labelSPAJStart;
@synthesize labelSPAJEnd;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
