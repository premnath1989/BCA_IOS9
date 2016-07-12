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

    @property (nonatomic, strong) IBOutlet UITableViewCell *tableViewCell;

    // LABEL

    @property (nonatomic, strong) IBOutlet UILabel *labelName;
    @property (nonatomic, strong) IBOutlet UILabel *labelSocialNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelSPAJNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnDate;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnTime;
    @property (nonatomic, strong) IBOutlet UILabel *labelProduct;
    @property (nonatomic, strong) IBOutlet UILabel *labelState;

    // BUTTON

    @property (nonatomic, strong) IBOutlet UIButton *buttonView;

    // VARIABLE

    @property (retain, strong) NSNumber *intID;

@end