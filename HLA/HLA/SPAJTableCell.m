//
//  ProspectListingTableViewCell.m
//  MPOS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJTableCell.h"

@implementation SPAJTableCell

@synthesize labelDate;
@synthesize labelSPAJ;
@synthesize labelSINO;
@synthesize labelName;
@synthesize labelProduk;
@synthesize labelStatus;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
