//
//  ViewController.h
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// DECLARATION

@interface SPAJExistingListCell : UITableViewCell

    // VARIABLE

    @property (nonatomic, weak) NSNumber *intID;

    // LAYOUT

    @property (nonatomic, weak) IBOutlet UITableViewCell *tableViewCell;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelName;
    @property (nonatomic, weak) IBOutlet UILabel *labelSocialNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelUpdatedOnDate;
    @property (nonatomic, weak) IBOutlet UILabel *labelUpdatedOnTime;
    @property (nonatomic, weak) IBOutlet UILabel *labelSalesIllustration;
    @property (nonatomic, weak) IBOutlet UILabel *labelTimeRemaining;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonView;
    @property (nonatomic, weak) IBOutlet UIButton *buttonPaymentReceipt;
    @property (nonatomic, weak) IBOutlet UIButton *buttonAgentForm;

@end