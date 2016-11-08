//
//  ChangePassword.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PasswordTips.h"
#import "AgentWS.h"
#import "LoginDBManagement.h"
#import "SpinnerUtilities.h"
#import "EncryptDecryptWrapper.h"

@interface ChangePassword : UIViewController<PasswordTipDelegate, AgentWSSoapBindingResponseDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *_PasswordTipPopover;
    PasswordTips *_PasswordTips;
    id loginDelegate;
    BOOL flagFirstLogin;
    BOOL flagFullSync;
    NSString *strAgentCode;
    LoginDBManagement *loginDB;
    EncryptDecryptWrapper *encryptWrapper;
}

@property (nonatomic, assign,readwrite) int userID;
@property (nonatomic, retain) UIPopoverController *PasswordTipPopover;
@property (nonatomic, retain) PasswordTips *PasswordTips;
@property (weak, nonatomic) IBOutlet UITextField *txtAgentCode;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBarCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBarDone;
@property (nonatomic,strong) SpinnerUtilities *spinnerLoading;
- (IBAction)btnChange:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletSave;
@property (weak, nonatomic) IBOutlet UILabel *lblMsg;


@property (nonatomic, copy) NSString *passwordDB;
@property (weak, nonatomic) IBOutlet UIButton *outletTips;
@property (weak, nonatomic) IBOutlet UILabel *lblTips;

- (void)setDelegate:(id)delegate firstLogin:(BOOL)firstLogin;
- (void)setAgentCode:(NSString *)agentCode;
- (void)gotoCarousel;


- (IBAction)btnTips:(id)sender;
- (IBAction)btnSave:(id)sender;

@end
