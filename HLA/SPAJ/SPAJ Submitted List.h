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

@interface SPAJSubmittedList : UIViewController

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelPageTitle;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldName;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSPAJNumber;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldSocialNumber;

    // TEXTFIELD

    @property (nonatomic, weak) IBOutlet UITextField *textFieldName;
    @property (nonatomic, weak) IBOutlet UITextField *textFieldSPAJNumber;
    @property (nonatomic, weak) IBOutlet UITextField *textFieldSocialNumber;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonSearch;
    @property (nonatomic, weak) IBOutlet UIButton *buttonReset;
    @property (nonatomic, weak) IBOutlet UIButton *buttonDelete;

@end