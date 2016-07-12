//
//  WebServiceUtilities.h
//  MPOS
//
//  Created by Erwin on 15/02/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceUtilities :NSObject

- (int)forgotPassword:(NSString *)username delegate:(id)delegate;
- (int)ValidateLogin:(NSString *)username password:(NSString *)password
                UUID:(NSString *)deviceID
            delegate:(id)delegate;
- (int)FirstTimeLogin:(id)delegate AgentCode:(NSString *)AgentCode
             password:(NSString *)password
          newPassword:(NSString *)newpassword
                 UUID:(NSString *)deviceID;
- (int)chgPassword:(id)delegate AgentCode:(NSString *)AgentCode
          password:(NSString *)password
       newPassword:(NSString *)newpassword
              UUID:(NSString *)deviceID;
- (int)fullSync:(NSString *)username delegate:(id)delegate;
- (int)checkVersion:(NSString *)version delegate:(id)delegate;
- (int)partialSync:(NSString *)agentCode delegate:(id)delegate xml:(NSString *)XMLTable;
- (int)AppVersionChecker:(NSString *)strVersion delegate:(id)delegate;
- (int)adminLogin:(NSString *)agentCode delegate:(id)delegate adminCode:(NSString *)adminCode adminPass:(NSString *)adminPass;
- (int)spvLogin:(NSString *)agentCode delegate:(id)delegate spvCode:(NSString *)spvCode spvPass:(NSString *)spvPass;
- (int)checkuserpass:(NSString *)username password:(NSString *)password delegate:(id)delegate;
- (int)changeUDID:(NSString *)username udid:(NSString *)udid delegate:(id)delegate;
- (int)dataReferralSync:(NSString *)lastUpdateDate delegate:(id)delegate;
@end