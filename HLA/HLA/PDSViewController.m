//
//  PDSViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PDSViewController.h"
#import "DBController.h"
#import "DataTable.h"

@interface PDSViewController ()

@end

@implementation PDSViewController
@synthesize dataTable = _dataTable;
@synthesize db = _db;
@synthesize SINo, PDSLanguage, PDSPlanCode, strBasicAnnually, strBasicMonthly,strBasicQuarterly,strBasicSemiAnnually;
@synthesize strOriBasicAnnually,strOriBasicMonthly,strOriBasicQuarterly,strOriBasicSemiAnnually;
@synthesize OtherRiderCode,OtherRiderDeductible,OtherRiderDesc,OtherRiderHL100SA,OtherRiderHL100SATerm,OtherRiderHL1kSA;
@synthesize OtherRiderHL1kSATerm,OtherRiderHLPercentage,OtherRiderHLPercentageTerm,OtherRiderPlanOption,OtherRiderSA;
@synthesize OtherRiderTempHL,OtherRiderTempHLTerm,OtherRiderTerm,Age,PayorAge,PolicyTerm,BasicSA;
@synthesize sex,OccpClass,HealthLoading,HealthLoadingTerm,TempHealthLoading,TempHealthLoadingTerm;
@synthesize CashDividend, YearlyIncome,PartialAcc, PartialPayout,OccLoading,aStrBasicSA;
@synthesize aStrOtherRiderAnnually,aStrOtherRiderMonthly,aStrOtherRiderQuarterly,aStrOtherRiderSemiAnnually;

NSMutableArray *UpdateTradDetail, *gWaiverAnnual, *gWaiverSemiAnnual, *gWaiverQuarterly, *gWaiverMonthly;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)calculateForReport {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self deleteTemp]; //clear all temp data
    [self InsertToSI_Temp_Trad];
    
    [self GeneratePDS];
    dirPaths = Nil;
    docsDir = Nil;
    
    _dataTable = Nil;
    _db = Nil;
    SINo = Nil;
    PDSLanguage = Nil;
    databasePath = Nil;
    contactDB = Nil;
}

-(void)GeneratePDS {
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databaseName = @"hladb.sqlite";
    int pageNum = 0;
    int riderCount = 0;
    NSString *desc = @"Page";
    int DBID;
    
    self.db = [DBController sharedDatabaseController:databaseName];
    NSString *sqlStmt = [NSString stringWithFormat:@"SELECT SiNo FROM SI_Temp_Trad"];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    NSArray* row = [_dataTable.rows objectAtIndex:0];
    NSString *pageDenomination = nil;
    NSString *PDS2Str;
    NSString *PDSLangUpper;
    NSString *PDSLang;
    if ([PDSLanguage isEqualToString:@"E"]) {
        if( [PDSPlanCode isEqualToString:@"S100"]) {
            pageDenomination = @"PDS_ENG_S100_Page";
        } else if( [PDSPlanCode isEqualToString:@"HLAWP"]) {
            pageDenomination = @"PDS_ENG_HLAWP_Page";
        }
        PDS2Str = @"ENG_PDS2";
        PDSLangUpper = @"PDS_ENG";
        PDSLang = @"PDS_ENG";
    } else {        
        if( [PDSPlanCode isEqualToString:@"S100"]) {
            pageDenomination = @"PDS_BM_S100_Page";
        } else if( [PDSPlanCode isEqualToString:@"HLAWP"]) {
            pageDenomination = @"PDS_BM_HLAWP_Page";
        }
        PDS2Str = @"BM_PDS2";
        PDSLangUpper = @"PDS_BM";
        PDSLang = @"PDS_BM";
    }
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@1.html',%d,'%@')",
               pageDenomination,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    
    riderCount = 0; //reset rider count
    int descRiderCountStart = 2; //start of rider description page
    int riderInPageCount = 0; //number of rider in a page, maximum 3
    NSString *riderInPage = @""; //rider in a page, write to db
    NSString *headerTitle = @"tblHeader;";
    NSString *curRider = @"";
    NSString *prevRider = @"";
    
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode "
               "NOT IN ('C+', 'HMM', 'HSP_II', 'MG_II', 'MG_IV') ORDER BY Seq ASC, PTypeCode ASC, RiderCode ASC ",SINo];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    // First LA
    for (row in _dataTable.rows) { //income rider
        riderCount++;
        curRider = [row objectAtIndex:0];
        if ([curRider isEqualToString:@"CCTR"] || [curRider isEqualToString:@"TPDYLA"] || [curRider isEqualToString:@"HB"] ||
            [curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"HSP_II"] || [curRider isEqualToString:@"MG_II"] ||
            [curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"PA"] || [curRider isEqualToString:@"PR"] ||
            [curRider isEqualToString:@"SP_STD"] || [prevRider isEqualToString:@"SP_PRE"] || [curRider isEqualToString:@"PTR"] ||
            [curRider isEqualToString:@"CPA"] || [curRider isEqualToString:@"EDB"] || [curRider isEqualToString:@"ETPDB"]) {
            riderInPageCount++;
            prevRider = curRider;
            
            if(riderInPageCount == 1) {
                riderInPage = [headerTitle stringByAppendingString:riderInPage];
            }
            
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            if (riderInPageCount == 3) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                
                riderInPageCount = 0;
                riderInPage = @"";
                prevRider = @"";
            } else if (riderInPageCount == 1 && riderCount == _dataTable.rows.count) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            } else if (riderInPageCount == 2 && riderCount == _dataTable.rows.count) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            }
        } else {
            if (riderInPageCount == 2) {
                pageNum++;
                if(riderInPageCount == 0)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                prevRider= @"";
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if ([prevRider isEqualToString:@"CCTR"] || [prevRider isEqualToString:@"TPDYLA"] || [prevRider isEqualToString:@"HB"] ||
                [prevRider isEqualToString:@"HMM"] || [prevRider isEqualToString:@"HSP_II"] || [prevRider isEqualToString:@"MG_II"] ||
                [prevRider isEqualToString:@"MG_IV"] || [prevRider isEqualToString:@"PA"] || [prevRider isEqualToString:@"PTR"] ||
                [prevRider isEqualToString:@"SP_STD"] || [prevRider isEqualToString:@"EDB"] || [prevRider isEqualToString:@"PR"] || [prevRider isEqualToString:@"CPA"] ||
                [prevRider isEqualToString:@"ETPDB"]) {
                
                if (![curRider isEqualToString:@"ICR"] && ![curRider isEqualToString:@"LCPR"] && ![curRider isEqualToString:@"LCWP"]
                    && ![curRider isEqualToString:@"PLCP"] && ![prevRider isEqualToString:@""] && ![curRider isEqualToString:@"CIR"] && ![curRider isEqualToString:@"SP_PRE"]
                    && ![curRider isEqualToString:@"WBI6R30"]) {
                    
                    prevRider = [prevRider stringByAppendingString:@";"];
                    curRider = [prevRider stringByAppendingString:curRider];
                    riderInPageCount = 0;
                    riderInPage = @"";
                } else {
                    pageNum++;
                    if(riderCount == 1) {
                        riderInPage = [headerTitle stringByAppendingString:riderInPage];
                    }
                    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES "
                               "('2#%@','%@_Page%d.html',%d,'%@')",riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                    DBID = [_db ExecuteINSERT:sqlStmt];
                    prevRider = @"";
                    riderInPage = @"";
                    riderInPageCount = 0;
                }
            }
            
            pageNum++;
            if(riderInPageCount == 0)
                curRider = [headerTitle stringByAppendingString:curRider];
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#%@','%@_Page%d.html',%d,'%@')",
                       curRider,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            
            if ([[row objectAtIndex:0] isEqualToString:@"WBI6R30"]) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('2#tblHeader;%@','%@_Page%d_2.html',%d,'%@')",@"WBI6R30",
                           PDSLangUpper,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
            }
        }
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@3.html',%d,'%@')",
               pageDenomination,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    
	sqlStmt = [NSString stringWithFormat:@"SELECT COUNT (*) FROM Trad_Rider_Details Where SINo = '%@' ",SINo];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    if ([[_dataTable.rows[0] objectAtIndex:0] integerValue] + riderCount > 20) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@4.html',%d,'%@')",
                   pageDenomination,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_Page4.html',%d,'%@')",
               PDSLang,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
		
    riderCount = 0; //reset rider count
    descRiderCountStart = 6; //start of rider description page
    riderInPageCount = 0; //number of rider in a page, maximum 3
    riderInPage = @""; //rider in a page, write to db
    headerTitle = @"tblHeader;";
    
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' AND "
               "RiderCode NOT IN ('C+','MG_II','MG_IV','HSP_II','HMM') ORDER BY Seq ASC, PTypeCode ASC, RiderCode ASC ",SINo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    for (row in _dataTable.rows) { //income rider
        riderCount++;
        curRider = [row objectAtIndex:0];
        
        riderInPageCount++;
        prevRider = curRider;
        
        if ([curRider isEqualToString:@"CPA"] || [curRider isEqualToString:@"PA"]) {
            if (![riderInPage isEqualToString:@""]) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            riderInPage = [headerTitle stringByAppendingString:riderInPage];
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            pageNum++;
        
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d.html',%d,'%@')",
                       riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d_2.html',%d,'%@')",
                       riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];

            riderInPageCount = 0;
            riderInPage = @"";
        } else {
            if(riderInPageCount == 1) {
                riderInPage = [headerTitle stringByAppendingString:riderInPage];
            }
            
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            if (riderInPageCount == 2) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 1 && riderCount == _dataTable.rows.count) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 2 && riderCount == _dataTable.rows.count) {
                pageNum++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('5#%@','%@_Page%d.html',%d,'%@')",
                           riderInPage,PDSLang,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
        }
        
    }
	
	sqlStmt = [NSString stringWithFormat:@"Update SI_Temp_Pages_PDS set riders = riders || 'tblFooter' where pagenum = %d  ", pageNum];
	DBID = [_db ExecuteINSERT:sqlStmt];
	    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@7.html',%d,'%@')",
               pageDenomination,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@7_2.html',%d,'%@')",
               pageDenomination,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    
    // for C+ only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"C+\"  ",SINo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) { //got C+
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_C_1.html',%d,'%@')",
                   PDSLangUpper, pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_C_2.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_C_3.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }
    
    // for HMM only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"HMM\"  ",SINo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        if([[[_dataTable.rows objectAtIndex:0] objectAtIndex:7] isEqualToString:@"HMM_1000"]) {
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_PLUS_1.html',%d,'%@')",
                       PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_PLUS_2.html',%d,'%@')",
                       PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
        } else {
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_1.html',%d,'%@')",
                       PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            
            pageNum++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_2.html',%d,'%@')",
                       PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_3.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_4.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HMM_5.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }
    
    // for HSP_II only
    
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"HSP_II\"  ",SINo];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HS_1.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HS_2.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HS_3.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_HS_4.html',%d,'%@')",PDSLang,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }    
    
    // for MG_II only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"MG_II\"  ",SINo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG2_1.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG2_2.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG2_3.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG2_4.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG2_5.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }
	
	//for MG_IV only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"MG_IV\"  ",SINo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG4_1.html',%d,'%@')",
                   PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG4_2.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG4_3.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG4_4.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('%@_MG4_5.html',%d,'%@')",PDSLangUpper,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
    }
    
    // pds END---    
    
    _dataTable = Nil;
    _db = Nil;
    sqlStmt = Nil;
    riderInPage = Nil;
    headerTitle = Nil;
    curRider = Nil;
    prevRider = Nil;
    dirPaths = Nil;
    docsDir = Nil;
    databaseName = Nil;
    desc = Nil;
    
}

-(void)deleteTemp{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        QuerySQL = @"Delete from SI_Temp_Pages_PDS";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_Temp_trad";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    statement = Nil;
    QuerySQL = Nil;
}

-(void)InsertToSI_Temp_Trad{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        
        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad (\"SINo\", \"PlanCode\") VALUES (\"%@\", \"%@\") ", SINo, PDSPlanCode];        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    statement = Nil;
    QuerySQL = Nil;
}

-(void)InsertToSI_Temp_Trad_LA{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *getCustomerCodeSQL;
    NSString *getFromCltProfileSQL;
    NSString *CustCode;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND sequence = %d ", SINo, 1];
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"", CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        Age = sqlite3_column_int(statement2, 3);
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_LA (\"SINo\", \"Age\") "
                                     " VALUES (\"%@\",\"%d\")", SINo,  Age];
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            sqlite3_step(statement3);
                            sqlite3_finalize(statement3);
                        }
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
	// check for 2nd life assured
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND sequence = %d ", SINo, 2];
        
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        NSString *SecName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                        NSString *Secsmoker = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)];
                        NSString *Secsex = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)];
                        int SecAge = sqlite3_column_int(statement2, 3);
                        
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_LA (\"SINo\", \"LADesc\", "
                                     "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
                                     " VALUES (\"%@\",\"2nd Life Assured\",\"LA\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                     " \"Hayat Diinsuranskan ke-2\")", SINo, 2, SecName, SecAge, Secsex, Secsmoker ];
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            sqlite3_step(statement3);
                            sqlite3_finalize(statement3);
                        }
                        
                        SecName = Nil;
                        Secsmoker = Nil;
                        Secsex = Nil;
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    //check for payor
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND PtypeCode = 'PY' ", SINo];
        
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        NSString *PYName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                        NSString *PYsmoker = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)];
                        NSString *PYsex = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)];
                        int PYAge = sqlite3_column_int(statement2, 3);
                        
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_LA (\"SINo\", \"LADesc\", "
                                     "\"PtypeCode\", \"Seq\", \"Name\", \"Age\", \"Sex\", \"Smoker\", \"LADescM\") "
                                     " VALUES (\"%@\",\"Assured\",\"PY\",\"%d\",\"%@\",\"%d\", \"%@\", \"%@\", "
                                     " \"Pemunya\")", SINo, 1, PYName, PYAge, PYsex, PYsmoker ];
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement3) == SQLITE_DONE) {
                                
                            }
                            sqlite3_finalize(statement3);
                        }
                        
                        PYName = Nil;
                        PYsmoker = Nil;
                        PYsex = Nil;
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
	
    statement = Nil;
    statement2 = Nil;
    statement3 = Nil;
    getCustomerCodeSQL = Nil;
    getFromCltProfileSQL= Nil;
    CustCode= Nil;
    QuerySQL= Nil;
}

-(void)InsertToSI_Temp_Trad_Details{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    NSString *RiderSQL;
    NSString *SelectSQL = @"";
    NSString *firstLifeLoading = [OccLoading objectAtIndex:0];
    NSString *secondtLifeLoading = @"";
    
	if ([firstLifeLoading isEqualToString:@"0.0"]) { //<-- for penta
        firstLifeLoading = @"";
    } else {
		firstLifeLoading = [NSString stringWithFormat:@"%d", [firstLifeLoading intValue]];
	}
    
    if (OccLoading.count > 1) {
		secondtLifeLoading = [[OccLoading objectAtIndex:1] isEqualToString:@"0.0"] ? @"" : [OccLoading objectAtIndex:1] ;
    } else {
        secondtLifeLoading = @"";
    }
	
	if (![secondtLifeLoading isEqualToString:@""]) {
		secondtLifeLoading = [NSString stringWithFormat:@"%d", [secondtLifeLoading intValue]];
	}
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
		NSString *strAnnually = @"";
		NSString *strSemiAnnually = @"";
		NSString *strQuarterly = @"";
		NSString *strMonthly = @"";
		NSString *HL1KSA = @"";
		NSString *TempHL1KSA = @"";
		
		
		SelectSQL = @"Select * from SI_Store_Premium where type = \"B\" ";
		if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
				strSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				strQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
				strMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
				strBasicAnnually = strAnnually;
				strBasicSemiAnnually = strSemiAnnually;
				strBasicQuarterly = strQuarterly;
				strBasicMonthly = strMonthly;
			}
			sqlite3_finalize(statement);
		}
		
		SelectSQL = @"Select * from SI_Store_Premium where type = \"BOriginal\" ";
		if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				strOriBasicAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
				strOriBasicSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				strOriBasicQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
				strOriBasicMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
				
			}
			sqlite3_finalize(statement);
		}
		
		
		SelectSQL = [NSString stringWithFormat:@"Select case when HL1KSA is '' then '0' else HL1KSA end as HL1KSA, "
					 "case when TempHL1KSA is '' then '0' else TempHL1KSA end as TempHL1KSA, HL1kSATerm, TempHL1kSATerm  from Trad_Details where Sino = \"%@\" ", SINo];
		
		if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				HL1KSA = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] isEqual:NULL] ? @"0" : [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] ;
				TempHL1KSA = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] isEqual:NULL] ? @"0" : [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] ;
				
			}
			sqlite3_finalize(statement);
		}
		
		NSString *totalHLoading = [NSString stringWithFormat:@"%.2f", [HL1KSA floatValue ] + [TempHL1KSA floatValue]];
		
		if ([totalHLoading isEqualToString:@"0"]) {
			totalHLoading = @"";
		}
		
		if (![totalHLoading isEqualToString:@""]) {
            double ActualPremium;
			for (int i = 1; i <= PolicyTerm;  i++) {
				if (![HL1KSA isEqualToString:@"0"]) {
					if(i > [HealthLoadingTerm intValue]) {
						ActualPremium = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue] - ([HL1KSA doubleValue] * BasicSA/1000);
					} else {
						ActualPremium = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
					}
				} else {
					ActualPremium = [[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
				}
				
				if (![TempHL1KSA isEqualToString:@"0"]) {
					if (i > [TempHealthLoadingTerm intValue ]) {
						ActualPremium = ActualPremium - ([TempHL1KSA doubleValue] * BasicSA/1000);
					}
				}
				[aStrBasicSA addObject: [NSString stringWithFormat:@"%.2f", ActualPremium]];
			}
		} else {
			for (int i = 1; i <= PolicyTerm;  i++) {
				[aStrBasicSA addObject:[strBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
				
			}
		}
		
		QuerySQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
					"\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") "
					" VALUES ( "
					" \"%@\",\"1\",\"DATA\",\"HLA Cash Promise\",\"\",\"0\",\"%.2f\",\"%d\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" "
					")", SINo, BasicSA,PolicyTerm,@"6",strAnnually, strSemiAnnually, strQuarterly, strMonthly, totalHLoading, firstLifeLoading ];
		
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		
		sqlite3_close(contactDB);
		
		strAnnually = Nil;
		strSemiAnnually = Nil;
		strQuarterly = Nil;
		strMonthly = Nil;
		HL1KSA = Nil;
		TempHL1KSA = Nil;
		
	}
    
    NSString *strAnnually = @"";
    NSString *strSemiAnnually = @"";
    NSString *strQuarterly = @"";
    NSString *strMonthly = @"";
    NSString *strUnits = @"";
    NSString *seq = @"";
    NSString *OtherHLoading= @"";
    NSString *OtherTempHLoading= @"";
    for (int a=0; a<OtherRiderCode.count; a++) {
        strAnnually = @"";
        strSemiAnnually = @"";
        strQuarterly = @"";
        strMonthly = @"";
        strUnits = @"";
        seq = @"";
        OtherHLoading= @"";
        OtherTempHLoading= @"";
        
        if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"ICR" ]) {
            seq = @"4";
        } else if(([[OtherRiderCode objectAtIndex:a] characterAtIndex:0] > 64 && [[OtherRiderCode objectAtIndex:a] characterAtIndex:0] < 73) ||
                ([[OtherRiderCode objectAtIndex:a] characterAtIndex:0] > 96 && [[OtherRiderCode objectAtIndex:a] characterAtIndex:0] < 105)) {
            seq = @"2";
        } else {
            seq = @"6";
        }
		
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            SelectSQL = [ NSString stringWithFormat:@"Select \"Type\", \"Annually\",\"SemiAnnually\",\"Quarterly\",\"Monthly\", \"Units\"  "
						 " from SI_Store_Premium as A, trad_rider_details as B where A.Type = B.riderCode AND \"type\" = \"%@\" "
						 " AND \"FromAge\" is NULL AND B.SINO = \"%@\" ", [OtherRiderCode objectAtIndex:a], SINo];
            if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    strAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    strSemiAnnually = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    strQuarterly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    strMonthly = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    strUnits = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    
                    [aStrOtherRiderAnnually addObject:[strAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                    [aStrOtherRiderSemiAnnually addObject:[strSemiAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                    [aStrOtherRiderQuarterly addObject:[strQuarterly stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                    [aStrOtherRiderMonthly addObject:[strMonthly stringByReplacingOccurrencesOfString:@"," withString:@"" ]];
                }
                sqlite3_finalize(statement);
            }
			
            if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"C+"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"CCTR"] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"CIR"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"C+"] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"CPA"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"TPDYLA"] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"LCPR"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"C+"] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"PA"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"PLCP"] ||
				[[OtherRiderCode objectAtIndex:a] isEqualToString:@"ICR"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"PTR"] ||
				[[OtherRiderCode objectAtIndex:a ] isEqualToString:@"EDB" ] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"ETPDB" ]) {
                SelectSQL = [NSString stringWithFormat:@"Select HL1KSA, TempHL1KSA from Trad_Rider_Details where Sino = \"%@\" AND Ridercode = \"%@\"  ", SINo, [OtherRiderCode objectAtIndex:a]];
            } else if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"CIWP"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"LCWP"] ||
					 [[OtherRiderCode objectAtIndex:a] isEqualToString:@"PR"] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"SP_PRE"] ||
					 [[OtherRiderCode objectAtIndex:a] isEqualToString:@"SP_STD"]) {
                SelectSQL = [NSString stringWithFormat:@"Select HL100SA, TempHL1KSA from Trad_Rider_Details where Sino = \"%@\" AND Ridercode = \"%@\"  ", SINo, [OtherRiderCode objectAtIndex:a]];
                
            } else {
                SelectSQL = [NSString stringWithFormat:@"Select HLPercentage, TempHL1KSA from Trad_Rider_Details where Sino = \"%@\" AND Ridercode = \"%@\"  ", SINo, [OtherRiderCode objectAtIndex:a]];
                
            }
            
            if(sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    OtherHLoading = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] isEqualToString:@"(null)"] ? @"" : [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] ;
                    OtherTempHLoading = [[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] isEqualToString:@"(null)"] ? @"" : [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)] ;
                }
                sqlite3_finalize(statement);
            }
            
            if ([OtherHLoading isEqualToString:@"" ]) {
                OtherHLoading = @"";
            } else {
                OtherHLoading = [NSString stringWithFormat:@"%d", [OtherHLoading intValue]];
            }
            
			if (![OtherTempHLoading isEqualToString:@"" ]) {
                OtherHLoading = [NSString stringWithFormat:@"%d",[OtherHLoading intValue ] + [OtherTempHLoading intValue]];
            }
            			
            // special case for LCWP, PR, SP_PRE, SP_STD --> second life assured riders
            if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"LCWP" ] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"PR" ] || [[OtherRiderCode objectAtIndex:a] isEqualToString:@"SP_PRE" ] ||
                [[OtherRiderCode objectAtIndex:a] isEqualToString:@"SP_STD" ]) {
                [UpdateTradDetail addObject:[OtherRiderCode objectAtIndex:a]];
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, [[OtherRiderDesc objectAtIndex:a] stringByAppendingString:[ NSString stringWithFormat:@" (%@%%)", [OtherRiderSA objectAtIndex:a]]],
                            [OtherRiderPlanOption objectAtIndex:a], @"-", [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], @"-",
                            @"-", @"-", @"-", OtherHLoading, secondtLifeLoading, [OtherRiderCode objectAtIndex:a] ];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Annual",@"-", @"500.00", @"", @"", strAnnually, @"-", @"-", @"-",OtherHLoading, secondtLifeLoading, [OtherRiderCode objectAtIndex:a]];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Semi-annual",@"-", @"400.00", @"", @"", @"-", strSemiAnnually, @"-", @"-",OtherHLoading, secondtLifeLoading, [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Quarterly",@"-", @"300.00", @"", @"", @"-", @"-", strQuarterly, @"-", OtherHLoading, secondtLifeLoading, [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Monthly",@"-", @"200.00", @"", @"", @"-", @"-", @"-", strMonthly,OtherHLoading, secondtLifeLoading, [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
            } else if ([[OtherRiderCode objectAtIndex:a] isEqualToString:@"CIWP"]) {
                //special case for ciwp only --> first life assured riders
                [UpdateTradDetail addObject:[OtherRiderCode objectAtIndex:a]];
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, [[OtherRiderDesc objectAtIndex:a] stringByAppendingString:[ NSString stringWithFormat:@" (%@%%)", [OtherRiderSA objectAtIndex:a]]],
                            [OtherRiderPlanOption objectAtIndex:a], @"-", [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], @"-",
                            @"-", @"-", @"-",OtherHLoading, @"", [OtherRiderCode objectAtIndex:a] ];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Annual",@"-", @"500.00", @"", @"", strAnnually, @"-", @"-", @"-",OtherHLoading, @"", [OtherRiderCode objectAtIndex:a]];
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Semi-annual",@"-", @"400.00", @"", @"", @"-", strSemiAnnually, @"-", @"-",OtherHLoading, @"", [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Quarterly",@"-", @"300.00", @"", @"", @"-", @"-", strQuarterly, @"-", OtherHLoading, @"", [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                            "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\",\"col11\") VALUES ( "
                            " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\" "
                            ")", SINo, seq, @"-Monthly",@"-", @"200.00", @"", @"", @"-", @"-", @"-", strMonthly, OtherHLoading, @"", [OtherRiderCode objectAtIndex:a]];
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
            } else {
                NSString *RiderDesc = @"";
                NSString *SA = @"";
                if (![[OtherRiderDeductible objectAtIndex:a] isEqualToString:@"(null)" ]) {
                    RiderDesc= [NSString stringWithFormat:@"%@ (Class %@) (Deductible %@ )", [OtherRiderDesc objectAtIndex:a],
                                OccpClass ,[OtherRiderDeductible objectAtIndex:a] ];
                } else if ([[OtherRiderCode objectAtIndex:a ] isEqualToString:@"CPA" ] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"PA"] ||
                         [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"HMM" ] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"HSP_II"] ||
                         [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"MG_II" ] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"MG_IV" ]) {
                    RiderDesc= [NSString stringWithFormat:@"%@ (Class %@)", [OtherRiderDesc objectAtIndex:a], OccpClass ];
                } else {
                    RiderDesc = [OtherRiderDesc objectAtIndex:a];
                }
                
                if ([[OtherRiderCode objectAtIndex:a ] isEqualToString:@"HMM"] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"HSP_II"] ||
                    [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"MG_II"] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"MG_IV"] ||
                     [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"HB"]) {
                    SA = @"-";
					if (![OtherHLoading isEqualToString:@""]) {
						OtherHLoading = [OtherHLoading stringByAppendingFormat:@"%%" ];
					}
                } else {
                    SA = [OtherRiderSA objectAtIndex:a];
                }
                
                NSString *planOption = [OtherRiderPlanOption objectAtIndex:a];
                if ([planOption isEqualToString:@"L"]) {
                    planOption = @"Option 1";
                } else if ([planOption isEqualToString:@"I"]) {
                    planOption = @"Option 2";
                } else if ([planOption isEqualToString:@"B"]) {
                    planOption = @"Option 3";
                } else if ([planOption isEqualToString:@"N"]) {
                    planOption = @"Option 4";
                }
				
                if ([[OtherRiderCode objectAtIndex:a ] isEqualToString:@"CCTR" ]) {
                    RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
                                "\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
                                " \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" "
                                ")", SINo, seq, RiderDesc,planOption, strUnits, [OtherRiderSA objectAtIndex:a],
                                [OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], strAnnually,
                                strSemiAnnually, strQuarterly, strMonthly, OtherHLoading, firstLifeLoading];
                } else {
					if ([[OtherRiderCode objectAtIndex:a ] isEqualToString:@"EDB" ] || [[OtherRiderCode objectAtIndex:a ] isEqualToString:@"ETPDB" ] ) {
						RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
									"\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
									" \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" "
									")", SINo, seq, RiderDesc,planOption, strUnits, SA,
									[OtherRiderTerm objectAtIndex:a], @"6", strAnnually,
									strSemiAnnually, strQuarterly, strMonthly, OtherHLoading, firstLifeLoading];
						
					} else if ([[OtherRiderCode objectAtIndex:a ] isEqualToString:@"LCPR"]) { // add in occ loading
						RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
									"\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
									" \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" "
									")", SINo, seq, RiderDesc,planOption, strUnits, SA,
									[OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], strAnnually,
									strSemiAnnually, strQuarterly, strMonthly, OtherHLoading, firstLifeLoading];
					} else {
						// without occ loading in quotation
						RiderSQL = [NSString stringWithFormat: @"Insert INTO SI_Temp_Trad_Details (\"SINO\", \"SeqNo\", \"DataType\",\"col0_1\",\"col0_2\",\"col1\",\"col2\", "
									"\"col3\",\"col4\",\"col5\",\"col6\",\"col7\",\"col8\",\"col9\",\"col10\") VALUES ( "
									" \"%@\",\"%@\",\"DATA\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"\" "
									")", SINo, seq, RiderDesc,planOption, strUnits, SA,
									[OtherRiderTerm objectAtIndex:a], [OtherRiderTerm objectAtIndex:a], strAnnually,
									strSemiAnnually, strQuarterly, strMonthly, OtherHLoading];
					}
                }
                
                
                if(sqlite3_prepare_v2(contactDB, [RiderSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
				planOption = Nil;
				SA = Nil;
            }
            
            sqlite3_close(contactDB);
        }
        
        strAnnually = Nil;
        strSemiAnnually = Nil;
        strQuarterly = Nil;
        strMonthly = Nil;
        strUnits = Nil;
        seq = Nil, OtherHLoading= Nil;
    }
    
    statement = Nil;
    QuerySQL = Nil;
    RiderSQL = Nil;
    SelectSQL =  Nil;
    firstLifeLoading = Nil;
    secondtLifeLoading = Nil;
}

-(void)UpdateToSI_Temp_Trad_Details{
    if (UpdateTradDetail.count > 0) {
        sqlite3_stmt *statement;
        NSString *QuerySQL = @"";
        
        for (int i = 0; i< UpdateTradDetail.count; i++) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			
            [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
			
            NSString *SAAnnual = [formatter stringFromNumber:[NSDecimalNumber numberWithFloat:[[gWaiverAnnual objectAtIndex:i] floatValue ]]];
            NSString *SASemiAnnual = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverSemiAnnual objectAtIndex:i] doubleValue ]]];
            NSString *SAQuaterly = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverQuarterly objectAtIndex:i] doubleValue ]]];
            NSString *SAMonthly = [formatter stringFromNumber:[NSNumber numberWithFloat:[[gWaiverMonthly objectAtIndex:i] doubleValue ]]];
            
			
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
				QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%.2f\" where col0_1 = \"-Annual\" AND col11 = \"%@\" ",
							[[gWaiverAnnual objectAtIndex:i] doubleValue ] , [UpdateTradDetail objectAtIndex:i ]];
				
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
				QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%.2f\" where col0_1 = \"-Semi-annual\" AND col11 = \"%@\" ",
                            [[gWaiverSemiAnnual objectAtIndex:i] doubleValue ] , [UpdateTradDetail objectAtIndex:i ]];
				
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
				QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%.2f\" where col0_1 = \"-Quarterly\" AND col11 = \"%@\" ",
                            [[gWaiverQuarterly objectAtIndex:i] doubleValue ], [UpdateTradDetail objectAtIndex:i ]];
				
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
				QuerySQL = [ NSString stringWithFormat:@"UPDATE SI_Temp_Trad_Details set col2 = \"%.2f\" where col0_1 = \"-Monthly\" AND col11 = \"%@\" ",
                            [[gWaiverMonthly objectAtIndex:i] doubleValue ], [UpdateTradDetail objectAtIndex:i ]];
				
                if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                
                sqlite3_close(contactDB);
            }
            
            SAAnnual = Nil;
            SASemiAnnual = Nil;
            SAQuaterly = Nil;
            SAMonthly = Nil;
            formatter = Nil;
        }
        
        statement = Nil;
        QuerySQL = Nil;
    }
    
}

-(void)InsertToSI_Temp_Trad_Rider {
    if (OtherRiderCode.count > 0) {
        int page;
        int NoOfPages = ceil(OtherRiderCode.count/3.00);
        int item;
        int Rider;
        
        NSString *tempRiderCode;
        NSString *tempRiderDesc;
        NSString *tempRiderPlanOption;
        NSMutableArray *tempCol1;
        NSMutableArray *tempCol2;
        NSMutableArray *tempCol3;
        NSMutableArray *tempCol4;
        NSString *tempHL100SA;
        NSString *tempHL100SATerm;
        NSString *tempTempHL;
        NSString *tempTempHLTerm;
        NSMutableArray *Rate;
        
        double tempRiderSA;
        double tempPremium;
        int tempRiderTerm;
        
        double waiverRiderSA;
        double waiverRiderSASemiAnnual;
        double waiverRiderSAQuarterly;
        double waiverRiderSAMonthly;
        for (page =1; page <=NoOfPages; page++) {
            for (Rider =0; Rider < 3; Rider++) {
                item = 3 * (page - 1) + Rider;
                if (item < OtherRiderCode.count) {
                    tempRiderCode = [OtherRiderCode objectAtIndex:item];
                    tempRiderDesc = [OtherRiderDesc objectAtIndex:item];
                    tempRiderPlanOption = [OtherRiderPlanOption objectAtIndex:item];
                    tempRiderSA = [[OtherRiderSA objectAtIndex:item] doubleValue];
                    tempRiderTerm = [[OtherRiderTerm objectAtIndex:item] intValue];
                    tempPremium = [[aStrOtherRiderAnnually objectAtIndex:item] doubleValue];
					tempHL100SA = [OtherRiderHL100SA objectAtIndex:item];
					tempHL100SATerm = [OtherRiderHL100SATerm objectAtIndex:item];
                    tempTempHL = [OtherRiderTempHL objectAtIndex:item];
                    tempTempHLTerm = [OtherRiderTempHLTerm objectAtIndex:item];
                    
                    tempCol1 = [[NSMutableArray alloc] init];
                    tempCol2 = [[NSMutableArray alloc] init];
                    tempCol3 = [[NSMutableArray alloc] init];
                    tempCol4 = [[NSMutableArray alloc] init];
                    Rate = [[NSMutableArray alloc] init];
                    
					for (int i = 0; i < PolicyTerm; i++) {
						if (i < tempRiderTerm) {
                            if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"SP_PRE"] || [tempRiderCode isEqualToString:@"SP_STD"] ||
                                [tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"LCWP"]) {
								//waiver SA
								waiverRiderSA = [[strOriBasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
								waiverRiderSASemiAnnual = [[strOriBasicSemiAnnually stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
								waiverRiderSAQuarterly = [[strOriBasicQuarterly stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
								waiverRiderSAMonthly = [[strOriBasicMonthly stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
								if ([tempRiderCode isEqualToString:@"CIWP"]) {
									for (int q=0; q < OtherRiderCode.count; q++) {
										if (!([[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCPR"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIR"]  ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PR"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCWP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_STD"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_PRE"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIWP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ICR"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_TW"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_TWP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_EXC"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"ACIR_MPP"])) {
											waiverRiderSA = waiverRiderSA +
											[[[aStrOtherRiderAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSASemiAnnual = waiverRiderSASemiAnnual +
											[[[aStrOtherRiderSemiAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSAQuarterly = waiverRiderSAQuarterly +
											[[[aStrOtherRiderQuarterly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSAMonthly = waiverRiderSAMonthly +
											[[[aStrOtherRiderMonthly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											
										}
									}
								} else {
									for (int q=0; q < OtherRiderCode.count; q++) {
										if (!([[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PLCP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PR"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"LCWP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_STD"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"SP_PRE"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"CIWP"] ||
											  [[OtherRiderCode objectAtIndex:q ] isEqualToString:@"PTR"])) {
											waiverRiderSA = waiverRiderSA +
											[[[aStrOtherRiderAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSASemiAnnual = waiverRiderSASemiAnnual +
											[[[aStrOtherRiderSemiAnnually objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSAQuarterly = waiverRiderSAQuarterly +
											[[[aStrOtherRiderQuarterly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											waiverRiderSAMonthly = waiverRiderSAMonthly +
											[[[aStrOtherRiderMonthly objectAtIndex:q] stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue ];
											
										}
									}
								}
								
								double actualPremium = 0.0;
								if([tempHL100SA isEqualToString:@"(null)"]) {
									actualPremium = tempPremium;
								} else {
									if(i + 1 <= [tempHL100SATerm intValue ]) {
										actualPremium = tempPremium;
									} else {
										actualPremium = tempPremium - ((waiverRiderSA *  tempRiderSA/100)/100) * [tempHL100SA doubleValue];
									}
								}
								
								if (![tempTempHL isEqualToString:@"(null)"] ) {
									if (i + 1 > [tempTempHLTerm intValue]) {
										actualPremium = actualPremium - ((waiverRiderSA *  tempRiderSA/100)/100) * [tempTempHL doubleValue];
									}
								}
								
								[tempCol1 addObject:[NSString stringWithFormat:@"%.2f", actualPremium]];
								[tempCol2 addObject:[NSString stringWithFormat:@"%.3f", waiverRiderSA *  tempRiderSA/100]];
								[tempCol3 addObject:[NSString stringWithFormat:@"-"]];
								[tempCol4 addObject:[NSString stringWithFormat:@"-"]];
								
								if (i == 1) {
									[gWaiverAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSA *  tempRiderSA/100.00] ];
									[gWaiverSemiAnnual addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSASemiAnnual *  tempRiderSA/100.00] ];
									[gWaiverQuarterly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAQuarterly *  tempRiderSA/100.00] ];
									[gWaiverMonthly addObject:[NSString stringWithFormat:@"%.9f", waiverRiderSAMonthly *  tempRiderSA/100.00] ];
									
								}
							}
						}
					}
                    
                    Rate = Nil;
                    tempRiderCode = Nil;
                    tempRiderDesc = Nil;
                    tempRiderPlanOption = Nil;
                    tempCol1 = Nil;
                    tempCol2 = Nil;
                    tempCol3 = Nil;
                    tempCol4 = Nil;
                    
                }
            }
        }
    }
}


-(void)getAllPreDetails {	
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *QuerySQL;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
		QuerySQL = [ NSString stringWithFormat:@"select \"PolicyTerm\", \"BasicSA\", \"premiumPaymentOption\", \"CashDividend\",  "
					"\"YearlyIncome\", \"AdvanceYearlyIncome\", \"HL1KSA\",\"sex\",\"Class\",\"OccLoading\", \"HL1KSATerm\",\"TempHL1KSA\",\"TempHL1KSATerm\" "
					", \"PartialAcc\", \"PartialPayout\"  from Trad_Details as A, "
					"Clt_Profile as B, trad_LaPayor as C, Adm_Occp_Loading_Penta as D where A.Sino = C.Sino AND C.custCode = B.custcode AND "
					"D.OccpCode = B.OccpCode AND A.sino = \"%@\" AND \"seq\" = 1 ", SINo];
		
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                PolicyTerm = sqlite3_column_int(statement, 0);
                BasicSA = sqlite3_column_double(statement, 1);
                CashDividend = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                YearlyIncome = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                HealthLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                OccpClass = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                HealthLoadingTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                TempHealthLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                TempHealthLoadingTerm = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
				PartialAcc = sqlite3_column_int(statement, 13);
                PartialPayout = sqlite3_column_int(statement, 14);
            }
            sqlite3_finalize(statement);
        }
        
		if (PartialPayout == 100) {
			YearlyIncome = @"POF";
		} else {
			YearlyIncome = @"ACC";
		}
		
		QuerySQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND PtypeCode = 'PY' ", SINo];
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString* CC  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSString* getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CC];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
						PayorAge = sqlite3_column_int(statement2, 3);
                    }
                    sqlite3_finalize(statement2);
                }
				
				getFromCltProfileSQL = Nil;
            }
            sqlite3_finalize(statement);
        }
		
        QuerySQL = [ NSString stringWithFormat:@"select \"OccLoading_TL\" from Trad_Details as A, "
                    "Clt_Profile as B, trad_LaPayor as C, Adm_Occp_Loading_Penta as D where A.Sino = C.Sino AND C.custCode = B.custcode AND "
                    "D.OccpCode = B.OccpCode AND A.sino = \"%@\" AND \"seq\" = 1 ORDER By sequence ASC ", SINo];
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                [OccLoading addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    OtherRiderCode = [[NSMutableArray alloc] init ];
    OtherRiderTerm = [[NSMutableArray alloc] init ];
    OtherRiderDesc = [[NSMutableArray alloc] init ];
    OtherRiderSA = [[NSMutableArray alloc] init ];
    OtherRiderPlanOption = [[NSMutableArray alloc] init ];
    OtherRiderDeductible = [[NSMutableArray alloc] init ];
	OtherRiderHL1kSA = [[NSMutableArray alloc] init ];
	OtherRiderHL1kSATerm = [[NSMutableArray alloc] init ];
	OtherRiderHL100SA = [[NSMutableArray alloc] init ];
	OtherRiderHL100SATerm = [[NSMutableArray alloc] init ];
	OtherRiderHLPercentage = [[NSMutableArray alloc] init ];
	OtherRiderHLPercentageTerm = [[NSMutableArray alloc] init ];
	OtherRiderTempHL = [[NSMutableArray alloc] init ];
	OtherRiderTempHLTerm = [[NSMutableArray alloc] init ];
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        QuerySQL = [ NSString stringWithFormat:@"Select A.RiderCode, \"RiderTerm\",\"RiderDesc\", \"SumAssured\", \"PlanOption\", "
					"\"Deductible\", \"HL1kSA\", \"HL1KSATerm\", \"HL100SA\", \"HL100SATerm\", \"HLPercentage\", \"HLPercentageTerm\", "
					" \"TempHL1kSA\", \"TempHL1kSATerm\"  from trad_rider_details as A, "
                    "trad_sys_rider_profile as B  where \"sino\" = \"%@\" AND A.ridercode = B.RiderCode ORDER BY B.RiderCode ASC ", SINo];
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
            NSString *tempOtherRiderSA;
            NSRange rangeofDotHL ;
            NSString *Display = @"";
            while(sqlite3_step(statement2) == SQLITE_ROW) {
                [OtherRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)]];
                [OtherRiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 1)]];
                [OtherRiderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 2)]];
                
                tempOtherRiderSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 3)];
                rangeofDotHL = [tempOtherRiderSA rangeOfString:@"."];
                Display = @"";
                if (rangeofDotHL.location != NSNotFound) {
                    NSString *substring = [tempOtherRiderSA substringFromIndex:rangeofDotHL.location ];
                    if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                        Display = [tempOtherRiderSA substringToIndex:rangeofDotHL.location ];
                    } else {
                        Display = tempOtherRiderSA;
                    }
                } else {
                    Display = tempOtherRiderSA;
                }
                
                [OtherRiderSA addObject: Display];
                if ([[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)] isEqualToString:@"(null)" ]   ) {
                    [OtherRiderPlanOption addObject:@""];
                } else {
                    [OtherRiderPlanOption addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 4)]];
                }
                
                [OtherRiderDeductible addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 5)]];
                [OtherRiderHL1kSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 6)]];
                [OtherRiderHL1kSATerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 7)]];
                [OtherRiderHL100SA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 8)]];
                [OtherRiderHL100SATerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 9)]];
                [OtherRiderHLPercentage addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 10)]];
                [OtherRiderHLPercentageTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 11)]];
                [OtherRiderTempHL addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 12)]];
                [OtherRiderTempHLTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 13)]];
                
                tempOtherRiderSA = Nil;
                Display = Nil;
            }
            sqlite3_finalize(statement2);
        }
        sqlite3_close(contactDB);
    }
    
    statement = Nil;
    statement2 = Nil;
    QuerySQL = Nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    [super viewDidUnload];
    _dataTable = Nil;
    _db = Nil;
    SINo = Nil;
    PDSLanguage = Nil;
    databasePath = Nil;
    contactDB = Nil;
}

@end
