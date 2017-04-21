//
//  SAMMeetingScheduleViewController.m
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMMeetingScheduleViewController.h"
#import "DateViewController.h"
#import "TimeViewController.h"
#import "AppDelegate.h"
#import "SAMModel.h"

@interface SAMMeetingScheduleViewController ()<DateViewControllerDelegate,TimeViewControllerDelegate>{
    DateViewController *scheduleDate;
    TimeViewController *scheduleTime;
    UIPopoverController *popoverViewer;
}

@end

AppDelegate *appDel;
SAMModel *data;

@implementation SAMMeetingScheduleViewController

@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    scheduleDate = [[DateViewController alloc]init];
    scheduleTime = [[TimeViewController alloc]init];
    
    textComment.layer.borderWidth = 1.0f;
    textComment.layer.borderColor = [[UIColor blackColor] CGColor];
    
    dbHelper = [[SAMDBHelper alloc] init];
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    data = appDel.SAMData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionDateMeeting:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
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
    //scheduleTime.btnSender = 1;
    //scheduleTime.msgDate = sender.currentTitle;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:scheduleTime];
    [popoverViewer setPopoverContentSize:CGSizeMake(540.0f, 294.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)actionSaveSchedule:(id)sender{
    if(![buttonDate.titleLabel.text containsString:@"Please Select"]) {
        data.dateNextMeeting = [NSString stringWithFormat:@"%@ %@", buttonDate.titleLabel.text, buttonTime.titleLabel.text];
        if([dbHelper UpdateSAMData:data]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meeting Berhasil Dijadwalkan"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gagal Menjadwalkan Meeting, Mohon Hubungi Kantor"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];

        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Harap Mengisi Tanggal Meeting"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

-(IBAction)actionDismissSchedule:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    [buttonDate setTitle:aDate forState:UIControlStateNormal];
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)timePick:(TimeViewController *)inController strTime:(NSString *)aTime{
    [buttonTime setTitle:aTime forState:UIControlStateNormal];
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    [buttonDate setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
