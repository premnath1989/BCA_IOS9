//
//  WebServiceUtilities.m
//  BLESS
//
//  Created by Erwin on 15/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "WebServiceUtilities.h"
#import "AgentWS.h"

@implementation WebServiceUtilities

-(int)ValidateLogin:(NSString *)username password:(NSString *)password UUID:(NSString *)deviceID delegate:(id)delegate{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_ValidateLogin *agentCodea = [[AgentWS_ValidateLogin alloc]init];
    agentCodea.strAgentID = username;
    agentCodea.strPassword = password;
    agentCodea.strDeviceID = deviceID;
    [binding ValidateLoginAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}

-(int)AppVersionChecker:(NSString *)strVersion delegate:(id)delegate{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_VersionChecker *agentCodea = [[AgentWS_VersionChecker alloc]init];
    agentCodea.strVersion = strVersion;
    [binding VersionCheckerAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}


-(int)fullSync:(NSString *)username delegate:(id)delegate{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_FullSyncTable *agentCodea = [[AgentWS_FullSyncTable alloc]init];
    agentCodea.strAgentCode = username;
    agentCodea.strStatus = @"";
    [binding FullSyncTableAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}

- (int)chgPassword:(id)delegate AgentCode:(NSString *)AgentCode password:(NSString *)password newPassword:(NSString *)newpassword UUID:(NSString *)deviceID {
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_ChangePassword *agentCodea = [[AgentWS_ChangePassword alloc]init];
    agentCodea.strAgentId = AgentCode;
    agentCodea.strPassword = password;
    agentCodea.strUDID = deviceID;
    agentCodea.strNewPass = newpassword;
    [binding ChangePasswordAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}

- (int)FirstTimeLogin:(id)delegate AgentCode:(NSString *)AgentCode password:(NSString *)password newPassword:(NSString *)newpassword UUID:(NSString *)deviceID {
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_ReceiveFirstLogin *agentCodea = [[AgentWS_ReceiveFirstLogin alloc]init];
    agentCodea.strAgentId = AgentCode;
    agentCodea.strAgentPass = password;
    agentCodea.strUID = deviceID;
    agentCodea.strNewPass = newpassword;
    agentCodea.strStatus = @"";
    [binding ReceiveFirstLoginAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}


-(int)partialSync:(NSString *)agentCode delegate:(id)delegate xml:(NSString *)XMLTable{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_PartialSync *agentCodea = [[AgentWS_PartialSync alloc]init];
    agentCodea.strAgentcode = agentCode;
    agentCodea.strXML = XMLTable;
    [binding PartialSyncAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}


-(int)checkVersion:(NSString *)version delegate:(id)delegate{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_CheckVersion *agentCodea = [[AgentWS_CheckVersion alloc]init];
    agentCodea.strVesion = version;
    agentCodea.strStatus = @"";
    [binding CheckVersionAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}


-(int)forgotPassword:(NSString *)username delegate:(id)delegate{
    AgentWSSoapBinding *binding = [AgentWS AgentWSSoapBinding];
    binding.logXMLInOut = YES;
    
    AgentWS_SendForgotPassword *agentCodea = [[AgentWS_SendForgotPassword alloc]init];
    agentCodea.strAgentId = username;
    [binding SendForgotPasswordAsyncUsingParameters:agentCodea delegate:delegate];
    return 1;
}

@end
