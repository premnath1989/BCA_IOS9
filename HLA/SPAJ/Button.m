//
//  TextFieldPrimary.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Button.h"
#import "Theme.h"
#import "Font Size.h"
#import "User Interface.h"
#import "Dimension.h"


// IMPLEMENTATION

    // NAVIGATION

    @implementation ButtonNavigation

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:0.0];
            [self setTitleColor:[objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0] forState:UIControlStateNormal];
            [self.widthAnchor constraintEqualToConstant:BUTTON_NAVIGATION_WIDTH].active = true;
            [self.heightAnchor constraintEqualToConstant:BUTTON_NAVIGATION_HEIGHT].active = true;
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(ICON_SIZE_MEDIUM + GENERAL_PADDING_MEDIUM + (ICON_SIZE_MEDIUM / 4), -ICON_SIZE_MEDIUM, 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (BUTTON_NAVIGATION_WIDTH - ICON_SIZE_MEDIUM) / 2, 0, 0)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
            [self setClipsToBounds:false];
            [self.titleLabel setFont:[UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_NAVIGATION_BUTTON]];
            [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        }

    @end

    // FORM

    @implementation ButtonFormPrimary

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0];
            [self setTitleColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_BUTTON]];
        }

    @end

    // GUIDE

    @implementation ButtonGuideMenu

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:0.0];
            [self setTitle:@"" forState:UIControlStateNormal];
        }

    @end

    @implementation ButtonOverlay

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:0.0];
            [self setTitle:@"" forState:UIControlStateNormal];
        }

    @end

    @implementation ButtonConfirmSPAJ

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.heightAnchor constraintEqualToConstant:BUTTON_CONFIRMSPAJ_HEIGHT].active = true;
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_NONARY floatOpacity:1.0];
            [self setTitleColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont fontWithName:THEME_FONT_SECONDARY size:FONTSIZE_FORM_BUTTON]];
        }

    @end