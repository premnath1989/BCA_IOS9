//
//  SAMDashboardViewController.h
//  BLESS
//
//  Created by Basvi on 12/20/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProspectViewController.h"

@interface SAMDashboardViewController : UIViewController <UIAlertViewDelegate, ProspectViewControllerDelegate>{
    IBOutlet UIView *viewCircleOutside;
    IBOutlet UIView *viewCircleInnerSide;
    
    IBOutlet UIView *viewUpcomingAppointments;
    IBOutlet UIView *viewSubmitted;
    
    ProspectViewController *prospectVC;
}

-(void)actionActivityView;

@end
