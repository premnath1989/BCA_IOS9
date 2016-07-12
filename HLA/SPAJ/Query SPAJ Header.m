//
//  User.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Query SPAJ Header.h"
#import "String.h"


// DECLARATION

@implementation QuerySPAJHeader

    // GENERAL

     - (NSManagedObjectContext*) generateContext
    {
        NSManagedObjectContext* context = nil;
        id applicationDelegate = [[UIApplication sharedApplication] delegate];
        if ([applicationDelegate performSelector:@selector(managedObjectContext)])
            
        {
            context = [applicationDelegate managedObjectContext];
        }
        else
        {
            
        }
        
        _objectValidation = [[Validation alloc]init];
        
        return context;
    }

    - (NSManagedObject*) generateHeader : (NSManagedObjectContext*) context stringTableName : (NSString*) stringTableName
    {
        NSManagedObject* tableRow = [NSEntityDescription insertNewObjectForEntityForName: stringTableName inManagedObjectContext : context];
        
        return tableRow;
    }


    // SELECT

    - (NSArray*) selectAll
    {
        NSManagedObjectContext *managedObjectContext = [self generateContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TABLE_NAME_SPAJHEADER];
        NSMutableArray* queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        // NSLog(@"selectAll(%@) - Fetching.", TABLE_NAME_SPAJHEADER);
        // NSLog(@"selectAll(%@) - Fetching result = %@.", queryResult);
        
        return queryResult;
    }

    - (NSArray*) selectByState: (NSString*) stringState
    {
        NSManagedObjectContext *managedObjectContext = [self generateContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TABLE_NAME_SPAJHEADER];
        NSPredicate *predicateWhere = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@/%@/%@", COLUMN_SPAJHEADER_STATE, CHARACTER_DASH, COREDATA_EQUALS], stringState];
        fetchRequest.predicate = predicateWhere;
        NSMutableArray *queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        // NSLog(@"selectByState(%@) - Fetching.", TABLE_NAME_SPAJHEADER);
        // NSLog(@"selectByState(%@) - Fetching result = %@.", queryResult);
        
        return queryResult;
    }

    - (NSArray*) selectForEApplicationList:(NSString *)stringName stringEApplicationNumber:(NSString *)stringEApplicationNumber
    {
        // INITIALIZE
        
        NSManagedObjectContext *managedObjectContext = [self generateContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TABLE_NAME_SPAJHEADER];
        
        
        // BY STATE
        
        NSPredicate *predicateState1 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_STATE, COREDATA_EQUALS], SPAJHEADER_STATE_ONPROGRESS];
        
        NSPredicate *predicateState2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_STATE, COREDATA_EQUALS], SPAJHEADER_STATE_COMPLETED];
        
        NSPredicate *predicateWhere = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicateState1, predicateState2]];
        
        // BY NAME
        
        if ([_objectValidation stringLengthExact:stringName intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateName = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_NAME, COREDATA_CONTAINS], stringName];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateName, predicateWhere]];
        }
        
        // BY E APPLICATION NUMBER
        
        if([_objectValidation stringLengthExact:stringEApplicationNumber intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateEApplicationNumber = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_EAPPLICATIONNUMBER, COREDATA_CONTAINS], stringEApplicationNumber];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateEApplicationNumber, predicateWhere]];
        }
        
        
        // FETCHING
        
        fetchRequest.predicate = predicateWhere;
        NSMutableArray *queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        // NSLog(@"selectByState(%@) - Fetching.", TABLE_NAME_SPAJHEADER);
        // NSLog(@"selectByState(%@) - Fetching result = %@.", queryResult);
        
        return queryResult;
    }

    - (NSArray*) selectForExistingList:(NSString *)stringName stringSocialNumber:(NSString *)stringSocialNumber stringSPAJNumber:(NSString *)stringSPAJNumber
    {
        // INITIALIZE
        
        NSManagedObjectContext *managedObjectContext = [self generateContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TABLE_NAME_SPAJHEADER];
        
        
        // BY STATE
        
        NSPredicate *predicateWhere = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_STATE, COREDATA_EQUALS], SPAJHEADER_STATE_READY];
        
        // BY NAME
        
        if ([_objectValidation stringLengthExact:stringName intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateName = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_NAME, COREDATA_CONTAINS], stringName];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateName, predicateWhere]];
        }
        
        // BY SPAJ NUMBER
        
        if([_objectValidation stringLengthExact:stringSPAJNumber intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateSPAJNumber = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_EAPPLICATIONNUMBER, COREDATA_CONTAINS], stringSPAJNumber];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateSPAJNumber, predicateWhere]];
        }
        
        // BY SOCIAL NUMBER
        
        if ([_objectValidation stringLengthExact:stringSocialNumber intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateSocialNumber = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_SOCIALNUMBER, COREDATA_CONTAINS], stringSocialNumber];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateSocialNumber, predicateWhere]];
        }
        
        
        // FETCHING
        
        fetchRequest.predicate = predicateWhere;
        NSMutableArray *queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        // NSLog(@"selectByState(%@) - Fetching.", TABLE_NAME_SPAJHEADER);
        // NSLog(@"selectByState(%@) - Fetching result = %@.", queryResult);
        
        return queryResult;
    }

    - (NSArray*) selectForSubmittedList:(NSString *)stringName stringSocialNumber:(NSString *)stringSocialNumber stringSPAJNumber:(NSString *)stringSPAJNumber
    {
        // INITIALIZE
        
        NSManagedObjectContext *managedObjectContext = [self generateContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TABLE_NAME_SPAJHEADER];
        
        
        // BY STATE
        
        NSPredicate *predicateWhere = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_STATE, COREDATA_EQUALS], SPAJHEADER_STATE_SUBMITTED];
        
        // BY NAME
        
        if ([_objectValidation stringLengthExact:stringName intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateName = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_NAME, COREDATA_CONTAINS], stringName];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateName, predicateWhere]];
        }
        
        // BY SPAJ NUMBER
        
        if([_objectValidation stringLengthExact:stringSPAJNumber intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateSPAJNumber = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_EAPPLICATIONNUMBER, COREDATA_CONTAINS], stringSPAJNumber];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateSPAJNumber, predicateWhere]];
        }
        
        // BY SOCIAL NUMBER
        
        if ([_objectValidation stringLengthExact:stringSocialNumber intExact:0])
        {
            
        }
        else
        {
            NSPredicate *predicateSocialNumber = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@", COLUMN_SPAJHEADER_SOCIALNUMBER, COREDATA_CONTAINS], stringSocialNumber];
            
            predicateWhere = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateSocialNumber, predicateWhere]];
        }
        
        
        // FETCHING
        
        fetchRequest.predicate = predicateWhere;
        NSMutableArray *queryResult = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        // NSLog(@"selectByState(%@) - Fetching.", TABLE_NAME_SPAJHEADER);
        // NSLog(@"selectByState(%@) - Fetching result = %@.", queryResult);
        
        return queryResult;
    }

    // INSERT

    - (NSNumber*) generateID
    {
        int intID = [self selectAll].count;
        
        if(intID == 0)
        {
            intID = 1;
        }
        else
        {
            intID = intID + 1;
        }
        
        NSNumber *numberID = [NSNumber numberWithInteger:intID];
        
        return numberID;
    }

    - (void) insert:(EntitySPAJHeader *)entitySPAJHeader
    {
        NSManagedObjectContext *context = [self generateContext];
        NSManagedObject *tableRow = [self generateHeader:context stringTableName:TABLE_NAME_SPAJHEADER];
        
        [tableRow setValue:[self generateID] forKey:COLUMN_SPAJHEADER_ID];
        [tableRow setValue:entitySPAJHeader.stringName forKey:COLUMN_SPAJHEADER_NAME];
        [tableRow setValue:entitySPAJHeader.stringSocialNumber forKey:COLUMN_SPAJHEADER_SOCIALNUMBER];
        [tableRow setValue:entitySPAJHeader.stringEApplicationNumber forKey:COLUMN_SPAJHEADER_EAPPLICATIONNUMBER];
        [tableRow setValue:entitySPAJHeader.stringSPAJNumber forKey:COLUMN_SPAJHEADER_SPAJNUMBER];
        [tableRow setValue:entitySPAJHeader.stringProductID forKey:COLUMN_SPAJHEADER_PRODUCTID];
        [tableRow setValue:entitySPAJHeader.stringIllustrationID forKey:COLUMN_SPAJHEADER_ILLUSTRATIONID];
        [tableRow setValue:entitySPAJHeader.stringCreatedBy forKey:COLUMN_SPAJHEADER_CREATEDBY];
        [tableRow setValue:entitySPAJHeader.dateCreatedOn forKey:COLUMN_SPAJHEADER_CREATEDON];
        [tableRow setValue:entitySPAJHeader.stringUpdatedBy forKey:COLUMN_SPAJHEADER_UPDATEDBY];
        [tableRow setValue:entitySPAJHeader.dateUpdatedOn forKey:COLUMN_SPAJHEADER_UPDATEDON];
        [tableRow setValue:entitySPAJHeader.stringSubmittedBy forKey:COLUMN_SPAJHEADER_SUBMITTEDBY];
        [tableRow setValue:entitySPAJHeader.dateSubmittedOn forKey:COLUMN_SPAJHEADER_SUBMITTEDON];
        [tableRow setValue:entitySPAJHeader.stringState forKey:COLUMN_SPAJHEADER_STATE];
        
        NSError *error = nil;
        
        if (![context save:&error])
        {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"insert %@ - %@ %@ %@ %@", TABLE_NAME_SPAJHEADER, entitySPAJHeader.stringName, entitySPAJHeader.stringSocialNumber, entitySPAJHeader.stringProductID, entitySPAJHeader.stringState);
        }
    }

@end