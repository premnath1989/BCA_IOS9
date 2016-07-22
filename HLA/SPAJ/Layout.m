//
//  TextFieldPrimary.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Layout.h"
#import "Theme.h"
#import "User Interface.h"
#import "Dimension.h"


// IMPLEMENTATION

    // NAVIGATION

    @implementation ViewNavigation

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:NAVIGATION_CONTAINER_WIDTH].active = true;
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        }

    @end

    @implementation StackViewNavigation

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            [self.widthAnchor constraintEqualToConstant:NAVIGATION_CONTAINER_WIDTH].active = true;
            
            self.axis = UILayoutConstraintAxisVertical;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentCenter;
            // self.spacing = FORM_STACKVIEW_VERTICALSPACING;
        }

    @end

    @implementation ViewGuideDetail

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.widthAnchor constraintEqualToConstant:GUIDEDETAIL_CONTAINER_WIDTH].active = true;
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_TERTIARY floatOpacity:1.0];
        }

    @end

    // PAGE

    @implementation ViewPageHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            [self.heightAnchor constraintEqualToConstant:PAGE_HEADER_HEIGHT].active = true;
            
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_QUATERNARY floatOpacity:1.0];
            
            self.clipsToBounds = YES;
            CALayer *layerBorderBottom = [CALayer layer];
            layerBorderBottom.borderColor = [objectUserInterface generateUIColor:THEME_COLOR_TERTIARY floatOpacity:1.0].CGColor;
            layerBorderBottom.borderWidth = PAGE_HEADER_BORDERWIDTH;
            layerBorderBottom.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), PAGE_HEADER_BORDERWIDTH);
            [self.layer addSublayer:layerBorderBottom];
        }

    @end

    @implementation ViewPageSubHeader

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            [self.heightAnchor constraintEqualToConstant:PAGE_SUBHEADER_HEIGHT].active = true;
            
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_NONARY floatOpacity:1.0];
        }

    @end

    // FORM

    @implementation StackViewFormColumn

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisHorizontal;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentCenter;
            self.spacing = FORM_STACKVIEWCOLUMN_HORIZONTALSPACING;
        }

    @end

    @implementation StackViewFormHorizontal

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisHorizontal;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentCenter;
            self.spacing = FORM_STACKVIEW_HORIZONTALSPACING;
        }

    @end

    @implementation StackViewFormVertical

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisVertical;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentLeading;
            self.spacing = FORM_STACKVIEW_VERTICALSPACING;
        }

    @end

    // GUIDE

    @implementation ViewGuideMenuSelected

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.heightAnchor constraintEqualToConstant:GUIDEMENU_CONTAINER_HEIGHT].active = true;
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        }

        @end

    @implementation ViewGuideMenuNotSelected

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface *objectUserInterface = [[UserInterface alloc] init];
            
            [self.heightAnchor constraintEqualToConstant:GUIDEMENU_CONTAINER_HEIGHT].active = true;
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_OCTONARY floatOpacity:1.0];
        }

    @end

    @implementation StackViewGuideMenuContainer

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisVertical;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentLeading;
        }

    @end

    @implementation StackViewGuideMenuHorizontal

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisHorizontal;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentCenter;
            self.spacing = GUIDEMENU_STACKVIEW_HORIZONTALSPACING;
        }

    @end

    @implementation StackViewGuideMenuVertical

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisVertical;
            self.distribution = UIStackViewDistributionFill;
            self.alignment = UIStackViewAlignmentLeading;
            self.spacing = GUIDEMENU_STACKVIEW_VERTICALSPACING;
        }

    @end

    // TABLE

    @implementation StackViewTableHorizontal

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            self.axis = UILayoutConstraintAxisHorizontal;
            self.distribution = UIStackViewDistributionFillEqually;
            self.alignment = UIStackViewAlignmentFill;
            self.spacing = TABLE_STACKVIEW_SPACING;
            
            [self.heightAnchor constraintEqualToConstant:TABLE_HEADER_HEIGHT].active = true;
        }

    @end

    @implementation TableViewGeneral

        // INITIALIZE

        - (void)awakeFromNib
        {
            [self setupStyle];
        }


        // FUNCTION

        - (void)setupStyle
        {
            UserInterface* objectUserInterface = [[UserInterface alloc] init];
            self.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:0.0];
            
            self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.separatorColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
            self.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
        }

    @end