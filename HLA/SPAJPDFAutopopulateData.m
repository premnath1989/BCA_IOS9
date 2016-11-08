//
//  SPAJPDFAutopopulate.m
//  BLESS
//
//  Created by Basvi on 8/26/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJPDFAutopopulateData.h"

@implementation SPAJPDFAutopopulateData

#pragma mark arrayInitialization

-(NSMutableArray *)arrayInitializeAgentProfileDB{
    NSMutableArray *arrayDBAgentID =[[NSMutableArray alloc]init];
    [arrayDBAgentID addObject:@"AgentName"];
    [arrayDBAgentID addObject:@"AgentCode"];
    [arrayDBAgentID addObject:@""];
    [arrayDBAgentID addObject:@"AgentExpiryDate"];
    [arrayDBAgentID addObject:@"AgentName"];
    [arrayDBAgentID addObject:@"AgentCode"];
    return arrayDBAgentID;
}

-(NSMutableArray *)arrayInitializeReferralDB{
    NSMutableArray *arrayDBReferral =[[NSMutableArray alloc]init];
    [arrayDBReferral addObject:@"ReferralName"];
    [arrayDBReferral addObject:@"BranchName"];
    [arrayDBReferral addObject:@"BranchCode"];
    [arrayDBReferral addObject:@"Kanwil"];
    [arrayDBReferral addObject:@"NIP"];
    [arrayDBReferral addObject:@"ReferralSource"];
    
    return arrayDBReferral;
}

-(NSMutableArray *)arrayInitializePODataDB{
    NSMutableArray *arrayDBPOData =[[NSMutableArray alloc]init];
    [arrayDBPOData addObject:@"ProductName"];
    [arrayDBPOData addObject:@"ProductCode"];
    return arrayDBPOData;
}


-(NSMutableArray *)arrayInitializeSIMasterDB{ //premnath Vijaykumar
    NSMutableArray *arrayDBSIData=[[NSMutableArray alloc]init];
    [arrayDBSIData addObject:@"SINO"];
    [arrayDBSIData addObject:@"CreatedDate"];
    [arrayDBSIData addObject:@"CreatedDate"];
    return arrayDBSIData;
}

-(NSMutableArray *)arrayInitializeSignatureDB{ //premnath Vijaykumar
    NSMutableArray *arrayDBSignature=[[NSMutableArray alloc]init];
    [arrayDBSignature addObject:@"SPAJSignatureLocation"];
    [arrayDBSignature addObject:@"SPAJDateSignatureParty4"];
    return arrayDBSignature;
}


-(NSMutableArray *)arrayInitializeAgentProfileHTML{
    NSMutableArray *arrayHTMLAgentID =[[NSMutableArray alloc]init];
    [arrayHTMLAgentID addObject:@"TextAgentName"];
    [arrayHTMLAgentID addObject:@"TextAgentCode"];
    [arrayHTMLAgentID addObject:@"TextLicenseNumber"];
    [arrayHTMLAgentID addObject:@"DateActiveAgentExpired"];
    [arrayHTMLAgentID addObject:@"TextIllustrationAgentName"];
    [arrayHTMLAgentID addObject:@"TextIllustrationAgentCode"];
    return arrayHTMLAgentID;
}

-(NSMutableArray *)arrayInitializeReferralHTML{
    NSMutableArray *arrayHTMLReferal =[[NSMutableArray alloc]init];
    [arrayHTMLReferal addObject:@"TextReferenceName"];
    [arrayHTMLReferal addObject:@"TextBranchName"];
    [arrayHTMLReferal addObject:@"TextBranchCode"];
    [arrayHTMLReferal addObject:@"AreaKanwilAgent"];
    [arrayHTMLReferal addObject:@"TextAgentID"];
    [arrayHTMLReferal addObject:@"RadioButtonReferenceSource"];
    
    return arrayHTMLReferal;
}

-(NSMutableArray *)arrayInitializePODataHTML{
    NSMutableArray *arrayHTMLPOData =[[NSMutableArray alloc]init];
    [arrayHTMLPOData addObject:@"TextProductName"];
    [arrayHTMLPOData addObject:@"TextProductCode"];
    return arrayHTMLPOData;
}


-(NSMutableArray *)arrayInitializeSIMasterHTML{ //premnath Vijaykumar
    NSMutableArray *arrayHTMLSIData =[[NSMutableArray alloc]init];
    [arrayHTMLSIData addObject:@"TextIllustrationNumber"];
    [arrayHTMLSIData addObject:@"DateIllustration"];
    [arrayHTMLSIData addObject:@"DateReference"];
    return arrayHTMLSIData;
}

-(NSMutableArray *)arrayInitializeSignatureHTML{ //premnath Vijaykumar
    NSMutableArray *arrayHTMLSignature =[[NSMutableArray alloc]init];
    [arrayHTMLSignature addObject:@"TextSignedPlace"];
    [arrayHTMLSignature addObject:@"DateSigned"];
    return arrayHTMLSignature;
}

@end
