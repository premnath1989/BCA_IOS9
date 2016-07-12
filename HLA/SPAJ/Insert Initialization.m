//
//  User.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Insert Initialization.h"
#import "Query SPAJ Header.h"
#import "String.h"
#import "Entity SPAJ Header.h"


// DECLARATION

@implementation InsertInitialization

    // GENERAL

    - (void) initializeSPAJHeader
    {
        QuerySPAJHeader *querySPAJHeader = [[QuerySPAJHeader alloc]init];
        NSArray *selectSPAJHeader = querySPAJHeader.selectAll;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"]; // for example
        
        
        NSArray *arraySPAJHeader =
        [
            NSArray arrayWithObjects:
         
            [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Andy Phan", COREDATA_SEPARATOR, @"1234567890", COREDATA_SEPARATOR,
                @"RN1234567890", COREDATA_SEPARATOR, @"", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"26-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"27-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"28-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_ONPROGRESS],
            [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Erwin Lim", COREDATA_SEPARATOR, @"9876543210", COREDATA_SEPARATOR,
                @"RN9876543210", COREDATA_SEPARATOR, @"", COREDATA_SEPARATOR,
                @"PR002", COREDATA_SEPARATOR, @"IL002", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"27-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"28-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"29-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_ONPROGRESS],
            [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Faiz Baraja", COREDATA_SEPARATOR, @"2345678901", COREDATA_SEPARATOR,
                @"RN2345678901", COREDATA_SEPARATOR, @"", COREDATA_SEPARATOR,
                @"PR003", COREDATA_SEPARATOR, @"IL003", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"25-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"26-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"27-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_COMPLETED],
            [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Premnath Vijayakumar", COREDATA_SEPARATOR, @"3456789012", COREDATA_SEPARATOR,
                @"RN3456789012", COREDATA_SEPARATOR, @"3456789012", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"24-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"25-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"26-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_READY],
            [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Satria Karima", COREDATA_SEPARATOR, @"4567890123", COREDATA_SEPARATOR,
                @"RN4567890123", COREDATA_SEPARATOR, @"4567890123", COREDATA_SEPARATOR,
                @"PR002", COREDATA_SEPARATOR, @"IL002", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"23-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"24-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"25-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_READY],
             [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Yosi Olivaer", COREDATA_SEPARATOR, @"5678901234", COREDATA_SEPARATOR,
                @"RN5678901234", COREDATA_SEPARATOR, @"5678901234", COREDATA_SEPARATOR,
                @"PR003", COREDATA_SEPARATOR, @"IL003", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"22-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"23-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"24-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_READY],
             [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Aditya Nugraha", COREDATA_SEPARATOR, @"6789012345", COREDATA_SEPARATOR,
                @"RN6789012345", COREDATA_SEPARATOR, @"6789012345", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"21-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"22-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"23-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_SUBMITTED],
             [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Raymond Nugroho", COREDATA_SEPARATOR, @"7890123456", COREDATA_SEPARATOR,
                @"RN7890123456", COREDATA_SEPARATOR, @"7890123456", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"20-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"21-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"22-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_SUBMITTED],
             [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Rudy", COREDATA_SEPARATOR, @"8901234567", COREDATA_SEPARATOR,
                @"RN8901234567", COREDATA_SEPARATOR, @"8901234567", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"19-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"20-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"21-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_SUBMITTED],
             [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                @"Lala Isman", COREDATA_SEPARATOR, @"9012345678", COREDATA_SEPARATOR,
                @"RN9012345678", COREDATA_SEPARATOR, @"9012345678", COREDATA_SEPARATOR,
                @"PR001", COREDATA_SEPARATOR, @"IL001", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"19-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"20-06-2016", COREDATA_SEPARATOR,
                @"EM001", COREDATA_SEPARATOR, @"28-06-2016", COREDATA_SEPARATOR,
                SPAJHEADER_STATE_SUBMITTED]
         , nil];
        
        NSLog(@"SPAJ Header array 0 = %@", arraySPAJHeader[0]);
        NSLog(@"SPAJ Header count %i", selectSPAJHeader.count);
        
        if (selectSPAJHeader.count == 0)
        {
            NSLog(@"SPAJ Header count %i", selectSPAJHeader.count);
            
            for(int i = 0; i < arraySPAJHeader.count; i ++)
            {
                NSArray *arrayContent = [arraySPAJHeader[i] componentsSeparatedByString:COREDATA_SEPARATOR];
                NSDate *dateCreatedOn = [dateFormatter dateFromString:arrayContent[7]];
                NSDate *dateUpdatedOn = [dateFormatter dateFromString:arrayContent[9]];
                NSDate *dateSubmittedOn = [dateFormatter dateFromString:arrayContent[11]];
                
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[0]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[1]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[2]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[3]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[4]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[5]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[6]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[7]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[8]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[9]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[10]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[11]);
                NSLog(@"SPAJ Header arrayContent %i = %@", i, arrayContent[12]);
                
                EntitySPAJHeader* entitySPAJHeader = [EntitySPAJHeader alloc];
                entitySPAJHeader.stringName = arrayContent[0];
                entitySPAJHeader.stringSocialNumber = arrayContent[1];
                entitySPAJHeader.stringEApplicationNumber = arrayContent[2];
                entitySPAJHeader.stringSPAJNumber = arrayContent[3];
                entitySPAJHeader.stringProductID = arrayContent[4];
                entitySPAJHeader.stringIllustrationID = arrayContent[5];
                entitySPAJHeader.stringCreatedBy = arrayContent[6];
                entitySPAJHeader.dateCreatedOn = dateCreatedOn;
                entitySPAJHeader.stringUpdatedBy = arrayContent[8];
                entitySPAJHeader.dateUpdatedOn = dateUpdatedOn;
                entitySPAJHeader.stringSubmittedBy = arrayContent[10];
                entitySPAJHeader.dateSubmittedOn = dateSubmittedOn;
                entitySPAJHeader.stringState = arrayContent[12];
                
                [querySPAJHeader insert:entitySPAJHeader];
            }
        }
        else
        {
            
        }
    }

@end