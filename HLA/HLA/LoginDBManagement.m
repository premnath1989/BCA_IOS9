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

@implementation LoginDBManagement

- (instancetype)init{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"HLA_Rates.sqlite"]];
    UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
    CommDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Rates.json"]];
    [self makeDBCopy];
    
    return self;
}

- (void)makeDBCopy
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *DBerror;
    
    /*  update Occupation list with Professional Athlete : Edwin 21-11-2013  */
    sqlite3_stmt *statement;
    BOOL proceedInsert = false;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT OccpCode FROM Adm_Occp_Loading_Penta WHERE OccpCode='OCC01717'"];

        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                proceedInsert = false;
            }else
            {
                proceedInsert = true;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        query_stmt = Nil;
        querySQL = Nil;
    }
    statement = Nil;


    if(proceedInsert)
    {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
        {

            NSString *querySQL = [NSString stringWithFormat:
                                  @"insert into Adm_Occp_Loading_Penta Values('OCC01717', 'PROFESSIONAL ATHLETE', '4', 'A', 'EM', '4', '0.0', '0.0' )"];


            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_DONE){

                }
                sqlite3_finalize(statement);
            }

            sqlite3_close(contactDB);
            querySQL = Nil;

        }
    }
    /*                                                      */


    success = [fileManager fileExistsAtPath:databasePath];
    //if (success) return;
    if (!success) {

        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [DBerror localizedDescription]);
        }

        defaultDBPath = Nil;
    }

    if([fileManager fileExistsAtPath:CommDatabasePath] == FALSE ){

        //if there are any changes, system will delete the old rates.json file and replace with the new one
        // code here
        //--------------

        NSString *CommissionRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Rates.json"];
        success = [fileManager copyItemAtPath:CommissionRatesPath toPath:CommDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create Commision Rates json file with message '%@'.", [DBerror localizedDescription]);
        }
        CommissionRatesPath= Nil;
    }

    //[fileManager removeItemAtPath:UL_RatesDatabasePath error:Nil];

    if([fileManager fileExistsAtPath:UL_RatesDatabasePath] == FALSE ){

        NSString *ULRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UL_Rates.sqlite"];
        success = [fileManager copyItemAtPath:ULRatesPath toPath:UL_RatesDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create UL Rates file with message '%@'.", [DBerror localizedDescription]);
        }
        ULRatesPath= Nil;
    }

    if([fileManager fileExistsAtPath:RatesDatabasePath] == FALSE ){
        NSString *RatesDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HLA_Rates.sqlite"];
        success = [fileManager copyItemAtPath:RatesDBPath toPath:RatesDatabasePath error:&DBerror];
        if (!success) {
            NSAssert1(0, @"Failed to create writable Rates database file with message '%@'.", [DBerror localizedDescription]);
        }
        RatesDBPath = Nil;
    }
    else {
        return;
    }

    fileManager = Nil;
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
                }else{
                    agentStatusFlag = AGENT_IS_INACTIVE;
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

- (int) InsertAgentProfile:(NSString *) urlStr
{
    NSArray *urlArr = [urlStr componentsSeparatedByString:@"|"];
    int insertAgentProfile = TABLE_INSERTION_FAILED;
    if (urlArr.count < 1) {
        return 0;//should not reach here
    }
    
    NSLog(@"parseURL: %@", urlStr);
    
    NSString* agentCode_1 =  [urlArr objectAtIndex:1]; //[queryStringDict objectForKey:@"agentCode"];
    NSString* agentName_1 = [urlArr objectAtIndex:2];
    NSString* agentType_1 = [urlArr objectAtIndex:3];
    NSString* immediateLeaderCode_1 = [urlArr objectAtIndex:4];
    NSString* immediateLeaderName_1 = [urlArr objectAtIndex:5];
    NSString* BusinessRegNumber_1 = [urlArr objectAtIndex:6];
    NSString* agentEmail_1 = [urlArr objectAtIndex:7];
    NSString* agentLoginId_1 = [urlArr objectAtIndex:8];
    NSString* agentIcNo_1 = [urlArr objectAtIndex:9];
    NSString* agentContractDate_1 = [urlArr objectAtIndex:10];
    NSString* agentAddr1_1 = [urlArr objectAtIndex:11];
    NSString* agentAddr2_1 = [urlArr objectAtIndex:12];
    NSString* agentAddr3_1 = [urlArr objectAtIndex:13];
    NSString* agentAddrPostcode_1 = [urlArr objectAtIndex:14];
    NSString* agentContactNumber_1 = [urlArr objectAtIndex:15];
    NSString* agentPassword_1 = [urlArr objectAtIndex:16];
    NSString* agentStatus_1 = [urlArr objectAtIndex:17];
    NSString* channel_1 = [urlArr objectAtIndex:18];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:agentCode_1 forKey:AGENT_KEY_CODE];
    [defaults synchronize];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;

        NSString *CheckSql = [NSString stringWithFormat:
                              @"select * FROM agent_profile"];


        FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
        [db open];

        FMResultSet *results;
        results = [db executeQuery:CheckSql];

        while ([results next]) {
            [db executeUpdate:@"DELETE FROM agent_profile"];
        }
        [db close];

        querySQL = [NSString stringWithFormat:
                    @"insert into Agent_profile (agentCode, AgentName, AgentType, AgentContactNo, ImmediateLeaderCode, ImmediateLeaderName, BusinessRegNumber, AgentEmail, AgentLoginID, AgentICNo, "
                    "AgentContractDate, AgentAddr1, AgentAddr2, AgentAddr3, AgentAddr4, AgentPortalLoginID, AgentPortalPassword, AgentContactNumber, AgentPassword, AgentStatus, Channel, AgentAddrPostcode, agentNRIC, LastLogonDate) VALUES "
                    "('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '%@', %@) ",
                    agentCode_1, agentName_1, agentType_1, agentContactNumber_1,immediateLeaderCode_1, immediateLeaderName_1,BusinessRegNumber_1, agentEmail_1, agentLoginId_1, agentIcNo_1, agentContractDate_1, agentAddr1_1, agentAddr2_1, agentAddr3_1, @"", agentLoginId_1, agentPassword_1, agentContactNumber_1, agentPassword_1, agentStatus_1, channel_1, agentAddrPostcode_1, agentIcNo_1, @"datetime(\"now\", \"+8 hour\")" ];


        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE){
                insertAgentProfile = TABLE_INSERTION_SUCCESS;
            }
            else{
                NSLog(@"%@",[[NSString alloc] initWithUTF8String:sqlite3_errmsg(contactDB)]) ;
            }
            sqlite3_finalize(statement);
        }
        else{
            NSLog(@"%@",[[NSString alloc] initWithUTF8String:sqlite3_errmsg(contactDB)]) ;
        }
        
        sqlite3_close(contactDB);
    }
    return insertAgentProfile;
}

- (void) updateLoginDate:(int)indexNo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET LastLogonDate= \"%@\" WHERE IndexNo=\"%d\"",dateString,indexNo];
        
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

-(NSString *)checkingLastLogout
{
    
    sqlite3_stmt *statement;
    NSString *nsdate = @"";
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastLogonDate FROM Agent_Profile WHERE AgentCode=1024"];
        
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


@end