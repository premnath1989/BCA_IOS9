
//
//  Login.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Reachability.h"
#import "LoginDBManagement.h"
#import "AgentWS.h"
#import "ChangePassword.h"
#import "WebServiceUtilities.h"
#import "SpinnerUtilities.h"
#import "AppDisclaimer.h"
#import <MessageUI/MFMailComposeViewController.h>

@protocol LoginDelegate
- (void)Dismiss: (NSString *)ViewToBePresented;
@end

static const int XML_TYPE_GET_AGENT_INFO = 100; //to check on login when the device is online
static const int XML_TYPE_VALIDATE_AGENT = 101; //check on registering device
static const int XML_TYPE_GET_APP_INFO = 102; //check app info

static NSString* KEY_BAD_ATTEMPTS = @"badAttempts";
static NSString* KEY_AGENT_STATUS = @"agentStatus";
static NSString* KEY_AGENT_CODE = @"agentCode";
static NSString* KEY_LAST_SYNC_DATE = @"lastSyncDate";
static NSString* KEY_LAST_CHECK_DEVICE_DATE = @"lastCheckDeviceDate";
static NSString* KEY_DEVICE_STATUS = @"deviceStatus";

static NSString* APP_TYPE_IRECRUIT = @"IRECRUIT";
static NSString* APP_TYPE_ISALES = @"ISALES";
static NSString* APP_TYPE_IM_SOLUTIONS = @"IPAD";
static NSString* APP_TYPE_HLA_FAST = @"HLA_FAST";

static NSString* DATE_FORMAT = @"yyyy-MM-dd";


@interface Login : UIViewController<NSXMLParserDelegate, UITextFieldDelegate, AgentWSSoapBindingResponseDelegate,UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *labelUDID;
    
    UITextField *activeField;
    id<LoginDelegate> _delegate;
    Reachability *internetReachableFoo;
    BOOL firstLogin;
    NSString *status;
    NSInteger badAttempts;
    NSString *error;
    NSString *agentInfo;
    LoginDBManagement *loginDB;
    
    NSString *agentLogin;
    //  NSString *agentCode;
    NSString *agentName;
    NSString *icNo;
    NSString *contractDate;
    NSString *email;
    NSString *address1;
    NSString *address2;
    NSString *address3;
    NSString *postalCode;
    NSString *stateCode;
    NSString *countryCode;
    NSString *agentStatus;
    NSString *leaderCode;
    NSString *leaderName;
    
    NSString *statusDesc;
    NSString *loginDate;
    NSString *deviceStatus;
    
    NSString *currentVers;
    NSString *lastUpdateDate;
    NSString *obsoleteVersNo;
    NSString *obsoleteDate;
    NSString *licenseStatus;
    
    int xmlType;
    
    BOOL ONLINE_PROCESS;
    BOOL OFFLINE_PROCESS;
    BOOL showLogout;
    ChangePassword * UserProfileView;
    SpinnerUtilities *spinnerLoading;
    EncryptDecryptWrapper *encryptWrapper;
}

@property (nonatomic, strong) id<LoginDelegate> delegate;

@property (nonatomic, assign) int statusLogin;
@property (nonatomic, assign) int indexNo;
@property (nonatomic, copy) NSString *agentID;
@property (nonatomic, copy) NSString *agentPortalLoginID;
@property (nonatomic, copy) NSString *agentPortalPassword;
@property (nonatomic, copy) NSString *agentCode;
@property (nonatomic, copy) NSString *msg;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblForgotPwd;
@property (weak, nonatomic) IBOutlet UILabel *lblLastLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeRemaining;
@property (weak, nonatomic) IBOutlet UILabel *lblVersinBuild;

@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;

- (IBAction)btnLogin:(id)sender;
- (IBAction)btnReset:(id)sender;
- (IBAction)btnReport:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;
@property (weak, nonatomic) IBOutlet UIButton *outletReset;
@property (weak, nonatomic) IBOutlet UIButton *outletReport;
@property (weak, nonatomic) IBOutlet UIButton *outletLogin;
@property (weak, nonatomic) IBOutlet UILabel *uatDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *uatAgentStatus;

@property (weak, nonatomic) IBOutlet UILabel *serverOption;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverSegmented;
@property (weak, nonatomic) IBOutlet UIView *viewWrapper;

+(NSString *)getLabelVersion;

+(bool)forSMPD_Acturial:(NSString*) password;
+(void)setFirstDevice;
- (IBAction)passLogin:(id)sender;

@end