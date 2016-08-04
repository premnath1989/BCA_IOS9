//
//  ProspectListingTableViewCell.h
//  MPOS
//
//  Created by Erwin on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAJTableCell : UITableViewCell {
    
}

@property (nonatomic, weak) IBOutlet UILabel* labelDate;
@property (nonatomic, weak) IBOutlet UILabel* labelSPAJ;
@property (nonatomic, weak) IBOutlet UILabel* labelSINO;
@property (nonatomic, weak) IBOutlet UILabel* labelName;
@property (nonatomic, weak) IBOutlet UILabel* labelProduk;
@property (nonatomic, weak) IBOutlet UILabel* labelStatus;
@end
