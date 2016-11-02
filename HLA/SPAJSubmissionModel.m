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



@end
