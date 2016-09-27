//
//  TextViewSPAJ.m
//  BLESS
//
//  Created by Basvi on 9/23/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "TextViewSPAJ.h"

@implementation TextViewSPAJ
@synthesize textViewName;

-(void)setTextViewName:(NSString *)stringTextViewName{
    textViewName = stringTextViewName;
}

-(NSString *)getTextViewName{
    return textViewName;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
