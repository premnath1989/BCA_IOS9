//
//  ModelSIPOData.m
//  MPOS
//
//  Created by Basvi on 2/25/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIPOData.h"

@implementation ModelSIPOData


-(void)savePODate:(NSDictionary *)dataPO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_PO_Data (SINO, ProductCode, ProductName, QuickQuote,SIDate,PO_Name,PO_DOB,PO_Gender,PO_Age,PO_OccpCode,PO_Occp,PO_ClientID,RelWithLA,LA_ClientID,LA_Name,LA_DOB,LA_Age,LA_Gender,LA_OccpCode,LA_Occp,CreatedDate,UpdatedDate,IsInternalStaff) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"",?)" ,
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
                    [dataPO valueForKey:@"LA_Occp"],
                    [dataPO valueForKey:@"IsInternalStaff"]/*,
                    [dataPO valueForKey:@"CreatedDate"],
                    [dataPO valueForKey:@"UpdatedDate"]*/];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updatePOData:(NSDictionary *)dataPO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_PO_Data set ProductCode=?, ProductName=?, QuickQuote=?,SIDate=?,PO_Name=?,PO_DOB=?,PO_Gender=?,PO_Age=?,PO_OccpCode=?,PO_Occp=?,PO_ClientID=?,RelWithLA=?,LA_ClientID=?,LA_Name=?,LA_DOB=?,LA_Age=?,LA_Gender=?,LA_OccpCode=?,LA_Occp=?,UpdatedDate=""datetime(\"now\", \"+7 hour\")"",IsInternalStaff=? where SINO=?" ,
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
                    [dataPO valueForKey:@"LA_Occp"],
                    [dataPO valueForKey:@"IsInternalStaff"],
                    [dataPO valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updatePODataDate:(NSString *)SINO Date:(NSString *)date{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_PO_Data set CreatedDate=""datetime(\"now\", \"+7 hour\")"",UpdatedDate=""datetime(\"now\", \"+7 hour\")"",SIDate=? where SINO=?" ,
                    date,SINO];
    //NSLog(@"update SI_PO_Data set SIDate=""select strftime(\"'%@/%m/%Y'\", datetime(\"now\"))"" where SINO=%@",SINO);
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(void)savePartialPODate:(NSDictionary *)dataPO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_PO_Data (SINO, ProductCode, ProductName, QuickQuote,SIDate,PO_Name,PO_DOB,PO_Gender,PO_Age,PO_OccpCode,PO_Occp,PO_ClientID,RelWithLA,CreatedDate,UpdatedDate,IsInternalStaff) values (?,?,?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"",?)" ,
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
                    [dataPO valueForKey:@"IsInternalStaff"]
/*,
                                                    [dataPO valueForKey:@"CreatedDate"],
                                                    [dataPO valueForKey:@"UpdatedDate"]*/];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updatePartialPOData:(NSDictionary *)dataPO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_PO_Data set ProductCode=?, ProductName=?, QuickQuote=?,SIDate=?,PO_Name=?,PO_DOB=?,PO_Gender=?,PO_Age=?,PO_OccpCode=?,PO_Occp=?,PO_ClientID=?,RelWithLA=?,UpdatedDate=""datetime(\"now\", \"+7 hour\")"",IsInternalStaff=? where SINO=?" ,
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
                    [dataPO valueForKey:@"IsInternalStaff"],
                    [dataPO valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(void)deletePOData:(NSString *)siNo{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_PO_Data where SINO=?",siNo];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(NSDictionary *)getPO_DataFor:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString* SINO;
    NSString* ProductCode;
    NSString* ProductName;
    NSString* QuickQuote;
    NSString* SIDate;
    NSString* PO_Name;
    NSString* PO_DOB;
    NSString* PO_Gender;
    NSString* PO_Age;
    NSString* PO_OccpCode;
    NSString* PO_Occp;
    NSString* PO_ClientID;
    NSString* RelWithLA;
    NSString* LA_ClientID;
    NSString* LA_Name;
    NSString* LA_DOB;
    NSString* LA_Age;
    NSString* LA_Gender;
    NSString *LA_OccpCode;
    NSString *LA_Occp;
    NSString *CreatedDate;
    NSString *UpdatedDate;
    NSString *IsInternalStaff;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_PO_Data where SINO = \"%@\"",SINo]];
    NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_PO_Data where SINO = \"%@\"",SINo]);
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        ProductCode = [s stringForColumn:@"ProductCode"];
        ProductName = [s stringForColumn:@"ProductName"];
        QuickQuote = [s stringForColumn:@"QuickQuote"];
        SIDate = [s stringForColumn:@"SIDate"];
        PO_Name = [s stringForColumn:@"PO_Name"];
        PO_DOB = [s stringForColumn:@"PO_DOB"];
        PO_Gender = [s stringForColumn:@"PO_Gender"];
        PO_Age = [s stringForColumn:@"PO_Age"];
        PO_OccpCode = [s stringForColumn:@"PO_OccpCode"];
        PO_Occp = [s stringForColumn:@"PO_Occp"];
        PO_ClientID = [s stringForColumn:@"PO_ClientID"];
        RelWithLA = [s stringForColumn:@"RelWithLA"];
        LA_ClientID = [s stringForColumn:@"LA_ClientID"];
        LA_Name = [s stringForColumn:@"LA_Name"];
        LA_DOB = [s stringForColumn:@"LA_DOB"];
        LA_Age = [s stringForColumn:@"LA_Age"];
        LA_Gender = [s stringForColumn:@"LA_Gender"];
        LA_OccpCode = [s stringForColumn:@"LA_OccpCode"];
        LA_Occp = [s stringForColumn:@"LA_Occp"];
        CreatedDate = [s stringForColumn:@"CreatedDate"];
        UpdatedDate = [s stringForColumn:@"UpdatedDate"];
        IsInternalStaff = [s stringForColumn:@"IsInternalStaff"];
    }

    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
                                          SINO,@"SINO",
                                          ProductCode,@"ProductCode",
                                          ProductName,@"ProductName",
                                          QuickQuote,@"QuickQuote",
                                          SIDate,@"SIDate",
                                          PO_Name,@"PO_Name",
                                          PO_DOB,@"PO_DOB",
                                          PO_Gender,@"PO_Gender",
                                          PO_Age,@"PO_Age",
                                          PO_OccpCode,@"PO_OccpCode",
                                          PO_Occp,@"PO_Occp",
                                          PO_ClientID,@"PO_ClientID",
                                          RelWithLA,@"RelWithLA",
                                          LA_ClientID,@"LA_ClientID",
                                          LA_Name,@"LA_Name",
                                          LA_DOB,@"LA_DOB",
                                          LA_Age,@"LA_Age",
                                          LA_Gender,@"LA_Gender",
                                          LA_OccpCode,@"LA_OccpCode",
                                          LA_Occp,@"LA_Occp",
                                          CreatedDate,@"CreatedDate",
                                          UpdatedDate,@"UpdatedDate",
                                          IsInternalStaff,@"IsInternalStaff",nil];
    
   [results close];
   [database close];
   return dict;
}

-(int)getPODataCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_PO_Data where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(int)getLADataCount:(NSString *)prospectProfileID{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_PO_Data where LA_ClientID = \"%@\" or PO_ClientID = \"%@\"",prospectProfileID,prospectProfileID]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(NSMutableArray *)getSINumberForProspectProfileID:(NSString *)prospectProfileID{
    NSMutableArray *SINumberArray = [[NSMutableArray alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select SINO from SI_PO_Data where LA_ClientID = \"%@\" or PO_ClientID = \"%@\"",prospectProfileID,prospectProfileID]];
    while ([s next]) {
        [SINumberArray addObject:[s stringForColumn:@"SINO"]];
    }
    
    [results close];
    [database close];
    return SINumberArray;
}

@end
