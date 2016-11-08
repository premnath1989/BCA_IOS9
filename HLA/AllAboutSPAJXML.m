//
//  AllAboutSPAJXML.m
//  BLESS
//
//  Created by Basvi on 11/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AllAboutSPAJXML.h"
#import "SPAJSubmissionFiles.h"
#import "Formatter.h"
#import "SPAJSubmissionModel.h"
#import "ModelSIPOData.h"
#import "ModelEproposalRelation.h"
#import "Model_SI_Premium.h"

@implementation AllAboutSPAJXML {
    SPAJSubmissionFiles *spajSubmissionFiles;
    SPAJSubmissionModel *spajSubmissionModel;
    ModelSIPOData *modelSIPOData;
    ModelEproposalRelation *modelEproposalRelation;
    Model_SI_Premium *modelSIPremium;
    
    Formatter *formatter;
}

-(id)init {
    if ( self = [super init] ) {
        spajSubmissionFiles = [[SPAJSubmissionFiles alloc]init];
        spajSubmissionModel = [[SPAJSubmissionModel alloc]init];
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelEproposalRelation = [[ModelEproposalRelation alloc]init];
        modelSIPremium = [[Model_SI_Premium alloc]init];
        
        formatter = [[Formatter alloc]init];
    }
    return self;
}

-(NSMutableDictionary *)BlessInfo{
    NSMutableDictionary *BlessInfo = [[NSMutableDictionary alloc]init];
    [BlessInfo setValue:@"BLESS(I)" forKey:@"SystemName"];
    [BlessInfo setValue:[spajSubmissionModel getBlessVersion] forKey:@"BLESSVersion"];//edit
    return BlessInfo;
}

-(NSMutableDictionary *)SubmissionInfo:(NSDictionary *)dictTransaction{
    NSDictionary* submissionData = [[NSDictionary alloc]initWithDictionary:[spajSubmissionModel getSubsmissionInfo:[dictTransaction valueForKey:@"SPAJEappNumber"]]];
    
    NSMutableDictionary *SubmissionInfo = [[NSMutableDictionary alloc]init];
    [SubmissionInfo setValue:[submissionData valueForKey:@"ProposalNo"] forKey:@"ProposalNo"];
    [SubmissionInfo setValue:[submissionData valueForKey:@"ProposalContNo"] forKey:@"ProposalContNo"];
    [SubmissionInfo setValue:[submissionData valueForKey:@"PolAppntDate"] forKey:@"PolAppntDate"];
    [SubmissionInfo setValue:[submissionData valueForKey:@"FirstTrialDate"] forKey:@"FirstTrialDate"];
    [SubmissionInfo setValue:@"N" forKey:@"DateBackFlag"];//apa?
    [SubmissionInfo setValue:[submissionData valueForKey:@"ReceiveDate"] forKey:@"ReceiveDate"];
    [SubmissionInfo setValue:@"TRAD" forKey:@"SIType"];
    [SubmissionInfo setValue:@"ID" forKey:@"ManageCom"];
    return SubmissionInfo;
}

-(NSMutableDictionary *)ChannelInfo:(NSDictionary *)dictTransaction{
    NSDictionary* channelData = [[NSDictionary alloc]initWithDictionary:[spajSubmissionModel getChannelInfo:[dictTransaction valueForKey:@"SPAJSINO"]]];
    
    NSMutableDictionary *ChannelInfo = [[NSMutableDictionary alloc]init];
    [ChannelInfo setValue:@"03" forKey:@"SALECHNL"];
    [ChannelInfo setValue:[channelData valueForKey:@"ReferralsBank"] forKey:@"ReferralsBank"];
    [ChannelInfo setValue:[channelData valueForKey:@"ReferralsCode"] forKey:@"ReferralsCode"];
    [ChannelInfo setValue:[channelData valueForKey:@"ReferralsName"] forKey:@"ReferralsName"];
    return ChannelInfo;
}

-(NSMutableDictionary *)AgentInfo{
    NSDictionary* agentData = [[NSDictionary alloc]initWithDictionary:[spajSubmissionModel getAgentInfo]];
    
    NSMutableDictionary *AgentInfo = [[NSMutableDictionary alloc]init];
    [AgentInfo setValue:@"1" forKey:@"AgentCount"];
    //Agent
    NSMutableDictionary *Agent = [[NSMutableDictionary alloc]init];
    [Agent setValue:@"1" forKey:@"Seq"];
    [Agent setValue:[agentData valueForKey:@"AgentCode"] forKey:@"AgentCode"];
    [Agent setValue:[agentData valueForKey:@"AgentDist"] forKey:@"AgentDist"];//Kanwil
    [Agent setValue:[agentData valueForKey:@"AgentKCU"] forKey:@"AgentKCU"];//KCU
    [Agent setValue:[agentData valueForKey:@"AgentCom"] forKey:@"AgentCom"];//Branch Code
    [Agent setValue:[agentData valueForKey:@"AgentBank"] forKey:@"AgentBank"];//Branch Name
    [Agent setValue:@"100" forKey:@"AgentPercentage"];
    [AgentInfo setValue:Agent forKey:@"Agent ID=\"1\""];
    return AgentInfo;
}

-(NSMutableDictionary *)PaymentInfo:(NSDictionary *)dictTransaction{
    //NSDictionary* paymentData = [[NSDictionary alloc]initWithDictionary:[spajSubmissionModel getChannelInfo:[dictTransaction valueForKey:@"SPAJSINO"]]];
    
    NSString* paymentMethod = [spajSubmissionModel stringPaymentMethod:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"]intValue] StringElementName:@"RadioButtonPremiPaymentWay"]];
    
    NSString* currency = [spajSubmissionModel stringCurrencyNumber:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"RadioButtonPremiPaymentKurs"]];
    
    NSString* NewBankAcctNo = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPremiPaymentBankAccountDetailsNumber"];
    
    NSString* BankAcctName;
    NSString* CreditCardName;
    
    if ([paymentMethod isEqualToString:@"K"]){
        BankAcctName= @"";
        CreditCardName= [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPremiPaymentBankAccountDetailsName"];
    }
    else if ([paymentMethod isEqualToString:@"O"]){
        BankAcctName= [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPremiPaymentBankAccountDetailsName"];
        CreditCardName= @"";
    }
    else {
        BankAcctName= @"";
        CreditCardName= @"";
    }
    
    NSString* BankCode = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPremiPaymentBankAccountDetailsBankName"];
    
    NSMutableDictionary *PaymentInfo = [[NSMutableDictionary alloc]init];
    [PaymentInfo setValue:@"V" forKey:@"FirstTimePayment"];
    [PaymentInfo setValue:@"" forKey:@"BankAuthorization"];
    [PaymentInfo setValue:@"F" forKey:@"OutPayFlag"];
    [PaymentInfo setValue:paymentMethod forKey:@"PayLocation"];//Cara Pembayaran Premi
    [PaymentInfo setValue:NewBankAcctNo forKey:@"NewBankAcctNo"];//No Rek
    [PaymentInfo setValue:currency forKey:@"NewCurrency"];//13 IDR  14 USD
    [PaymentInfo setValue:BankAcctName forKey:@"BankAcctName"];//Nama Pemilik Rekening (if O)
    [PaymentInfo setValue:CreditCardName forKey:@"CreditCardName"];//Nama Pemilik Kartu Kredit (if K)
    [PaymentInfo setValue:BankCode forKey:@"BankCode"];//Debit Bank Name
    [PaymentInfo setValue:@"" forKey:@"CreditCardExpiry"];//Credit Card expiry date
    
    [PaymentInfo setValue:@"1234134122" forKey:@"ReNewBankAcctNo"];//Renewal Debit/Credit Account No.
    [PaymentInfo setValue:@"13" forKey:@"ReNewCurrency"];//Renewal Account Currency
    [PaymentInfo setValue:@"Wawwee" forKey:@"ReNewBankAcctName"];//Renewal Bank Account holder name
    [PaymentInfo setValue:@"BANK CENTRAL ASIA" forKey:@"ReNewBankCode"];//Renewal Bank name
    [PaymentInfo setValue:@"" forKey:@"ReNewBankBranch"];//Renewal Bank branch Name
    [PaymentInfo setValue:@"" forKey:@"ReNewCreditCardExpiry"];//Renewal Credit Card expiry date
    
    [PaymentInfo setValue:@"9999999999" forKey:@"ReturnBankAcctNo"];//Premium Return Debit/Credit Account No.
    [PaymentInfo setValue:@"Ariani Pondaag" forKey:@"ReturnBankAcctName"];//Premium Return Bank Account holder name
    [PaymentInfo setValue:@"BANK CENTRAL ASIA" forKey:@"ReturnBankCode"];//Premium Return Bank name
    [PaymentInfo setValue:@"CHASE PLAZA" forKey:@"ReturnBankBranch"];//Premium Return Bank branch Name
    
    
    return PaymentInfo;
}

-(NSMutableDictionary *)SPAJFilename:(NSDictionary *)dictTransaction{
    NSMutableDictionary *SPAJFilename = [[NSMutableDictionary alloc]init];
    
    NSArray* arrayFileSPAJ = [spajSubmissionModel getFileNamesFor:@"SPAJ" DictTransaction:dictTransaction];
    NSArray* arrayFileSupplementary = [spajSubmissionModel getFileNamesFor:@"Supplementary" DictTransaction:dictTransaction];
    NSArray* arrayFileIDImages = [spajSubmissionModel getFileNamesFor:@"IDImages" DictTransaction:dictTransaction];
    NSArray* arrayFileHealthQuestionaire = [spajSubmissionModel getFileNamesFor:@"HealthQuestionaires" DictTransaction:dictTransaction];
    NSArray* arrayFileAmandement = [spajSubmissionModel getFileNamesFor:@"AmendmentForm" DictTransaction:dictTransaction];
    NSArray* arrayFileForeigner = [spajSubmissionModel getFileNamesFor:@"ForeignerForm" DictTransaction:dictTransaction];
    
    //SPAJ
    NSMutableDictionary *SPAJ = [[NSMutableDictionary alloc]init];
    
    //filename
    if ([arrayFileSPAJ count]>0){
        [SPAJ setValue:[NSString stringWithFormat:@"%i",[arrayFileSPAJ count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileSPAJ count];i++){
            NSMutableDictionary *Filename = [[NSMutableDictionary alloc]init];
            [Filename setValue:[arrayFileSPAJ objectAtIndex:i] forKey:@"Filename"];
            [SPAJ setValue:Filename forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [SPAJ setValue:[NSString stringWithFormat:@"%i",[arrayFileSPAJ count]+1] forKey:@"FileCount"];
        NSMutableDictionary *Filename = [[NSMutableDictionary alloc]init];
        [Filename setValue:@"" forKey:@"Filename"];
        [SPAJ setValue:Filename forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:SPAJ forKey:@"SPAJ"];
    
    //Supplementary
    NSMutableDictionary *Supplementary = [[NSMutableDictionary alloc]init];
    
    //filename
    if ([arrayFileSupplementary count]>0){
        [Supplementary setValue:[NSString stringWithFormat:@"%i",[arrayFileSupplementary count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileSupplementary count];i++){
            NSMutableDictionary *Filename = [[NSMutableDictionary alloc]init];
            [Filename setValue:[arrayFileSupplementary objectAtIndex:i] forKey:@"Filename"];
            [Supplementary setValue:Filename forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [Supplementary setValue:[NSString stringWithFormat:@"%i",[arrayFileSupplementary count]+1] forKey:@"FileCount"];
        NSMutableDictionary *Filename = [[NSMutableDictionary alloc]init];
        [Filename setValue:@"" forKey:@"Filename"];
        [Supplementary setValue:Filename forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:Supplementary forKey:@"Supplementary"];
    
    //IDImages
    NSMutableDictionary *IDImages = [[NSMutableDictionary alloc]init];
    
    //filename
    if ([arrayFileIDImages count]>0){
        [IDImages setValue:[NSString stringWithFormat:@"%i",[arrayFileIDImages count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileIDImages count];i++){
            NSMutableDictionary *FilenameID = [[NSMutableDictionary alloc]init];
            [FilenameID setValue:[arrayFileIDImages objectAtIndex:i] forKey:@"Filename"];
            [FilenameID setValue:[spajSubmissionModel getIDType:[arrayFileIDImages objectAtIndex:i] AtIndex:3] forKey:@"IDType"];
            [FilenameID setValue:[spajSubmissionModel getPersonType:[arrayFileIDImages objectAtIndex:i] AtIndex:2] forKey:@"PersonType"];
            [IDImages setValue:FilenameID forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [IDImages setValue:[NSString stringWithFormat:@"%i",[arrayFileIDImages count]+1] forKey:@"FileCount"];
        NSMutableDictionary *FilenameID = [[NSMutableDictionary alloc]init];
        [FilenameID setValue:@"" forKey:@"Filename"];
        [FilenameID setValue:@"" forKey:@"IDType"];
        [FilenameID setValue:@"" forKey:@"PersonType"];
        [IDImages setValue:FilenameID forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:IDImages forKey:@"IDImages"];
    
    //HealthQuestionaires
    NSMutableDictionary *HealthQuestionaires = [[NSMutableDictionary alloc]init];
    
    
    //filename
    if ([arrayFileHealthQuestionaire count]>0){
        [HealthQuestionaires setValue:[NSString stringWithFormat:@"%i",[arrayFileHealthQuestionaire count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileHealthQuestionaire count];i++){
            NSMutableDictionary *FilenameHealth = [[NSMutableDictionary alloc]init];
            [FilenameHealth setValue:[arrayFileHealthQuestionaire objectAtIndex:i] forKey:@"Filename"];
            [FilenameHealth setValue:[spajSubmissionModel getFormNameFromFileName:[arrayFileHealthQuestionaire objectAtIndex:i]] forKey:@"FormName"];
            [HealthQuestionaires setValue:FilenameHealth forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [HealthQuestionaires setValue:[NSString stringWithFormat:@"%i",[arrayFileHealthQuestionaire count]+1] forKey:@"FileCount"];
        NSMutableDictionary *FilenameHealth = [[NSMutableDictionary alloc]init];
        [FilenameHealth setValue:@"" forKey:@"Filename"];
        [FilenameHealth setValue:@"" forKey:@"FormName"];
        [HealthQuestionaires setValue:FilenameHealth forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:HealthQuestionaires forKey:@"HealthQuestionaires"];
    
    //AmendmentForm
    NSMutableDictionary *AmendmentForm = [[NSMutableDictionary alloc]init];
    
    //filename
    if ([arrayFileAmandement count]>0){
        [AmendmentForm setValue:[NSString stringWithFormat:@"%i",[arrayFileAmandement count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileAmandement count];i++){
            NSMutableDictionary *FilenameAmandment = [[NSMutableDictionary alloc]init];
            [FilenameAmandment setValue:[arrayFileAmandement objectAtIndex:i] forKey:@"Filename"];
            [AmendmentForm setValue:FilenameAmandment forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [AmendmentForm setValue:[NSString stringWithFormat:@"%i",[arrayFileAmandement count]+1] forKey:@"FileCount"];
        NSMutableDictionary *FilenameAmandment = [[NSMutableDictionary alloc]init];
        [FilenameAmandment setValue:@"" forKey:@"Filename"];
        [AmendmentForm setValue:FilenameAmandment forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:AmendmentForm forKey:@"AmendmentForm"];
    
    //ForeignerForm
    NSMutableDictionary *ForeignerForm = [[NSMutableDictionary alloc]init];
    
    
    //filename
    if ([arrayFileForeigner count]>0){
        [ForeignerForm setValue:[NSString stringWithFormat:@"%i",[arrayFileForeigner count]] forKey:@"FileCount"];
        for (int i=0;i<[arrayFileForeigner count];i++){
            NSMutableDictionary *FilenameForeign = [[NSMutableDictionary alloc]init];
            [FilenameForeign setValue:[arrayFileForeigner objectAtIndex:i] forKey:@"Filename"];
            [ForeignerForm setValue:FilenameForeign forKey:[NSString stringWithFormat:@"File ID=\"%i\"",i+1]];
        }
    }
    else{
        [ForeignerForm setValue:[NSString stringWithFormat:@"%i",[arrayFileForeigner count]+1] forKey:@"FileCount"];
        NSMutableDictionary *FilenameForeign = [[NSMutableDictionary alloc]init];
        [FilenameForeign setValue:@"" forKey:@"Filename"];
        [ForeignerForm setValue:FilenameForeign forKey:@"File ID=\"1\""];
    }
    [SPAJFilename setValue:ForeignerForm forKey:@"ForeignerForm"];
    
    return SPAJFilename;
}


-(NSMutableDictionary *)AssuredInfo:(NSDictionary *)dictTransaction{
    NSMutableDictionary *AssuredInfo = [[NSMutableDictionary alloc]init];
    [AssuredInfo setValue:[dictTransaction valueForKey:@"SPAJNumber"] forKey:@"ProposalContNo"];
    
    [AssuredInfo setValue:[self Party:dictTransaction] forKey:@"Party ID=\"1\""];
    return AssuredInfo;
}

-(NSMutableDictionary *)Party:(NSDictionary *)dictTransaction{
    NSMutableDictionary *Party = [[NSMutableDictionary alloc]init];
    NSString *SINO = [dictTransaction valueForKey:@"SPAJSINO"];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
    NSString* relation = [dictPOData valueForKey:@"RelWithLA"];
    
    NSString* PTypeCode = @"PO";
    NSString* InsuredType = @"M";
    NSString* LATitle = @"";
    NSString* LAName = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderFullName"];
    NSString* LASex = [spajSubmissionModel GetSexCode:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"RadioButtonPolicyHolderSex"]];
    NSString* LADOB = [formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"DatePolicyHolderBirth"]];
    NSString* IDType = [spajSubmissionModel GetIDTypeCode:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"RadioButtonPolicyHolderIDType"]];
    NSString* IDNo =[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderIDNumber"];
    NSString* IDExpiryDate = [formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"DatePolicyHolderActive"]];
    NSString* LAMaritalStatus = [spajSubmissionModel GetMaritalStatusCode:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"RadioButtonPolicyHolderMaritalStatus"]];
    NSString* LARelationship = [modelEproposalRelation GetRelationCode:relation];
    NSString* LAHeighUnit = @"cm";
    NSString* LAHeight = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHeight"];
    NSString* LAWeightUnit = @"kg";
    NSString* LAWeight = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderWeight"];
    NSString* LAIDSubmitted = @"Y";
    NSString* LANationality ;
    NSString* LABirthPlace = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderBirthPlace"];
    NSString* LAReligion;
    
    [Party setValue:PTypeCode forKey:@"PTypeCode"];
    [Party setValue:@"1" forKey:@"Seq"];
    [Party setValue:InsuredType forKey:@"InsuredType"];
    [Party setValue:LATitle forKey:@"LATitle"];
    [Party setValue:LAName forKey:@"LAName"];
    [Party setValue:LASex forKey:@"LASex"];
    [Party setValue:LADOB forKey:@"LADOB"];
    [Party setValue:IDType forKey:@"IDType"];
    [Party setValue:IDNo forKey:@"IDNo"];
    [Party setValue:IDExpiryDate forKey:@"IDExpiryDate"];
    [Party setValue:LAMaritalStatus forKey:@"LAMaritalStatus"];
    [Party setValue:LARelationship forKey:@"LARelationship"];
    [Party setValue:LAHeighUnit forKey:@"LAHeighUnit"];
    [Party setValue:LAHeight forKey:@"LAHeight"];
    [Party setValue:LAWeightUnit forKey:@"LAWeightUnit"];
    [Party setValue:LAWeight forKey:@"LAWeight"];
    [Party setValue:LAIDSubmitted forKey:@"LAIDSubmitted"];
    [Party setValue:LANationality forKey:@"LANationality"];
    [Party setValue:LABirthPlace forKey:@"LABirthPlace"];
    [Party setValue:LAReligion forKey:@"LAReligion"];
    
    [Party setValue:@"" forKey:@"BenefitInsu"];
    [Party setValue:@"" forKey:@"LACompanyName"];
    [Party setValue:@"" forKey:@"LAAnnualIncome"];
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
    
    [Party setValue:[self Addresses:dictTransaction] forKey:@"Address"];
    [Party setValue:[self OccupationInfo:dictTransaction] forKey:@"OccupationInfo"];
    [Party setValue:[self QuestionaireInfo:dictTransaction Party:@"O" Section:@"KS_PH"] forKey:@"QuestionaireInfo"];
    return Party;
}

-(NSMutableDictionary *)Addresses:(NSDictionary *)dictTransaction{
    NSMutableDictionary *Address = [[NSMutableDictionary alloc]init];
    
    //Address Residence
    [Address setValue:[self AddressResidence:dictTransaction] forKey:@"Address Type=\"Residence\""];
    
    //Address Office
    [Address setValue:[self AddressOffice:dictTransaction] forKey:@"Address Type=\"Office\""];
    
    return Address;
}

-(NSMutableDictionary *)AddressResidence:(NSDictionary *)dictTransaction{
    NSMutableDictionary *AddressResidence = [[NSMutableDictionary alloc]init];
    
    NSString *Address1 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeAddress1"];
    NSString *Address2 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeAddress2"];
    NSString *Address3 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeAddress3"];
    
    NSString *PostCode = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomePostalCode"];
    NSString *District = @"";
    NSString *Area = @"";
    NSString *City = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeCity"];
    NSString *State = @"";
    NSString *Country = @"";
    NSString *HomePhoneAreaCode = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeTelephone"] StringSeparator:@"-" AtIndex:0];
    NSString *HomePhone = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHomeTelephone"] StringSeparator:@"-" AtIndex:1];
    NSString *MobileCode = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHandphone1"] StringSeparator:@"-" AtIndex:0];
    NSString *Mobile = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHandphone1"] StringSeparator:@"-" AtIndex:1];
    NSString *MobileCCode= [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHandphone2"] StringSeparator:@"-" AtIndex:0];
    NSString *Mobile2= [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderHandphone2"] StringSeparator:@"-" AtIndex:1];
    NSString *SMSNoticeNo = @"";
    NSString *Email = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderEmail"];
    NSString *CorrespondenceAddress = [spajSubmissionModel GetCorrespondenceAddressCode:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"RadioButtonPolicyHolderCorrespondanceAddress"]];
    NSString *CorrespondenceMedia = @"";
    
    [AddressResidence setValue:Address1 forKey:@"Address1"];
    [AddressResidence setValue:Address2 forKey:@"Address2"];
    [AddressResidence setValue:Address3 forKey:@"Address3"];
    [AddressResidence setValue:PostCode forKey:@"PostCode"];
    [AddressResidence setValue:District forKey:@"District"];
    [AddressResidence setValue:Area forKey:@"Area"];
    [AddressResidence setValue:City forKey:@"City"];
    [AddressResidence setValue:State forKey:@"State"];
    [AddressResidence setValue:Country forKey:@"Country"];
    [AddressResidence setValue:HomePhoneAreaCode forKey:@"HomePhoneAreaCode"];
    [AddressResidence setValue:HomePhone forKey:@"HomePhone"];
    [AddressResidence setValue:MobileCode forKey:@"MobileCode"];
    [AddressResidence setValue:Mobile forKey:@"Mobile"];
    [AddressResidence setValue:MobileCCode forKey:@"MobileCCode"];
    [AddressResidence setValue:Mobile2 forKey:@"Mobile2"];
    [AddressResidence setValue:SMSNoticeNo forKey:@"SMSNoticeNo"];
    [AddressResidence setValue:Email forKey:@"Email"];
    [AddressResidence setValue:CorrespondenceAddress forKey:@"CorrespondenceAddress"];
    [AddressResidence setValue:CorrespondenceMedia forKey:@"CorrespondenceMedia"];
    return AddressResidence;
}

-(NSMutableDictionary *)AddressOffice:(NSDictionary *)dictTransaction{
    NSMutableDictionary *AddressOffice = [[NSMutableDictionary alloc]init];
    
    NSString *Address1 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeAddress1"];
    NSString *Address2 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeAddress2"];
    NSString *Address3 = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeAddress3"];
    
    NSString *PostCode = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficePostalCode"];
    NSString *District = @"";
    NSString *Area = @"";
    NSString *City = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeCity"];
    NSString *State = @"";
    NSString *Country = @"";
    NSString *CompanyPhoneAreaCode = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeTelephone"] StringSeparator:@"-" AtIndex:0];
    NSString *CompanyPhone = [spajSubmissionModel getStringFromString:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderOfficeTelephone"] StringSeparator:@"-" AtIndex:1];
    
    [AddressOffice setValue:Address1 forKey:@"Address1"];
    [AddressOffice setValue:Address2 forKey:@"Address2"];
    [AddressOffice setValue:Address3 forKey:@"Address3"];
    [AddressOffice setValue:PostCode forKey:@"PostCode"];
    [AddressOffice setValue:District forKey:@"District"];
    [AddressOffice setValue:Area forKey:@"Area"];
    [AddressOffice setValue:City forKey:@"City"];
    [AddressOffice setValue:State forKey:@"State"];
    [AddressOffice setValue:Country forKey:@"Country"];
    [AddressOffice setValue:CompanyPhoneAreaCode forKey:@"CompanyPhoneAreaCode"];
    [AddressOffice setValue:CompanyPhone forKey:@"CompanyPhone"];
    return AddressOffice;
}

-(NSMutableDictionary *)OccupationInfo:(NSDictionary *)dictTransaction{
    NSMutableDictionary *OccupationInfo = [[NSMutableDictionary alloc]init];
    NSString *SINO = [dictTransaction valueForKey:@"SPAJSINO"];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
    NSString* PO_OccpCode = [dictPOData valueForKey:@"PO_OccpCode"];
    
    NSString *CompanyName = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderCompany"];
    NSString *OccupationCode=PO_OccpCode;//dari nasabah
    NSString *PartTime = [spajSubmissionModel getPartTimeConfirmation:[spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderSideJob"]];//Y/N
    NSString *OccupationType = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderMainJob"];
    NSString *Industry = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderWorkScope"];
    NSString *Position = [spajSubmissionModel querySPAJDetailValue:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] StringElementName:@"TextPolicyHolderPosition"];
    
    [OccupationInfo setValue:CompanyName forKey:@"CompanyName"];
    [OccupationInfo setValue:OccupationCode forKey:@"OccupationCode"];
    [OccupationInfo setValue:PartTime forKey:@"PartTime"];
    [OccupationInfo setValue:OccupationType forKey:@"OccupationType"];
    [OccupationInfo setValue:Industry forKey:@"Industry"];
    [OccupationInfo setValue:Position forKey:@"Position"];
    return OccupationInfo;
}

-(NSMutableDictionary *)QuestionaireInfo:(NSDictionary *)dictTransaction Party:(NSString *)QnParty Section:(NSString *)stringSection{
    NSMutableDictionary *QuestionaireInfo = [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayElementAnswer = [[NSMutableArray alloc]initWithArray:[spajSubmissionModel getSPAJAnswerElementValueForSubmission:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] Section:stringSection]];
    
    if ([arrayElementAnswer count]>0){
        for (int i=0;i<[arrayElementAnswer count];i++){
            //Questions
            NSMutableDictionary *Questions = [[NSMutableDictionary alloc]init];
            [Questions setValue:[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] forKey:@"QnID"];
            [Questions setValue:QnParty forKey:@"QnParty"];
            [Questions setValue:[spajSubmissionModel getAnswerType:[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"]] forKey:@"AnswerType"];
            [Questions setValue:[spajSubmissionModel getAnswerValue:[[arrayElementAnswer objectAtIndex:i] valueForKey:@"Value"]] forKey:@"Answer"];
            [Questions setValue:@"" forKey:@"Reason"];
            [QuestionaireInfo setValue:Questions forKey:[NSString stringWithFormat:@"Questions ID=\"%i\"",i+1]];
        }
    }
    else{
        NSMutableDictionary *Questions = [[NSMutableDictionary alloc]init];
        [Questions setValue:@"" forKey:@"QnID"];
        [Questions setValue:@"" forKey:@"QnParty"];
        [Questions setValue:@"" forKey:@"AnswerType"];
        [Questions setValue:@"" forKey:@"Answer"];
        [Questions setValue:@"" forKey:@"Reason"];
        [QuestionaireInfo setValue:Questions forKey:[NSString stringWithFormat:@"Questions ID=\"1\""]];
    }
    return QuestionaireInfo;
    
}

-(NSMutableDictionary *)NomineeInfo:(NSDictionary *)dictTransaction Section:(NSString *)stringSection{
    NSMutableDictionary *NomineeInfo = [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayElementAnswer = [[NSMutableArray alloc]initWithArray:[spajSubmissionModel getSPAJAnswerElementValueForSubmission:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] Section:stringSection]];
    
    
    
    NSMutableArray* arrayNominee1 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee2 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee3 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee4 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee5 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee6 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee7 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee8 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee9 = [[NSMutableArray alloc]init];
    NSMutableArray* arrayNominee10 = [[NSMutableArray alloc]init];
    
    for (int i=0;i<[arrayElementAnswer count];i++){
        if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"10"].location == NSNotFound)){
            [arrayNominee10 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"9"].location == NSNotFound)){
            [arrayNominee9 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"8"].location == NSNotFound)){
            [arrayNominee8 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"7"].location == NSNotFound)){
            [arrayNominee7 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"6"].location == NSNotFound)){
            [arrayNominee6 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"5"].location == NSNotFound)){
            [arrayNominee5 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"4"].location == NSNotFound)){
            [arrayNominee4 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"3"].location == NSNotFound)){
            [arrayNominee3 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"2"].location == NSNotFound)){
            [arrayNominee2 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
        else if (!([[[arrayElementAnswer objectAtIndex:i] valueForKey:@"elementID"] rangeOfString:@"1"].location == NSNotFound)){
            [arrayNominee1 addObject:[arrayElementAnswer objectAtIndex:i]];
        }
    }
    
    NSMutableArray* arrayAllNominee = [[NSMutableArray alloc]init];
    if ([arrayNominee1 count]>0){
        [arrayAllNominee addObject:arrayNominee1];
    }
    
    if ([arrayNominee2 count]>0){
        [arrayAllNominee addObject:arrayNominee2];
    }
    
    if ([arrayNominee3 count]>0){
        [arrayAllNominee addObject:arrayNominee3];
    }
    
    if ([arrayNominee4 count]>0){
        [arrayAllNominee addObject:arrayNominee4];
    }
    
    if ([arrayNominee5 count]>0){
        [arrayAllNominee addObject:arrayNominee5];
    }
    
    if ([arrayNominee6 count]>0){
        [arrayAllNominee addObject:arrayNominee6];
    }
    
    if ([arrayNominee7 count]>0){
        [arrayAllNominee addObject:arrayNominee7];
    }
    
    if ([arrayNominee8 count]>0){
        [arrayAllNominee addObject:arrayNominee8];
    }
    
    if ([arrayNominee9 count]>0){
        [arrayAllNominee addObject:arrayNominee9];
    }
    
    if ([arrayNominee10 count]>0){
        [arrayAllNominee addObject:arrayNominee10];
    }
    
    [NomineeInfo setValue:[NSString stringWithFormat:@"%i",[arrayAllNominee count]] forKey:@"NomineeCount"];
    if ([arrayAllNominee count]>0){
        for (int x=0;x<[arrayAllNominee count];x++){
            
            NSString* NMName = [spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"TextBeneficiariesListFullName"];
            NSString* NMShare = [spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"TextBeneficiariesListSharePercentage"];
            NSString* NMDOB = [formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:[spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"DateBeneficiariesListBirthday"]];
            NSString* NMSex = [spajSubmissionModel GetSexCode:[spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"RadioButtonBeneficiariesListSex"]];
            NSString* NMRelationship = [modelEproposalRelation GetRelationCode:[spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"SelectBeneficiariesListRelationship"]];
            NSString* NMNationality = [spajSubmissionModel stringFromArray:[arrayAllNominee objectAtIndex:x] StringFilter:@"SelectBeneficiariesListNationality"];
            
            //Nominee
            NSMutableDictionary *Nominee = [[NSMutableDictionary alloc]init];
            [Nominee setValue:[NSString stringWithFormat:@"%i",x+1] forKey:@"Seq"];
            [Nominee setValue:@"L" forKey:@"NMType"];
            [Nominee setValue:NMName forKey:@"NMName"];
            [Nominee setValue:NMShare forKey:@"NMShare"];
            [Nominee setValue:NMDOB forKey:@"NMDOB"];
            [Nominee setValue:NMSex forKey:@"NMSex"];
            [Nominee setValue:NMRelationship forKey:@"NMRelationship"];
            [Nominee setValue:@"A11" forKey:@"NMNationality"];
            
            [Nominee setValue:@"N" forKey:@"FCFlag"];
            [Nominee setValue:@"2" forKey:@"FATCAType"];
            [Nominee setValue:@"P" forKey:@"NMPriority"];
            [NomineeInfo setValue:Nominee forKey:[NSString stringWithFormat:@"Nominee ID=\"%i\"",[arrayAllNominee count]+1]];
        }
    }
    
    
    return NomineeInfo;
}

-(NSMutableDictionary *)SIInfo:(NSDictionary *)dictTransaction{
    NSMutableDictionary *SIInfo = [[NSMutableDictionary alloc]init];
    [SIInfo setValue:[dictTransaction valueForKey:@"SPAJSINO"] forKey:@"SINO"];
    [SIInfo setValue:@"1.0" forKey:@"SIVersion"];
    [SIInfo setValue:@"TRAD" forKey:@"SIType"];
    
    return SIInfo;
}

-(NSMutableDictionary *)BasicPlan:(NSDictionary *)dictTransaction{
    NSMutableDictionary *BasicPlan = [[NSMutableDictionary alloc]init];
    NSDictionary* basicPlanData = [[NSDictionary alloc]initWithDictionary:[modelSIPremium getPremium_For:[dictTransaction valueForKey:@"SPAJSINO"]]];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPOData getPO_DataFor:[dictTransaction valueForKey:@"SPAJSINO"]]];
    
    NSString *PTypeCode;
    NSString *PlanType = [dictPOData valueForKey:@"ProductName"];
    NSString *PlanCode = [dictPOData valueForKey:@"ProductCode"];
    NSString *SumAssured = [basicPlanData valueForKey:@"Sum_Assured"];
    NSString *CoverageUnit = [basicPlanData valueForKey:@""];
    NSString *CoverageTerm = [basicPlanData valueForKey:@""];
    NSString *PayingTerm = [basicPlanData valueForKey:@"Payment_Term"];
    NSString *PaymentModel = [basicPlanData valueForKey:@"Payment_Frequency"];
    NSString *PaymentAmount = [basicPlanData valueForKey:@"TotalPremiumLoading"];
    NSString *PayEndYearFlag = [basicPlanData valueForKey:@""];
    NSString *Currency = [basicPlanData valueForKey:@"13"];
    NSString *ExtraPremiumPercentage = [basicPlanData valueForKey:@"ExtraPremiumPercentage"];
    NSString *ExtraPremiumPerMil = [basicPlanData valueForKey:@"ExtraPremiumSum"];
    NSString *ExtraPremiumPeriod = [basicPlanData valueForKey:@"ExtraPremiumTerm"];
    
    [BasicPlan setValue:PTypeCode forKey:@"PTypeCode"];
    [BasicPlan setValue:PlanType forKey:@"PlanType"];
    [BasicPlan setValue:PlanCode forKey:@"PlanCode"];
    [BasicPlan setValue:SumAssured forKey:@"SumAssured"];
    [BasicPlan setValue:CoverageUnit forKey:@"CoverageUnit"];
    [BasicPlan setValue:CoverageTerm forKey:@"CoverageTerm"];
    [BasicPlan setValue:PayingTerm forKey:@"PayingTerm"];
    [BasicPlan setValue:PaymentModel forKey:@"PaymentModel"];
    [BasicPlan setValue:PaymentAmount forKey:@"PaymentAmount"];
    [BasicPlan setValue:PayEndYearFlag forKey:@"PayEndYearFlag"];
    [BasicPlan setValue:Currency forKey:@"Currency"];
    [BasicPlan setValue:ExtraPremiumPercentage forKey:@"ExtraPremiumPercentage"];
    [BasicPlan setValue:ExtraPremiumPerMil forKey:@"ExtraPremiumPerMil"];
    [BasicPlan setValue:ExtraPremiumPeriod forKey:@"ExtraPremiumPeriod"];
    
    return BasicPlan;
}

-(NSMutableDictionary *)Duties{
    NSMutableDictionary *Duties = [[NSMutableDictionary alloc]init];
    //Duty
    NSMutableDictionary *Duty = [[NSMutableDictionary alloc]init];
    [Duty setValue:@"" forKey:@"DutyCode"];
    [Duty setValue:@"" forKey:@"SumInsured"];
    [Duty setValue:@"" forKey:@"Premium"];
    [Duties setValue:Duty forKey:@"Duty"];
    return Duties;
}

-(NSMutableDictionary *)PartiesSI:(NSDictionary *)dictTransaction{
    //Parties
    NSMutableDictionary *PartiesSI = [[NSMutableDictionary alloc]init];
    [PartiesSI setValue:@"1" forKey:@"PartyCount"];
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
    
    return PartiesSI;
}

-(void)generateXMLDictionary:(NSDictionary *)dictTransaction{
    
    
    NSMutableDictionary *sampleDict = [[NSMutableDictionary alloc]init];
    
    //Bless Info
    [sampleDict setValue:[self BlessInfo] forKey:@"BLESSInfo"];
    
    //Submission Info
    [sampleDict setValue:[self SubmissionInfo:dictTransaction] forKey:@"SubmissionInfo"];
    
    //ChannelInfo
    [sampleDict setValue:[self ChannelInfo:dictTransaction] forKey:@"ChannelInfo"];
    
    //AgentInfo
    [sampleDict setValue:[self AgentInfo] forKey:@"AgentInfo"];
    
    
    //AssuredInfo
    /*NSMutableDictionary *AssuredInfo = [[NSMutableDictionary alloc]init];
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
    [sampleDict setValue:AssuredInfo forKey:@"AssuredInfo"];*/
    [sampleDict setValue:[self AssuredInfo:dictTransaction] forKey:@"AssuredInfo"];
    
    //NomineeInfo
    /*NSMutableDictionary *NomineeInfo = [[NSMutableDictionary alloc]init];
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
    [NomineeInfo setValue:Nominee forKey:@"Nominee ID=\"1\""];*/
    //[sampleDict setValue:NomineeInfo forKey:@"NomineeInfo"];
    [sampleDict setValue:[self NomineeInfo:dictTransaction Section:@"PM"] forKey:@"NomineeInfo"];
    
    //PaymentInfo
    [sampleDict setValue:[self PaymentInfo:dictTransaction] forKey:@"PaymentInfo"];
    
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
    /*NSMutableDictionary *BasicPlan = [[NSMutableDictionary alloc]init];
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
    [SIInfo setValue:BasicPlan forKey:@"BasicPlan"];*/
    //Duties
    /*NSMutableDictionary *Duties = [[NSMutableDictionary alloc]init];
    //Duty
    NSMutableDictionary *Duty = [[NSMutableDictionary alloc]init];
    [Duty setValue:@"" forKey:@"DutyCode"];
    [Duty setValue:@"" forKey:@"SumInsured"];
    [Duty setValue:@"" forKey:@"Premium"];
    [Duties setValue:Duty forKey:@"Duty"];
    [SIInfo setValue:Duties forKey:@"Duties"];*/
    
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
    [sampleDict setValue:[self SPAJFilename:dictTransaction] forKey:@"SPAJFilename"];
    
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@_SPAJ.xml",[formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    [spajSubmissionFiles xmltoFile:sampleDict path:fullPath];
}

@end
