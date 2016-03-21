//
//  DBMigration.h
//  BLESS
//
//  Created by Erwin Lim  on 3/21/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "LoginDBManagement.h"
#import <sqlite3.h>

@interface DBMigration : NSObject{
    LoginDBManagement *loginDB;
    NSString *databasePath;
    NSArray *dirPaths;
    NSString *defaultDBPath;
    NSString *bundleDBPath;
    sqlite3 *contactDB;
    NSString *tempDir;
}

-(void)updateDatabase;

@end