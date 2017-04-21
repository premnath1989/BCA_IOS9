//
//  SAMMeetingScheduleViewController.h
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMDBHelper.h"
#import "SIDate.h"

@interface SAMMeetingScheduleViewController : UIViewController{
    IBOutlet UIButton *buttonDate;
    IBOutlet UIButton *buttonTime;
    IBOutlet UITextView *textComment;
    
    SAMDBHelper *dbHelper;
    SIDate *_SIDate;
    
    UIPopoverController *_SIDatePopover;
}
    
@property (nonatomic, retain) SIDate *SIDate;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;

@end
