//
//  SAMMeetingNoteViewController.h
//  BLESS
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMMeetingNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *meetingDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *meetingTimePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingWhere;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingActivity;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetingStatus;
@property (weak, nonatomic) IBOutlet UITextView *txtMeetingComment;

-(IBAction)actionSubmit:(id)sender;

@end
