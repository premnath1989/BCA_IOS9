//
//  TextFieldSPAJ.m
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "TextFieldSPAJ.h"

@implementation TextFieldSPAJ
@synthesize textFieldName;

-(void)setTextFieldName:(NSString *)stringTextFieldName{
    textFieldName = stringTextFieldName;
}

-(NSString *)getTextFieldName{
    return textFieldName;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
