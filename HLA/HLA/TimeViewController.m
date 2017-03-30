//
//  TimeViewController.m
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

@end

@implementation TimeViewController
@synthesize outletTextHour,outletTextMinute,outletTextSecond;
@synthesize timePickerView;
@synthesize btnSender;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    formatter = [[Formatter alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)donePressed:(id)sender{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [timeFormat stringFromDate: timePickerView.date];
    [_delegate timePick:self strTime:timeString];
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
