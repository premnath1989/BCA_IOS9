//
//  SAMMain.h
//  BLESS
//
//  Created by Basvi on 12/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layout.h"

@interface SAMMain : UIViewController
    // VIEW

    @property (nonatomic, weak) IBOutlet UIView *viewContent;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonHome;

    @property (nonatomic, weak) IBOutlet ViewNavigation *viewNavigation;
    /*@property (nonatomic, weak) IBOutlet UIButton *buttonEApplicationList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonExistingList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSubmittedList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonAdd;*/

@end
