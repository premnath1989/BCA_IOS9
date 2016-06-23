//
//  User.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "User.h"
#import "Validation.h"


// DECLARATION

@implementation User

    // INITIALIZE

    - (id)initialize:(NSString *)stringUserCode stringUserPassword:(NSString *)stringUserPassword stringUserLevel:(NSString *)stringUserLevel stringEmail:(NSString *)stringEmail booleanState:(BOOL)booleanState
    {
        if ([super init])
        {
            _stringUserCode = stringUserCode;
            _stringUserPassword = stringUserPassword;
            _stringUserLevel = stringUserLevel;
            _stringEmail = stringEmail;
            _booleanState = booleanState;
            _objectValidation = [[Validation alloc]init];
        }
        else
        {
            
        }
        
        
        return self;
    }


    // FUNCTION  

    - (Boolean)validation
    {
        NSLog(@"Object user | user code : %@", _stringUserCode);
        NSLog(@"Object user | user password : %@", _stringUserPassword);
        NSLog(@"Object user | user level : %@", _stringUserLevel);
        NSLog(@"Object user | user email : %@", _stringEmail);
        NSLog(@"Object user | user state : %hhu", _booleanState);
        
        if ([_objectValidation stringFormatAlphaNumeric:_stringUserCode] == false)
        {
            NSLog(@"User | validation, user code must be alphanumeric.");
            return false;
        }
        else if ([_objectValidation stringFormatNumeric:_stringUserPassword] == false)
        {
            NSLog(@"User | validation, user password must be numeric.");
            return false;
        }
        else if ([_objectValidation stringLengthRange:_stringUserCode intMin:RULE_USERCODE_MINLENGTH intMax:RULE_USERCODE_MAXLENGTH] == false)
        {
            NSLog(@"User | validation, user code length must be between 1 and 6 characters length.");
            return false;
        }
        else if ([_objectValidation stringLengthExact:_stringUserPassword intExact:RULE_USERPASSWORD_LENGTH] == false)
        {
            NSLog(@"User | validation, user password length must be 6 characters length.");
            return false;
        }
        else
        {
            NSLog(@"User | validation, success !.");
            return true;
        }
    }

@end