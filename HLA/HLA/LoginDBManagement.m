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
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"]];
    UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
    CommDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Rates.json"]];
    
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
        NSString *RatesDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
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

-(int)fullSyncTable:(WebResponObj *)obj{
    int insertProc = TABLE_INSERTION_FAILED;
    
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
        if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
        {
            sqlite3_exec(contactDB, [sql UTF8String], NULL, NULL, &error);
                if (error == NULL || (error[0] == '\0')) {
                    insertProc = TABLE_INSERTION_SUCCESS;
                }
            
            sqlite3_close(contactDB);
        }
    }
    return insertProc;
}

-(int)insertAgentProfile:(WebResponObj *)obj
{
//    int insertProc = TABLE_INSERTION_FAILED;
//    NSString *sql = @"insert into Agent_profile (";
//    
//    for(NSString *keys in obj){
//        NSString *key = [NSString stringWithFormat:@"%@,",keys];
//        sql = [sql stringByAppendingString:key];
//    }
//    sql = [sql substringToIndex:[sql length]-1];
//    sql = [sql stringByAppendingString:@") VALUES ("];
//    
//    for(NSString *keys in obj.DataRows){
//        NSString *value = @"";
//        if([obj.DataRows valueForKey:keys] != NULL)
//        value = [NSString stringWithFormat:@"'%@',",[obj.DataRows valueForKey:keys]];
//        else
//        value = [NSString stringWithFormat:@"'',"];
//        
//        sql = [sql stringByAppendingString:value];
//    }
//    sql = [sql substringToIndex:[sql length]-1];
//    sql = [sql stringByAppendingString:@")"];
//    
//    NSLog(@"%@",sql);
//    
//    char *error;
//    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
//    {
//        sqlite3_exec(contactDB, [sql UTF8String], NULL, NULL, &error);
//            if (error == NULL || (error[0] == '\0')) {
//                insertProc = TABLE_INSERTION_SUCCESS;
//            }
//        
//        sqlite3_close(contactDB);
//    }
//    return insertProc;
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


@end