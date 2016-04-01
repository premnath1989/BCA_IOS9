//
//  ProspectListingTableViewCell.m
//  MPOS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProspectListingTableViewCell.h"

@implementation ProspectListingTableViewCell
@synthesize labelName =_labelName;
@synthesize labelDOB =_labelDOB;
@synthesize labelPhone1 =_labelPhone1;
@synthesize labelBranchName =_labelBranchName;
@synthesize labelDateCreated =_labelDateCreated;
@synthesize labelDateModified =_labelDateModified;
@synthesize labelTimeRemaining =_labelTimeRemaining;
@synthesize labelidNum =_labelidNum;

- (void)awakeFromNib {
    NSLog(@"test");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
