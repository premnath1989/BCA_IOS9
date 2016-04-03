//
//  DBUpdater.m
//  MPOS
//
//  Created by CK Quek on 9/8/15.
//  Copyright (c) 2015 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DBUpdater.h"
#import <sqlite3.h>

@implementation DBUpdater

-(NSArray *)filterJSONFiles:(NSString *)init_version
{
    NSString *folderpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dbupdates"];
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderpath error:nil];
    NSMutableArray *filter = [[NSMutableArray alloc] init];
    
    NSPredicate *subpredicate1 = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", @".json"];
    [filter addObject:subpredicate1];
    NSPredicate *subpredicate2 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[(NSString *)evaluatedObject stringByDeletingPathExtension] compare: init_version] == NSOrderedDescending;
    }];
    [filter addObject:subpredicate2];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:filter];
    NSArray *filteredMatch = [fileArray filteredArrayUsingPredicate:predicate];
    
    NSArray *sortedFiles = [filteredMatch sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    return sortedFiles;
}

-(NSDictionary *)parseJSONFile:(NSString *)filename
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json" inDirectory:@"dbupdates"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!dict) {        
        NSLog(@"%@ - Could not parse json file.",[error localizedDescription]);
    }
    
    return dict;
}

#pragma mark - Updating functions
-(void)updateDatabase
{
    NSString *tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hladb.sqlite"];
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"hladb.sqlite"];
    NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
    
    // compare database version with the version saved in the plist
    NSString *dbVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"dbVersion"];
    NSString *bundleDBVersion = @"0.0";
    sqlite3 *database;
    if (sqlite3_open([bundleDBPath UTF8String], &database) == SQLITE_OK) {
        bundleDBVersion = [self getDBVersionNumber:database];
    }
    
    sqlite3_close(database);
    if ([bundleDBVersion compare:dbVersion] == NSOrderedDescending) {
        if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
            // get actual database version
            dbVersion = [self getDBVersionNumber:database];
            if ([dbVersion isEqualToString:@""]) {
                [self createDBVersionTable:database];
                dbVersion = @"0";
            }
        }
        sqlite3_close(database);
        
        NSArray *filteredJSON = [self filterJSONFiles:dbVersion];
        if (filteredJSON.count > 0) {
            NSDictionary *dict;
            NSString *remark;
            NSString *jsonVersion;
            [self copyDBFromDefault:defaultDBPath ToTemp:tempDir];
            
            if (sqlite3_open([tempDir UTF8String], &database) == SQLITE_OK) {
                for (NSString *jsonFileName in filteredJSON) {
                    jsonVersion = [[jsonFileName lastPathComponent] stringByDeletingPathExtension];
                    dict = [self parseJSONFile:jsonVersion];
                    if (dict != NULL) {
                        [self runSQLStatements:database SQLStatements:dict];
                        [self runInsertIfFalse:database SQLStatements:dict];
                        // update version
                        remark = [dict objectForKey:@"remark"];
                        [self updateDBVersion:database NewVersion:jsonVersion Remark:remark];
                    }
                }
            }
            sqlite3_close(database);
            [self moveDBFromTemp:tempDir ToDefault:defaultDBPath];
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:bundleDBVersion forKey:@"dbVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

-(void)copyDBFromDefault:(NSString *)defaultDBPath ToTemp:(NSString *)tempDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    NSError *error;
    // remove left over hladb.sqlite from temporary folder
    if ([fileManager removeItemAtPath:tempDir error:&error] != YES) {
        if (error.code != 4) {
            NSLog(@"%@ - Removing item from temporary directory.",[error localizedDescription]);            
        }
    }
    
    // copy hladb.sqlite from document folder to temporary folder
    if ([fileManager copyItemAtPath:defaultDBPath toPath:tempDir error:&error] != YES) {
        NSLog(@"%@ - Copy item from default to temporary directory.",[error localizedDescription]);
    }
}

-(void)moveDBFromTemp:(NSString *)tempDir ToDefault:(NSString *)defaultDBPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // remove hladb.sqlite from default folder
    if ([fileManager removeItemAtPath:defaultDBPath error:&error] != YES) {
        if (error.code != 4) {
            NSLog(@"%@ - Removing item from default directory.",[error localizedDescription]);
        }
    }
    
    // replace the hladb.sqlite by moving the database in the temporary folder to the default folder
    if ([fileManager moveItemAtPath:tempDir toPath:defaultDBPath error:&error] != YES) {
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
        }
    } else {
        // no DB_Version table found, create new one
        NSLog(@"No version table found.");
        version = @"";
    }
    sqlite3_finalize(statement);
    return version;
}

// database must be opened
-(void)createDBVersionTable:(sqlite3 *)database
{
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS DB_Version (Version VARCHAR, DateUpdate INTEGER, Remark VARCHAR)";
    
    int result = sqlite3_exec(database, [createTableSQL UTF8String], NULL, NULL, NULL);
    if(result == SQLITE_OK) {
        NSLog(@"Database created.");
    } else {
        NSLog(@"Error %d - Unable to create database.",result);
    }
}

-(void)runSQLStatements:(sqlite3 *)database SQLStatements:(NSDictionary *)dict
{
    NSArray *sqlArr = [dict objectForKey:@"sql"];
    sqlite3_stmt *statement;
    for (NSString *sql in sqlArr) {
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }    
}

-(void)runInsertIfFalse:(sqlite3 *)database SQLStatements:(NSDictionary *)dict
{
    NSArray *sqlArr = [dict objectForKey:@"execOnFalse"];
    sqlite3_stmt *statement;
    NSString *sql;
    for (NSArray *arr in sqlArr) {
        sql = [arr objectAtIndex:0];
        int temp = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (temp != SQLITE_OK) {
            sql = [arr objectAtIndex:1];
            sqlite3_stmt *statement2;
            if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                sqlite3_step(statement2);
                sqlite3_finalize(statement2);
            }
        }
        sqlite3_finalize(statement);
    }
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

#pragma mark - Misc


@end
