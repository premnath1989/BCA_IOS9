//
//  ModelSIPOData.m
//  BLESS
//
//  Created by Basvi on 2/25/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ModelSIPOData.h"

@implementation ModelSIPOData

-(void)savePODate:(NSDictionary *)dataPO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_PO_Data (SINO, ProductCode, ProductName, QuickQuote,SIDate,PO_Name,PO_DOB,PO_Gender,PO_Age,PO_OccpCode,PO_Occp,PO_ClientID,RelWithLA,LA_ClientID,LA_Name,LA_DOB,LA_Age,LA_Gender,LA_OccpCode,LA_Occp,CreatedDate,UpdatedDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+8 hour\")"",""datetime(\"now\", \"+8 hour\")"")" ,
                    [dataPO valueForKey:@"SINO"],
                    [dataPO valueForKey:@"ProductCode"],
                    [dataPO valueForKey:@"ProductName"],
                    [dataPO valueForKey:@"QuickQuote"],
                    [dataPO valueForKey:@"SIDate"],
                    [dataPO valueForKey:@"PO_Name"],
                    [dataPO valueForKey:@"PO_DOB"],
                    [dataPO valueForKey:@"PO_Gender"],
                    [dataPO valueForKey:@"PO_Age"],
                    [dataPO valueForKey:@"PO_OccpCode"],
                    [dataPO valueForKey:@"PO_Occp"],
                    [dataPO valueForKey:@"PO_ClientID"],
                    [dataPO valueForKey:@"RelWithLA"],
                    [dataPO valueForKey:@"LA_ClientID"],
                    [dataPO valueForKey:@"LA_Name"],
                    [dataPO valueForKey:@"LA_DOB"],
                    [dataPO valueForKey:@"LA_Age"],
                    [dataPO valueForKey:@"LA_Gender"],
                    [dataPO valueForKey:@"LA_OccpCode"],
                    [dataPO valueForKey:@"LA_Occp"]/*,
                    [dataPO valueForKey:@"CreatedDate"],
                    [dataPO valueForKey:@"UpdatedDate"]*/];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getP_DataFor:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayNationCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayNationDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_PO_Data where SINO = \"%@\"",SINo]];
    while ([s next]) {
        NSString *NationCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NationCode"]];
        NSString *NationDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NationDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayNationCode addObject:NationCode];
        [arrayNationDesc addObject:NationDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayNationCode,@"NationCode", arrayNationDesc,@"NationDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
