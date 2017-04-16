//
//  SAMMeetingNoteViewController.h
//  BLESS
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityStatus.h"

@interface SAMMeetingNoteViewController : UIViewController <ActivityStatusDelegate> {
    ActivityStatus *_activityStatus;
    sqlite3 *contactDB;
    
    UIPopoverController *_statusPopoverController;
}

@property (weak, nonatomic) IBOutlet UIButton *meetingDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *meetingTimeFromPicker;
@property (weak, nonatomic) IBOutlet UIButton *meetingTimeToPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingWhere;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingActivity;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingStatus;
@property (weak, nonatomic) IBOutlet UITextView *txtMeetingComment;
@property (weak, nonatomic) IBOutlet UIButton *outletStatus;

@property NSString *databasePath;

-(IBAction)actionClose:(id)sender;
-(IBAction)actionSubmit:(id)sender;
-(IBAction)actionStatus:(id)sender;

@end
