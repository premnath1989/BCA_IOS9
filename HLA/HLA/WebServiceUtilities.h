//
//  WebServiceUtilities.h
//  BLESS
//
//  Created by Erwin on 15/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceUtilities :NSObject

- (int)forgotPassword:(NSString *)username delegate:(id)delegate;
- (int)ValidateLogin:(NSString *)username password:(NSString *)password
                UUID:(NSString *)deviceID delegate:(id)delegate;
- (int)FirstTimeLogin:(id)delegate AgentCode:(NSString *)AgentCode password:(NSString *)password newPassword:(NSString *)newpassword UUID:(NSString *)deviceID;
- (int)chgPassword:(id)delegate AgentCode:(NSString *)AgentCode password:(NSString *)password newPassword:(NSString *)newpassword UUID:(NSString *)deviceID;
-(int)fullSync:(id)delegate;
@end