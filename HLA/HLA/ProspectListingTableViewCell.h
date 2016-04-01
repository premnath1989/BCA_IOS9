//
//  ProspectListingTableViewCell.h
//  MPOS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProspectListingTableViewCell : UITableViewCell {
    
}

@property (nonatomic, weak) IBOutlet UILabel* labelName;
@property (nonatomic, weak) IBOutlet UILabel* labelidNum;
@property (nonatomic, weak) IBOutlet UILabel* labelDOB;
@property (nonatomic, weak) IBOutlet UILabel* labelPhone1;
@property (nonatomic, weak) IBOutlet UILabel* labelBranchName;
@property (nonatomic, weak) IBOutlet UILabel* labelDateCreated;
@property (nonatomic, weak) IBOutlet UILabel* labelDateModified;
@property (nonatomic, weak) IBOutlet UILabel* labelTimeRemaining;
@end
