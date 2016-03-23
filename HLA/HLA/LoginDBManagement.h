//
//  LoginDBManagement.h
//  BLESS
//
//  Created by Erwin on 05/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "WebResponObj.h"

@interface LoginDBManagement : NSObject{
    NSString *databasePath;
    NSString *RatesDatabasePath;
    NSString *UL_RatesDatabasePath;
    NSString *CommDatabasePath;
    sqlite3 *contactDB;
}

- (int) SearchAgent:(NSString *)AgentID;
- (int) insertAgentProfile:(WebResponObj *)obj;
- (int) FirstLogin:(NSString *)AgentID;
- (int) AgentRecord;
- (int) AgentStatus:(NSString *)AgentID;
- (int) DeleteAgentProfile;
- (int) fullSyncTable:(WebResponObj *)obj;
- (int) DeviceStatus:(NSString *)AgentID;
- (int) SpvStatus:(NSString *)spvID;
- (void) updatePassword:(NSString *)newPassword;
- (void) makeDBCopy;
- (void) updateLoginDate;
- (void) updateLogoutDate;
- (BOOL) SpvAdmValidation:(NSString *)username password:(NSString *)password;
- (NSString *) expiryDate:(NSString *)AgentID;
- (NSString *) checkingLastLogout;
- (NSString *) localDBUDID;
- (NSString *) AgentCodeLocal;
- (NSMutableDictionary *)getAgentDetails;
-(NSMutableDictionary *)premiKeluargaku:(NSString *)SINo;
//- (int) InsertAgentProfile:(NSString *) urlStr;

@end
