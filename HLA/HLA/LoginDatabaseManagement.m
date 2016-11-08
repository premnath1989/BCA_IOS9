////
////  LoginDatabaseManagement.m
////  BLESS
////
////  Created by Erwin on 04/02/2016.
////  Copyright © 2016 Hong Leong Assurance. All rights reserved.
////
//
//#import "LoginDatabaseManagement.h"
//
//@implementation LoginDatabaseManagement
//
//
//#pragma mark - handle db
//
//- (void)makeDBCopy
//{
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *DBerror;
//    
//    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [dirPaths objectAtIndex:0];
//    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
//    NSString *RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"HLA_Rates.sqlite"]];
//    NSString *UL_RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"UL_Rates.sqlite"]];
//    NSString *CommDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Rates.json"]];
//    
//    /*
//     u1, insert 2 new column into Trad_rider_Detail, tempHL1KSA and tempHL1KSATerm
//     u2, update Trad_Rider_Label,
//     //update trad_sys_rider_label set labelcode = 'HL10T' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labeldesc = 'Health Loading (Per 1K SA) Term';
//     //update trad_sys_rider_label set labelcode = 'HL10' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labeldesc = 'Health Loading (Per 1K SA)';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading (Per 100 SA)' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labelcode = 'HL10';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading (Per 100 SA) Term' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labelcode = 'HL10T';
//     //update trad_sys_rider_label set labeldesc = 'Sum Assured (%%)' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labelcode = 'SUMA';
//     //update trad_sys_rider_label set labelcode = 'SUAS' where ridercode in ('PR', 'SP_PRE', 'SP_STD') and labelcode = 'Sum Assured (%%)';
//     u3, update Trad_Rider_Label,
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (Per 100 SA)' where labeldesc = 'Health Loading (Per 100 SA)';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (Per 100 SA) Term' where labeldesc = 'Health Loading (Per 100 SA) Term';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (Per 1K SA)' where labeldesc = 'Health Loading (Per 1K SA)';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (Per 1K SA) Term' where labeldesc = 'Health Loading (Per 1K SA) Term';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (%%)' where labeldesc = 'Health Loading (%%)';
//     //update trad_sys_rider_label set labeldesc = 'Health Loading 1 (%%) Term' where labeldesc = 'Health Loading (%%) Term';
//     u4, insert 5 new jobs
//     //	insert into Adm_Occp_Loading_Penta Values('OCC02452', 'VICE PRESIDENT', '1', 'A', 'EM', '1', '0', '0' );
//     insert into Adm_Occp_Loading_Penta Values('OCC02453', 'PRESIDENT', '1', 'A', 'EM', '1', '0', '0' );
//     insert into Adm_Occp_Loading_Penta Values('OCC02454', 'CUSTOMER SERVICE EXEC', '1', 'A', 'EM', '1', '0', '0' );
//     insert into Adm_Occp_Loading_Penta Values('OCC02455', 'SALES ENGINEER', '1', 'A', 'EM', '1', '0', '0' );
//     insert into Adm_Occp_Loading_Penta Values('OCC02456', 'SERVICE ENGINEER', '1', 'A', 'EM', '2', '0', '0' );
//     insert into Adm_Occp_Loading Values('OCC02452', 'STD', '1', '1', '1' );
//     insert into Adm_Occp_Loading Values('OCC02453', 'STD', '1', '1', '1');
//     insert into Adm_Occp_Loading Values('OCC02454', 'STD', '1', '1', '1');
//     insert into Adm_Occp_Loading Values('OCC02455', 'STD', '1', '1', '1');
//     insert into Adm_Occp_Loading Values('OCC02456', 'STD', '1', '1', '1');
//     insert into Adm_Occp Values('OCC02452', 'VICE PRESIDENT', '1', '', '', '', '', '' );
//     insert into Adm_Occp Values('OCC02453', 'PRESIDENT', '1', '', '', '', '', '' );
//     insert into Adm_Occp Values('OCC02454', 'CUSTOMER SERVICE EXEC', '1', '', '', '', '', '' );
//     insert into Adm_Occp Values('OCC02455', 'SALES ENGINEER', '1', '', '', '', '', '' );
//     insert into Adm_Occp Values('OCC02456', 'SERVICE ENGINEER', '1', '', '', '', '', '' );
//     u5, update trad_sys_mtn
//     update trad_sys_mtn set MaxAge = '63' where PlanCode = 'HLACP';
//     u6, Delete From Adm_Occp_Loading_Penta where OccpCode = 'OCC01717';
//     Update Trad_Sys_Rider_Mtn set MaxAge = '63' where RiderCode in ('ETPDB', 'EDB');
//     
//     u7, ALTER TABLE \"Agent_profile\" ADD COLUMN \"AgentPortalLoginID\" VARCHAR
//     ALTER TABLE \"Agent_profile\" ADD COLUMN \"AgentPortalPassword\" VARCHAR
//     */
//    
//    /*
//     sqlite3_stmt *statement;
//     if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
//     {
//     
//     NSString *querySQL = [NSString stringWithFormat:
//     @"update trad_sys_Rider_mtn set MaxSA = '1500000' where RiderCode = 'CIR';"];
//     
//     if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
//     if (sqlite3_step(statement) == SQLITE_DONE){
//     
//     }
//     else {
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
//     message:@"ERROR" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
//     [alert show];
//     alert = Nil;
//     }
//     sqlite3_finalize(statement);
//     }
//     
//     sqlite3_close(contactDB);
//     querySQL = Nil;
//     
//     }
//     */
//    
//    /*  update Occupation list with Professional Athlete : Edwin 21-11-2013  */
//    sqlite3_stmt *statement;
//    BOOL proceedInsert = false;
//    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat: @"SELECT OccpCode FROM Adm_Occp_Loading_Penta WHERE OccpCode='OCC01717'"];
//        
//        const char *query_stmt = [querySQL UTF8String];
//        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            if (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                proceedInsert = false;
//            }else
//            {
//                proceedInsert = true;
//            }
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(contactDB);
//        query_stmt = Nil;
//        querySQL = Nil;
//    }
//    statement = Nil;
//    
//    
//    if(proceedInsert)
//    {
//        sqlite3_stmt *statement;
//        if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
//        {
//            
//            NSString *querySQL = [NSString stringWithFormat:
//                                  @"insert into Adm_Occp_Loading_Penta Values('OCC01717', 'PROFESSIONAL ATHLETE', '4', 'A', 'EM', '4', '0.0', '0.0' )"];
//            
//            
//            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
//                if (sqlite3_step(statement) == SQLITE_DONE){
//                    
//                }
//                sqlite3_finalize(statement);
//            }
//            
//            sqlite3_close(contactDB);
//            querySQL = Nil;
//            
//        }
//    }
//    /*                                                      */
//    
//    
//    success = [fileManager fileExistsAtPath:databasePath];
//    //if (success) return;
//    if (!success) {
//        
//        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&DBerror];
//        if (!success) {
//            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [DBerror localizedDescription]);
//        }
//        
//        defaultDBPath = Nil;
//    }
//    
//    if([fileManager fileExistsAtPath:CommDatabasePath] == FALSE ){
//        
//        //if there are any changes, system will delete the old rates.json file and replace with the new one
//        // code here
//        //--------------
//        
//        NSString *CommissionRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Rates.json"];
//        success = [fileManager copyItemAtPath:CommissionRatesPath toPath:CommDatabasePath error:&DBerror];
//        if (!success) {
//            NSAssert1(0, @"Failed to create Commision Rates json file with message '%@'.", [DBerror localizedDescription]);
//        }
//        CommissionRatesPath= Nil;
//    }
//    
//    //[fileManager removeItemAtPath:UL_RatesDatabasePath error:Nil];
//    
//    if([fileManager fileExistsAtPath:UL_RatesDatabasePath] == FALSE ){
//        
//        NSString *ULRatesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UL_Rates.sqlite"];
//        success = [fileManager copyItemAtPath:ULRatesPath toPath:UL_RatesDatabasePath error:&DBerror];
//        if (!success) {
//            NSAssert1(0, @"Failed to create UL Rates file with message '%@'.", [DBerror localizedDescription]);
//        }
//        ULRatesPath= Nil;
//    }
//    
//    if([fileManager fileExistsAtPath:RatesDatabasePath] == FALSE ){
//        NSString *RatesDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HLA_Rates.sqlite"];
//        success = [fileManager copyItemAtPath:RatesDBPath toPath:RatesDatabasePath error:&DBerror];
//        if (!success) {
//            NSAssert1(0, @"Failed to create writable Rates database file with message '%@'.", [DBerror localizedDescription]);
//        }
//        RatesDBPath = Nil;
//    }
//    else {
//        return;
//    }
//    
//    fileManager = Nil;
//    error = Nil;
//    
//    
//}
//
//@end