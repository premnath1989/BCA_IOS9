//
//  PendingVCCell.h
//  MPOS
//
//  Created by Basvi on 14/01/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewViewController.h"

@interface PendingVCCell : UITableViewCell<UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *siNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *proposalNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *siVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eAppVersionLabel;
@property (weak, nonatomic) IBOutlet UIButton *toViewButton;
@property (weak, nonatomic) IBOutlet UILabel *policyNo;
@property (weak, nonatomic) IBOutlet UILabel *TimeRemainingLabel;
- (IBAction)Payment_Button:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PAyment;

@property (weak, nonatomic) IBOutlet UIButton *toViewButton1;






@end
