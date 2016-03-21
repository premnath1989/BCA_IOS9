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

@implementation DBMigration

#pragma mark - Updating functions
-(void)updateDatabase
{
    tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hladb.sqlite"];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"hladb.sqlite"];
    bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
    
    // compare database version with the version saved in the plist
    NSString *dbVersion = [NSString stringWithFormat:
                           @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]];
    NSLog(@"dbversion New: %@",dbVersion);
    NSString *bundleDBVersion = @"0.0";
    sqlite3 *database;
    if (sqlite3_open([bundleDBPath UTF8String], &database) == SQLITE_OK) {
        bundleDBVersion = [self getDBVersionNumber:database];
    }
    sqlite3_close(database);
    
    if ([bundleDBVersion compare:dbVersion] == NSOrderedAscending) {
        
        [self moveDBFromDefault:defaultDBPath ToTemp:tempDir];
        
        
        loginDB = [[LoginDBManagement alloc]init];
        [loginDB makeDBCopy];
        
        
        NSMutableDictionary *newTablesDict =  [self getTablesName:defaultDBPath];
        NSMutableDictionary *oldTablesDict =  [self getTablesName:tempDir];
        NSMutableDictionary *tempTablesDict = [[NSMutableDictionary alloc]init];
        
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
                [tempTablesDict setValue:[newTablesDict valueForKey:tableName] forKey:tableName];
            }
        }
        
        if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
            
            for(NSString *tableName in [tempTablesDict allKeys]){
                //we construct dictionary consist of new database schema
                for(NSString *columnName in [tempTablesDict valueForKey:tableName]){
                    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",
                                     tableName, columnName, [[tempTablesDict valueForKey:tableName]valueForKey:columnName]]; 
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
        
        
        [[NSUserDefaults standardUserDefaults] setObject:bundleDBVersion forKey:@"dbVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (int)DbSchema{
    
    return 0;
}

-(void)updateDBVersion:(sqlite3 *)database NewVersion:(NSString *)newVersion Remark:(NSString *)remark
{
    int today = [[NSDate date] timeIntervalSince1970];
    // delete old database entry
    NSString *sql = @"DELETE FROM DB_Version";
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
    
    // insert new database entry
    sql = [NSString stringWithFormat:@"INSERT INTO DB_Version (Version, DateUpdate, Remark) VALUES (\"%@\", \"%d\", \"%@\")",
           newVersion, today, remark];
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, NULL);
    
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
    
    //Now we remove the database from default path
    if(![fileManager fileExistsAtPath:defaultDBPathStr]){
        NSLog(@"db is removed");
    }
}

-(void)moveDBFromTemp:(NSString *)tempDirStr ToDefault:(NSString *)defaultDBPathStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // remove hladb.sqlite from default folder
    if ([fileManager removeItemAtPath:bundleDBPath error:&error] != YES) {
        if (error.code != 4) {
            NSLog(@"%@ - Removing item from default directory.",[error localizedDescription]);
        }
    }
    
    // replace the hladb.sqlite by moving the database in the temporary folder to the default folder
    if ([fileManager moveItemAtPath:tempDirStr toPath:bundleDBPath error:&error] != YES) {
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
                        [newColumnsArr setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,2)] forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,1)]];
                        NSLog(@"columns name: %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,1)]);
                        NSLog(@"columns type: %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(columnsStatement,2)]);
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
