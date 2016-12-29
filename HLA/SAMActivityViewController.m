//
//  SAMActivityViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityViewController.h"
#import "SAMMeetingScheduleViewController.h"

@interface SAMActivityViewController (){
    SAMMeetingScheduleViewController* samMeetingScheduleVC;
}

@end

@implementation SAMActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCircleAndBorderView];
    samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc]initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCircleAndBorderView{
    
    for (UIView *view in viewActivitySteps.subviews){
        if ([view isKindOfClass:[UIView class]]){
            view.layer.cornerRadius = view.bounds.size.width/2;
            for (UIView *viewInner in view.subviews){
                viewInner.layer.cornerRadius = viewInner.bounds.size.width/2;
            }
        }
    }
    
    viewActivityComments.layer.borderWidth = 1.0;
    viewActivityComments.layer.borderColor = [UIColor colorWithRed:137.0/255.0 green:199.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
}

-(IBAction)actionScheduleMeeting:(id)sender{
    [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
    samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
    [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
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
