//
//  LoginDBManagement.m
//  BLESS
//
//  Created by Erwin on 05/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginDBManagement.h"
#import "FMDatabase.h"
#import "LoginMacros.h"
#import "SSKeychain.h"
#import "WebServiceUtilities.h"

@implementation LoginDBManagement

- (instancetype)init{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"]];
    UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
    RefDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"DataReferral.sqlite"]];
    CommDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Rates.json"]];
    
    return self;
}

- (void)makeDBCopy
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *DBerror;
    
    success = [fileManager fileExistsAtPath:databasePath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [DBerror localizedDescription]);
        }
        
        defaultDBPath = Nil;
    }
    
    if([fileManager fileExistsAtPath:CommDatabasePath] == FALSE ){
        
        NSString *CommissionRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Rates.json"];
        success = [fileManager copyItemAtPath:CommissionRatesPath toPath:CommDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create Commision Rates json file with message '%@'.", [DBerror localizedDescription]);
        }
        CommissionRatesPath= Nil;
    }
    
    if([fileManager fileExistsAtPath:UL_RatesDatabasePath] == FALSE ){
        
        NSString *ULRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UL_Rates.sqlite"];
        success = [fileManager copyItemAtPath:ULRatesPath toPath:UL_RatesDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create UL Rates file with message '%@'.", [DBerror localizedDescription]);
        }
        ULRatesPath= Nil;
    }
    
    if([fileManager fileExistsAtPath:RatesDatabasePath] == FALSE ){
        
        NSString *RatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
        success = [fileManager copyItemAtPath:RatesPath toPath:RatesDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create UL Rates file with message '%@'.", [DBerror localizedDescription]);
        }
        RatesPath= Nil;
    }
    
    if([fileManager fileExistsAtPath:RefDatabasePath] == FALSE ){
        NSString *RefDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DataReferral.sqlite"];
        success = [fileManager copyItemAtPath:RefDBPath toPath:RefDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create writable Rates database file with message '%@'.", [DBerror localizedDescription]);
        }
        RefDBPath = Nil;
    }
    else {
        return;
    }
    
    fileManager = Nil;
}

- (int)lightWeightMigration{
    
    
    return 1;
}

- (int) SearchAgent:(NSString *)AgentID{
    sqlite3_stmt *statement;
    int AgentFound = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Agent_Profile WHERE AgentLoginID=\"%@\" ", AgentID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) AgentFound = AGENT_IS_FOUND;
            else AgentFound = AGENT_IS_NOT_FOUND;
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return AgentFound;
}

- (int) AgentRecord{
    sqlite3_stmt *statement;
    int AgentFound = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Agent_Profile"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) AgentFound = AGENT_IS_FOUND;
            else AgentFound = AGENT_IS_NOT_FOUND;
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return AgentFound;
}

- (int) DeviceStatus:(NSString *)AgentID{
    sqlite3_stmt *statement;
    int DeviceStatusFlag = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT DeviceStatus FROM Agent_Profile WHERE AgentCode=\"%@\" ", AgentID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *strFirstLogin = [[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"%@",strFirstLogin);
                if([strFirstLogin caseInsensitiveCompare:@"A"] == NSOrderedSame){
                    DeviceStatusFlag = DEVICE_IS_ACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"I"] == NSOrderedSame){
                    DeviceStatusFlag = DEVICE_IS_INACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"T"] == NSOrderedSame){
                    DeviceStatusFlag = DEVICE_IS_TERMINATED;
                }
            }else{
                DeviceStatusFlag = AGENT_IS_NOT_FOUND;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return DeviceStatusFlag;
}

- (int) SpvStatus:(NSString *)spvID{
    sqlite3_stmt *statement;
    int agentStatusFlag = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT DirectSupervisorStatus FROM Agent_Profile WHERE DirectSupervisorCode=\"%@\" ", spvID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *strFirstLogin = [[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"%@",strFirstLogin);
                if([strFirstLogin caseInsensitiveCompare:@"A"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_ACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"I"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_INACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"T"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_TERMINATED;
                }
            }else{
                agentStatusFlag = AGENT_IS_NOT_FOUND;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return agentStatusFlag;
}

- (int) AgentStatus:(NSString *)AgentID{
    sqlite3_stmt *statement;
    int agentStatusFlag = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT AgentStatus FROM Agent_Profile WHERE AgentCode=\"%@\" ", AgentID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *strFirstLogin = [[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                NSLog(@"%@",strFirstLogin);
                if([strFirstLogin caseInsensitiveCompare:@"A"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_ACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"I"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_INACTIVE;
                }else if([strFirstLogin caseInsensitiveCompare:@"T"] == NSOrderedSame){
                    agentStatusFlag = AGENT_IS_TERMINATED;
                }
            }else{
                agentStatusFlag = AGENT_IS_NOT_FOUND;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return agentStatusFlag;
}

- (NSString *) expiryDate:(NSString *)AgentID{
    sqlite3_stmt *statement;
    NSString *nsdate = @"";
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LicenseExpiryDate FROM Agent_Profile WHERE AgentCode=\"%@\" ", AgentID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                nsdate = [[NSString alloc]
                          initWithUTF8String:
                          (const char *) sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return nsdate;
}



- (int) DeleteAgentProfile{
    sqlite3_stmt *statement;
    int DeleteAgent = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM AGENT_PROFILE"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                DeleteAgent = TABLE_INSERTION_SUCCESS;
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return DeleteAgent;
}

- (int) FirstLogin:(NSString *)AgentID{
    sqlite3_stmt *statement;
    int FirstLogin = DATABASE_ERROR;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT FirstLogin FROM Agent_Profile WHERE AgentCode=\"%@\" ", AgentID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *strFirstLogin = [[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                FirstLogin = [strFirstLogin intValue];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return FirstLogin;
}



- (void) updateLogoutDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET LastLogoutDate= \"%@\"",dateString];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        
        query_stmt = Nil;
        querySQL = Nil;
    }
    
    dateFormatter = Nil;
    dateString = Nil;
    dbpath = Nil;
    statement = Nil;
}

- (void) updatePassword:(NSString *)newPassword{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentPassword= \"%@\"",newPassword];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        
        query_stmt = Nil;
        querySQL = Nil;
    }
    dbpath = Nil;
    statement = Nil;
}

- (void) updateLoginDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET LastLogonDate= \"%@\"",dateString];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        
        query_stmt = Nil;
        querySQL = Nil;
    }
    
    dateFormatter = Nil;
    dateString = Nil;
    dbpath = Nil;
    statement = Nil;
}

-(BOOL)fullSyncTable:(WebResponObj *)obj{
    return [self SyncTable:obj dbString:databasePath];
}

-(BOOL)SyncTable:(WebResponObj *)obj dbString:(NSString *)DB{
    BOOL insertProc = FALSE;
    
    for(dataCollection *data in [obj getDataWrapper]){
        NSString *tableName = [[data.tableName componentsSeparatedByString:@"&"] objectAtIndex: 0];
        NSString *sql =  [NSString stringWithFormat:@"insert or replace into %@ (",tableName ];
        for(NSString *keys in data.dataRows){
            NSString *key = [NSString stringWithFormat:@"%@,",keys];
            sql = [sql stringByAppendingString:key];
        }
        sql = [sql substringToIndex:[sql length]-1];
        sql = [sql stringByAppendingString:@") VALUES ("];
        
        for(NSString *keys in data.dataRows){
            NSString *value = @"";
            if([data.dataRows valueForKey:keys] != NULL)
                value = [NSString stringWithFormat:@"'%@',",[data.dataRows valueForKey:keys]];
            else
                value = [NSString stringWithFormat:@"'',"];
            
            sql = [sql stringByAppendingString:value];
        }
        sql = [sql substringToIndex:[sql length]-1];
        sql = [sql stringByAppendingString:@")"];
        
        
        NSLog(@"%@",sql);
        
        char *error;
        if (sqlite3_open([DB UTF8String ], &contactDB) == SQLITE_OK)
        {
            sqlite3_exec(contactDB, [sql UTF8String], NULL, NULL, &error);
            if (error == NULL || (error[0] == '\0')) {
                insertProc = TRUE;
            }
            
            sqlite3_close(contactDB);
        }
    }
    return insertProc;
}

-(int)ReferralSyncTable:(WebResponObj *)obj{
    return [self SyncTable:obj dbString:RefDatabasePath];
}

-(long long)SPAJAllocated{
    long long SPAJCount = 0;
    
    sqlite3_stmt *statement;
    NSString *valueStart = @"";
    NSString *valueEnd = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT SPAJAllocationBegin, SPAJAllocationEnd FROM SPAJPackNumber"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    valueStart = [[NSString alloc]
                             initWithUTF8String:
                             (const char *) sqlite3_column_text(statement, 0)];
                    valueEnd = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue]) + 1;
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return SPAJCount;
}

-(long long)SPAJUsed{
    long long SPAJCount = [self SPAJNonActive];
    
    sqlite3_stmt *statement;
    NSString *valueStart = @"";
    NSString *valueEnd = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT SPAJAllocationBegin, SPAJAllocationEnd, LastUsedSPAJNo FROM SPAJPackNumber WHERE STATUS = 'ACTIVE'"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 2) != NULL){
                    valueStart = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 2)];
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue]) + 1;
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return SPAJCount;
}

- (NSMutableArray *)SPAJRetrievePackID{
    
    NSMutableArray *PackIDWrapper = [[NSMutableArray alloc]init];
    
    sqlite3_stmt *statement;
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT PACKID, SPAJAllocationBegin, SPAJAllocationEnd, CreatedDate FROM SPAJPackNumber"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 3) != NULL){
                    NSMutableDictionary *PackIDContent = [[NSMutableDictionary alloc]init];
                    [PackIDContent setValue:[[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 0)] forKey:@"PackID"];
                    [PackIDContent setValue:[[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 1)] forKey:@"SPAJAllocationBegin"];
                    [PackIDContent setValue:[[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 2)] forKey:@"SPAJAllocationEnd"];
                    [PackIDContent setValue:[[NSString alloc]
                                             initWithUTF8String:
                                             (const char *) sqlite3_column_text(statement, 3)] forKey:@"CreatedDate"];
                    [PackIDWrapper addObject:PackIDContent];
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return PackIDWrapper;
}


-(long long)SPAJNonActive{
    long long SPAJCount = 0;
    
    sqlite3_stmt *statement;
    NSString *valueStart = @"";
    NSString *valueEnd = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT SPAJAllocationBegin, SPAJAllocationEnd, LastUsedSPAJNo FROM SPAJPackNumber WHERE STATUS = 'NONACTIVE'"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 2) == NULL){
                    valueStart = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue]) + 1;
                }else{
                    valueStart = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                    if([valueStart caseInsensitiveCompare:valueEnd] == NSOrderedSame){
                        valueStart = [[NSString alloc]
                                      initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                    }
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue])+1;
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return SPAJCount;
}


-(long long)SPAJBalance{
    long long SPAJCount = 0;
    
    sqlite3_stmt *statement;
    NSString *valueStart = @"";
    NSString *valueEnd = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT SPAJAllocationBegin, SPAJAllocationEnd, LastUsedSPAJNo FROM SPAJPackNumber WHERE STATUS = 'ACTIVE'"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 2) == NULL){
                    valueStart = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue]) + 1;
                }else{
                    valueStart = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 1)];
                    SPAJCount = SPAJCount + ([valueEnd longLongValue]-[valueStart longLongValue]);
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return SPAJCount;
}

- (void) updatePackIDStatus:(NSString *)packID status:(NSString *)status
                   lastused:(NSString *)lastSPAJused{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE SPAJPackNumber SET LastUsedSPAJNo = \"%@\", STATUS= \"%@\",UpdatedDate=\"%@\" WHERE PACKID=\"%@\"",lastSPAJused,status,dateString,packID];
        
       
        if (sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, NULL) == SQLITE_OK)
        {
            NSLog(@"Status update!");
            
        } else {
            NSLog(@"Status update Failed!");
        }
        sqlite3_close(contactDB);
    }
}

-(long long)getLastActiveSPAJNum{
    
    sqlite3_stmt *statement;
    NSString *valueEnd = @"";
    NSString *valueCurrent = @"";
    NSString *valuePackID = @"";
    NSString *valueStatus = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT PACKID, SPAJAllocationBegin, SPAJAllocationEnd, LastUsedSPAJNo FROM SPAJPackNumber WHERE Status='ACTIVE' order by rowid LIMIT 1"];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 3) != NULL){
                    valuePackID = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 0)];
                    valueEnd = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 2)];
                    valueCurrent = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 3)];
                    valueCurrent = [NSString stringWithFormat:@"%lld",[valueCurrent longLongValue] + 1];
                    if([valueCurrent caseInsensitiveCompare:valueEnd] == NSOrderedSame){
                        valueStatus = @"NONACTIVE";
                    }else{
                        valueStatus = @"ACTIVE";
                    }
                }else{
                    valuePackID = [[NSString alloc]
                                   initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                    valueCurrent = [[NSString alloc]
                                    initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                    valueStatus = @"ACTIVE";
                   
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
        
        [self updatePackIDStatus:valuePackID status:valueStatus lastused:valueCurrent];
    }
    return [valueCurrent longLongValue];
}



-(NSString *)RiderCode:(NSString *)SINo riderCode:(NSString *)code{
    
    sqlite3_stmt *statement;
    NSString *value = @"";
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT ExtraPremiRp FROM SI_Temp_Trad_Rider WHERE SINO='%@' AND RiderCode='%@'", SINo, code];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    value = [[NSString alloc]
                             initWithUTF8String:
                             (const char *) sqlite3_column_text(statement, 0)];
                }
            }
        }
        sqlite3_close(contactDB);
    }
    
    return value;
}

-(NSMutableDictionary *)premiKeluargaku:(NSString *)SINo{
    
    sqlite3_stmt *statement;
    NSMutableDictionary *premiDetails = [[NSMutableDictionary alloc]init];
    NSMutableArray *columnArray = [self columnNames:@"SI_Premium"];
    
    NSString *sql = @"";
    for(NSString *keys in columnArray){
        NSString *key = [NSString stringWithFormat:@"%@,",keys];
        sql = [sql stringByAppendingString:key];
    }
    sql = [sql substringToIndex:[sql length]-1];
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM SI_Premium WHERE SINO='%@'", SINo];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            //will continue to go down the rows (columns in your table) till there are no more
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                for(int index = 0; index < columnArray.count ; index++){
                    NSString *value = @"";
                    if((const char *) sqlite3_column_text(statement, index) != NULL){
                        value = [[NSString alloc]
                                 initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, index)];
                    }
                    
                    [premiDetails setValue:value forKey:[columnArray objectAtIndex:index]];
                    //do something with colName because it contains the column's name
                }
            }
        }
        sqlite3_close(contactDB);
    }
    
    return premiDetails;
}

-(NSString *)checkingLastLogout
{
    
    sqlite3_stmt *statement;
    NSString *nsdate = @"";
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastLogonDate FROM Agent_Profile"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    nsdate = [[NSString alloc]
                              initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return nsdate;
}

- (void)duplicateRow:(NSString *)tableName param:(NSString *)column oldValue:(NSString *)oldValue newValue:(NSString *)newValue{
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE tmp AS SELECT * FROM %@ where %@=\"%@\"",tableName,column,oldValue];
        
        BOOL success = [self sqlStatement:createSQL];
        
        if (success)
        {
            if([tableName caseInsensitiveCompare:@"SI_Master"]==NSOrderedSame){
                createSQL = [NSString stringWithFormat:@"UPDATE tmp SET %@ =\"%@\",EnableEditing='1',IllustrationSigned='1',id = ((Select max(id) from %@)+1)",column,newValue,tableName];
            }else if([tableName caseInsensitiveCompare:@"SI_Temp_Trad_Rider"]==NSOrderedSame){
                createSQL = [NSString stringWithFormat:@"UPDATE tmp SET %@ =\"%@\",rowid = ((Select max(id) from %@)+1)",column,newValue,tableName];
            }else{
                createSQL = [NSString stringWithFormat:@"UPDATE tmp SET %@ =\"%@\",id = ((Select max(id) from %@)+1)",column,newValue,tableName];
            }
            success = [self sqlStatement:createSQL];
            
            if (success)
            {
                createSQL = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * FROM tmp",tableName];
                success = [self sqlStatement:createSQL];
                
                if(success)
                {
                    createSQL = @"DROP TABLE tmp";
                    [self sqlStatement:createSQL];
                    
                    //                    if (success) {
                    //                        createSQL = [NSString stringWithFormat:@"UPDATE %@ SET CustCode=\"%@\" WHERE CustCode='0'",tableName,nextCustCode];
                    //
                    //                        [self sqlStatement:createSQL];
                    //                    }
                }
            }
            
        }
    }
}

-(int)insertTableFromJSON:(NSDictionary*) params databasePath:(NSString *)dbName{
    int insertProc = 0;
    sqlite3 *instanceDB;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    //first loop for the table name
    for(NSString *tableName in [params allKeys]){
        
        //now we do loop for each data inside the table
        for(NSDictionary *dataArray in [params valueForKey:tableName]){
            NSString *sql =  [NSString stringWithFormat:@"insert or replace into %@ (",tableName ];
            for(NSString *keys in [dataArray allKeys]){
                NSString *key = [NSString stringWithFormat:@"%@,",keys];
                sql = [sql stringByAppendingString:key];
            }
            sql = [sql substringToIndex:[sql length]-1];
            sql = [sql stringByAppendingString:@") VALUES ("];
            
            for(NSString *keys in [dataArray allKeys]){
                NSString *value = @"";
                if([[params valueForKey:tableName][0] valueForKey:keys] != NULL)
                    value = [NSString stringWithFormat:@"'%@',",[dataArray valueForKey:keys]];
                else
                    value = [NSString stringWithFormat:@"'',"];
                
                sql = [sql stringByAppendingString:value];
            }
            sql = [sql substringToIndex:[sql length]-1];
            sql = [sql stringByAppendingString:@")"];
            
            NSLog(@"query : %@", sql);
            
            char *error;
            if (sqlite3_open([dbPath UTF8String], &instanceDB) == SQLITE_OK)
            {
                sqlite3_exec(instanceDB, [sql UTF8String], NULL, NULL, &error);
                if (error == NULL || (error[0] == '\0')) {
                    insertProc = 1;
                }
                sqlite3_close(instanceDB);
            }
        }
    }
    return insertProc;
}

-(BOOL)sqlStatement:(NSString*)querySQL
{
    BOOL success = YES;
    sqlite3_stmt *statement;
    
    int status = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) ;
    if ( status == SQLITE_OK) {
        int errorCode = sqlite3_step(statement);
        success = errorCode == SQLITE_DONE;
        sqlite3_finalize(statement);
    }
    return  success;
}

-(NSString *)EditIllustration:(NSString *)SIno
{
    
    sqlite3_stmt *statement;
    NSString *EditMode = @"";
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT EnableEditing FROM SI_Master WHERE SINO=\"%@\"", SIno];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    EditMode = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 0)];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return EditMode;
}

-(NSString *)localDBUDID
{
    
    sqlite3_stmt *statement;
    NSString *UDID = @"";
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT UDID FROM Agent_Profile"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    UDID = [[NSString alloc]
                            initWithUTF8String:
                            (const char *) sqlite3_column_text(statement, 0)];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return UDID;
}

- (NSMutableArray *) columnNames{
    sqlite3_stmt *statement;
    NSMutableArray *columns = [NSMutableArray array];
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, "pragma table_info ('Agent_Profile')", -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            //will continue to go down the rows (columns in your table) till there are no more
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *columnName = [[NSString alloc]
                                        initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [columns addObject:columnName];
                //do something with colName because it contains the column's name
            }
        }
        sqlite3_close(contactDB);
    }
    return columns;
}

- (NSMutableArray *) columnNames:(NSString *)table{
    sqlite3_stmt *statement;
    NSMutableArray *columns = [NSMutableArray array];
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat: @"pragma table_info ('%@')", table];
        int rc = sqlite3_prepare_v2(contactDB, [sql UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            //will continue to go down the rows (columns in your table) till there are no more
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *columnName = [[NSString alloc]
                                        initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [columns addObject:columnName];
                //do something with colName because it contains the column's name
            }
        }
        sqlite3_close(contactDB);
    }
    return columns;
}

-(NSMutableDictionary *)getAgentDetails
{
    
    sqlite3_stmt *statement;
    NSMutableDictionary *agentDetails = [[NSMutableDictionary alloc]init];
    NSMutableArray *columnArray = [self columnNames];
    
    NSString *sql = @"";
    for(NSString *keys in columnArray){
        NSString *key = [NSString stringWithFormat:@"%@,",keys];
        sql = [sql stringByAppendingString:key];
    }
    sql = [sql substringToIndex:[sql length]-1];
    
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM Agent_Profile", sql];
    NSLog(@"%@",querySQL);
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        int rc = sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL);
        
        if (rc==SQLITE_OK)
        {
            //will continue to go down the rows (columns in your table) till there are no more
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                for(int index = 0; index < columnArray.count ; index++){
                    NSString *value = @"";
                    if((const char *) sqlite3_column_text(statement, index) != NULL){
                        value = [[NSString alloc]
                                 initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, index)];
                    }
                    
                    [agentDetails setValue:value forKey:[columnArray objectAtIndex:index]];
                    //do something with colName because it contains the column's name
                }
            }
        }
        sqlite3_close(contactDB);
    }
    return agentDetails;
}


-(BOOL) SpvAdmValidation:(NSString *)username password:(NSString *)password
{
    BOOL successLog = FALSE;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    NSString *SupervisorCode;
    NSString *SupervisorPass;
    NSString *Admin;
    NSString *AdminPassword;
    
    FMResultSet *result1 = [db executeQuery:@"select AgentCode, AgentPassword, DirectSupervisorCode, DirectSupervisorPassword, Admin, AdminPassword  from Agent_profile"];
    
    while ([result1 next]) {
        
        SupervisorCode = [[result1 objectForColumnName:@"DirectSupervisorCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        SupervisorPass = [[result1 objectForColumnName:@"DirectSupervisorPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Admin = [[result1 objectForColumnName:@"Admin"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AdminPassword = [[result1 objectForColumnName:@"AdminPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (([username isEqualToString:SupervisorCode] && [password isEqualToString:SupervisorPass])
            || ([username isEqualToString:Admin] && [password isEqualToString:AdminPassword])) {
            successLog = TRUE;
        }
    }
    
    [db close];
    
    return successLog;
    
}

-(NSString *) AgentCodeLocal
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    NSString *AgentName;
    NSString *AgentPassword;
    NSString *SupervisorCode;
    NSString *SupervisorPass;
    NSString *Admin;
    NSString *AdminPassword;
    
    FMResultSet *result1 = [db executeQuery:@"select AgentCode, AgentPassword, DirectSupervisorCode, DirectSupervisorPassword, Admin, AdminPassword  from Agent_profile"];
    
    while ([result1 next]) {
        AgentName = [[result1 objectForColumnName:@"AgentCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AgentPassword = [[result1 objectForColumnName:@"AgentPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        SupervisorCode = [[result1 objectForColumnName:@"DirectSupervisorCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        SupervisorPass = [[result1 objectForColumnName:@"DirectSupervisorPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Admin = [[result1 objectForColumnName:@"Admin"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AdminPassword = [[result1 objectForColumnName:@"AdminPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    [db close];
    
    return AgentName;
}

//we store the UDID into the Keychain
-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
        
    }
    return strApplicationUUID;
}

-(NSString *) getLastUpdateReferral
{
    sqlite3_stmt *statement;
    NSString *LastDate = @"";
    if (sqlite3_open([RefDatabasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT max(UpdateTime) FROM DataReferral"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW) {
                if((const char *) sqlite3_column_text(statement, 0) != NULL){
                    LastDate = [[NSString alloc]
                                initWithUTF8String:
                                (const char *) sqlite3_column_text(statement, 0)];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return LastDate;
}

- (void) updateSIMaster:(NSString *)SINO EnableEditing:(NSString *)EditFlag{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE SI_Master SET EnableEditing= \"%@\" WHERE SINO = \"%@\"",EditFlag, SINO];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"EditMode Updated!");
                
            } else {
                NSLog(@"EditMode update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        
        query_stmt = Nil;
        querySQL = Nil;
    }
    dbpath = Nil;
    statement = Nil;
}


@end