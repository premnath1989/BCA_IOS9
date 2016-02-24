//
//  Constants.h
//  iMobile Planner
//
//  Created by CK Quek on 2/12/15.
//  Copyright (c) 2015 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

typedef enum {
    REPORT_UNDERWRITING = 0,
    REPORT_PDS,
    REPORT_SI,
    REPORT_GST
} REPORT_TYPE;

typedef enum {
    SIMENU_LIFEASSURED = 0,
    SIMENU_SECOND_LIFE_ASSURED,
    SIMENU_BASIC_PLAN,
    SIMENU_RIDER,
    SIMENU_PAYOR,
    SIMENU_HEALTH_LOADING,
    SIMENU_PREMIUM,
    SIMENU_QUOTATION,
    SIMENU_SUMMARY_QUOTATION,
    SIMENU_PRODUCT_DISCLOSURE_SHEET,
    SIMENU_UNDERWRITING,
    SIMENU_PDS_SAVE_AS,
    SIMENU_EXP_QUOTATION,
    SIMENU_EXP_PDS,
    SIMENU_GST
    
} SIMENU;

extern NSString* const STR_S100;
extern NSString* const STR_HLAWP;
extern NSString* const RELEASE_DATE;

extern const double annualRate;
extern const double semiAnnualRate;
extern const double quarterlyRate;
extern const double monthlyRate;

extern const double gstValue;

@end
