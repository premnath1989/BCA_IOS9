//
//  TimeViewController.h
//  BLESS
//
//  Created by Basvi on 12/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Formatter.h"

@class TimeViewController;
@protocol TimeViewControllerDelegate
-(void)timePick:(TimeViewController *)inController strTime:(NSString *)aTime;
@end

@interface TimeViewController : UIViewController{
    Formatter *formatter;
    id <TimeViewControllerDelegate> _delegate;
}
@property (retain, nonatomic) IBOutlet UIDatePicker *timePickerView;
@property (weak, nonatomic) IBOutlet UITextField *outletTextHour;
@property (weak, nonatomic) IBOutlet UITextField *outletTextMinute;
@property (weak, nonatomic) IBOutlet UITextField *outletTextSecond;

@property (nonatomic, strong) id <TimeViewControllerDelegate> delegate;
@property int btnSender;


@end
