//
//  SAMDBHelper.m
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMDBHelper.h"
#import "SAMModel.h"

@implementation SAMDBHelper {
    sqlite3 *contactDB;
}

- (NSMutableArray *) loadAllSAMData {
    NSMutableArray *res;
    
    NSString *SAMType;
    NSString *SAMDateModified;
    NSString *SAMStatus;
    NSString *SAMNextMeeting;
    NSString *SAMProspectName;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.SAM_Type, a.SAM_DateModified, a.SAM_Status, a.SAM_NextMeeting, b.ProspectName FROM SAM_Master as a, prospect_profile as b WHERE a.SAM_CustomerID = b.IndexNo"];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            res = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                SAMType = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                const char *datemodified = (const char *) sqlite3_column_text(statement, 1);
                SAMDateModified = datemodified == NULL ? nil : [[NSString alloc] initWithUTF8String:datemodified];
                
                const char *status = (const char *) sqlite3_column_text(statement, 2);
                SAMStatus = status == NULL ? nil : [[NSString alloc] initWithUTF8String:status];
                
                const char *nextmeeting = (const char *) sqlite3_column_text(statement, 3);
                SAMNextMeeting = nextmeeting == NULL ? nil : [[NSString alloc] initWithUTF8String:nextmeeting];
                
                const char *prospectname = (const char *) sqlite3_column_text(statement, 4);
                SAMProspectName = prospectname == NULL ? nil : [[NSString alloc] initWithUTF8String:prospectname];
                
                SAMModel *model = [[SAMModel alloc] init];
                model.customerType = SAMType;
                model.dateModified = SAMDateModified;
                model.status = SAMStatus;
                model.dateNextMeeting = SAMNextMeeting;
                model.customerName = SAMProspectName;
                
                [res addObject:model];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return res;
}

@end
