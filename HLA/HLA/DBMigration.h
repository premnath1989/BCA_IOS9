//
//  DBMigration.h
//  BLESS
//
//  Created by Erwin Lim  on 3/21/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "LoginDBManagement.h"
#import <sqlite3.h>
@class ColumnDetails;

@interface ColumnDetails:NSObject
{
    //Instance variables
    NSString *type;   // Length of a box
    NSString *PK;  // Breadth of a box
}
@property(nonatomic, readwrite) NSString *type; // Property
@property(nonatomic, readwrite) NSString *PK; // Property
@end

@interface DBMigration : NSObject{
    LoginDBManagement *loginDB;
    NSString *databasePath;
    NSArray *dirPaths;
    NSString *defaultDBPath;
    sqlite3 *contactDB;
    NSString *tempDir;
}

-(void)updateDatabase:(NSString*)dbName;
-(void)updateDatabaseUseNewDB:(NSString*)dbName;
-(BOOL)hardUpdateDatabase:(NSString*)dbName versionNumber:(NSString *)dbVersion;

@end