//
//  ModelSPAJHtml.m
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJHtml.h"

@implementation ModelSPAJHtml

-(NSString *)selectHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection{
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection = \"%@\"",stringColumnName,stringHtmlSection]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
    }
    
    [results close];
    [database close];
    return stringReturn;
}

-(NSString *)selectHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection SPAJID:(int)spajID{
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection = \"%@\" and SPAJID = %i",stringColumnName,stringHtmlSection,spajID]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
    }
    
    [results close];
    [database close];
    return stringReturn;
}


-(NSArray *)selectArrayHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection{
    NSMutableArray* arrayHtmlFileName = [[NSMutableArray alloc]init];
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection = \"%@\"",stringColumnName,stringHtmlSection]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection in (\"%@\")",stringColumnName,stringHtmlSection]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
        [arrayHtmlFileName addObject:stringReturn];
    }
    
    [results close];
    [database close];
    return arrayHtmlFileName;
}

-(NSArray *)selectArrayHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection SPAJID:(int)spajID{
    NSMutableArray* arrayHtmlFileName = [[NSMutableArray alloc]init];
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection = \"%@\"",stringColumnName,stringHtmlSection]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJHtml where SPAJHtmlSection in (\"%@\") and SPAJID = %i",stringColumnName,stringHtmlSection,spajID]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
        [arrayHtmlFileName addObject:stringReturn];
    }
    
    [results close];
    [database close];
    return arrayHtmlFileName;
}

-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection{
    NSDictionary *dict;
    
    NSString* spajHtmlID;
    NSString* spajHtmlName;
    NSString* spajID;
    NSString* spajHtmlStatus;
    NSString* spajHtmlSection;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SPAJHtml where SPAJHtmlStatus = 'A' and SPAJHtmlSection = \"%@\"",htmlSection]];
    while ([s next]) {
        spajHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"SPAJHtmlID"]];
        spajID = [s stringForColumn:@"SPAJID"];
        spajHtmlName = [s stringForColumn:@"SPAJHtmlName"];
        spajHtmlStatus = [s stringForColumn:@"SPAJHtmlStatus"];
        spajHtmlSection = [s stringForColumn:@"SPAJHtmlSection"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          spajHtmlID,@"SPAJHtmlID",
          spajID,@"SPAJID",
          spajHtmlName,@"SPAJHtmlName",
          spajHtmlSection,@"SPAJHtmlSection",
          spajHtmlStatus,@"SPAJHtmlStatus",nil];
    
    
    [results close];
    [database close];
    return dict;
}

-(int)selectActiveHtmlSPAJID{
    int spajID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SPAJHtml where SPAJHtmlStatus = 'A' group by SPAJHtmlStatus"]];
    while ([s next]) {
        //spajHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"SPAJHtmlID"]];
        spajID = [s intForColumn:@"SPAJID"];
        //spajHtmlName = [s stringForColumn:@"SPAJHtmlName"];
        //spajHtmlStatus = [s stringForColumn:@"SPAJHtmlStatus"];
        //spajHtmlSection = [s stringForColumn:@"SPAJHtmlSection"];
    }
    
    [results close];
    [database close];
    return spajID;
}

@end
