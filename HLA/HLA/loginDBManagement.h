//
//  loginDBManagement.h
//  BLESS
//
//  Created by Erwin on 05/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface loginDBManagement : NSObject{
    NSString *databasePath;
    NSString *RatesDatabasePath;
    NSString *UL_RatesDatabasePath;
    NSString *CommDatabasePath;
    sqlite3 *contactDB;
}

- (int) SearchAgent:(NSString *)AgentID;
- (int) InsertAgentProfile:(NSString *) urlStr;
- (void) updateLoginDate:(int)indexNo;


@end
