//
//  SIUtilities.m
//  iMobile Planner
//
//  Created by shawal sapuan on 5/13/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUtilities.h"
#import "DataTable.h"
#import "FMDatabaseAdditions.h"


static sqlite3 *contactDB = nil;

@implementation SIUtilities


+ (BOOL)makeDBCopy:(NSString *)path {
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
    success = [fileManager fileExistsAtPath:path];
    if (success) return YES;
    
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            return NO;
        }
        
        defaultDBPath = Nil;
    }
    
	fileManager = Nil;
    error = Nil;
    return YES;
}

+ (BOOL)addColumnTable:(NSString *)table column:(NSString *)columnName type:(NSString *)columnType dbpath:(NSString *)path {
    sqlite3_stmt *statement;
    if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",table,columnName,columnType];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            return NO;
        }
        
        sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, NULL);
        return YES;
        sqlite3_close(contactDB);
    }
    return YES;
}


+ (BOOL)updateTable:(NSString *)table set:(NSString *)column value:(NSString *)val where:(NSString *)param equal:(NSString *)val2 dbpath:(NSString *)path {
    sqlite3_stmt *statement;
    if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"UPDATE %@ SET %@= \"%@\" WHERE %@=\"%@\"",table,column,val,param,val2];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            return NO;
        }
        
        sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, NULL);
        return YES;
        sqlite3_close(contactDB);
    }
    return YES;
}


+ (void)runQuery:(NSString *)path withQuery:(NSString *)query {
    
	FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    [database executeUpdate:query];
    
    [database close];
}


+ (NSString *)WSLogin {
#ifdef UAT_BUILD
    return @"http://echannel.dev/";
#else
    return @"http://www.hla.com.my:2880/";
#endif
}

+ (BOOL)InstallUpdate:(NSString *)path {
    NSString * AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];

    sqlite3_stmt *statement;
    NSString *QuerySQL;
    NSString *CurrenVersion = @"";

    // checking of SI Version
    if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK){

        QuerySQL = [ NSString stringWithFormat:@"select SIVersion FROM Trad_Sys_SI_version_Details"];
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CurrenVersion = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }

        if (! [AppsVersion isEqualToString:CurrenVersion]) {
            QuerySQL = [ NSString stringWithFormat:@"Update Trad_Sys_SI_version_Details set SIVersion = '%@'", AppsVersion];
            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
        }

        // checking of eApps Version
        CurrenVersion = @"";
        QuerySQL = [ NSString stringWithFormat:@"select eAppVersion FROM eProposal_Version_Details"];
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CurrenVersion = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        
        
        if (! [AppsVersion isEqualToString:CurrenVersion]) {
            QuerySQL = [ NSString stringWithFormat:@"Update eProposal_Version_Details set eAppVersion = '%@'", AppsVersion];
            if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
        }

        sqlite3_close(contactDB);
    }



    return YES;
}

@end
