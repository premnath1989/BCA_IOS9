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
#import "SAMMeetingNoteModel.h"
#import "AppDelegate.h"

@interface SAMMeetingNoteViewController ()<DateViewControllerDelegate, TimeViewControllerDelegate> {
    DateViewController *scheduleDate;
    TimeViewController *scheduleTime;
    UIPopoverController *popoverViewer;
}
@end

int const TIME_FROM_BUTTON_TAG = 0;
int const TIME_TO_BUTTON_TAG = 1;
int const MEETING_NOTE_SUCCESS_TAG = 2;

SAMMeetingNoteModel *note;
AppDelegate *appDel;

@implementation SAMMeetingNoteViewController

@synthesize meetingDatePicker;
@synthesize meetingTimeFromPicker;
@synthesize meetingTimeToPicker;
@synthesize txtMeetingWhere;
@synthesize txtMeetingStatus;
@synthesize txtMeetingActivity;
@synthesize txtMeetingComment;
@synthesize outletStatus;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;

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
    dbHelper = [[SAMDBHelper alloc] init];
    
    note = [[SAMMeetingNoteModel alloc] init];
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    txtMeetingActivity.text = [self GetActivity:appDel.SAMData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) GetActivity: (SAMModel *) data
{
    if(!([data.idApplication isEqualToString:@""] || [data.idApplication isEqualToString:@"null"])) {
        return @"Aplikasi";
    } else if(!([data.idIllustration isEqualToString:@""] || [data.idIllustration isEqualToString:@"null"])) {
        return @"Illustrasi";
    } else if(!([data.idVideo isEqualToString:@""] || [data.idVideo isEqualToString:@"null"])) {
        return @"Video";
    } else if(!([data.idRecomendation isEqualToString:@""] || [data.idRecomendation isEqualToString:@"null"])) {
        return @"Rekomendasi Produk";
    } else if(!([data.idCFF isEqualToString:@""] || [data.idCFF isEqualToString:@"null"])) {
        return @"CFF";
    } else {
        return @"Introduksi";
    }
}

- (NSString *) GetDuration {
    NSString *duration = @"";
    
    return duration;
}

#pragma mark -Action

-(IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionSave:(id)sender {
    note.SAMID = appDel.SAMData._id;
    note.SAMNumber = appDel.SAMData.number;
    note.meetingDate = meetingDatePicker.titleLabel.text;
    note.meetingTime = meetingTimeFromPicker.titleLabel.text;
    note.meetingStatus = outletStatus.titleLabel.text;
    note.meetingLocation = txtMeetingWhere.text;
    note.meetingActivity = txtMeetingActivity.text;
    note.meetingComments = txtMeetingComment.text;
    note.meetingDuration = [self GetDuration];
    
    if([dbHelper CreateMeetingNote:note]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Catatan Berhasil Disimpan"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        alert.tag = MEETING_NOTE_SUCCESS_TAG;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Catatan Gagal Disimpan"
                                                        message:@"Mohon dicek kembali data catatan"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }

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
    
//    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
//    scheduleDate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
//    scheduleDate.delegate = self;
//    scheduleDate.btnSender = 1;
//    scheduleDate.msgDate = sender.currentTitle;
//    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:scheduleDate];
//    [popoverViewer setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        self.SIDate = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];

    
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

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    meetingDatePicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [meetingDatePicker setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == MEETING_NOTE_SUCCESS_TAG) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
