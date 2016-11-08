//
//  ModelCFFAnswers.m
//  BLESS
//
//  Created by Basvi on 6/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelCFFAnswers.h"

@implementation ModelCFFAnswers


-(void)deleteCFFAnswerByCFFTransID:(int)cffTransactionID{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"delete from CFFAnswers where CFFTransactionID = %i",cffTransactionID]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(int)getCFFAnswersCount:(int)intCFFTransactionID CFFSection:(NSString *)stringCFFSection{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM CFFAnswers cffa join CFFHtml cffh on cffa.CFFHtmlID = cffh.CFFHtmlID where cffa.CFFTransactionID = %i and cffh.CFFHtmlSection=\"%@\"",intCFFTransactionID,stringCFFSection]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(int)voidGetDuplicateRowID:(NSDictionary *)dictionaryCFFAnswers{
    int IndexNo;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select IndexNo from CFFAnswers where CustomerID=\"%@\" and CFFID=\"%@\" and CFFTransactionID=\"%@\" and elementID=\"%@\" and CFFHtmlID=\"%@\"",
        [dictionaryCFFAnswers valueForKey:@"CustomerID"],
        [dictionaryCFFAnswers valueForKey:@"CFFID"],
        [dictionaryCFFAnswers valueForKey:@"CFFTransactionID"],
        [dictionaryCFFAnswers valueForKey:@"elementID"],
        [dictionaryCFFAnswers valueForKey:@"CFFHtmlID"]]];
    
    while ([s next]) {
        IndexNo = [s intForColumn:@"IndexNo"];
    }
    
    [results close];
    [database close];
    return IndexNo;
}



@end
