//
//  SPAJSubmissionModel.m
//  BLESS
//
//  Created by Basvi on 11/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJSubmissionModel.h"

@implementation SPAJSubmissionModel

-(id)init {
    if ( self = [super init] ) {
        formatter = [[Formatter alloc]init];
    }
    return self;
}


-(NSString *)getBlessVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

-(NSString *)stringCurrencyNumber:(NSString *)stringCurrency{
    if ([stringCurrency isEqualToString:@"usd"]){
        return @"14";
    }
    else if ([stringCurrency isEqualToString:@"idr"]){
        return @"13";
    }
    return @"";
}

-(NSString *)stringPaymentMethod:(NSString *)stringPaymentMethod{
    if ([stringPaymentMethod isEqualToString:@"debit"]){
        return @"O";
    }
    else if ([stringPaymentMethod isEqualToString:@"credit"]){
        return @"K";
    }
    else if ([stringPaymentMethod isEqualToString:@"other"]){
        return @"N";
    }
    /*else if ([stringPaymentMethod isEqualToString:@"IDR"]){
        return @"V";
    }*/
    return @"";
}

-(NSDictionary *)getSubsmissionInfo:(NSString *)SPAJEappNumber{
    NSDictionary *dict ;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *SINumber;
    NSString *SPAJNumber;
    NSString *SPAJCreationDate;
    NSString *XMLCreationDate;
    NSString *PolicyOwnerSignatureDate;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    
    s = [database executeQuery:[NSString stringWithFormat:@"SELECT spajTransaction.*,spajSignature.* FROM SPAJTransaction  spajTransaction left join SPAJSignature spajSignature on spajTransaction.SPAJTransactionID=spajSignature.SPAJTransactionID where SPAJEappNumber = '%@'",SPAJEappNumber]];
    
    while ([s next]) {
        SINumber = [s stringForColumn:@"SPAJSINO"];
        SPAJNumber = [s stringForColumn:@"SPAJNumber"];
        SPAJCreationDate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"yyyy-MM-dd" DateValue:[s stringForColumn:@"SPAJDateCreated"]];
        XMLCreationDate = [formatter getDateToday:@"yyyy-MM-dd"];
        PolicyOwnerSignatureDate = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"yyyy-MM-dd" DateValue:[s stringForColumn:@"SPAJDateSignatureParty1"]];
    }
    
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:SINumber,@"ProposalNo", SPAJNumber,@"ProposalContNo", SPAJCreationDate,@"PolAppntDate",XMLCreationDate,@"FirstTrialDate",PolicyOwnerSignatureDate,@"ReceiveDate", nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getChannelInfo:(NSString *)SPAJSINumber{
    NSDictionary *dict ;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *ReferralBranch;
    NSString *ReferralCode;
    NSString *ReferralName;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    
    s = [database executeQuery:[NSString stringWithFormat:@"select * from prospect_profile where IndexNo = (select PO_ClientID from SI_PO_Data where SINO = '%@')",SPAJSINumber]];
    
    while ([s next]) {
        ReferralBranch = [s stringForColumn:@"BranchName"];
        ReferralCode = [s stringForColumn:@"BranchCode"];
        ReferralName = [s stringForColumn:@"ReferralName"];
    }
    
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:ReferralBranch,@"ReferralsBank", ReferralCode,@"ReferralsCode", ReferralName,@"ReferralsName", nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getAgentInfo{
    NSDictionary *dict ;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *AgentCode;
    NSString *Kanwil;
    NSString *KCU;
    NSString *BranchCode;
    NSString *BranchName;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    
    s = [database executeQuery:[NSString stringWithFormat:@"select * from Agent_profile"]];
    
    while ([s next]) {
        AgentCode = [s stringForColumn:@"AgentCode"];
        Kanwil = [s stringForColumn:@"KanwilCode"];
        KCU = [s stringForColumn:@"KCU"];
        BranchCode = [s stringForColumn:@"BranchCode"];
        BranchName = [s stringForColumn:@"BranchName"];
    }
    
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:AgentCode,@"AgentCode", Kanwil,@"AgentDist", KCU,@"AgentKCU",BranchCode,@"AgentCom",BranchName,@"AgentBank", nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSString *)querySPAJDetailValue:(int)transactionID StringElementName:(NSString *)stringElementName{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *stringValue;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    
    s = [database executeQuery:[NSString stringWithFormat:@"SELECT Value FROM SPAJAnswers where elementID='%@' and SPAJTransactionID =%i",stringElementName,transactionID]];
    
    while ([s next]) {
        stringValue = [s stringForColumn:@"Value"];
    }
    
    
    [results close];
    [database close];
    return stringValue;
}

-(NSMutableArray *)getSPAJAnswerElementValueForSubmission:(int)spajTransactionID Section:(NSString *)stringSection{
    NSMutableArray* spajValueArray = [[NSMutableArray alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select elementID,Value from SPAJAnswers where SPAJHtmlSection ='%@' and SPAJTransactionID = %i",stringSection,spajTransactionID]];
    while ([s next]) {
        NSMutableDictionary* tempRevertRadioButtonDict = [[NSMutableDictionary alloc]init];
        [tempRevertRadioButtonDict setObject:[s stringForColumn:@"elementID"] forKey:@"elementID"];
        [tempRevertRadioButtonDict setObject:[s stringForColumn:@"Value"] forKey:@"Value"];
        [spajValueArray addObject:tempRevertRadioButtonDict];
    }
    
    [results close];
    [database close];
    return spajValueArray;
}


#pragma mark FileName
-(NSArray *)getFileNamesFor:(NSString *)stringFileNameFilter DictTransaction:(NSDictionary *)dictTransaction{
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    int count;
    
    NSArray* originalDirectoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
    NSMutableArray *directoryContent = [[NSMutableArray alloc]initWithArray:originalDirectoryContent];
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    
    if ([stringFileNameFilter isEqualToString:@"SPAJ"]){
        NSString *match1 = @"*SPAJ.pdf";
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
    }
    
    else if ([stringFileNameFilter isEqualToString:@"Supplementary"]){
        NSString *match1 = @"*Supplementary*";
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
    }
    
    else if ([stringFileNameFilter isEqualToString:@"IDImages"]){
        NSString *match1 = @"*ID*";
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
    }
    
    else if ([stringFileNameFilter isEqualToString:@"HealthQuestionaires"]){
        NSString *matchHealth = @"*healthquestionnairepdf*";
        NSString *matchActivity = @"*activityquestionnairepdf*";
        NSString *matchHealthIndo = @"*kuesionerkesehatan*";
        NSString *matchActivityIndo = @"*kuesioneraktivitas*";
        
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@ or SELF like %@ or SELF like %@ or SELF like %@", matchHealth,matchActivity,matchHealthIndo,matchActivityIndo];
        
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
        
        for (int x=0;x<[directoryContent count];x++){
            if ([[directoryContent objectAtIndex:x] rangeOfString:@"amandemen"].location == NSNotFound){
            
            }
            else{
                [directoryContent removeObjectAtIndex:x];
            }
        }
    }
    
    else if ([stringFileNameFilter isEqualToString:@"AmendmentForm"]){
        NSString *match1 = @"*kuesionerkesehatan_amandemen*";
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
    }
    
    else if ([stringFileNameFilter isEqualToString:@"ForeignerForm"]){
        NSString *match1 = @"*ForeignerForm*";
        NSPredicate *predicateFiles = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
        directoryContent = [[directoryContent filteredArrayUsingPredicate:predicateFiles] mutableCopy];
    }
    return directoryContent;
}

-(NSString *)getFormNameFromFileName:(NSString *)stringFileName{
    NSString *stringName;
    NSArray *chunks = [stringFileName componentsSeparatedByString: @"_"];
    
    NSString* realString;
    if ([chunks count]>0){
        realString = [chunks lastObject];
        NSArray *chunks1 = [realString componentsSeparatedByString: @"."];
        stringName = [chunks1 objectAtIndex:0];
    }
    
    
    return stringName;
}

-(NSString *)getPersonType:(NSString *)stringFileName AtIndex:(int)indexString{
    NSString *stringType;
    NSArray *chunks = [stringFileName componentsSeparatedByString: @"_"];
    
    NSString* realString;
    if ([chunks count]>0){
        realString = [chunks objectAtIndex:indexString];
        
        if ([realString isEqualToString:@"PemegangPolis"]){
            stringType = @"PO";
        }
        else if ([realString isEqualToString:@"Tertanggung"]){
            stringType = @"LA";
        }
        else if ([realString isEqualToString:@"OrangTuaWali"]){
            stringType = @"GD";
        }
        else if ([realString isEqualToString:@"Payment"]){
            stringType = @"GD";
        }
        else if ([realString isEqualToString:@"Other"]){
            stringType = @"GD";
        }
    }
    
    return stringType;
}

-(NSString *)getIDType:(NSString *)stringFileName AtIndex:(int)indexString{
    NSString *stringType;
    NSArray *chunks = [stringFileName componentsSeparatedByString: @"_"];
    
    NSString* realString;
    if ([chunks count]>0){
        realString = [chunks objectAtIndex:indexString];
        stringType = realString;
    }
    
    return stringType;
}


#pragma mark assured Info 
-(NSString *)GetSexCode:(NSString *)stringSex{
    if ([stringSex isEqualToString:@"male"]){
        return @"0";
    }
    else if ([stringSex isEqualToString:@"male"]){
        return @"1";
    }
    return @"";
}

-(NSString *)GetIDTypeCode:(NSString *)stringIDType{
    if ([stringIDType isEqualToString:@"KTP"]){
        return @"1";
    }
    else if ([stringIDType isEqualToString:@"SIM"]){
        return @"2";
    }
    else if ([stringIDType isEqualToString:@"PASPOR"]){
        return @"3";
    }
    else if ([stringIDType isEqualToString:@"KIMSKITAS"]){
        return @"4";
    }
    else if ([stringIDType isEqualToString:@"OTHER"]){
        return @"5";
    }
    return @"";
}

-(NSString *)GetMaritalStatusCode:(NSString *)stringMaritalStatus{
    if ([stringMaritalStatus isEqualToString:@"single"]){
        return @"1";
    }
    else if ([stringMaritalStatus isEqualToString:@"married"]){
        return @"2";
    }
    else if ([stringMaritalStatus isEqualToString:@"divorced"]){
        return @"3";
    }
    return @"";
}

-(NSString *)GetReligionCode:(NSString *)stringReligion{
    if ([stringReligion isEqualToString:@"islam"]){
        return @"1";
    }
    else if ([stringReligion isEqualToString:@"katolik"]){
        return @"2";
    }
    else if ([stringReligion isEqualToString:@"kristen"]){
        return @"3";
    }
    else if ([stringReligion isEqualToString:@"hindu"]){
        return @"4";
    }
    else if ([stringReligion isEqualToString:@"budha"]){
        return @"5";
    }
    else if ([stringReligion isEqualToString:@"konghuchu"]){
        return @"6";
    }
    return @"";
}

-(NSString *)GetCorrespondenceAddressCode:(NSString *)stringCorrespondenceAddress{
    if ([stringCorrespondenceAddress isEqualToString:@"home"]){
        return @"0";
    }
    else if ([stringCorrespondenceAddress isEqualToString:@"office"]){
        return @"1";
    }
    return @"";
}

-(NSString *)getStringFromString:(NSString *)stringFileName StringSeparator:(NSString *)stringSeparator AtIndex:(int)indexReturn{
    NSString *stringName;
    NSArray *chunks = [stringFileName componentsSeparatedByString: stringSeparator];
    
    NSString* realString;
    if ([chunks count]>0){
        realString = [chunks lastObject];
        NSArray *chunks1 = [realString componentsSeparatedByString: @"."];
        stringName = [chunks1 objectAtIndex:indexReturn];
    }
    
    
    return stringName;
}

-(NSString *)getPartTimeConfirmation:(NSString *)stringPartTimeWork{
    if ([stringPartTimeWork length]>0){
        return @"Y";
    }
    else{
        return @"N";
    }
    
    return @"";
}

-(NSString *)getAnswerValue:(NSString *)stringAnswerValue{
    if ([stringAnswerValue isEqualToString:@"true"]){
        return @"Y";
    }
    else if ([stringAnswerValue isEqualToString:@"false"]){
        return @"N";
    }
    return stringAnswerValue;
}

-(NSString *)getAnswerType:(NSString *)stringElementID{
    if ([stringElementID rangeOfString:@"RadioButton"].location == NSNotFound){
        return @"TXT";
    }
    else if ([stringElementID isEqualToString:@"false"]){
        return @"OPT";
    }
    return @"";
}

-(NSString *)stringFromArray:(NSMutableArray *)OriginalArray StringFilter:(NSString *)stringFilter{
    NSMutableArray *cars = [[NSMutableArray alloc]initWithArray:OriginalArray];
    
    NSString *stringToSearch = stringFilter;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",stringToSearch]; // if you need case sensitive search avoid '[c]' in the predicate
    
    NSArray *resultsArray = [cars filteredArrayUsingPredicate:predicate];
    if ([resultsArray count]>0){
        return [[resultsArray objectAtIndex:0] valueForKey:@"Value"];
    }
    else{
        return @"";
    }
}




@end
