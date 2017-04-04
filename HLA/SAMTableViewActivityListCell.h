//
//  SAMTableViewAcitivtyListCell.h
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMTableViewActivityListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, weak) IBOutlet UIButton *buttonEdit;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *age;
@property (nonatomic, weak) IBOutlet UILabel *activityDate;
@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UILabel *activity;
@property (nonatomic, weak) IBOutlet UILabel *type;
@property (nonatomic, weak) IBOutlet UILabel *nextMeeting;

@end
