//
//  User.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import "Validation.h"


// DECLARATION

@interface User : NSObject

    // VARIABLE

    @property (nonatomic, copy, readwrite) NSString *stringUserCode, *stringUserPassword, *stringUserLevel, *stringEmail;
    @property (nonatomic, assign, readwrite) Boolean booleanState;

    // OBJECT

    @property (nonatomic, copy, readwrite) Validation *objectValidation;

    - (id)initialize:
        (NSString*)stringUserCode
        stringUserPassword:(NSString*)stringUserPassword
        stringUserLevel:(NSString*)stringUserLevel
        stringEmail:(NSString*)stringEmail
        booleanState:(BOOL)booleanState;


    // FUNCTION

    - (Boolean)validation;

@end