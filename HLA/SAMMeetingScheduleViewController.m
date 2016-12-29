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

@interface SAMMeetingScheduleViewController ()<DateViewControllerDelegate,TimeViewControllerDelegate>{
    DateViewController *scheduleDate;
    TimeViewController *scheduleTime;
    UIPopoverController *popoverViewer;
}

@end

@implementation SAMMeetingScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scheduleDate = [[DateViewController alloc]init];
    scheduleTime = [[TimeViewController alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //scheduleTime.btnSender = 1;
    //scheduleTime.msgDate = sender.currentTitle;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:scheduleTime];
    [popoverViewer setPopoverContentSize:CGSizeMake(540.0f, 294.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)actionSaveSchedule:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
