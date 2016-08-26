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
-(void)loadIDImage:(UIImage *)imageFront ImageBack:(UIImage *)imageBack;
@property (strong, nonatomic) NSDictionary* dictionaryIDData;
@property (strong, nonatomic) UIImage* imageFront;
@property (strong, nonatomic) UIImage* imageBack;

@end
