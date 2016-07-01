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
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlStatus = 'A' and CFFHtmlStatus = \"%@\"",htmlSection]];
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



@end
