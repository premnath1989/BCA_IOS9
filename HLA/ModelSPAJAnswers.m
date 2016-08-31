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


@end
