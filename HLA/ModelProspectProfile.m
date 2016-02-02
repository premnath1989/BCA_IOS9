//
//  ModelProspectProfile.m
//  iMobile Planner
//
//  Created by Faiz Umar Baraja on 29/01/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ModelProspectProfile.h"
#import "ProspectProfile.h"

@implementation ModelProspectProfile
-(NSMutableArray *)getProspectProfile{
    NSString *ProspectID = @"";
    NSString *NickName = @"";
    NSString *ProspectName = @"";
    NSString *ProspectDOB = @"" ;
    NSString *ProspectGender = @"";
    NSString *ResidenceAddress1 = @"";
    NSString *ResidenceAddress2 = @"";
    NSString *ResidenceAddress3 = @"";
    NSString *ResidenceAddressTown = @"";
    NSString *ResidenceAddressState = @"";
    NSString *ResidenceAddressPostCode = @"";
    NSString *ResidenceAddressCountry = @"";
    NSString *OfficeAddress1 = @"";
    NSString *OfficeAddress2 = @"";
    NSString *OfficeAddress3 = @"";
    NSString *OfficeAddressTown = @"";
    NSString *OfficeAddressState = @"";
    NSString *OfficeAddressPostCode = @"";
    NSString *OfficeAddressCountry = @"";
    NSString *ProspectEmail = @"";
    NSString *ProspectOccupationCode = @"";
    NSString *ExactDuties = @"";
    NSString *ProspectRemark = @"";
    //basvi added
    NSString *DateCreated = @"";
    NSString *CreatedBy = @"";
    NSString *DateModified = @"";
    NSString *ModifiedBy = @"";
    //
    NSString *ProspectGroup = @"";
    NSString *ProspectTitle = @"";
    NSString *IDTypeNo = @"";
    NSString *OtherIDType = @"";
    NSString *OtherIDTypeNo = @"";
    NSString *Smoker = @"";
    
    NSString *Race = @"";
    
    NSString *Nationality = @"";
    NSString *MaritalStatus = @"";
    NSString *Religion = @"";
    
    NSString *AnnIncome = @"";
    NSString *BussinessType = @"";
    
    NSString *registration = @"";
    NSString *registrationNo = @"";
    NSString *registrationDate = @"";
    NSString *exempted = @"";
    NSString *isGrouping = @"";
    NSString *COB = @"";
    
    NSString* NIP;
    NSString* BranchCode;
    NSString* BranchName;
    NSString* KCU;
    NSString* ReferralSource;
    NSString* ReferralName;
    NSString* IdentitySubmitted;
    NSString* IDExpirityDate;
    NSString* NPWPNo;
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docsPath = [paths objectAtIndex:0];
    //NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    NSMutableArray* ProspectTableData=[[NSMutableArray alloc]init];
    //results = [database executeQuery:@"SELECT * FROM prospect_profile WHERE QQFlag = 'false'  order by LOWER(ProspectName) ASC LIMIT 20)", Nil];
    FMResultSet *s = [database executeQuery:@"SELECT * FROM prospect_profile WHERE QQFlag = 'false'  order by LOWER(ProspectName) ASC LIMIT 20"];
    while ([s next]) {
        //occpToEnableSection = [results stringForColumn:@"OccpCode"];
        int ID = [s intForColumn:@"IndexNo"];
        ProspectID = [NSString stringWithFormat:@"%i",ID];
        NickName = [s stringForColumn:@"PreferredName"];
        ProspectName = [s stringForColumn:@"ProspectName"];
        ProspectDOB = [results stringForColumn:@"ProspectDOB"]; ;
        ProspectGender = [s stringForColumn:@"ProspectGender"];;
        ResidenceAddress1 = [s stringForColumn:@"ResidenceAddress1"];;
        ResidenceAddress2 = [s stringForColumn:@"ResidenceAddress2"];;
        ResidenceAddress3 = [s stringForColumn:@"ResidenceAddress3"];;
        ResidenceAddressTown = [s stringForColumn:@"ResidenceAddressTown"];;
        ResidenceAddressState = [s stringForColumn:@"ResidenceAddressState"];;
        ResidenceAddressPostCode = [s stringForColumn:@"ResidenceAddressPostCode"];;
        ResidenceAddressCountry = [s stringForColumn:@"ResidenceAddressCountry"];;
        OfficeAddress1 = [s stringForColumn:@"OfficeAddress1"];;
        OfficeAddress2 = [s stringForColumn:@"OfficeAddress2"];;
        OfficeAddress3 = [s stringForColumn:@"OfficeAddress3"];;
        OfficeAddressTown = [s stringForColumn:@"OfficeAddressTown"];;
        OfficeAddressState = [s stringForColumn:@"OfficeAddressState"];;
        OfficeAddressPostCode = [s stringForColumn:@"OfficeAddressPostCode"];;
        OfficeAddressCountry = [s stringForColumn:@"OfficeAddressCountry"];;
        ProspectEmail = [s stringForColumn:@"ProspectEmail"];;
        ProspectOccupationCode = [s stringForColumn:@"ProspectOccupationCode"];;
        ExactDuties = [s stringForColumn:@"ExactDuties"];;
        ProspectRemark = [s stringForColumn:@"ProspectRemark"];;
        //basvi added
        DateCreated = [s stringForColumn:@"DateCreated"];;
        CreatedBy = [s stringForColumn:@"CreatedBy"];;
        DateModified = [s stringForColumn:@"DateModified"];;
        ModifiedBy = [s stringForColumn:@"ModifiedBy"];;
        //
        ProspectGroup = [s stringForColumn:@"ProspectGroup"];;
        ProspectTitle = [s stringForColumn:@"ProspectTitle"];;
        IDTypeNo = [s stringForColumn:@"IDTypeNo"];;
        OtherIDType = [s stringForColumn:@"OtherIDType"];;
        OtherIDTypeNo = [s stringForColumn:@"OtherIDTypeNo"];;
        Smoker = [s stringForColumn:@"Smoker"];;
        
        Race = [s stringForColumn:@"Race"];;
        
        Nationality = [s stringForColumn:@"Nationality"];;
        MaritalStatus = [s stringForColumn:@"MaritalStatus"];;
        Religion = [s stringForColumn:@"Religion"];;
        
        AnnIncome = [s stringForColumn:@"AnnualIncome"];;
        BussinessType = [s stringForColumn:@"BussinessType"];;
        
        registration = [s stringForColumn:@"GST_registered"];;
        registrationNo = [s stringForColumn:@"GST_registrationNo"];;
        registrationDate = [s stringForColumn:@"GST_registrationDate"];;
        exempted = [s stringForColumn:@"GST_exempted"];
        
        isGrouping = [s stringForColumn:@"Prospect_IsGrouping"];
        COB = [s stringForColumn:@"CountryOfBirth"];
        
        NIP = [s stringForColumn:@"NIP"];
        BranchCode = [s stringForColumn:@"BranchCode"];
        BranchName = [s stringForColumn:@"BranchName"];
        KCU = [s stringForColumn:@"KCU"];
        ReferralSource = [s stringForColumn:@"ReferralSource"];
        ReferralName = [s stringForColumn:@"ReferralName"];
        IdentitySubmitted = [s stringForColumn:@"IdentitySubmitted"];
        IDExpirityDate = [s stringForColumn:@"IDExpirityDate"];
        NPWPNo = [s stringForColumn:@"NPWPNo"];

        
        [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName
                                                          AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                      AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3
                                                   AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                               AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry
                                                         AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown
                                                     AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                   AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark AndDateCreated:DateCreated AndDateModified:DateModified AndCreatedBy:CreatedBy AndModifiedBy:ModifiedBy
                                                 AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB
                                                            AndExactDuties:ExactDuties AndGroup:ProspectGroup AndTitle:ProspectTitle AndIDTypeNo:IDTypeNo AndOtherIDType:OtherIDType AndOtherIDTypeNo:OtherIDTypeNo AndSmoker:Smoker AndAnnIncome:AnnIncome AndBussType:BussinessType AndRace:Race AndMaritalStatus:MaritalStatus AndReligion:Religion AndNationality:Nationality AndRegistrationNo:registrationNo AndRegistration:registration AndRegistrationDate:registrationDate AndRegistrationExempted:exempted AndProspect_IsGrouping:isGrouping AndCountryOfBirth:COB AndNIP:NIP AndBranchCode:BranchCode AndBranchName:BranchName AndKCU:KCU AndReferralSource:ReferralSource AndReferralName:ReferralName AndIdentitySubmitted:IdentitySubmitted AndIDExpirityDate:IDExpirityDate AndNPWPNo:NPWPNo]];
    }
    [results close];
    [database close];
    return ProspectTableData;
}

-(NSMutableArray *)getDataMobileAndPrefix:(NSString *)DataToReturn ProspectTableData:(NSMutableArray *)prospectTableData
{
    NSMutableArray* dataMobile = [[NSMutableArray alloc] init];
    NSMutableArray* dataPrefix = [[NSMutableArray alloc] init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    for (int a=0; a<prospectTableData.count; a++) {
        ProspectProfile *pp = [prospectTableData objectAtIndex:a];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ContactCode, ContactNo, Prefix FROM contact_input where indexNo = %@ AND ContactCode = 'CONT008'", pp.ProspectID];
         FMResultSet *s = [database executeQuery:querySQL];
        while ([s next]) {
            [dataMobile addObject: [NSNumber numberWithInt: [results intForColumn:@"ContactNo"]]];
            [dataPrefix addObject:[NSNumber numberWithInt: [results intForColumn:@"Prefix"]]];
        }
        [results close];
        [database close];
    }
    if ([DataToReturn isEqualToString:@"Prefix"]){
        return dataPrefix;
    }
    else if ([DataToReturn isEqualToString:@"ContactNo"]){
        return dataMobile;
    }
    return dataPrefix;
}

@end
