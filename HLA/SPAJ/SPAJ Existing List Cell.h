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

    @property (retain, strong) NSNumber *intID;

    // LAYOUT

    @property (nonatomic, strong) IBOutlet UITableViewCell *tableViewCell;

    // LABEL

    @property (nonatomic, strong) IBOutlet UILabel *labelName;
    @property (nonatomic, strong) IBOutlet UILabel *labelSocialNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelSPAJNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnDate;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnTime;
    @property (nonatomic, strong) IBOutlet UILabel *labelSalesIllustration;
    @property (nonatomic, strong) IBOutlet UILabel *labelTimeRemaining;

    // BUTTON

    @property (nonatomic, strong) IBOutlet UIButton *buttonView;
    @property (nonatomic, strong) IBOutlet UIButton *buttonPaymentReceipt;
    @property (nonatomic, strong) IBOutlet UIButton *buttonAgentForm;

@end