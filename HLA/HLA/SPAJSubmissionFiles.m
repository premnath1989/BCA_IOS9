//
//  SPAJSubmissionFiles.m
//  BLESS
//
//  Created by Erwin Lim  on 8/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAJSubmissionFiles.h"

@implementation SPAJSubmissionFiles{
    
}

-(void)xmltoFile:(NSMutableDictionary *)dictInfo path:(NSString *)filePath
{
    NSError *error;
    NSMutableDictionary *sampleDict = [[NSMutableDictionary alloc]init];
    
    //Bless Info
    NSMutableDictionary *BlessInfo = [[NSMutableDictionary alloc]init];
    [BlessInfo setValue:@"BLESS(I)" forKey:@"SystemName"];
    [BlessInfo setValue:@"1.0" forKey:@"BLESSVersion"];
    [sampleDict setValue:BlessInfo forKey:@"BLESSInfo"];
    
    //Submission Info
    NSMutableDictionary *SubmissionInfo = [[NSMutableDictionary alloc]init];
    [SubmissionInfo setValue:@"11100001160811162860" forKey:@"ProposalNo"];
    [SubmissionInfo setValue:@"60000000291" forKey:@"ProposalContNo"];
    [SubmissionInfo setValue:@"2016-08-15" forKey:@"PolAppntDate"];
    [SubmissionInfo setValue:@"2016-08-15" forKey:@"FirstTrialDate"];
    [SubmissionInfo setValue:@"N" forKey:@"DateBackFlag"];
    [SubmissionInfo setValue:@"2016-08-15" forKey:@"ReceiveDate"];
    [SubmissionInfo setValue:@"2016-08-15" forKey:@"SIType"];
    [SubmissionInfo setValue:@"ID" forKey:@"ManageCom"];
    [sampleDict setValue:SubmissionInfo forKey:@"SubmissionInfo"];
    
    //ChannelInfo
    NSMutableDictionary *ChannelInfo = [[NSMutableDictionary alloc]init];
    [ChannelInfo setValue:@"03" forKey:@"SALECHNL"];
    [ChannelInfo setValue:@"BCA" forKey:@"ReferralsBank"];
    [ChannelInfo setValue:@"19885093" forKey:@"ReferralsCode"];
    [ChannelInfo setValue:@"YUNANTO" forKey:@"ReferralsName"];
    [sampleDict setValue:ChannelInfo forKey:@"ChannelInfo"];
    
    //AgentInfo
    NSMutableDictionary *AgentInfo = [[NSMutableDictionary alloc]init];
    [AgentInfo setValue:@"1" forKey:@"AgentCount"];
        //Agent
        NSMutableDictionary *Agent = [[NSMutableDictionary alloc]init];
        [Agent setValue:@"1" forKey:@"Seq"];
        [Agent setValue:@"11600055" forKey:@"AgentCode"];
        [Agent setValue:@"2005" forKey:@"AgentDist"];
        [Agent setValue:@"11600055" forKey:@"AgentCode"];
        [Agent setValue:@"0195" forKey:@"AgentCom"];
        [Agent setValue:@"BCA" forKey:@"AgentBank"];
        [Agent setValue:@"1" forKey:@"AgentPercentage"];
        [AgentInfo setValue:Agent forKey:@"Agent ID=\"1\""];
    [sampleDict setValue:AgentInfo forKey:@"AgentInfo"];
    
    //AssuredInfo
    NSMutableDictionary *AssuredInfo = [[NSMutableDictionary alloc]init];
    [AssuredInfo setValue:@"60000000291" forKey:@"ProposalContNo"];
        //Party
        NSMutableDictionary *Party = [[NSMutableDictionary alloc]init];
        [Party setValue:@"LA1" forKey:@"PTypeCode"];
        [Party setValue:@"1" forKey:@"Seq"];
        [Party setValue:@"M" forKey:@"InsuredType"];
        [Party setValue:@"MR" forKey:@"LATitle"];
        [Party setValue:@"BENEFICIARY14" forKey:@"LAName"];
        [Party setValue:@"1" forKey:@"LASex"];
        [Party setValue:@"2013-01-01" forKey:@"LADOB"];
        [Party setValue:@"1" forKey:@"IDType"];
        [Party setValue:@"899988392920123" forKey:@"IDNo"];
        [Party setValue:@"2018-01-01" forKey:@"IDExpiryDate"];
        [Party setValue:@"1" forKey:@"LAMaritalStatus"];
        [Party setValue:@"01" forKey:@"LARelationship"];
        [Party setValue:@"cm" forKey:@"LAHeighUnit"];
        [Party setValue:@"173" forKey:@"LAHeight"];
        [Party setValue:@"kg" forKey:@"LAWeightUnit"];
        [Party setValue:@"80" forKey:@"LAWeight"];
        [Party setValue:@"Y" forKey:@"LAIDSubmitted"];
        [Party setValue:@"A11" forKey:@"LANationality"];
        [Party setValue:@"Jakarta" forKey:@"LABirthPlace"];
        [Party setValue:@"2" forKey:@"LAReligion"];
        [Party setValue:@"" forKey:@"BenefitInsu"];
        [Party setValue:@"BCA Life" forKey:@"LACompanyName"];
        [Party setValue:@"100000000" forKey:@"LAAnnualIncome"];
        [Party setValue:@"Y" forKey:@"LAFNAFlag"];
        [Party setValue:@"" forKey:@"LAFNAReason"];
        [Party setValue:@"" forKey:@"LATotalIncome"];
        [Party setValue:@"" forKey:@"LACompanyType"];
        [Party setValue:@"" forKey:@"ANGGARANDASARNO"];
        [Party setValue:@"" forKey:@"SURATIJINUSAHANO"];
        [Party setValue:@"" forKey:@"TDPNO"];
        [Party setValue:@"" forKey:@"SKDPNO"];
        [Party setValue:@"" forKey:@"LACompanyAsset"];
        [Party setValue:@"" forKey:@"LABusinessType"];
        [Party setValue:@"N" forKey:@"FCFlag"];
        [Party setValue:@"2" forKey:@"FATCAType"];
    
            //Address
            NSMutableDictionary *Address = [[NSMutableDictionary alloc]init];
                //Address Residence
                NSMutableDictionary *AddressResidence = [[NSMutableDictionary alloc]init];
                [AddressResidence setValue:@"39 CC TOWER B" forKey:@"Address1"];
                [AddressResidence setValue:@"SUDIRMAN PARK APARTMENT" forKey:@"Address2"];
                [AddressResidence setValue:@"JL MANSOR HASYIM" forKey:@"Address3"];
                [AddressResidence setValue:@"162722" forKey:@"PostCode"];
                [AddressResidence setValue:@"DKI JAKARTA" forKey:@"District"];
                [AddressResidence setValue:@"JAKARTA TIMUR" forKey:@"Area"];
                [AddressResidence setValue:@"KARET" forKey:@"City"];
                [AddressResidence setValue:@"State" forKey:@"State"];
                [AddressResidence setValue:@"INDONESIA" forKey:@"Country"];
                [AddressResidence setValue:@"0812" forKey:@"HomePhoneAreaCode"];
                [AddressResidence setValue:@"6262727272" forKey:@"HomePhone"];
                [AddressResidence setValue:@"081" forKey:@"MobileCode"];
                [AddressResidence setValue:@"81388753619" forKey:@"Mobile"];
                [AddressResidence setValue:@"081" forKey:@"MobileCCode"];
                [AddressResidence setValue:@"81388788888" forKey:@"Mobile2"];
                [AddressResidence setValue:@"0" forKey:@"SMSNoticeNo"];
                [AddressResidence setValue:@"abc@email.com" forKey:@"Email"];
                [AddressResidence setValue:@"0" forKey:@"CorrespondenceAddress"];
                [AddressResidence setValue:@"2" forKey:@"CorrespondenceMedia"];
                [Address setValue:AddressResidence forKey:@"Address Type=\"Residence\""];
                //Address Office
                NSMutableDictionary *AddressOffice = [[NSMutableDictionary alloc]init];
                [AddressResidence setValue:@"Address1" forKey:@"Address1"];
                [AddressResidence setValue:@"Address2" forKey:@"Address2"];
                [AddressResidence setValue:@"Address3" forKey:@"Address3"];
                [AddressResidence setValue:@"123456" forKey:@"PostCode"];
                [AddressResidence setValue:@"DKI JAKARTA" forKey:@"District"];
                [AddressResidence setValue:@"JAKARTA TIMUR" forKey:@"Area"];
                [AddressResidence setValue:@"KARET" forKey:@"City"];
                [AddressResidence setValue:@"State" forKey:@"State"];
                [AddressResidence setValue:@"INDONESIA" forKey:@"Country"];
                [AddressResidence setValue:@"0812" forKey:@"CompanyPhoneAreaCode"];
                [AddressResidence setValue:@"6262727272" forKey:@"CompanyPhone"];
                [Address setValue:AddressOffice forKey:@"Address Type=\"Office\""];
            [Party setValue:Address forKey:@"Address"];
    
            //Occupation Info
            NSMutableDictionary *OccupationInfo = [[NSMutableDictionary alloc]init];
            [OccupationInfo setValue:@"BCA Life" forKey:@"CompanyName"];
            [OccupationInfo setValue:@"00" forKey:@"OccupationCode"];
            [OccupationInfo setValue:@"N" forKey:@"PartTime"];
            [OccupationInfo setValue:@"1" forKey:@"OccupationType"];
            [OccupationInfo setValue:@"Insurance" forKey:@"Industry"];
            [OccupationInfo setValue:@"Sales" forKey:@"Position"];
            [Party setValue:OccupationInfo forKey:@"OccupationInfo"];
    
            //Questionnaire
            NSMutableDictionary *QuestionaireInfo = [[NSMutableDictionary alloc]init];
                //Questions
                NSMutableDictionary *Questions = [[NSMutableDictionary alloc]init];
                [Questions setValue:@"Q1001" forKey:@"QnID"];
                [Questions setValue:@"I" forKey:@"QnParty"];
                [Questions setValue:@"OPT" forKey:@"AnswerType"];
                [Questions setValue:@"N" forKey:@"Answer"];
                [Questions setValue:@"" forKey:@"Reason"];
                [QuestionaireInfo setValue:Questions forKey:@"Questions ID=\"1\""];
            [Party setValue:QuestionaireInfo forKey:@"QuestionaireInfo"];
        [AssuredInfo setValue:Party forKey:@"Party ID=\"1\""];
    [sampleDict setValue:AssuredInfo forKey:@"AssuredInfo"];
    
    //NomineeInfo
    NSMutableDictionary *NomineeInfo = [[NSMutableDictionary alloc]init];
    [NomineeInfo setValue:@"1" forKey:@"NomineeCount"];
        //Nominee
        NSMutableDictionary *Nominee = [[NSMutableDictionary alloc]init];
        [Nominee setValue:@"1" forKey:@"Seq"];
        [Nominee setValue:@"L" forKey:@"NMType"];
        [Nominee setValue:@"Nominee 1" forKey:@"NMName"];
        [Nominee setValue:@"100" forKey:@"NMShare"];
        [Nominee setValue:@"1980-01-01" forKey:@"NMDOB"];
        [Nominee setValue:@"M" forKey:@"NMSex"];
        [Nominee setValue:@"02" forKey:@"NMRelationship"];
        [Nominee setValue:@"A11" forKey:@"NMNationality"];
        [Nominee setValue:@"N" forKey:@"FCFlag"];
        [Nominee setValue:@"2" forKey:@"FATCAType"];
        [Nominee setValue:@"P" forKey:@"NMPriority"];
        [NomineeInfo setValue:Nominee forKey:@"Nominee ID=\"1\""];
    [sampleDict setValue:NomineeInfo forKey:@"NomineeInfo"];
    
    //PaymentInfo
    NSMutableDictionary *PaymentInfo = [[NSMutableDictionary alloc]init];
    [PaymentInfo setValue:@"V" forKey:@"FirstTimePayment"];
    [PaymentInfo setValue:@"" forKey:@"BankAuthorization"];
    [PaymentInfo setValue:@"F" forKey:@"OutPayFlag"];
    [PaymentInfo setValue:@"0" forKey:@"PayLocation"];
    [PaymentInfo setValue:@"1 2 3 4 5 6 7 8 9 0" forKey:@"NewBankAcctNo"];
    [PaymentInfo setValue:@"13" forKey:@"NewCurrency"];
    [PaymentInfo setValue:@"Policy Owner14" forKey:@"BankAcctName"];
    [PaymentInfo setValue:@"1" forKey:@"CreditCardName"];
    [PaymentInfo setValue:@"1" forKey:@"BankCode"];
    [PaymentInfo setValue:@"1" forKey:@"CreditCardExpiry"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewBankAcctNo"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewCurrency"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewBankAcctName"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewBankCode"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewBankBranch"];
    [PaymentInfo setValue:@"1" forKey:@"ReNewCreditCardExpiry"];
    [PaymentInfo setValue:@"1" forKey:@"ReturnBankAcctNo"];
    [PaymentInfo setValue:@"1" forKey:@"ReturnBankAcctName"];
    [PaymentInfo setValue:@"1" forKey:@"ReturnBankCode"];
    [PaymentInfo setValue:@"1" forKey:@"ReturnBankBranch"];
    [sampleDict setValue:PaymentInfo forKey:@"PaymentInfo"];
    
    //OthetInfo
    NSMutableDictionary *OthetInfo = [[NSMutableDictionary alloc]init];
    [OthetInfo setValue:@"1" forKey:@"APPNTVIPVALUE"];
    [OthetInfo setValue:@"N" forKey:@"APPNTTRANINSUFLAG"];
    [OthetInfo setValue:@"N" forKey:@"APPNTTELUWFLAG"];
    [OthetInfo setValue:@"" forKey:@"APPNTREGFLAG"];
    [OthetInfo setValue:@"" forKey:@"APPNTREGID"];
    [OthetInfo setValue:@"" forKey:@"PayorVIPClass"];
    [OthetInfo setValue:@"N" forKey:@"PayorReplacementDeclaration"];
    [OthetInfo setValue:@"N" forKey:@"PayorAllowTeleUW"];
    [sampleDict setValue:OthetInfo forKey:@"OthetInfo"];
    
    //SIInfo
    NSMutableDictionary *SIInfo = [[NSMutableDictionary alloc]init];
    [SIInfo setValue:@"11100001160811160758" forKey:@"SINO"];
    [SIInfo setValue:@"1.0" forKey:@"SIVersion"];
    [SIInfo setValue:@"TRAD" forKey:@"SIType"];
        //BasicPlan
        NSMutableDictionary *BasicPlan = [[NSMutableDictionary alloc]init];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PTypeCode"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PlanType"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PlanCode"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"SumAssured"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"CoverageUnit"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"CoverageTerm"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PayingTerm"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PaymentModel"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PaymentAmount"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"PayEndYearFlag"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"Currency"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"ExtraPremiumPercentage"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"ExtraPremiumPerMil"];
        [BasicPlan setValue:@"11100001160811160758" forKey:@"ExtraPremiumPeriod"];
        [SIInfo setValue:BasicPlan forKey:@"BasicPlan"];
        //Duties
        NSMutableDictionary *Duties = [[NSMutableDictionary alloc]init];
            //Duty
            NSMutableDictionary *Duty = [[NSMutableDictionary alloc]init];
            [Duty setValue:@"" forKey:@"DutyCode"];
            [Duty setValue:@"" forKey:@"SumInsured"];
            [Duty setValue:@"" forKey:@"Premium"];
            [Duties setValue:Duty forKey:@"Duty"];
        [SIInfo setValue:Duties forKey:@"Duties"];
        //Parties
        NSMutableDictionary *PartiesSI = [[NSMutableDictionary alloc]init];
        [PartiesSI setValue:@"1" forKey:@"PartyCount"];
            //Party
            NSMutableDictionary *PartySI = [[NSMutableDictionary alloc]init];
            [PartySI setValue:@"1" forKey:@"Seq"];
                //Riders
                NSMutableDictionary *Riders = [[NSMutableDictionary alloc]init];
                [Riders setValue:@"0" forKey:@"RiderCount"];
                    //Rider
                    NSMutableDictionary *Rider = [[NSMutableDictionary alloc]init];
                    [Rider setValue:@"0" forKey:@"PlanType"];
                    [Rider setValue:@"0" forKey:@"PlanCode"];
                    [Rider setValue:@"0" forKey:@"PlanOption"];
                    [Rider setValue:@"0" forKey:@"SumAssured"];
                    [Rider setValue:@"0" forKey:@"CoverageUnit"];
                    [Rider setValue:@"0" forKey:@"CoverageTerm"];
                    [Rider setValue:@"0" forKey:@"PayingTerm"];
                    [Rider setValue:@"0" forKey:@"PaymentModel"];
                    [Rider setValue:@"0" forKey:@"PaymentAmount"];
                    [Riders setValue:Rider forKey:@"Rider ID=\"1\""];
                [PartySI setValue:Riders forKey:@"Riders"];
            [PartiesSI setValue:PartySI forKey:@"Party PTypeCode=\"LA1\""];
        [SIInfo setValue:PartiesSI forKey:@"Parties"];
    [sampleDict setValue:SIInfo forKey:@"SIInfo"];
    
    //SPAJFilename
    NSMutableDictionary *SPAJFilename = [[NSMutableDictionary alloc]init];
        //SPAJ
        NSMutableDictionary *SPAJ = [[NSMutableDictionary alloc]init];
        [SPAJ setValue:@"1" forKey:@"FileCount"];
            //filename
            NSMutableDictionary *Filename = [[NSMutableDictionary alloc]init];
            [Filename setValue:@"60000000001_SPAJ.pdf" forKey:@"Filename"];
            [SPAJ setValue:Filename forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:SPAJ forKey:@"SPAJ"];
        //Supplementary
        NSMutableDictionary *Supplementary = [[NSMutableDictionary alloc]init];
        [Supplementary setValue:@"1" forKey:@"FileCount"];
        //filename
        NSMutableDictionary *FilenameSup = [[NSMutableDictionary alloc]init];
        [FilenameSup setValue:@"" forKey:@"Filename"];
        [Supplementary setValue:FilenameSup forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:Supplementary forKey:@"Supplementary"];
        //IDImages
        NSMutableDictionary *IDImages = [[NSMutableDictionary alloc]init];
        [IDImages setValue:@"1" forKey:@"FileCount"];
        //filename
        NSMutableDictionary *FilenameID = [[NSMutableDictionary alloc]init];
        [FilenameID setValue:@"60000000001_ID2.jpg" forKey:@"Filename"];
        [FilenameID setValue:@"KTP" forKey:@"IDType"];
        [FilenameID setValue:@"LA1" forKey:@"PersonType"];
        [IDImages setValue:FilenameID forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:IDImages forKey:@"IDImages"];
        //HealthQuestionaires
        NSMutableDictionary *HealthQuestionaires = [[NSMutableDictionary alloc]init];
        [HealthQuestionaires setValue:@"1" forKey:@"FileCount"];
        //filename
        NSMutableDictionary *FilenameHealth = [[NSMutableDictionary alloc]init];
        [FilenameHealth setValue:@"60000000001_AngkatanBersenjata.jpg" forKey:@"Filename"];
        [FilenameHealth setValue:@"Angkatan Bersenjata" forKey:@"FormName"];
        [HealthQuestionaires setValue:FilenameHealth forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:HealthQuestionaires forKey:@"SPAJ"];
        //AmendmentForm
        NSMutableDictionary *AmendmentForm = [[NSMutableDictionary alloc]init];
        [AmendmentForm setValue:@"1" forKey:@"FileCount"];
        //filename
        NSMutableDictionary *FilenameAmandment = [[NSMutableDictionary alloc]init];
        [FilenameAmandment setValue:@"60000000001_SPAJ.pdf" forKey:@"Filename"];
        [AmendmentForm setValue:FilenameAmandment forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:AmendmentForm forKey:@"SPAJ"];
        //ForeignerForm
        NSMutableDictionary *ForeignerForm = [[NSMutableDictionary alloc]init];
        [ForeignerForm setValue:@"1" forKey:@"FileCount"];
        //filename
        NSMutableDictionary *FilenameForeign = [[NSMutableDictionary alloc]init];
        [FilenameForeign setValue:@"60000000001_SPAJ.pdf" forKey:@"Filename"];
        [ForeignerForm setValue:FilenameForeign forKey:@"File ID=\"1\""];
        [SPAJFilename setValue:ForeignerForm forKey:@"SPAJ"];
    [sampleDict setValue:SPAJFilename forKey:@"SPAJFilename"];
    
    NSString *textParsed = [self parseXML:sampleDict text:@""];
    [textParsed writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString *) parseXML:(NSMutableDictionary *)dictInfo text:(NSString *)text{
    for(NSString *root in [dictInfo allKeys]){
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<%@>",root]];
        if([[dictInfo valueForKey:root] isKindOfClass:[NSMutableDictionary class]]){
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[self parseXML:[dictInfo valueForKey:root] text:@""]]];
        }else{
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@",[dictInfo valueForKey:root]]];
        }
        NSArray *substrings = [root componentsSeparatedByString:@" "];
        NSString *nodeTitle = [substrings objectAtIndex:0];
        text = [text stringByAppendingString:[NSString stringWithFormat:@"</%@>",nodeTitle]];
    }
    return text;
}

@end