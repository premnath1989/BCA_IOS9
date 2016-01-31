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
        ProspectID = [NSString stringWithFormat:@"%i",[results intForColumn:@"IndexNo"]];
        NSLog(@"ProspectID %@",ProspectID);
        NickName = [results stringForColumn:@"PreferredName"];;
        ProspectName = [results stringForColumn:@"ProspectName"];;
        ProspectDOB = [results stringForColumn:@"ProspectDOB"]; ;
        ProspectGender = [results stringForColumn:@"ProspectGender"];;
        ResidenceAddress1 = [results stringForColumn:@"ResidenceAddress1"];;
        ResidenceAddress2 = [results stringForColumn:@"ResidenceAddress2"];;
        ResidenceAddress3 = [results stringForColumn:@"ResidenceAddress3"];;
        ResidenceAddressTown = [results stringForColumn:@"ResidenceAddressTown"];;
        ResidenceAddressState = [results stringForColumn:@"ResidenceAddressState"];;
        ResidenceAddressPostCode = [results stringForColumn:@"ResidenceAddressPostCode"];;
        ResidenceAddressCountry = [results stringForColumn:@"ResidenceAddressCountry"];;
        OfficeAddress1 = [results stringForColumn:@"OfficeAddress1"];;
        OfficeAddress2 = [results stringForColumn:@"OfficeAddress2"];;
        OfficeAddress3 = [results stringForColumn:@"OfficeAddress3"];;
        OfficeAddressTown = [results stringForColumn:@"OfficeAddressTown"];;
        OfficeAddressState = [results stringForColumn:@"OfficeAddressState"];;
        OfficeAddressPostCode = [results stringForColumn:@"OfficeAddressPostCode"];;
        OfficeAddressCountry = [results stringForColumn:@"OfficeAddressCountry"];;
        ProspectEmail = [results stringForColumn:@"ProspectEmail"];;
        ProspectOccupationCode = [results stringForColumn:@"ProspectOccupationCode"];;
        ExactDuties = [results stringForColumn:@"ExactDuties"];;
        ProspectRemark = [results stringForColumn:@"ProspectRemark"];;
        //basvi added
        DateCreated = [results stringForColumn:@"DateCreated"];;
        CreatedBy = [results stringForColumn:@"CreatedBy"];;
        DateModified = [results stringForColumn:@"DateModified"];;
        ModifiedBy = [results stringForColumn:@"ModifiedBy"];;
        //
        ProspectGroup = [results stringForColumn:@"ProspectGroup"];;
        ProspectTitle = [results stringForColumn:@"ProspectTitle"];;
        IDTypeNo = [results stringForColumn:@"IDTypeNo"];;
        OtherIDType = [results stringForColumn:@"OtherIDType"];;
        OtherIDTypeNo = [results stringForColumn:@"OtherIDTypeNo"];;
        Smoker = [results stringForColumn:@"Smoker"];;
        
        Race = [results stringForColumn:@"Race"];;
        
        Nationality = [results stringForColumn:@"Nationality"];;
        MaritalStatus = [results stringForColumn:@"MaritalStatus"];;
        Religion = [results stringForColumn:@"Religion"];;
        
        AnnIncome = [results stringForColumn:@"AnnualIncome"];;
        BussinessType = [results stringForColumn:@"BussinessType"];;
        
        registration = [results stringForColumn:@"GST_registered"];;
        registrationNo = [results stringForColumn:@"GST_registrationNo"];;
        registrationDate = [results stringForColumn:@"GST_registrationDate"];;
        exempted = [results stringForColumn:@"GST_exempted"];
        
        isGrouping = [results stringForColumn:@"Prospect_IsGrouping"];
        COB = [results stringForColumn:@"CountryOfBirth"];
        
        [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName
                                                          AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                      AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3
                                                   AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                               AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry
                                                         AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown
                                                     AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                   AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark AndDateCreated:DateCreated AndDateModified:DateModified AndCreatedBy:CreatedBy AndModifiedBy:ModifiedBy
                                                 AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB
                                                            AndExactDuties:ExactDuties AndGroup:ProspectGroup AndTitle:ProspectTitle AndIDTypeNo:IDTypeNo AndOtherIDType:OtherIDType AndOtherIDTypeNo:OtherIDTypeNo AndSmoker:Smoker AndAnnIncome:AnnIncome AndBussType:BussinessType AndRace:Race AndMaritalStatus:MaritalStatus AndReligion:Religion AndNationality:Nationality AndRegistrationNo:registrationNo AndRegistration:registration AndRegistrationDate:registrationDate AndRegistrationExempted:exempted AndProspect_IsGrouping:isGrouping AndCountryOfBirth:COB]];
    }
    [results close];
    [database close];
    return ProspectTableData;
}
@end
