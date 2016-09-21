//
//  ButtonSPAJ.m
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ButtonSPAJ.h"

@implementation ButtonSPAJ
@synthesize buttonName;

-(void)setButtonName:(NSString *)stringButtonName{
    buttonName = stringButtonName;
}

-(NSString *)getButtonName{
    return buttonName;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
