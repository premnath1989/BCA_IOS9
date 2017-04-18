//
//  SAMDBHelper.m
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMDBHelper.h"
#import "SAMModel.h"
#import "FMDatabase.h"

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
    NSString *SAMCustomerID;
    NSString *SAMDateModified;
    NSString *SAMStatus;
    NSString *SAMNextMeeting;
    NSString *SAMProspectName;
    NSString *SAMIDCFF;
    NSString *SAMIDProductRecommendation;
    NSString *SAMIDVideo;
    NSString *SAMIDIllustration;
    NSString *SAMIDApplication;
    NSString *SAMID;
    NSString *SAMNumber;
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.SAM_Type, a.SAM_CustomerID, a.SAM_DateModified, a.SAM_Status, a.SAM_NextMeeting, b.ProspectName, a.SAM_ID_CFF, a.SAM_ID_ProductRecommendation, a.SAM_ID_Video, a.SAM_ID_Illustration, a.SAM_ID_Application, a.SAM_ID, a.SAM_Number FROM SAM_Master as a, prospect_profile as b WHERE a.SAM_CustomerID = b.IndexNo"];
        const char *query_stmt = [sql UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            res = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                SAMType = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                SAMCustomerID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                const char *datemodified = (const char *) sqlite3_column_text(statement, 2);
                SAMDateModified = datemodified == NULL ? nil : [[NSString alloc] initWithUTF8String:datemodified];
                
                const char *status = (const char *) sqlite3_column_text(statement, 3);
                SAMStatus = status == NULL ? nil : [[NSString alloc] initWithUTF8String:status];
                
                const char *nextmeeting = (const char *) sqlite3_column_text(statement, 4);
                SAMNextMeeting = nextmeeting == NULL ? nil : [[NSString alloc] initWithUTF8String:nextmeeting];
                
                const char *prospectname = (const char *) sqlite3_column_text(statement, 5);
                SAMProspectName = prospectname == NULL ? nil : [[NSString alloc] initWithUTF8String:prospectname];
                
                const char *cff = (const char *) sqlite3_column_text(statement, 6);
                SAMIDCFF = cff == NULL ? nil : [[NSString alloc] initWithUTF8String:cff];
                
                const char *recommendation = (const char *) sqlite3_column_text(statement, 7);
                SAMIDProductRecommendation = recommendation == NULL ? nil : [[NSString alloc] initWithUTF8String:recommendation];
                
                const char *video = (const char *) sqlite3_column_text(statement, 8);
                SAMIDVideo = video == NULL ? nil : [[NSString alloc] initWithUTF8String:video];
                
                const char *illustration = (const char *) sqlite3_column_text(statement, 9);
                SAMIDIllustration = illustration == NULL ? nil : [[NSString alloc] initWithUTF8String:illustration];
                
                const char *application = (const char *) sqlite3_column_text(statement, 10);
                SAMIDApplication = application == NULL ? nil : [[NSString alloc] initWithUTF8String:application];
                
                const char *samId = (const char *) sqlite3_column_text(statement, 11);
                SAMID = samId == NULL ? nil : [[NSString alloc] initWithUTF8String:samId];
                
                const char *samNumber = (const char *) sqlite3_column_text(statement, 12);
                SAMNumber = samNumber == NULL ? nil : [[NSString alloc] initWithUTF8String:samNumber];
                
                SAMModel *model = [[SAMModel alloc] init];
                
                model._id = SAMID;
                model.number = SAMNumber;
                model.customerType = SAMType;
                model.customerID = SAMCustomerID;
                model.dateModified = SAMDateModified;
                model.status = SAMStatus;
                model.dateNextMeeting = SAMNextMeeting;
                model.customerName = SAMProspectName;
                model.idCFF = SAMIDCFF;
                model.idRecomendation = SAMIDProductRecommendation;
                model.idVideo = SAMIDVideo;
                model.idApplication = SAMIDApplication;
                model.idIllustration = SAMIDIllustration;
                
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
- (SAMModel *) ReadSAMData: (NSString *) customerID {
    SAMModel *model = [[SAMModel alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    NSString *SAMType;
    NSString *SAMDateModified;
    NSString *SAMStatus;
    NSString *SAMNextMeeting;
    NSString *SAMProspectName;
    NSString *SAMID;
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.SAM_Type, a.SAM_DateModified, a.SAM_Status, a.SAM_NextMeeting, b.ProspectName, a.SAM_ID FROM SAM_Master as a, prospect_profile as b WHERE a.SAM_CustomerID = b.IndexNo"];
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
                
                const char *samId = (const char *) sqlite3_column_text(statement, 5);
                SAMID = samId == NULL ? nil : [[NSString alloc] initWithUTF8String:samId];
                
                model._id = SAMID;
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
    NSString *lastID;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    SAMModel *model = [[SAMModel alloc] init];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
    FMResultSet *lastIdResult = [database executeQuery:GetLastIdSQL];
    while([lastIdResult next]) {
        lastID = [NSString stringWithFormat:@"%@", [lastIdResult objectForColumnName:@"indexno"]];
    }
    
    model = [self InsertSAMDataWithLastID:lastID];
    
    return model;
}

- (SAMModel *) InsertSAMDataWithLastID: (NSString *)lastID {
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    NSString *lastSAMID;
    
    SAMModel *model = [[SAMModel alloc] init];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",@"yyyy-MM-dd"]];
    NSString *targetDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString* dateToday = targetDateString;
    
    BOOL success = [database executeUpdate:@"INSERT INTO SAM_Master(\"SAM_Number\", \"SAM_CustomerID\", \"SAM_Type\", \"SAM_ID_CFF\", \"SAM_ID_ProductRecommendation\", \"SAM_ID_Video\", \"SAM_ID_Illustration\", \"SAM_ID_Application\", \"SAM_DateCreated\", \"SAM_DateModified\", \"SAM_Comments\", \"SAM_Status\", \"SAM_NextMeeting\") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", lastID, lastID, @"Prospect", @"", @"", @"", @"", @"", dateToday, dateToday, @"", @"Follow Up", @""];
    if(success) {
        model.number = lastID;
        model.customerID = lastID;
        model.customerType = @"Prospect";
        model.dateCreated = dateToday;
        model.dateModified = dateToday;
        model.status = @"Follow Up";
    }
    
    NSString *GetLastIdSQL = @"Select SAM_ID from SAM_Master order by \"SAM_ID\" desc limit 1";
    FMResultSet *lastIdResult = [database executeQuery:GetLastIdSQL];
    while([lastIdResult next]) {
        lastSAMID = [NSString stringWithFormat:@"%@", [lastIdResult objectForColumnName:@"SAM_ID"]];
        model._id = lastSAMID;
    }
    
    [database close];
    
    sqlite3_close(contactDB);
    return model;
}

- (BOOL) UpdateSAMData:(SAMModel *) model {
    BOOL isSuccess = false;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE SAM_Master set \"SAM_Type\"=\"%@\", \"SAM_DateModified\"=\"%@\", \"SAM_ID_CFF\"=\"%@\", \"SAM_ID_ProductRecommendation\"=\"%@\", \"SAM_ID_Video\"=\"%@\", \"SAM_ID_Illustration\"=\"%@\", \"SAM_ID_Application\"=\"%@\", \"SAM_Status\"=\"%@\", \"SAM_NextMeeting\"=\"%@\" WHERE SAM_CustomerID = \"%@\" ", model.customerType, model.dateModified, model.idCFF, model.idRecomendation, model.idVideo, model.idIllustration, model.idApplication, model.status, model.dateNextMeeting, model.customerID];
    
    isSuccess = [database executeUpdate:sql];
    
    //sqlite3_stmt *statement;
    //const char *dbpath = [databasePath UTF8String];
    //if(sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
    //    NSString *sql = [NSString stringWithFormat:@"UPDATE SAM_Master set \"SAM_Type\"=\"%@\", \"SAM_DateModified\"=\"%@\", \"SAM_ID_CFF\"=\"%@\", \"SAM_ID_ProductRecommendation\"=\"%@\", \"SAM_ID_Video\"=\"%@\", \"SAM_ID_Illustration\"=\"%@\", \"SAM_ID_Application\"=\"%@\", \"SAM_Status\"=\"%@\", \"SAM_NextMeeting\"=\"%@\" WHERE SAM_CustomerID = \"%@\" ", model.customerType, [formatter getDateToday:@"yyyy-MM-dd"], model.idCFF, model.idRecomendation, model.idVideo, model.idIllustration, model.idApplication, model.status, model.dateNextMeeting, model.customerID];
    //    const char *query_stmt = [sql UTF8String];
    //    if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
    //        isSuccess = true;
    //    }
    //    sqlite3_finalize(statement);
    //}
    sqlite3_close(contactDB);
    
    return isSuccess;
}

- (NSMutableArray *) ReadMeetingNoteForSAM:(NSString *)SAMid
{
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent:@"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT * FROM SAM_detail as details WHERE details.SAM_ID = ?", SAMid];
    
    while([result next]) {
        SAMMeetingNoteModel *note = [[SAMMeetingNoteModel alloc] init];
        note.SAMID = [result objectForColumnName:@"SAM_ID"];
        note.SAMNumber = [result objectForColumnName:@"SAM_Number"];
        note.meetingDate = [result objectForColumnName:@"SAMDetail_MeetingDate"];
        note.meetingTime = [result objectForColumnName:@"SAMDetail_MeetingTime"];
        note.meetingLocation = [result objectForColumnName:@"SAMDetail_MeetingLocation"];
        note.meetingDuration = [result objectForColumnName:@"SAMDetail_MeetingDuration"];
        note.meetingStatus = [result objectForColumnName:@"SAMDetail_MeetingStatus"];
        note.meetingActivity = [result objectForColumnName:@"SAMDetail_MeetingActivity"];
        note.meetingComments = [result objectForColumnName:@"SAMDetail_MeetingComments"];
        [notes addObject:note];
    }
    
    [database close];
    
    return notes;
}

- (BOOL) CreateMeetingNote:(SAMMeetingNoteModel *)note
{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent:@"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];

    BOOL isSuccess = [database executeUpdate:@"INSERT INTO SAM_Detail(\"SAM_ID\", \"SAM_Number\", \"SAMDetail_MeetingDate\", \"SAMDetail_MeetingTime\", \"SAMDetail_MeetingLocation\", \"SAMDetail_MeetingDuration\", \"SAMDetail_MeetingStatus\", \"SAMDetail_MeetingActivity\", \"SAMDetail_MeetingComments\") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", note.SAMID, note.SAMNumber, note.meetingDate, note.meetingTime, note.meetingLocation, note.meetingDuration, note.meetingStatus, note.meetingActivity, note.meetingComments];
    
    [database close];
    
    return isSuccess;
}

@end
