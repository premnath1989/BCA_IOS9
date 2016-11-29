//
//  ModelSPAJAnswers.m
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJAnswers.h"

@implementation ModelSPAJAnswers
-(int)voidGetDuplicateRowID:(NSDictionary *)dictionaryCFFAnswers{
    int IndexNo = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select IndexNo from SPAJAnswers where SPAJTransactionID=\"%@\" and elementID=\"%@\" and SPAJHtmlID=\"%@\"",
                                             [dictionaryCFFAnswers valueForKey:@"SPAJTransactionID"],
                                             [dictionaryCFFAnswers valueForKey:@"elementID"],
                                             [dictionaryCFFAnswers valueForKey:@"SPAJHtmlID"]]];
    
    while ([s next]) {
        IndexNo = [s intForColumn:@"IndexNo"];
    }
    
    [results close];
    [database close];
    return IndexNo;
}

-(NSString *)selectSPAJAnswersData:(NSString *)stringColumnName StringWhere:(NSString *)stringWhere{
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJAnswers %@",stringColumnName,stringWhere]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
    }
    
    [results close];
    [database close];
    return stringReturn;
}

-(void)deleteSPAJAnswers:(NSString *)stringWhereValue{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"delete from SPAJAnswers %@",stringWhereValue]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(int)selectSPAJIDActiveHtml{
    int spajID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select SPAJID from SPAJHtml where SPAJHtmlStatus = 'A'"]];
    while ([s next]) {
        spajID = [s intForColumn:@"SPAJID"];
    }
    
    [results close];
    [database close];
    return spajID;
}


-(int)getCountElementID:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection{
    int spajID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(elementID) as Count  from SPAJAnswers where SPAJHtmlSection in ('KS_PH','KS_IN') and SPAJTransactionID = %i and elementID like \"%%%@%%\"",spajTransactionID,stringElementName]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(elementID) as Count  from SPAJAnswers where SPAJHtmlSection ='%@' and SPAJTransactionID = %i and elementID like \"%%%@%%\"",stringSection,spajTransactionID,stringElementName]];
    while ([s next]) {
        spajID = [s intForColumn:@"Count"];
    }
    
    [results close];
    [database close];
    return spajID;
}

-(int)getCountElementIDForeigner:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection{
    NSString* value;
    int spajID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select Value  from SPAJAnswers where SPAJHtmlSection ='%@' and SPAJTransactionID = %i and elementID like \"%%%@%%\"",stringSection,spajTransactionID,stringElementName]];
    while ([s next]) {
        value = [s stringForColumn:@"Value"];
    }
    
    if ([value isEqualToString:@"false"]){
        spajID = 0;
    }
    else{
        spajID = 1;
    }
    
    [results close];
    [database close];
    return spajID;
}

-(NSMutableArray *)getSPAJAnswerValue:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection{
    NSMutableArray* spajValueArray = [[NSMutableArray alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(elementID) as Count  from SPAJAnswers where SPAJHtmlSection in ('KS_PH','KS_IN') and SPAJTransactionID = %i and elementID like \"%%%@%%\"",spajTransactionID,stringElementName]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select Value from SPAJAnswers where SPAJHtmlSection ='%@' and SPAJTransactionID = %i and elementID = \"%@\"",stringSection,spajTransactionID,stringElementName]];
    while ([s next]) {
        [spajValueArray addObject:[s stringForColumn:@"Value"]];
    }
    
    [results close];
    [database close];
    return spajValueArray;
}

-(NSMutableArray *)getSPAJAnswerElementValue:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection{
    NSMutableArray* spajValueArray = [[NSMutableArray alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(elementID) as Count  from SPAJAnswers where SPAJHtmlSection in ('KS_PH','KS_IN') and SPAJTransactionID = %i and elementID like \"%%%@%%\"",spajTransactionID,stringElementName]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select elementID,Value from SPAJAnswers where SPAJHtmlSection ='%@' and SPAJTransactionID = %i and elementID like \"%%%@%%\"",stringSection,spajTransactionID,stringElementName]];
    while ([s next]) {
        NSMutableDictionary* tempRevertRadioButtonDict = [[NSMutableDictionary alloc]init];
        [tempRevertRadioButtonDict setObject:[s stringForColumn:@"elementID"] forKey:@"elementID"];
        [tempRevertRadioButtonDict setObject:[s stringForColumn:@"Value"] forKey:@"Value"];
        [spajValueArray addObject:tempRevertRadioButtonDict];
    }
    
    [results close];
    [database close];
    return spajValueArray;
}

@end
