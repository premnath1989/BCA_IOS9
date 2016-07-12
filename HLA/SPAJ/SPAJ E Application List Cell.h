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

@interface SPAJEApplicationListCell : UITableViewCell

    // LAYOUT

    @property (nonatomic, strong) IBOutlet UITableViewCell *tableViewCell;

    // LABEL

    @property (nonatomic, strong) IBOutlet UILabel *labelName;
    @property (nonatomic, strong) IBOutlet UILabel *labelSocialNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelEApplicationNumber;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnDate;
    @property (nonatomic, strong) IBOutlet UILabel *labelUpdatedOnTime;
    @property (nonatomic, strong) IBOutlet UILabel *labelState;
    @property (nonatomic, strong) IBOutlet UILabel *labelSPAJNumber;

    // VARIABLE

    @property (retain, strong) NSNumber *intID;

@end