//
//  Rule.m
//  Practice
//
//  Created by Ibrahim on 20/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "String.h"


// IMPLEMENTATION

    // CHARACTER

    NSString* const CHARACTER_DASH = @" ";
    NSString* const CHARACTER_KRES = @"#";
    NSString* const CHARACTER_DOUBLEDOT = @" : ";

    // ENTITY

    NSString* const SPAJHEADER_PRODUCT_HERITAGE = @"Heritage";
    NSString* const SPAJHEADER_PRODUCT_KELUARGAKU = @"Keluargaku";
    NSString* const SPAJHEADER_STATE_PENDING = @"Pending";
    NSString* const SPAJHEADER_STATE_SUBMITTED = @"Submitted";
    NSString* const SPAJHEADER_STATE_COMPLETED = @"Completed";
    NSString* const SPAJHEADER_STATE_ONPROGRESS = @"On Progress";
    NSString* const SPAJHEADER_STATE_READY = @"Ready";

    // COREDATA

    NSString* const COREDATA_SEPARATOR = @" // ";
    NSString* const COREDATA_EQUALS = @" == %@";
    NSString* const COREDATA_CONTAINS = @" CONTAINS[cd] %@";

    NSString* const TABLE_NAME_SPAJHEADER = @"SPAJHeader";
    NSString* const COLUMN_SPAJHEADER_ID = @"id";
    NSString* const COLUMN_SPAJHEADER_NAME = @"name";
    NSString* const COLUMN_SPAJHEADER_SOCIALNUMBER = @"socialnumber";
    NSString* const COLUMN_SPAJHEADER_EAPPLICATIONNUMBER = @"eapplicationnumber";
    NSString* const COLUMN_SPAJHEADER_SPAJNUMBER = @"spajnumber";
    NSString* const COLUMN_SPAJHEADER_PRODUCTID = @"productid";
    NSString* const COLUMN_SPAJHEADER_ILLUSTRATIONID = @"illustrationid";
    NSString* const COLUMN_SPAJHEADER_CREATEDBY = @"createdby";
    NSString* const COLUMN_SPAJHEADER_CREATEDON = @"createdon";
    NSString* const COLUMN_SPAJHEADER_UPDATEDBY = @"updatedby";
    NSString* const COLUMN_SPAJHEADER_UPDATEDON = @"updatedon";
    NSString* const COLUMN_SPAJHEADER_SUBMITTEDBY = @"submittedby";
    NSString* const COLUMN_SPAJHEADER_SUBMITTEDON = @"submittedon";
    NSString* const COLUMN_SPAJHEADER_STATE = @"state";