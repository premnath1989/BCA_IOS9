//
//  SAMActivityViewController.h
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SAMModel.h"

@interface SAMActivityViewController : UIViewController{
    IBOutlet UIView* viewActivitySteps;
    IBOutlet UIView* viewActivityComments;
}

@property (strong, nonatomic) SAMModel *_SAMModel;

@end
