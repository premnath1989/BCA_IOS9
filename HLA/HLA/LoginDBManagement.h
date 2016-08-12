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
    NSString *RefDatabasePath;
    sqlite3 *contactDB;
}

//Agent Profile functions
- (int) SearchAgent:(NSString *)AgentID;
- (int) insertAgentProfile:(WebResponObj *)obj;
- (int) FirstLogin:(NSString *)AgentID;
- (int) AgentRecord;
- (int) AgentStatus:(NSString *)AgentID;
- (int) DeleteAgentProfile;
- (int) DeviceStatus:(NSString *)AgentID;
- (int) SpvStatus:(NSString *)spvID;
- (void) updatePassword:(NSString *)newPassword;
- (void) makeDBCopy;
- (void) updateLoginDate;
- (void) updateLogoutDate;
- (void) duplicateRow:(NSString *)tableName param:(NSString *)column
             oldValue:(NSString *)oldValue newValue:(NSString *)newValue;
- (NSMutableDictionary *)getAgentDetails;

//general functions
- (int)insertTableFromJSON:(NSDictionary*) params databasePath:(NSString *)dbName;
- (int) ReferralSyncTable:(WebResponObj *)obj;
- (BOOL) fullSyncTable:(WebResponObj *)obj;

//SPAJ Functions
- (long long)SPAJAllocated;
- (long long)SPAJBalance;
- (long long)SPAJUsed;
- (long long)getLastActiveSPAJNum;
- (NSMutableArray *)SPAJRetrievePackID;

//SI functions
- (void) updateSIMaster:(NSString *)SINO EnableEditing:(NSString *)EditFlag;
- (BOOL) SpvAdmValidation:(NSString *)username password:(NSString *)password;
- (NSString *)RiderCode:(NSString *)SINo riderCode:(NSString *)code;
- (NSString *) expiryDate:(NSString *)AgentID;
- (NSString *) checkingLastLogout;
- (NSString *) localDBUDID;
- (NSString *) AgentCodeLocal;
- (NSString *)EditIllustration:(NSString *)SIno;
- (NSString *)getUniqueDeviceIdentifierAsString;
- (NSString *) getLastUpdateReferral;
- (NSMutableDictionary *)premiKeluargaku:(NSString *)SINo;

@end
