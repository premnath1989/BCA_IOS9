//
//  ModelSPAJTransaction.m
//  BLESS
//
//  Created by Basvi on 7/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJTransaction.h"


@implementation ModelSPAJTransaction

-(void)saveSPAJTransaction:(NSDictionary *)spajTransactionDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into SPAJTransaction (SPAJID,SPAJEappNumber,SPAJNumber,SPAJSINO, SPAJDateCreated,CreatedBy,SPAJDateModified,ModifiedBy,SPAJStatus) values (?,?,?,?,?,?,?,?,?)" ,
                    [spajTransactionDictionary valueForKey:@"SPAJID"],
                    [spajTransactionDictionary valueForKey:@"SPAJEappNumber"],
                    [spajTransactionDictionary valueForKey:@"SPAJNumber"],
                    [spajTransactionDictionary valueForKey:@"SPAJSINO"],
                    [spajTransactionDictionary valueForKey:@"SPAJDateCreated"],
                    [spajTransactionDictionary valueForKey:@"CreatedBy"],
                    [spajTransactionDictionary valueForKey:@"SPAJDateModified"],
                    [spajTransactionDictionary valueForKey:@"ModifiedBy"],
                    [spajTransactionDictionary valueForKey:@"SPAJStatus"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJTransaction:(NSString *)stringColumnName StringColumnValue:(NSString *)stringColumnValue StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJTransaction set %@ = '%@'  where %@ = '%@'",
                    stringColumnName,
                    stringColumnValue,
                    stringWhereName,
                    stringWhereValue]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(NSString *)getSPAJTransactionData:(NSString *)stringColumnName StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue{
    NSString *returnValue;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJTransaction where %@ = '%@'",
                                            stringColumnName,
                                            stringWhereName,
                                            stringWhereValue]];
    
    while ([s next]) {
        returnValue = [s stringForColumn:stringColumnName];
    }
    [results close];
    [database close];
    return returnValue;
}



@end
