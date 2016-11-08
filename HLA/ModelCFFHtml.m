//
//  CFFHtml.m
//  BLESS
//
//  Created by Basvi on 6/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelCFFHtml.h"

@implementation ModelCFFHtml

-(void)saveHtmlData:(NSDictionary *)dictHtmlData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into CFFHtml (CFFID, CFFHtmlName, CFFHtmlStatus, CFFHtmlSection) values (?,?,?,?)" ,
                    [dictHtmlData valueForKey:@"CFFID"],
                    [dictHtmlData valueForKey:@"CFFHtmlName"],
                    [dictHtmlData valueForKey:@"CFFHtmlStatus"],
                    [dictHtmlData valueForKey:@"CFFHtmlSection"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)saveGlobalHtmlData:(NSDictionary *)dictHtmlData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString* tableColumn = [[dictHtmlData valueForKey:@"columnName"] componentsJoinedByString:@","];
    NSString* tableValue = [[dictHtmlData valueForKey:@"columnValue"] componentsJoinedByString:@","];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"insert or replace into %@ (%@) values (%@)",[dictHtmlData valueForKey:@"tableName"],tableColumn,tableValue]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateGlobalHtml:(NSString *)tableName StringSet:(NSString *)stringSet StringWhere:(NSString *)stringWhere{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update %@ set %@ where %@",tableName,stringSet,stringWhere]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(void)updateGlobalHtmlData:(NSString *)htmlSection{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"update CFFHtml set CFFHtmlStatus = 'I' where CFFHtmlSection = ?" ,htmlSection];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

//dataTable array = 1.tableColumn 2.tableName 3.
-(int)voidGetDuplicateRowID:(NSString *)stringQuery ColumnReturn:(NSString *)stringColumn{
    int IndexNo;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"%@",stringQuery]];
    
    while ([s next]) {
        IndexNo = [s intForColumn:stringColumn];
    }
    
    [results close];
    [database close];
    return IndexNo;
}


-(void)updateHtmlData:(NSDictionary *)dictHtmlData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"update CFFHtml set CFFHtmlStatus = 'I' where CFFHtmlSection = ?" ,
                    [dictHtmlData valueForKey:@"CFFHtmlSection"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSMutableArray *)selectHtmlData:(int)CFFHtmlID HtmlSection:(NSString *)cffHtmlSection{
    NSMutableArray* arrayDictCFFHtmlID = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString* cffHtmlID;
    NSString* cffHtmlName;
    NSString* cffHtmlStatus;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFID = %i and CFFHtmlSection = \"%@\"",CFFHtmlID,cffHtmlSection]];
    while ([s next]) {
        cffHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"CFFHtmlID"]];
        cffHtmlName = [s stringForColumn:@"CFFHtmlName"];
        cffHtmlStatus = [s stringForColumn:@"CFFHtmlStatus"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              cffHtmlID,@"CFFHtmlID",
              cffHtmlName,@"CFFHtmlName",
              cffHtmlStatus,@"CFFHtmlStatus",nil];
        
        [arrayDictCFFHtmlID addObject:dict];
    }
    
    [results close];
    [database close];
    return arrayDictCFFHtmlID;
}

-(NSDictionary *)selectActiveHtml{
    NSDictionary *dict;
    
    NSString* cffHtmlID;
    NSString* cffHtmlName;
    NSString* cffID;
    NSString* cffHtmlStatus;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlStatus = 'A'"]];
    while ([s next]) {
        cffHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"CFFHtmlID"]];
        cffID = [s stringForColumn:@"CFFID"];
        cffHtmlName = [s stringForColumn:@"CFFHtmlName"];
        cffHtmlStatus = [s stringForColumn:@"CFFHtmlStatus"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          cffHtmlID,@"CFFHtmlID",
          cffID,@"CFFID",
          cffHtmlName,@"CFFHtmlName",
          cffHtmlStatus,@"CFFHtmlStatus",nil];

    
    [results close];
    [database close];
    return dict;
}



-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection{
    NSDictionary *dict;
    
    NSString* cffHtmlID;
    NSString* cffHtmlName;
    NSString* cffID;
    NSString* cffHtmlStatus;
    NSString* cffHtmlSection;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlStatus = 'A' and CFFHtmlSection = \"%@\"",htmlSection]];
    while ([s next]) {
        cffHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"CFFHtmlID"]];
        cffID = [s stringForColumn:@"CFFID"];
        cffHtmlName = [s stringForColumn:@"CFFHtmlName"];
        cffHtmlStatus = [s stringForColumn:@"CFFHtmlStatus"];
        cffHtmlSection = [s stringForColumn:@"CFFHtmlSection"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          cffHtmlID,@"CFFHtmlID",
          cffID,@"CFFID",
          cffHtmlName,@"CFFHtmlName",
          cffHtmlSection,@"CFFHtmlSection",
          cffHtmlStatus,@"CFFHtmlStatus",nil];
    
    
    [results close];
    [database close];
    return dict;
}

-(NSMutableArray *)selectHtmlServerID:(NSString *)TableName ColumnName:(NSString *)columnName{
    NSMutableArray* arrayServerID = [[NSMutableArray alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from %@ ",columnName,TableName]];
    while ([s next]) {
        [arrayServerID addObject:[s stringForColumn:columnName]?:@""];
    }
    
    [results close];
    [database close];
    return arrayServerID;
}


@end
