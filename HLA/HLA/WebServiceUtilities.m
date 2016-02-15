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
    agentCodea.strAgentID = @"emi";
    agentCodea.strPassword = @"password";
    agentCodea.strDeviceID = @"asd";
    [binding ValidateLoginAsyncUsingParameters:agentCodea delegate:delegate];
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
