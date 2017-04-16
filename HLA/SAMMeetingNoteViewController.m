//
//  SAMMeetingNoteViewController.m
//  BLESS
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMMeetingNoteViewController.h"
#import "DateViewController.h"
#import "TimeViewController.h"

@interface SAMMeetingNoteViewController ()<DateViewControllerDelegate, TimeViewControllerDelegate> {
    DateViewController *scheduleDate;
    TimeViewController *scheduleTime;
    UIPopoverController *popoverViewer;
}
@end

int const TIME_FROM_BUTTON_TAG = 0;
int const TIME_TO_BUTTON_TAG = 1;

@implementation SAMMeetingNoteViewController

@synthesize meetingDatePicker;
@synthesize meetingTimeFromPicker;
@synthesize meetingTimeToPicker;
@synthesize txtMeetingWhere;
@synthesize txtMeetingStatus;
@synthesize txtMeetingActivity;
@synthesize txtMeetingComment;
@synthesize outletStatus;

@synthesize databasePath;

#pragma mark -View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtMeetingComment.layer.borderWidth = 1.0f;
    txtMeetingComment.layer.borderColor = [[UIColor blackColor] CGColor];
    
    meetingTimeFromPicker.tag = TIME_FROM_BUTTON_TAG;
    meetingTimeToPicker.tag = TIME_TO_BUTTON_TAG;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action

-(IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionStatus:(id)sender {
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_activityStatus == nil) {
        _activityStatus = [[ActivityStatus alloc] initWithStyle:UITableViewStylePlain];
        _activityStatus.delegate = self;
        _statusPopoverController = [[UIPopoverController alloc] initWithContentViewController:_activityStatus];
    }
    [_statusPopoverController presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

-(IBAction)actionDateMeeting:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    scheduleDate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    scheduleDate.delegate = self;
    scheduleDate.btnSender = 1;
    scheduleDate.msgDate = sender.currentTitle;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:scheduleDate];
    [popoverViewer setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)actionTimeMeeting:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    scheduleTime = [[TimeViewController alloc]initWithNibName:@"TimeViewController" bundle:nil];
    scheduleTime.delegate = self;
    scheduleTime.btnSender = sender.tag;
    //scheduleTime.msgDate = sender.currentTitle;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:scheduleTime];
    [popoverViewer setPopoverContentSize:CGSizeMake(540.0f, 294.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -Delegate

-(void) selectedStatus:(NSString *)status {
    outletStatus.titleLabel.text = status;
    if([status isEqualToString:@"- SELECT -"]) {
        outletStatus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        outletStatus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    [outletStatus setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",status]forState:UIControlStateNormal];
    [outletStatus setBackgroundColor:[UIColor clearColor]];
    [_statusPopoverController dismissPopoverAnimated:YES];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB {
    [meetingDatePicker setTitle:aDate forState:UIControlStateNormal];
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)timePick:(TimeViewController *)inController strTime:(NSString *)aTime {
    if(inController.btnSender == TIME_FROM_BUTTON_TAG) {
        [meetingTimeFromPicker setTitle:aTime forState:UIControlStateNormal];
    } else if(inController.btnSender == TIME_TO_BUTTON_TAG) {
        [meetingTimeToPicker setTitle:aTime forState:UIControlStateNormal];
    }
    [popoverViewer dismissPopoverAnimated:YES];
}

@end
