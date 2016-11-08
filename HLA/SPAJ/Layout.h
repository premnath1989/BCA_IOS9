//
//  TextFieldPrimary.h
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// DECLARATION

    // NAVIGATION

    @interface ViewNavigation : UIView

        - (void)setupStyle;

    @end

    @interface StackViewNavigation : UIStackView

        - (void)setupStyle;

    @end

    @interface ViewGuideDetail : UIView

        - (void)setupStyle;

    @end

    // PAGE

    @interface ViewPageHeader : UIView

        - (void)setupStyle;

    @end

    @interface ViewPageSubHeader : UIView

        - (void)setupStyle;

    @end

    // FORM

    @interface StackViewFormColumn : UIStackView

        - (void)setupStyle;

    @end

    @interface StackViewFormHorizontal : UIStackView

        - (void)setupStyle;

    @end

    @interface StackViewFormVertical : UIStackView

        - (void)setupStyle;

    @end

    // GUIDE

    @interface ViewGuideMenuSelected : UIView

        - (void)setupStyle;

    @end

    @interface ViewGuideMenuNotSelected : UIView

        - (void)setupStyle;

    @end

    @interface StackViewGuideMenuContainer : UIStackView

        - (void)setupStyle;

    @end

    @interface StackViewGuideMenuVertical : UIStackView

        - (void)setupStyle;

    @end

    @interface StackViewGuideMenuHorizontal : UIStackView

        - (void)setupStyle;

    @end


    //  TABLE

    @interface StackViewTableHorizontal : UIStackView

        - (void)setupStyle;

    @end

    @interface TableViewGeneral : UITableView

        - (void)setupStyle;

    @end