//
//  SAMTableViewActivityDetailCell.h
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMTableViewActivityDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableViewCell *cell;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;
@property (weak, nonatomic) IBOutlet UILabel *labelActivity;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelComments;

@end
