//
//  DBMigration.m
//  BLESS
//
//  Created by Erwin Lim  on 3/21/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBMigration.h"
#import "LoginMacros.h"

@implementation ColumnDetails

@synthesize type;
@synthesize PK;

-(id)init
{
    self = [super init];
    return self;
}

@end

@implementation DBMigration

#pragma mark - Updating functions
-(void)updateDatabase:(NSString*)dbName
{
    tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:dbName];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    // compare database version with the version saved in the plist
    NSString *dbVersion = [NSString stringWithFormat:
                           @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]];
    NSLog(@"dbversion New: %@",dbVersion);
    NSString *bundleDBVersion = @"0.0";
    sqlite3 *database;
    if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
        bundleDBVersion = [self getDBVersionNumber:database];
    }
    sqlite3_close(database);
    
    
    if ([bundleDBVersion floatValue] < [dbVersion floatValue]) {
        
        [self moveDBFromDefault:defaultDBPath ToTemp:tempDir];
        loginDB = [[LoginDBManagement alloc]init];
        [loginDB makeDBCopy];

        //put database element into dictionary
        NSMutableDictionary *newTablesDict =  [self getTablesName:defaultDBPath];
        NSMutableDictionary *oldTablesDict =  [self getTablesName:tempDir];
        NSMutableDictionary *tempTablesDict = [[NSMutableDictionary alloc]init];
        
        //we gather the difference between database
        for(NSString *tableName in [newTablesDict allKeys]){
            if([oldTablesDict valueForKey:tableName] != nil){
                NSMutableDictionary *tempColumnDict = [[NSMutableDictionary alloc]init];
                for(NSString *columnName in [[newTablesDict valueForKey:tableName] allKeys]){
                    if([[oldTablesDict valueForKey:tableName] valueForKey:columnName] == nil){
                        //add new column to the tempTableDict
                        [tempColumnDict setValue:[[newTablesDict valueForKey:tableName] valueForKey:columnName] forKey:columnName];
                    }
                }
                if([[tempColumnDict allValues]count] != 0)
                    [tempTablesDict setValue:tempColumnDict forKey:tableName];
            }else{
                
                //insert new table into tempDir
                NSString *sqlTable = [NSString stringWithFormat:@"CREATE TABLE %@ (",tableName];
                NSString *sqlIndex = @"";
                if (sqlite3_open([tempDir UTF8String], &database) == SQLITE_OK) {
                    for(NSString *columnName in [newTablesDict valueForKey:tableName]){
                        ColumnDetails *columnType = (ColumnDetails *)[[newTablesDict valueForKey:tableName] valueForKey:columnName];
                        NSString *key = [NSString stringWithFormat:@"%@ %@,",columnName, columnType.type];
                        sqlTable = [sqlTable stringByAppendingString:key];
                        if([columnType.PK isEqualToString:@"1"]){
                            sqlIndex = [NSString stringWithFormat:@"CREATE UNIQUE INDEX %@ ON %@(%@)",tableName, tableName, columnName];
                        }
                    }
                    sqlTable = [sqlTable substringToIndex:[sqlTable length]-1];
                    sqlTable = [sqlTable stringByAppendingString:@")"];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(database, [sqlTable UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        sqlite3_step(statement);
                    }
                    
                    //after new table is created, now we inserted the index
                    sqlite3_finalize(statement);
                    if([sqlIndex isEqualToString:@""]){
                        if (sqlite3_prepare_v2(database, [sqlIndex UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                            sqlite3_step(statement);
                        }
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(database);
            }
        }
        
        //insert new column into tempDir
        if (sqlite3_open([tempDir UTF8String], &database) == SQLITE_OK) {
            for(NSString *tableName in [tempTablesDict allKeys]){
                //we construct query from temp dictionary
                for(NSString *columnName in [tempTablesDict valueForKey:tableName]){
                    ColumnDetails *columnType = (ColumnDetails *)[[tempTablesDict valueForKey:tableName]valueForKey:columnName];
                    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",
                                     tableName, columnName, columnType.type];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        sqlite3_step(statement);
                    }
                    sqlite3_finalize(statement);
                }
            }
        }
        
        sqlite3_close(database);
        [self moveDBFromTemp:tempDir ToDefault:defaultDBPath];
        [self updateDBVersion:defaultDBPath NewVersion:dbVersion Remark:@""];
        
        [[NSUserDefaults standardUserDefaults] setObject:bundleDBVersion forKey:@"dbVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

//implementation of update DB
//we use the new DB and insert the data from the older DB.
-(void)updateDatabaseUseNewDB:(NSString*)dbName{
    NSString *dbVersion = [NSString stringWithFormat:
                           @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]];
    
    if([self hardUpdateDatabase:dbName versionNumber:dbVersion]){
        
        defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
        
        NSString *dbVersion = [NSString stringWithFormat:
                               @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]];
        NSLog(@"dbName = %@, dbversion New: %@",dbName, dbVersion);
        NSString *bundleDBVersion = @"0.0";
        sqlite3 *database;
        if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
            bundleDBVersion = [self getDBVersionNumber:database];
        }
        sqlite3_close(database);
            
        NSMutableDictionary *oldTablesDict =  [self getTablesName:tempDir];
        NSMutableDictionary *newTablesDict =  [self getTablesName:defaultDBPath];
        char *error;
        for(NSString *tableName in [oldTablesDict allKeys]){
            if([newTablesDict valueForKey:tableName] != nil){
                if(sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK){
                    NSString *sql = [NSString stringWithFormat:@"ATTACH \"%@\" AS defDB",
                                     tempDir];
                    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error);
                    if (error) {
                        NSLog(@"Error to Attach = %s",error);
                    }
                    
                    NSString *tablesCol = @"(";
                    NSString *tablesColSelection = @"";
                    
                    for(NSString *tableColName in [[oldTablesDict valueForKey:tableName] allKeys]){
                        tablesCol = [tablesCol stringByAppendingString:[NSString stringWithFormat:@"[%@],",tableColName]];
                        tablesColSelection =[tablesColSelection stringByAppendingString:[NSString stringWithFormat:@"[%@],",tableColName]];
                    }
                    tablesCol = [tablesCol substringToIndex:[tablesCol length]-1];
                    tablesColSelection = [tablesColSelection substringToIndex:[tablesCol length]-1];
                    tablesCol = [tablesCol stringByAppendingString:@")"];
                    
                    sql = [NSString stringWithFormat:
                           @"INSERT OR REPLACE INTO %@ %@ SELECT %@ FROM defDB.%@;",
                           tableName,tablesCol, tablesColSelection, tableName];
                    NSLog(@"%@", sql);
                    sqlite3_exec(database, [sql UTF8String], NULL, NULL,&error);
                    if (error) {
                        NSLog(@"Error to insert = %s",error);
                    }
                }
                sqlite3_close(database);
            }
        }
        [self updateDBVersion:defaultDBPath NewVersion:dbVersion Remark:@""];
    }
}

-(BOOL)hardUpdateDatabase:(NSString*)dbName versionNumber:(NSString *)dbVersion
{
    tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:dbName];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    
    // compare database version with the version saved in the plist
    NSLog(@"dbName = %@, dbversion New: %@",dbName, dbVersion);
    NSString *bundleDBVersion = @"0.0";
    sqlite3 *database;
    if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
        bundleDBVersion = [self getDBVersionNumber:database];
    }
    sqlite3_close(database);
    
    if ([bundleDBVersion floatValue] < [dbVersion floatValue]) {
        
        [self moveDBFromDefault:defaultDBPath ToTemp:tempDir];
        loginDB = [[LoginDBManagement alloc]init];
        [loginDB makeDBCopy];
        [self updateDBVersion:defaultDBPath NewVersion:dbVersion Remark:@""];
        return TRUE;
    }
    return FALSE;
}

- (int)DbSchema{
    
    return 0;
}

-(void)updateDBVersion:(NSString *)dbPath NewVersion:(NSString *)newVersion Remark:(NSString *)remark
{
    int today = [[NSDate date] timeIntervalSince1970];
    
    sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
    
        // delete old database entry
        NSString *sql = @"DELETE FROM DB_Version";
        sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
        
        // insert new database entry
        sql = [NSString stringWithFormat:@"INSERT INTO DB_Version (Version, DateUpdate, Remark) VALUES (\"%@\", \"%d\", \"%@\")",
               newVersion, today, remark];
        sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
    }
    sqlite3_close(database);
    
}

-(void)moveDBFromDefault:(NSString *)defaultDBPathStr ToTemp:(NSString *)tempDirStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // remove left over hladb.sqlite from temporary folder
    if ([fileManager removeItemAtPath:tempDirStr error:&error] != YES) {
        if (error.code != 4) {
            NSLog(@"%@ - Removing item from temporary directory.",[error localizedDescription]);
        }
    }
    
    // copy hladb.sqlite from document folder to temporary folder
    if ([fileManager copyItemAtPath:defaultDBPathStr toPath:tempDirStr error:&error] != YES) {
        NSLog(@"%@ - Copy item from default to temporary directory.",[error localizedDescription]);
    }
    
    
    //Now we remove the database from default path
    if([fileManager fileExistsAtPath:defaultDBPathStr]){
        if ([fileManager removeItemAtPath:defaultDBPathStr error:&error] != YES) {
            if (error.code != 4) {
                NSLog(@"%@ - Removing item from temporary directory.",[error localizedDescription]);
            }
        }
    }
}

-(void)moveDBFromTemp:(NSString *)tempDirStr ToDefault:(NSString *)defaultDBPathStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // remove hladb.sqlite from default folder
    if ([fileManager removeItemAtPath:defaultDBPathStr error:&error] != YES) {
        if (error.code != 4) {
            NSLog(@"%@ - Removing item from default directory.",[error localizedDescription]);
        }
    }
    
    // replace the hladb.sqlite by moving the database in the temporary folder to the default folder
    if ([fileManager moveItemAtPath:tempDirStr toPath:defaultDBPathStr error:&error] != YES) {
        NSLog(@"%@ - Moving item from temporary to default directory.",[error localizedDescription]);
    }
    
}

#pragma mark - Database functions

- (NSString *)getDBVersionNumber:(sqlite3 *)database
{
    sqlite3_stmt *statement;
    NSString * version = @"0";
    NSString *querySQL = @"SELECT Version FROM DB_Version";
    if (sqlite3_prepare_v2(database, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        int result = sqlite3_step(statement);
        if (result == SQLITE_ROW) {
            version = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            NSLog(@"dbversion old: %@",version);
        }
    } else {
        // no DB_Version table found, create new one
        NSLog(@"No version table found.");
        version = @"";
    }
    sqlite3_finalize(statement);
    return version;
}

- (NSMutableDictionary *) getTablesName:(NSString *)dbPath{
    sqlite3_stmt *tableStatement;
    sqlite3_stmt *columnsStatement;
    NSMutableDictionary *newTableDict = [[NSMutableDictionary alloc]init];
    if (sqlite3_open([dbPath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT name FROM sqlite_master WHERE type='table'"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &tableStatement, NULL) == SQLITE_OK){
            while (sqlite3_step(tableStatement) == SQLITE_ROW) {
                
                NSLog(@"table name: %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(tableStatement,0)]);
                //now we are getting the columns for each respective table
                NSString *querySQLColumn = [NSString stringWithFormat: @"PRAGMA table_info(%@)", [NSString stringWithUTF8String:(char *)sqlite3_column_text(tableStatement,0)]];
                if (sqlite3_prepare_v2(contactDB, [querySQLColumn UTF8String], -1, &columnsStatement, NULL) == SQLITE_OK){
                    NSMutableDictionary *newColumnsArr = [[NSMutableDictionary alloc]init];
                    
                    while (sqlite3_step(columnsStatement) == SQLITE_ROW) {
                        ColumnDetails *columnInfo = [[ColumnDetails alloc]init];
                        columnInfo.type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,2)];
                        columnInfo.PK = [NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,5)];
                        [newColumnsArr setValue:columnInfo forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,1)]];
                    }
                    //we insert the columns array into dictionary
                    [newTableDict setValue:newColumnsArr forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_text(tableStatement,0)]];
                }
                sqlite3_finalize(columnsStatement);
            }
            sqlite3_finalize(tableStatement);
        }
        sqlite3_close(contactDB);
    }
    return newTableDict;
}



@end
