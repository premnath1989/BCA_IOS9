//
//  TextFieldPrimary.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Input.h"
#import "Theme.h"
#import "Dimension.h"
#import "User Interface.h"


// IMPLEMENTATION

@implementation TextFieldPrimary

    // INITIALIZE

    - (void)awakeFromNib
    {
        [self setupStyle];
    }


    // FUNCTION

    - (void)setupStyle
    {
        UserInterface* objectUserInterface = [[UserInterface alloc] init];
        
        [self.widthAnchor constraintEqualToConstant:TEXTFIELD_WIDTH_MEDIUM].active = true;
        [self.heightAnchor constraintEqualToConstant:TEXTFIELD_HEIGHT_SINGLE].active = true;
        
        [self setContentVerticalAlignment : UIControlContentVerticalAlignmentCenter];
        [self setTextAlignment : NSTextAlignmentLeft];
        self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:0.0];
        self.borderStyle = UITextBorderStyleLine;
        self.layer.borderWidth = INPUT_BORDER_WIDTH;
        self.layer.borderColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0].CGColor;

        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }

@end