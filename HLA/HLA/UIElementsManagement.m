//
//  UIElementsManagement.m
//  BLESS
//
//  Created by Erwin on 12/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIElementsManagement.h"
#import "UIButton+Property.h"

@implementation UIElementsManagement

- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour font:(UIFont *)Font{
    ParentView = view;
    themeColour = Colour;
    themeFont = Font;
    return self;
}

- (void)setupUI{
    //set basic UI Elements design
    for (UIView *view in [ParentView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) [self designUITextField:(UITextField *)view];
        else if([view isKindOfClass:[UIButton class]]){
            UIButton *object =(UIButton *)view;
            switch(object.property){
                case 1:
                    [self designUIButton:(UIButton *)view];
                    break;
            }
        }
    }
}

- (void)designUITextField:(UITextField *)textField{
    textField.layer.borderColor = [themeColour CGColor];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1.0f;
    textField.font = themeFont;
}

- (void)designUIButton:(UIButton *)button{
    button.layer.borderColor = [themeColour CGColor];
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
}


@end
