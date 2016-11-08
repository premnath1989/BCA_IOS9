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

@interface SPAJSubmittedListCell : UITableViewCell

    // LAYOUT

    @property (nonatomic, weak) IBOutlet UITableViewCell *tableViewCell;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelName;
    @property (nonatomic, weak) IBOutlet UILabel *labelSocialNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelUpdatedOnDate;
    @property (nonatomic, weak) IBOutlet UILabel *labelUpdatedOnTime;
    @property (nonatomic, weak) IBOutlet UILabel *labelProduct;
    @property (nonatomic, weak) IBOutlet UILabel *labelState;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonView;

    // VARIABLE

    @property (nonatomic, weak) NSNumber *intID;

@end