//
//  Rule.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Rule.h"


// IMPLEMENTATION

    // USER

    int const RULE_USERCODE_MINLENGTH = 1;
    int const RULE_USERCODE_MAXLENGTH = 6;
    int const RULE_USERPASSWORD_LENGTH = 6;


    // REGEX

    NSString *const REGEX_IS_ALPHANUMERIC = @"^[a-zA-Z0-9]*$";
    NSString *const REGEX_IS_NUMERIC = @"^[0-9]*$";
    NSString *const REGEX_IS_ALPHA = @"^[a-zA-Z]*$";
    NSString *const REGEX_IS_EMAIL = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
