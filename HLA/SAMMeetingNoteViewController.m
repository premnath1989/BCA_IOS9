//
//  SAMMeetingNoteViewController.m
//  BLESS
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMMeetingNoteViewController.h"

@interface SAMMeetingNoteViewController ()

@end

@implementation SAMMeetingNoteViewController

@synthesize meetingDatePicker;
@synthesize meetingTimePicker;
@synthesize txtMeetingWhere;
@synthesize txtMeetingStatus;
@synthesize txtMeetingActivity;
@synthesize txtMeetingComment;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtMeetingComment.layer.borderWidth = 5.0f;
    txtMeetingComment.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
