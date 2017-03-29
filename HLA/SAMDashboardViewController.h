//
//  SAMDashboardViewController.h
//  BLESS
//
//  Created by Basvi on 12/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMDashboardViewController : UIViewController <UIAlertViewDelegate>{
    IBOutlet UIView *viewCircleOutside;
    IBOutlet UIView *viewCircleInnerSide;
    
    IBOutlet UIView *viewUpcomingAppointments;
    IBOutlet UIView *viewSubmitted;
}

-(void)actionActivityView;

@end
