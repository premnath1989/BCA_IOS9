//
//  ProspectListingTableViewCell.h
//  MPOS
//
//  Created by Erwin on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAJRequestCell : UITableViewCell {
    
}

@property (nonatomic, weak) IBOutlet UILabel* labelDate;
@property (nonatomic, weak) IBOutlet UILabel* labelPackID;
@property (nonatomic, weak) IBOutlet UILabel* labelTotal;
@property (nonatomic, weak) IBOutlet UILabel* labelSPAJStart;
@property (nonatomic, weak) IBOutlet UILabel* labelSPAJEnd;
@end
