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
    
    BOOL success = [database executeUpdate:@"insert into CFFHtml (CFFHtmlName, CFFHtmlStatus) values (?,?)" ,
                    [dictHtmlData valueForKey:@"CFFHtmlName"],
                    [dictHtmlData valueForKey:@"CFFHtmlStatus"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSMutableArray *)selectHtmlData:(int)CFFHtmlID{
    NSMutableArray* arrayDictCFFHtmlID = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString* cffHtmlID;
    NSString* cffHtmlName;
    NSString* cffHtmlStatus;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlID = %i",CFFHtmlID]];
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
    NSString* cffHtmlStatus;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from CFFHtml where CFFHtmlStatus = 'A'"]];
    while ([s next]) {
        cffHtmlID = [NSString stringWithFormat:@"%i",[s intForColumn:@"CFFHtmlID"]];
        cffHtmlName = [s stringForColumn:@"CFFHtmlName"];
        cffHtmlStatus = [s stringForColumn:@"CFFHtmlStatus"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          cffHtmlID,@"CFFHtmlID",
          cffHtmlName,@"CFFHtmlName",
          cffHtmlStatus,@"CFFHtmlStatus",nil];

    
    [results close];
    [database close];
    return dict;
}



@end
