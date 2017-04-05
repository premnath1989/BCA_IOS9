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

@synthesize formatter;

NSArray *dirPaths;
NSString *docsDir;
NSString *databasePath;

- (NSMutableArray *) readAllSAMData {
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    NSMutableArray *res;
    
    NSString *SAMType;
    NSString *SAMDateModified;
    NSString *SAMStatus;
    NSString *SAMNextMeeting;
    NSString *SAMProspectName;
    
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

/**
 * Return SAM data from database based on customer ID
 * @param customerID customer ID after creating new customer
 * @return A new SAMModel object containing customer's data
 */
- (SAMModel *) GetSAMData: (NSString *) customerID {
    SAMModel *model = [[SAMModel alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    NSString *SAMType;
    NSString *SAMDateModified;
    NSString *SAMStatus;
    NSString *SAMNextMeeting;
    NSString *SAMProspectName;
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.SAM_Type, a.SAM_DateModified, a.SAM_Status, a.SAM_NextMeeting, b.ProspectName FROM SAM_Master as a, prospect_profile as b WHERE a.SAM_CustomerID = b.IndexNo"];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
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
                
                model.customerType = SAMType;
                model.dateModified = SAMDateModified;
                model.status = SAMStatus;
                model.dateNextMeeting = SAMNextMeeting;
                model.customerName = SAMProspectName;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return model;
}

- (SAMModel *) InsertSAMData {
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *lastID;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    SAMModel *model = [[SAMModel alloc] init];
    
    NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
    const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
    if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement2) == SQLITE_ROW) {
            lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
            sqlite3_finalize(statement2);
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",@"yyyy-MM-dd"]];
    NSString *targetDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString* dateToday = targetDateString;
    
    NSString *insertSAMSQL = [NSString stringWithFormat:@"INSERT INTO SAM_Master(\"SAM_Number\", \"SAM_CustomerID\", \"SAM_Type\", \"SAM_ID_CFF\", \"SAM_ID_ProductRecommendation\", \"SAM_ID_Video\", \"SAM_ID_Illustration\", \"SAM_ID_Application\", \"SAM_DateCreated\", \"SAM_DateModified\", \"SAM_Comments\", \"SAM_Status\", \"SAM_NextMeeting\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, lastID, @"Prospect", @"", @"", @"", @"", @"", dateToday, dateToday, @"", @"Follow Up", @""];
    
    const char *insert_stmt = [insertSAMSQL UTF8String];
    if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            model.number = lastID;
            model.customerID = lastID;
            model.customerType = @"Prospect";
            model.dateCreated = dateToday;
            model.dateModified = dateToday;
            model.status = @"Follow Up";
        } else {
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting into profile table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [failAlert show];
        }
        sqlite3_finalize(statement);
    }
    else{
        NSLog(@"query insert %@",insertSAMSQL);
        NSLog(@"could not prepare statement: %s", sqlite3_errmsg(contactDB));
    }
    
    sqlite3_close(contactDB);
    return model;
}

- (BOOL) UpdateSAMData:(SAMModel *) model {
    BOOL isSuccess = false;
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE SAM_Master set \"SAM_Type\"=\"%@\", \"SAM_DateModified\"=\"%@\", \"SAM_ID_CFF\"=\"%@\", \"SAM_ID_ProductRecommendation\"=\"%@\", \"SAM_ID_Video\"=\"%@\", \"SAM_ID_Illustration\"=\"%@\", \"SAM_ID_Application\"=\"%@\", \"SAM_Status\"=\"%@\", \"SAM_NextMeeting\"=\"%@\" WHERE SAM_CustomerID = \"%@\" ", model.customerType, [formatter getDateToday:@"yyyy-MM-dd"], model.idCFF, model.idRecomendation, model.idVideo, model.idIllustration, model.idApplication, model.status, model.dateNextMeeting, model.customerID];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            isSuccess = true;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(contactDB);
    
    return isSuccess;
}

@end
