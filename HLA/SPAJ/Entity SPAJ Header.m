//
//  User.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Entity SPAJ Header.h"
#import "Validation.h"


// DECLARATION

@implementation EntitySPAJHeader

    // INITIALIZE

    - (id)initialize:(id)intID stringName:(NSString *)stringName stringSocialNumber:(NSString *)stringSocialNumber stringEApplicationNumber:(NSString *)stringEApplicationNumber stringSPAJNumber:(NSString *)stringSPAJNumber stringProductID:(NSString *)stringProductID stringIllustrationID:(NSString *)stringIllustrationID stringCreatedBy:(NSString *)stringCreatedBy dateCreatedOn:(NSDate *)dateCreatedOn stringUpdatedBy:(NSString *)stringUpdatedBy dateUpdatedOn:(NSDate *)dateUpdatedOn stringSubmittedBy:(NSString *)stringSubmittedBy dateSubmittedOn:(NSDate *)dateSubmittedOn stringState:(NSString *)stringState
    {
        if ([super init])
        {
            _intID = intID;
            _stringName = stringName;
            _stringSocialNumber = stringSocialNumber;
            _stringEApplicationNumber = stringEApplicationNumber;
            _stringSPAJNumber = stringSPAJNumber;
            _stringProductID = stringProductID;
            _stringIllustrationID = stringIllustrationID;
            _stringCreatedBy = stringCreatedBy;
            _dateCreatedOn = dateCreatedOn;
            _stringUpdatedBy = stringUpdatedBy;
            _dateUpdatedOn = dateUpdatedOn;
            _stringSubmittedBy = stringSubmittedBy;
            _dateSubmittedOn = dateSubmittedOn;
            _stringState = stringState;
        }
        else
        {
            
        }
        
        return self;
    }

@end