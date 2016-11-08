//
//  ClearData.m
//  iMobile Planner
//
//  Created by Emi on 16/4/15.
//  Copyright (c) 2015 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ClearData.h"
#import "DataTable.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"
#import "Cleanup.h"
#import "ModelSPAJTransaction.h"

@implementation ClearData

NSMutableArray *EProArr;

-(void)ClientWipeOff {
	
	
	//PART 1: Submitted case (30 days)
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [dirPaths objectAtIndex:0];
	NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
	
	[db open];
	
	
    NSString *eProposalNo;
	NSString *ProspectID;
	int DayCount = 0;
	
	EProArr = [NSMutableArray array];
	
	//PART 2: Non-Received CASE (30 days)
	
	NSMutableArray *CDateProsArr = [NSMutableArray array];
	
	FMResultSet *result_prospect2 = [db executeQuery:@"SELECT * from prospect_profile"];
	NSString *CreatedDate;
    
    NSDateFormatter *dateFormatter;
    NSDate *date;
    NSDictionary *tempData;
	while ([result_prospect2 next]) {
		CreatedDate = [result_prospect2 objectForColumnName:@"DateCreated"];
		ProspectID = [result_prospect2 objectForColumnName:@"IndexNo"];
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
		date = [dateFormatter dateFromString: CreatedDate];
		dateFormatter = [[NSDateFormatter alloc] init];
		
		//new deletion
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		CreatedDate = [dateFormatter stringFromDate:date];
		
		DayCount = [self CalculateDateCheck:CreatedDate];
        NSLog(@"daycount %d",DayCount);
		//if (DayCount > 30) {
        if (DayCount > 30) {
			tempData = [[NSDictionary alloc] initWithObjectsAndKeys:CreatedDate, @"CreatedDate", ProspectID, @"ProspectID", nil];
			[CDateProsArr addObject:[tempData copy]];
		}
	}
	
	if (CDateProsArr.count != 0) {
		for (int c=0; c<= CDateProsArr.count-1; c++) {
			ProspectID = [[CDateProsArr objectAtIndex:c] objectForKey:@"ProspectID"];
			
			[self GetProposalNo:ProspectID database:db];
			NSLog(@"prospectID: %@, ePeoposalNo: %@", ProspectID, eProposalNo);
			
			if (EProArr.count != 0) {
				for (int d=0; d<= EProArr.count-1; d++) {
					eProposalNo = [EProArr objectAtIndex:d];
					
					[self deleteEApp:eProposalNo database:db];
					[self deleteOldPdfs:eProposalNo];
				}
			}
			
			Cleanup *DeleteSi =[[Cleanup alloc]init];
			[DeleteSi deleteAllSIUsingCustomerID: ProspectID];
			
			[self deleteCFF:ProspectID database:db];
			[self deleteProspect:ProspectID database:db];
		}
	}
	
    [db close];
	
}

-(void)SubmitedWipeOff :(NSString *)eProposalNo{
	
	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [dirPaths objectAtIndex:0];
	NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
	
	[db open];
	
	//delete only related value to the submission
	NSString *ProspectID;
	NSString *SINo;
	
	FMResultSet *result1 = [db executeQuery:@"select SiNo from eProposal WHERE eProposalNo = ?", eProposalNo, nil];
	
	while ([result1 next]) {
		SINo = [result1 objectForColumnName:@"SiNo"];
	}
	
	NSMutableArray *prosIDArr = [NSMutableArray array];
	FMResultSet *result2 = [db executeQuery:@"SELECT * from eProposal_LA_Details WHERE eProposalNo = ?", eProposalNo];
    
    NSDictionary *tempData;
	while ([result2 next]) {
		ProspectID =  [result2 objectForColumnName:@"ProspectProfileID"];
		tempData = [[NSDictionary alloc] initWithObjectsAndKeys: eProposalNo, @"eProposalNo", ProspectID, @"ProspectID", nil];
		[prosIDArr addObject:[tempData copy]];
	}
	
	if (prosIDArr.count != 0) {
		for (int a=0; a <= prosIDArr.count-1; a++) {
			ProspectID = [[prosIDArr objectAtIndex:a] objectForKey:@"ProspectID"];
			[self deleteEApp:eProposalNo database:db];
			[self deleteOldPdfs:eProposalNo];
			
			Cleanup *DeleteSi =[[Cleanup alloc]init];
			[DeleteSi deleteSpecificSIUsingSINo: SINo];
		}
	}
	[db close];
	
}

-(void)GetProposalNo:(NSString *)prospectID database:(FMDatabase *)db {
	NSString *ProposalNo = @"";
	EProArr = [NSMutableArray array];	
	FMResultSet *result = [db executeQuery:@"SELECT eProposalNo FROM eProposal_LA_Details where prospectProfileID = ?", prospectID];
	
	while ([result next]) {
		ProposalNo =  [result objectForColumnName:@"eProposalNo"];
		[EProArr addObject:ProposalNo];
	}
}

-(void)deleteProspect:(NSString *)prospectID database:(FMDatabase *)db {
	
	NSString *strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from prospect_profile where indexNo = '%@'", prospectID];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in deleting prospect_profile");
	}
	[db executeUpdate:@"Delete from contact_input where indexNo = ?", prospectID];
}

//TEMP SET: DELETE SI

-(void)deleteSI:(NSString *)prospectID database:(FMDatabase *)db {
	FMResultSet *results4;
	NSString *SINO = @"";
	results4 = [db executeQuery:@"SELECT B.SINo from Clt_Profile as A , UL_LAPayor as B where A.indexNo = ? AND A.CustCode = B.Custcode", prospectID];
	while ([results4 next]) {
		SINO = [results4 objectForColumnName:@"SINo"];
		[db executeUpdate:@"DELETE FROM UL_Details WHERE SINo = ?", SINO];
	}
	
	results4 = [db executeQuery:@"SELECT B.SINo from Clt_Profile as A , Trad_LAPayor as B where A.indexNo = ? AND A.CustCode = B.Custcode", prospectID];
	while ([results4 next]) {
		SINO = [results4 objectForColumnName:@"SINo"];
		[db executeUpdate:@"DELETE FROM Trad_Details WHERE SINo = ?", SINO];
	}
}

-(void)deleteCFF:(NSString *)prospectID database:(FMDatabase *)db {
	NSString *CFFID;
	FMResultSet *result_CFF = [db executeQuery:[NSString stringWithFormat:@"Select * from CFF_Master where ClientProfileID = '%@'", prospectID]];
	
    while ([result_CFF next]) {
		CFFID = [result_CFF objectForColumnName:@"ID"];
	}
		
	if ((NSNull *) CFFID != [NSNull null]) {
		[db executeUpdate:@"DELETE FROM CFF_Master WHERE ID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Protection WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Protection_Details WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Retirement WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Retirement_Details WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Education WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Education_Details WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_SavingsInvest WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_SavingsInvest_Details WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Family_Details WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_CA WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_CA_Recommendation WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Recommendation_Rider WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_RecordOfAdvice WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_RecordOFAdvice_Rider WHERE CFFID = ?", CFFID];
		[db executeUpdate:@"DELETE FROM CFF_Personal_Details WHERE CFFID = ?", CFFID];
	}
	
}


-(void)deleteEApp:(NSString *)proposal database:(FMDatabase *)db {
    NSString *strDel = @"";
	NSLog(@"Delete eApp: %@", proposal);
	
	//Update Eapp List before delete
	NSString *queryB = @"";
	queryB = [NSString stringWithFormat:@"UPDATE eApp_Listing SET isDeleted = 'Y' WHERE ProposalNo = '%@'" , proposal];
	[db executeUpdate:queryB];
	
	//Only delete if status not 4 - submitted, 6 - failed, 7 - received (with policy no)
	FMResultSet *result_Status = [db executeQuery:[NSString stringWithFormat:@"Select * from eApp_listing where status not in (7, 4, 6) and ProposalNo = '%@'", proposal]];
	
    while ([result_Status next]) {
		NSLog(@"Delete EappListing: %@", proposal);
		//Delete eApp_Listing
        if (![db executeUpdate:@"Delete from eApp_Listing where ProposalNo = ?", proposal, nil]) {
			NSLog(@"Error in Delete Statement - CFF eApp_Listing");
		}
		
		//Delete eProposal_LA_Details
		if (![db executeUpdate:@"Delete from eProposal_LA_Details where eProposalNo = ?", proposal, nil]) {
			NSLog(@"Error in Delete Statement - eProposal_LA_Details");
		}
		
		//Delete eProposal
		if (![db executeUpdate:@"Delete from eProposal where eProposalNo = ?", proposal, nil]) {
			NSLog(@"Error in Delete Statement - eProposal");
		}
	}
	
	//Delete eProposal_Existing_Policy_1
	if (![db executeUpdate:@"Delete from eProposal_Existing_Policy_1 where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_Existing_Policy_1");
	}
	
	//Delete eProposal_Existing_Policy_2
	if (![db executeUpdate:@"Delete from eProposal_Existing_Policy_2 where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_Existing_Policy_2");
	}
	
	//Delete eProposal_NM_Details
	if (![db executeUpdate:@"Delete from eProposal_NM_Details where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_NM_Details");
	}
	
	//Delete eProposal_Trustee_Details
	if (![db executeUpdate:@"Delete from eProposal_Trustee_Details where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_Trustee_Details");
	}
	
	//Delete eProposal_QuestionAns
	if (![db executeUpdate:@"Delete from eProposal_QuestionAns where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_QuestionAns");
	}
	
	//Delete eProposal_Additional_Questions_1
	if (![db executeUpdate:@"Delete from eProposal_Additional_Questions_1 where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_Additional_Questions_1");
	}
	
	//Delete eProposal_Additional_Questions_2
	if (![db executeUpdate:@"Delete from eProposal_Additional_Questions_2 where eProposalNo = ?", proposal, nil]) {
		NSLog(@"Error in Delete Statement - eProposal_Additional_Questions_2");
	}
	
	//Delete eProposal_Signature
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_Signature where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_Signature");
	}
	
	//DELETE EApp_CFF START
	
	//Delete eProposal_CFF_Master
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Master where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Master");
	}
	
	//Delete eProposal_CFF_CA
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_CA where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_CA");
	}
	
	//Delete eProposal_CFF_CA_Recommendation
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_CA_Recommendation where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_CA_Recommendation");
	}
	
	//Delete eProposal_CFF_CA_Recommendation_Rider
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_CA_Recommendation where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_CA_Recommendation_Rider");
	}
	
	//Delete eProposal_CFF_Education
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Education where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Education");
	}
	
	//Delete eProposal_CFF_Education_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Education_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Education_Details");
	}
	
	//Delete eProposal_CFF_Family_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Family_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Family_Details");
	}
	
	//Delete eProposal_CFF_Personal_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Personal_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Personal_Details");
	}
	
	//Delete eProposal_CFF_Protection
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Protection where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Protection");
	}
	
	//Delete eProposal_CFF_Protection_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Protection_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Protection_Details");
	}
	
	//Delete eProposal_CFF_RecordOfAdvice
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_RecordOfAdvice where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_RecordOfAdvice");
	}
	
	//Delete eProposal_CFF_RecordOfAdvice_Rider
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_RecordOfAdvice_Rider where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_RecordOfAdvice_Rider");
	}
	
	//Delete eProposal_CFF_Retirement
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Retirement where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Retirement");
	}
	
	//Delete eProposal_CFF_Retirement_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_Retirement_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_Retirement_Details");
	}
	
	//Delete eProposal_CFF_SavingsInvest
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_SavingsInvest where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_SavingsInvest");
	}
	
	//Delete eProposal_CFF_SavingsInvest_Details
	strDel = @"";
	strDel = [NSString stringWithFormat: @"Delete from eProposal_CFF_SavingsInvest_Details where eProposalNo = '%@'", proposal];
	if (![db executeUpdate:strDel]) {
		NSLog(@"Error in Delete Statement - eProposal_CFF_SavingsInvest_Details");
	}
	
	//DELETE eApp_CFF END
	
}

-(void)deleteOldPdfs:(NSString *)proposal
{

    NSFileManager *fm = [NSFileManager defaultManager];
	// Get the root directory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];
	NSString *SIXMLPath = [documentsDirectory stringByAppendingPathComponent:@"SIXML"];
	NSString *PRXMLPath = [documentsDirectory stringByAppendingPathComponent:@"ProposalXML"];
	
    NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self CONTAINS '%@'",proposal]];
	
    NSArray *dirContentsForm = [fm contentsOfDirectoryAtPath:FormsPath error:nil];
	NSArray *dirContentsSIXML = [fm contentsOfDirectoryAtPath:SIXMLPath error:nil];
	NSArray *dirContentsPRXML = [fm contentsOfDirectoryAtPath:PRXMLPath error:nil];
	
	NSArray *filteredFilesFORM = [dirContentsForm filteredArrayUsingPredicate:filter];
	NSArray *filteredFilesSIXML = [dirContentsSIXML filteredArrayUsingPredicate:filter];
	NSArray *filteredFilesPRXML = [dirContentsPRXML filteredArrayUsingPredicate:filter];
	
    NSError *error;
	
    for (NSString *file in filteredFilesFORM) {
		[fm removeItemAtPath:[FormsPath stringByAppendingPathComponent:file] error:&error];
		[fm removeItemAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Complete.xml"]] error:&error];
		[fm removeItemAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Complete.xml.enc"]] error:&error];
    }
	
	for (NSString *file in filteredFilesPRXML) {
		[fm removeItemAtPath:[PRXMLPath stringByAppendingPathComponent:file] error:&error];		
    }
	
	for (NSString *file in filteredFilesSIXML) {
		[fm removeItemAtPath:[SIXMLPath stringByAppendingPathComponent:file] error:&error];		
    }
		
}


-(int) CalculateDate:(NSString *)date2 {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setLocale:[NSLocale systemLocale]];
    [df setDateFormat:@"dd/MM/yyyy"];
	
	int numberOfDay;
	
	NSDate* d2 = [df dateFromString:date2];
	NSDate *todayDate = [NSDate date];	
	
	NSUInteger unitFlags = NSDayCalendarUnit;
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *compGST = [calendar components:unitFlags fromDate:d2 toDate:todayDate options:0];
	
	numberOfDay = abs([compGST day]);
	
	return numberOfDay + 1;
}

-(int) CalculateDateCheck: (NSString *)date2 {
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setLocale:[NSLocale systemLocale]];
    [df setDateFormat:@"dd/MM/yyyy"];
	
	NSArray *CreatedDate = [date2 componentsSeparatedByString:@" "];
	NSString *CreatedDateString = [CreatedDate objectAtIndex:0];
	NSString *CreatedTimeString = [CreatedDate objectAtIndex:1];
	NSString *DateNTime = [NSString stringWithFormat:@"%@ %@",CreatedDateString,CreatedTimeString];
	
	NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
	// this is imporant - we set our input date format to match our input string
	// if format doesn't match you'll get nil from your string, so be careful
	[dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *dateFromString1 = [[NSDate alloc] init];
	dateFromString1 = [dateFormatter1 dateFromString:DateNTime];
		
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *FinalDate = dateFromString1;
    
	NSString *strNewDate;
	NSString *strCurrentDate;
	NSDateFormatter *df1 =[[NSDateFormatter alloc]init];
	[df1 setDateStyle:NSDateFormatterMediumStyle];
	[df1 setTimeStyle:NSDateFormatterMediumStyle];
	strCurrentDate = [df1 stringFromDate:FinalDate];
    
	int hoursToAdd = 8760;
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setHour:hoursToAdd];
	NSDate *newDate= [calendar dateByAddingComponents:components toDate:FinalDate options:0];
	
	[df setDateFormat:@"dd/MM/yyyy ( HH:mm a )"];
	strNewDate = [df stringFromDate:newDate];
	
	NSDate *mydate = [NSDate date];
	NSTimeInterval secondsInEightHours = 8 * 60 * 60;
	NSDate *currentDate = [mydate dateByAddingTimeInterval:secondsInEightHours];
	NSDate *expireDate = [newDate dateByAddingTimeInterval:secondsInEightHours];
	
	int countdown = -[currentDate timeIntervalSinceDate:expireDate];//pay attention here.
	int minutes = (countdown / 60) % 60;
	int hours = (countdown / 3600) % 24;
	int days = (countdown / 86400) % 365;
	
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsDay = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:currentDate
                                                          toDate:expireDate
                                                         options:NSCalendarWrapComponents];
    int days1 = [componentsDay day];
    
    if (minutes < 1 && hours < 1 && days1 < 1) {
		return 31; //will delete
    } else {
		return 0; //no delete
    }
}

-(void)SPAJExpiredWipeOff {
    ModelSPAJTransaction *modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    [modelSPAJTransaction voidHideExpiredSPAJ];
}

@end
