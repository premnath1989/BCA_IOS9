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

@interface EntitySPAJHeader : NSObject

    // VARIABLE

    @property (nonatomic, assign, readwrite) int intID;
    @property (nonatomic, copy, readwrite) NSString *stringName, *stringSocialNumber, *stringEApplicationNumber, *stringSPAJNumber, *stringProductID, *stringIllustrationID, *stringState, *stringCreatedBy, *stringUpdatedBy, *stringSubmittedBy;
    @property (nonatomic, copy, readwrite) NSDate *dateCreatedOn, *dateUpdatedOn, *dateSubmittedOn;

    // OBJECT

    @property (nonatomic, copy, readwrite) Validation *objectValidation;

    - (id)initialize:
                                   intID
                      stringName : (NSString*) stringName
              stringSocialNumber : (NSString*) stringSocialNumber
        stringEApplicationNumber : (NSString*) stringEApplicationNumber
                stringSPAJNumber : (NSString*) stringSPAJNumber
                 stringProductID : (NSString*) stringProductID
            stringIllustrationID : (NSString*) stringIllustrationID
                 stringCreatedBy : (NSString*) stringCreatedBy
                   dateCreatedOn : (NSDate*) dateCreatedOn
                 stringUpdatedBy : (NSString*) stringUpdatedBy
                   dateUpdatedOn : (NSDate*) dateUpdatedOn
               stringSubmittedBy : (NSString*) stringSubmittedBy
                 dateSubmittedOn : (NSDate*) dateSubmittedOn
                     stringState : (NSString*) stringState;

@end