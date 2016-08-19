//
//  SPAJIDCapturedViewController.h
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAJIDCapturedViewController : UIViewController{
    IBOutlet UIImageView* imageViewFront;
    IBOutlet UIImageView* imageViewBack;
    IBOutlet UILabel* labelName;
    IBOutlet UILabel* labelIDDesc;
}

-(void)loadIDInformation;
@property (strong, nonatomic) NSDictionary* dictionaryIDData;

@end
