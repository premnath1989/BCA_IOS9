//
//  ButtonSPAJ.h
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonSPAJ : UIButton
@property (weak, nonatomic) NSString* buttonName;

-(void)setButtonName:(NSString *)stringButtonName;
-(NSString *)getButtonName;

@end
