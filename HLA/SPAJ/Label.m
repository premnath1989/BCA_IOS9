//
//  TextFieldPrimary.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Label.h"
#import "Theme.h"
#import "Font Size.h"
#import "Dimension.h"
#import "User Interface.h"


// IMPLEMENTATION

    // NAVIGATION

    @implementation LabelPageTitle

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_TITLE]];
            self.textAlignment = NSTextAlignmentCenter;
            self.numberOfLines = 1;
        }

    @end

    @implementation LabelMenuHint

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_FIELD]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 1;
        }

    @end

    // NOTE

    @implementation LabelNoteHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:FIELD_WIDTH_MEDIUM].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_NOTE_HEADER]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelNoteDetail

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:NOTE_WIDTH_MEDIUM].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SEPTENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_NOTE_DETAIL]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelInformationHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_SECONDARY size:FONTSIZE_NOTE_HEADER]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelInformationDetail

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:NOTE_WIDTH_MEDIUM].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_NOTE_DETAIL]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    // FIELD

    @implementation LabelFieldShort

    // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:FIELD_WIDTH_SHORT].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_FIELD]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelFieldMedium

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:FIELD_WIDTH_MEDIUM].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_FIELD]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelFieldLong

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:FIELD_WIDTH_LONG].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_FORM_FIELD]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    // MENU

    @implementation LabelGuideMenuStep

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:48].active = true;
            [self.widthAnchor constraintEqualToConstant:48].active = true;
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_SECONDARY size:FONTSIZE_GUIDEMENU_STEP]];
            self.textAlignment = NSTextAlignmentCenter;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelGuideMenuHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_GUIDEMENU_HEADER]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelGuideMenuDetail

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_GUIDEMENU_DETAIL]];
            self.textAlignment = NSTextAlignmentLeft;
            self.numberOfLines = 4;
        }

    @end

    // TABLE

    @implementation ViewTableHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        }

    @end

    @implementation LabelTableHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_QUINARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_TABLE_HEADER]];
            self.textAlignment = NSTextAlignmentCenter;
            self.numberOfLines = 4;
        }

    @end

    @implementation LabelTableDetail

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self setTextColor : [objectUserInterface generateUIColor:THEME_COLOR_SENARY floatOpacity:1.0]];
            [self setFont : [UIFont fontWithName:THEME_FONT_PRIMARY size:FONTSIZE_TABLE_DETAIL]];
            self.textAlignment = NSTextAlignmentCenter;
            self.numberOfLines = 4;
        }

    @end