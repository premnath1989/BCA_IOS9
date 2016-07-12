//
//  User.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entity SPAJ Header.h"
#import "Validation.h"


// DECLARATION

@interface QuerySPAJHeader : NSObject

    // OBJECT

    @property (nonatomic, copy, readwrite) Validation *objectValidation;


    // GENERAL

    - (NSManagedObjectContext*) generateContext;

    - (NSManagedObject*) generateHeader : (NSManagedObjectContext*) context stringTableName : (NSString*) stringTableName;

    // SELECT

    - (NSArray*) selectAll;

    - (NSArray*) selectByState : (NSString*) stringState;

    - (NSArray*) selectForEApplicationList : (NSString*) stringName stringEApplicationNumber : (NSString*) stringEApplicationNumber;

    - (NSArray*) selectForExistingList : (NSString*) stringName stringSocialNumber : (NSString*) stringSocialNumber stringSPAJNumber : (NSString*) stringSPAJNumber;

    - (NSArray*) selectForSubmittedList : (NSString*) stringName stringSocialNumber : (NSString*) stringSocialNumber stringSPAJNumber : (NSString*) stringSPAJNumber;

    // INSERT

    - (NSNumber*) generateID;

    - (void) insert : (EntitySPAJHeader*) entitySPAJHeader;


@end