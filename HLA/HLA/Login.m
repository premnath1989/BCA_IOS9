//
//  Login.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Login.h"
#import "MainScreen.h"
#import "ForgotPwd.h"
#import "FirstTimeViewController.h"
#import "AppDelegate.h"
#import "CarouselViewController.h"
#import "SecurityQuestion.h"
#import "ViewController.h"
#import "Reachability.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"
#import "SettingUserProfile.h"
#import "SIUtilities.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "AgentPortalLogin.h"
#import "AgentProfile.h"
#import "StoreVarFirstTimeReg.h"
#import "ColorHexCode.h"
#import "MBProgressHUD.h"
#import <AdSupport/ASIdentifierManager.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "LoginMacros.h"
#import "WebServiceUtilities.h"
#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLNode.h"
#import "SynchdaysCounter.h"
#import "WebResponObj.h"
#import "DBMigration.h"
#import "SSKeychain.h"

@interface Login ()

@end
NSString *ProceedStatus = @"";

@implementation Login
@synthesize outletReset;
@synthesize outletReport;
@synthesize scrollViewLogin;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize lblForgotPwd;
@synthesize statusLogin,indexNo,agentID;
@synthesize outletLogin,agentPortalLoginID,agentPortalPassword,lblVersinBuild;
@synthesize delegate = _delegate;
@synthesize previousElementName, agentCode;
@synthesize elementName, msg, lblLastLogin, lblTimeRemaining;
@synthesize uatAgentStatus, uatDeviceLabel;
@synthesize serverOption;
@synthesize serverSegmented;
@synthesize viewWrapper;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self DBInitialized];
    
    ONLINE_PROCESS = FALSE;
    OFFLINE_PROCESS = FALSE;
    encryptWrapper = [[EncryptDecryptWrapper alloc]init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

    [labelUDID setText:[self getUniqueDeviceIdentifierAsString]];
    
    txtUsername.delegate = self;
    txtUsername.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    txtPassword.delegate = self;
    txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    UserProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwd"];
    firstLogin = false;
    if([loginDB AgentRecord] == AGENT_IS_NOT_FOUND){
        [self FirstTimeAlert:@"Selamat"];
        firstLogin = true;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword:)];
    [lblForgotPwd setUserInteractionEnabled:YES];
    [lblForgotPwd addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    NSLog(@"devideId %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    [self ShowLoginDate];

    outletLogin.hidden = FALSE;
    
    NSString *BCAversion= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    lblVersinBuild.text =[NSString stringWithFormat:@"%@ b%@",BCAversion, build];
    
    AppDelegate *delegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] containsString:@"UAT"])
    {
        serverOption.hidden = TRUE;
        serverSegmented.hidden = TRUE;
        serverSegmented.selectedSegmentIndex = 1;
        delegate.serverURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Prod_Webservices"];
        viewWrapper.hidden = TRUE;
    }else{
        serverSegmented.selectedSegmentIndex = 0;
        delegate.serverURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UAT_Webservices"];
    }
}

- (void)DBInitialized{
    loginDB = [[LoginDBManagement alloc]init];
    [loginDB makeDBCopy];
    
    DBMigration *migration = [[DBMigration alloc]init];
    [migration updateDatabaseUseNewDB:@"hladb.sqlite"];
    [migration hardUpdateDatabase:@"BCA_Rates.sqlite" versionNumber:[NSString stringWithFormat:
                            @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]]];
    [migration hardUpdateDatabase:@"DataReferral.sqlite"versionNumber:[NSString stringWithFormat:
                            @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbReferralVersion"]]];
}


- (void)appVersionChecker{
    if([self connected]){
        [spinnerLoading startLoadingSpinner:self.view label:@"Periksa Versi Aplikasi"];
        NSString *version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
        [webservice AppVersionChecker:version delegate:self];
    }
}

//added by Edwin 12-02-2014
static NSString *labelVers;
+(NSString*)getLabelVersion
{
    return labelVers;
}

-(void)hideKeyboard{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    spinnerLoading = [[SpinnerUtilities alloc]init];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if(firstLogin){
        UserProfileView.modalPresentationStyle = UIModalPresentationFormSheet;
        UserProfileView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [UserProfileView setDelegate:self firstLogin:firstLogin];
        UserProfileView.preferredContentSize = CGSizeMake(600, 500);
        [self presentViewController:UserProfileView animated:YES completion:nil];
    }
    
    [self appVersionChecker];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


//here is our function for every response from webservice
- (void) operation:(AgentWSSoapBindingOperation *)operation
                completedWithResponse:(AgentWSSoapBindingResponse *)response
{
    NSArray *responseBodyParts = response.bodyParts;
    if([[response.error localizedDescription] caseInsensitiveCompare:@""] != NSOrderedSame){
        if(ONLINE_PROCESS){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server sedang bermasalah, anda di arahkan ke offline login" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
            [alert show];
            OFFLINE_PROCESS = TRUE;
            [self loginAction];
        }else{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
            [alert show];
            [spinnerLoading stopLoadingSpinner];
        }
    }
    for(id bodyPart in responseBodyParts) {
    
        /****
         * SOAP Fault Error
         ****/
        if ([bodyPart isKindOfClass:[SOAPFault class]]) {
            
            //You can get the error like this:
            NSString* errorMesg = ((SOAPFault *)bodyPart).simpleFaultString;
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:errorMesg delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
            [alert show];
            [spinnerLoading stopLoadingSpinner];
        }
        
        else if([bodyPart isKindOfClass:[AgentWS_VersionCheckerResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_VersionCheckerResponse* rateResponse = bodyPart;
            
            if([(NSString *)rateResponse.VersionCheckerResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Informasi" message:@"Harap Download applikasi versi terbaru" delegate:self cancelButtonTitle:@"Download" otherButtonTitles:@"Cancel", nil];
                [alert show];
                alert.tag = 100;
            }
        }
        
        else if([bodyPart isKindOfClass:[AgentWS_AdminLoginResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_AdminLoginResponse* rateResponse = bodyPart;
            
            if([(NSString *)rateResponse.AdminLoginResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                [self loginSuccess];
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Informasi" message:@"Username/Password yang Anda masukkan salah" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        /****
         * is it AgentWS_SendForgotPasswordResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_SendForgotPasswordResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_SendForgotPasswordResponse* rateResponse = bodyPart;
            if([(NSString *)rateResponse.SendForgotPasswordResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Sukses!"message:[NSString stringWithFormat:@"Password baru telah di kirimkan ke email anda"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Gagal!" message:[NSString stringWithFormat:@"Periksa lagi koneksi internet anda"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        /****
         * is it AgentWS_ChangeUDIDResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_ChangeUDIDResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_ChangeUDIDResponse* rateResponse = bodyPart;
            if([(NSString *)rateResponse.ChangeUDIDResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                
                NSString *encryptedPass = [encryptWrapper encrypt:txtPassword.text];
                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                [webservice ValidateLogin:txtUsername.text password:encryptedPass UUID:[[[UIDevice currentDevice] identifierForVendor] UUIDString] delegate:self];
            }else{
                
                NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
                [SSKeychain setPassword:nil forService:appName account:@"incodingLogin"];
                
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Periksa lagi koneksi internet anda"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        else if([bodyPart isKindOfClass:[AgentWS_SupervisorLoginResponse class]]) {
            AgentWS_SupervisorLoginResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                      rateResponse.SupervisorLoginResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                [self parseXML:root objBuff:returnObj index:0];
                if([loginDB fullSyncTable:returnObj]){
                    [spinnerLoading stopLoadingSpinner];
                    if([self validToLogin] && [self CredentialChecking:TRUE])
                        [self loginSuccess];
                }
            }else if([rateResponse.strStatus caseInsensitiveCompare:@"False"] == NSOrderedSame){
                
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Username/Password yang Anda masukkan salah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
                
            }
        }
        
        /****
         * is it AgentWS_ValidateLoginResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_ValidateLoginResponse class]]) {
            AgentWS_ValidateLoginResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                      rateResponse.ValidateLoginResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                [self parseXML:root objBuff:returnObj index:0];
                if([loginDB fullSyncTable:returnObj]){
                    [spinnerLoading stopLoadingSpinner];
                    if([self validToLogin] && [self CredentialChecking:FALSE])
                        [self loginSuccess];
                }
            }else if([rateResponse.strStatus caseInsensitiveCompare:@"False"] == NSOrderedSame){
                
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Username/Password yang Anda masukkan salah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}


- (void) parseXML:(DDXMLElement *)root objBuff:(WebResponObj *)obj index:(int)index{
    // go through all elements in root element (DataSetMenu element)
    for (DDXMLElement *DataSetMenuElement in [root children]) {
        // if the element name's is MenuCategories then do something
        if([[DataSetMenuElement children] count] <= 0){
            if([[DataSetMenuElement name] caseInsensitiveCompare:@"xs:element"]==NSOrderedSame){
//                DDXMLNode *name = [DataSetMenuElement attributeForName: @"name"];
//                DDXMLNode *type = [DataSetMenuElement attributeForName: @"type"];
//                NSLog(@"%@ : %@", [name stringValue], [type stringValue]);
//                
//                DDXMLNode *tableName = [[[DataSetMenuElement parent] parent] parent];
//                [obj addRow:[tableName ] columnNames:[name stringValue] data:@""];
            }else{
                NSArray *elements = [root elementsForName:[DataSetMenuElement name]];
                if([[[elements objectAtIndex:0]stringValue] caseInsensitiveCompare:@""] != NSOrderedSame){
                    NSLog(@"%d %@ = %@", index,[[DataSetMenuElement parent]name], [[elements objectAtIndex:0]stringValue]);
                    NSString *tableName = [NSString stringWithFormat:@"%@&%d",[[[DataSetMenuElement parent] parent]name], index];
                    [obj addRow:tableName columnNames:[[DataSetMenuElement parent]name] data:[[elements objectAtIndex:0]stringValue]];
                }else{
                    NSLog(@"%d %@ = %@",index, [DataSetMenuElement name], [[elements objectAtIndex:0]stringValue]);
                    NSString *tableName = [NSString stringWithFormat:@"%@&%d",[[DataSetMenuElement parent]name], index];
                    [obj addRow:tableName columnNames:[DataSetMenuElement name] data:[[elements objectAtIndex:0]stringValue]];
                }
            }
        }else{
            DDXMLNode *name = [DataSetMenuElement attributeForName: @"diffgr:id"];
            if(name != nil){
                NSLog(@"diffgr : %@",[[DataSetMenuElement attributeForName:@"diffgr:id"] stringValue]);
                index++;
            }
        }
        [self parseXML:DataSetMenuElement objBuff:obj index:index];
    }
}

- (void)forgotPassword:(UIGestureRecognizer*)gestureRecognizer
{
    
    if (txtUsername.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Username harap diisi" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show];
        alert = Nil;
    }
    else {
        [spinnerLoading startLoadingSpinner:self.view label:@"Loading"];
        
        WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
        [webservice forgotPassword:txtUsername.text delegate:self];
    }
}

#pragma mark - keyboard display

-(void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = self.outletReset.frame.origin;
    CGFloat buttonHeight = self.outletReset.frame.size.height;
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [self.scrollViewLogin setContentOffset:scrollPoint animated:YES];
    }
}


-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    [self.scrollViewLogin setContentOffset:CGPointZero animated:YES];
}

#pragma mark - action

- (IBAction)btnLogin:(id)sender {
    
    if (txtUsername.text.length <= 0 && txtPassword.text.length <=0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username dan password harap diisi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = USERNAME_PASSWORD_VALIDATION;
        [alert show];
    }else if(txtUsername.text.length <= 0 && txtPassword.text.length != 0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username harap diisi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = USERNAME_PASSWORD_VALIDATION;
        [alert show];
    }else if(txtUsername.text.length != 0 && txtPassword.text.length <= 0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password harap diisi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = USERNAME_PASSWORD_VALIDATION;
        [alert show];
    }else{
        if(firstLogin && ![self connected]){
            [self FirstTimeAlert:@"Informasi"];
        }else{
            [self loginAction];
        }
    }
}

- (IBAction)btnReport:(id)sender {
    if([self connected]){
        NSMutableDictionary *agentDetails = [loginDB getAgentDetails];
        //compose the agent Details into NSString
        NSString *agentDetailsStr = @" ";
        for(NSString *key in agentDetails.allKeys){
            agentDetailsStr = [agentDetailsStr stringByAppendingString:key];
            agentDetailsStr = [agentDetailsStr stringByAppendingString:[NSString stringWithFormat:@"= %@ \n ",[agentDetails valueForKey:key]]];
        }
        
        NSString *dbVersion = [NSString stringWithFormat:
                               @"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"dbVersion"]];
        NSString *BCAversion= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *iosVersion = [[UIDevice currentDevice]systemVersion];
        
        NSString *ErrorLog = [NSString stringWithFormat:@"%@APP Version : %@ %@ \n iOS Version : %@ \n DB Version : %@ \n Data Version : ", agentDetailsStr,BCAversion, build, iosVersion, dbVersion];
        [self writeStringToFile:ErrorLog];
        [self sendByEmail:agentDetails];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No Internet" message:[NSString stringWithFormat:@"Periksa lagi internet anda untuk mengirim error report"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

- (void)sendByEmail:(NSMutableDictionary*)agentDetails{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"errorlog.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
    mc.mailComposeDelegate = self;
    [mc setToRecipients:[NSArray arrayWithObject: @"sales_support@bcalife.co.id"]];
    [mc addAttachmentData:[NSData dataWithContentsOfFile:fileAtPath] mimeType:@"text/csv" fileName:fileName];
    [mc setSubject:[NSString stringWithFormat:@"Error Log of Agent %@", [agentDetails valueForKey:@"AgentCode"]]];
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    // NEVER REACHES THIS PLACE
    [self dismissModalViewControllerAnimated:YES];
    NSLog (@"mail finished");
}

- (void)writeStringToFile:(NSString*)aString {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"errorlog.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }else{
        [[NSFileManager defaultManager] removeItemAtPath:fileAtPath error:NULL];
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}


- (void)FirstTimeAlert:(NSString *)title{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet untuk melakukan login perdana (dapat berlangsung hingga 3 menit)"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void) ShowLoginDate
{
    NSString *lastSyncDate = [self getLastSyncDate];
    int dayRem = 0;
    
    NSLog(@"lastSyncDate %@", lastSyncDate);
    if( [lastSyncDate compare:@""] == NSOrderedSame )
    {
        lastSyncDate = @"";
    }
    
    int differentDay = [self syncDaysLeft];
    if(differentDay<0)
    {
        differentDay = differentDay * -1;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *lastSync = [dateFormatter dateFromString:lastSyncDate];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    lastSyncDate = [dateFormatter stringFromDate:lastSync];
    
    lblLastLogin.text = lastSyncDate;
    [lblLastLogin sizeToFit];
    dayRem = 7 - differentDay;
    
    if (dayRem<0) {
        lblTimeRemaining.textColor = [UIColor redColor];
        lblTimeRemaining.text = [NSString stringWithFormat:@"0 hari"];
    }
    else {
        lblTimeRemaining.textColor = [UIColor whiteColor];
        lblTimeRemaining.text = [NSString stringWithFormat:@"%d hari", dayRem];
    }
}

- (BOOL) validToLogin{
    
    //need to check again the date format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    
    BOOL validFlag = true;
    
    
    NSString *encryptedPass = [encryptWrapper encrypt:txtPassword.text];
    if(![loginDB SpvAdmValidation:txtUsername.text password:encryptedPass]){
        switch ([loginDB AgentStatus:txtUsername.text]) {
            case AGENT_IS_INACTIVE:
            {
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Status Agen adalah inactive"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                validFlag = false;
                break;
            }
            case AGENT_IS_NOT_FOUND:
            {
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Username/Password yang di masukan salah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                validFlag = false;
                break;
            }
            case AGENT_IS_TERMINATED:
            {
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Status Agen adalah terminated"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                validFlag = false;
                break;
            }
            default:
                break;
        }
        switch ([[dateFormatter dateFromString:[loginDB expiryDate:txtUsername.text]] compare:[NSDate date]]) {
            case NSOrderedAscending:
            {
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Lisensi Agen telah expired"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                validFlag = false;
                break;
            }
            default:
                break;
        }
    }
    
    if([[loginDB localDBUDID] caseInsensitiveCompare:[self getUniqueDeviceIdentifierAsString]]!= NSOrderedSame){
        [spinnerLoading stopLoadingSpinner];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Agen login di device yang tidak terdaftar"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        validFlag = false;
    }
    
    switch ([loginDB DeviceStatus:txtUsername.text]) {
        case DEVICE_IS_INACTIVE:
        {
            [spinnerLoading stopLoadingSpinner];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Status Perangkat anda tidak aktif"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            validFlag = false;
            break;
        }
        case DEVICE_IS_TERMINATED:
        {
            [spinnerLoading stopLoadingSpinner];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Status Perangkat anda telah di terminate"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            validFlag = false;
            break;
        }
        default:
            break;
    }
    
    return validFlag;
}

- (void) loginAction
{
    //check the agentstatus and expiry date
    if(!firstLogin){
        
        NSString *encryptedPass = [encryptWrapper encrypt:txtPassword.text];
        //online login
        int dateDifference = [self syncDaysLeft];
        if(dateDifference>0)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Mohon kembalikan waktu anda ke semula"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
            [spinnerLoading startLoadingSpinner:self.view label:@"Loading"];
            if([self connected] && !OFFLINE_PROCESS){
                ONLINE_PROCESS = TRUE;
                int usernameTemp = [self UsernameUDIDChecking];
                if(usernameTemp != 0){
                    switch (usernameTemp) {
                        case USERNAME_IS_AGENT:{
                            [self getUDIDLogin];
                            break;
                        }
                        case USERNAME_IS_SPV:{
                            
                            if([loginDB SpvStatus:txtUsername.text] == AGENT_IS_ACTIVE){
                                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                                [webservice spvLogin:[loginDB AgentCodeLocal] delegate:self spvCode:txtUsername.text spvPass:encryptedPass];
                            }else{
                                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Status Agen adalah inactive"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                                ONLINE_PROCESS = FALSE;
                            }
                            break;
                        }
                        case USERNAME_IS_ADMIN:{
                            
                            WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                            [webservice adminLogin:[loginDB AgentCodeLocal] delegate:self adminCode:txtUsername.text  adminPass:encryptedPass];
                            break;
                        }
                        default:
                            break;
                    }
                }else{
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Username/password yang Anda masukkan salah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [spinnerLoading stopLoadingSpinner];
                }
            }else{
                //offline login
                if([self validToLogin]){
                    ONLINE_PROCESS = FALSE;
                    OFFLINE_PROCESS = FALSE;
                    [self doOfflineLoginCheck];
                }else{
                    [spinnerLoading stopLoadingSpinner];
                }
            }
        }
    }
}

- (void) loginSuccess
{
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    zzz.indexNo = self.indexNo;
    zzz.userRequest = agentID;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isLoggedIn = TRUE;
    
    [self openHome];
    //        [loginDB updateLoginDate];
}



-(void) loginFail
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isLoggedIn = FALSE;
}

//we store the UDID into the Keychain
-(NSString *)getUniqueDeviceIdentifierAsString
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
        
    }
    return strApplicationUUID;
}

//just a flag of login udid
-(NSString *)getUDIDLogin
{
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incodingLogin"];
    WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incodingLogin"];
        
        //change the udid
        [webservice changeUDID:txtUsername.text udid:[SSKeychain passwordForService:appName account:@"incoding"] delegate:self];
        
    }else{
        NSString *encryptedPass = [encryptWrapper encrypt:txtPassword.text];
        [webservice ValidateLogin:txtUsername.text password:encryptedPass UUID:strApplicationUUID delegate:self];
    }
    return strApplicationUUID;
}


- (void) openHome
{
    if([loginDB SPAJBalance] < 30){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"SPAJ Balance anda di bawah 30, segera lakukan synch"
                              delegate: self
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil, nil];
        [alert show];
    }
    
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselMenu = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselMenu.getInternet = @"No";
    carouselMenu.loginPreviousController = @"Login";
    [self presentViewController:carouselMenu animated:YES completion:Nil];
}

- (int)syncDaysLeft{
    NSString *todaysDate = [self getTodayDate];
    NSString *lastSyncDate = [self getLastSyncDate];
    
    NSLog(@"lastSyncDate %@", lastSyncDate);
    if([lastSyncDate compare:@""] == NSOrderedSame){
        lastSyncDate = todaysDate;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    
    return [SynchdaysCounter daysBetweenDate:[formatter dateFromString:todaysDate] andDate:[dateFormatter dateFromString:lastSyncDate]];
}

- (void) doOfflineLoginCheck
{
    int dateDifference = [self syncDaysLeft];
    
    if(dateDifference<0)
    {
        dateDifference = dateDifference * -1;
    }
    
    if(dateDifference > 7)
    {
        if(dateDifference > 14){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Informasi"
                                                            message:@"Anda tidak melakukan online login selama 14 hari, semua data nasabah telah terhapus."
                                                           delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Informasi"
                                                        message:@"Anda tidak melakukan online login selama 7 hari, pastikan perangkat terhubung ke internet untuk login."
                                                       delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [spinnerLoading stopLoadingSpinner];
    }else
    {
        
        if ([self OfflineLogin]) {
            [self openHome];
            //[self loginSuccess];
        }
        [spinnerLoading stopLoadingSpinner];
    }
}

- (NSString *) getTodayDate
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    NSLog(@"%@",dateString);
    
    return dateString;
}


-(NSString*) getDeviceSerial
{
    AgentProfile *agentProf = [ [AgentProfile alloc] init];
    NSString *deviceSerial = [agentProf getDeviceSerialNo];
    
    return deviceSerial;
}


- (IBAction)btnReset:(id)sender
{
    txtUsername.text = @"";
    txtPassword.text = @"";
}

- (IBAction)passLogin:(id)sender
{
    
    if([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] containsString:@"UAT"])
        [self loginSuccess];
}

#pragma mark - XML parser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict  {
    
    self.previousElementName = self.elementName;
    
    if (qName) {
        self.elementName = qName;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    self.elementName = nil;
}

-(void) storeAgentCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:agentCode forKey:KEY_AGENT_CODE];
    [defaults synchronize];
}

-(NSString *) getStoredAgentCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:KEY_AGENT_CODE];
}

-(NSString *) getStoredLastCheckedDeviceDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:KEY_LAST_CHECK_DEVICE_DATE];
}

-(void) storeDeviceStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    deviceStatus = @"N";
    [defaults setObject:deviceStatus forKey:KEY_DEVICE_STATUS];
    [defaults synchronize];
    
}

-(NSString *) getDeviceStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:KEY_DEVICE_STATUS];
}

-(void) storeAgentStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:@"N" forKey:KEY_AGENT_STATUS]; //for testing
    [defaults setObject:agentStatus forKey:KEY_AGENT_STATUS];
    [defaults synchronize];
}

-(NSString *) getStoredAgentStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:KEY_AGENT_STATUS];
}

-(void) storeLastSyncDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:loginDate forKey:KEY_LAST_SYNC_DATE];
    [defaults synchronize];
    
}

-(NSString *) getLastSyncDate
{
    return [loginDB checkingLastLogout];
}

-(int) UsernameUDIDChecking
{
    int statusUsername = 0;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    NSString *AgentName;
    NSString *AgentPassword;
    NSString *SupervisorCode;
    NSString *SupervisorPass;
    NSString *Admin;
    NSString *AdminPassword;
    NSString *UDID;
    
    FMResultSet *result1 = [db executeQuery:@"select AgentCode, AgentPassword, DirectSupervisorCode, DirectSupervisorPassword, Admin, AdminPassword, UDID  from Agent_profile"];
    
    while ([result1 next]) {
        AgentName = [[result1 objectForColumnName:@"AgentCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AgentPassword = [[result1 objectForColumnName:@"AgentPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        SupervisorCode = [[result1 objectForColumnName:@"DirectSupervisorCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        SupervisorPass = [[result1 objectForColumnName:@"DirectSupervisorPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Admin = [[result1 objectForColumnName:@"Admin"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AdminPassword = [[result1 objectForColumnName:@"AdminPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UDID = [[result1 objectForColumnName:@"UDID"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    if([txtUsername.text isEqualToString:AgentName] ){
        
        statusUsername = USERNAME_IS_AGENT;

    }else if([txtUsername.text isEqualToString:SupervisorCode]){
        
        statusUsername = USERNAME_IS_SPV;

    }else if([txtUsername.text isEqualToString:Admin]){
        statusUsername = USERNAME_IS_ADMIN;
    }
    
//    if([[loginDB localDBUDID] caseInsensitiveCompare:[self getUniqueDeviceIdentifierAsString]]!= NSOrderedSame){
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Agen login di device yang tidak terdaftar"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        statusUsername = USERNAME_IS_INVALID;
//    }
    
    [db close];
    
    return statusUsername;
}

-(BOOL) CredentialChecking:(BOOL)spvAdminBypass
{
    BOOL successLog = FALSE;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *dbPath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    NSString *AgentName;
    NSString *AgentPassword;
    NSString *SupervisorCode;
    NSString *SupervisorPass;
    NSString *Admin;
    NSString *AdminPassword;
    
    FMResultSet *result1 = [db executeQuery:@"select AgentCode, AgentPassword, DirectSupervisorCode, DirectSupervisorPassword, Admin, AdminPassword  from Agent_profile"];
    
    while ([result1 next]) {
        AgentName = [[result1 objectForColumnName:@"AgentCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AgentPassword = [[result1 objectForColumnName:@"AgentPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        SupervisorCode = [[result1 objectForColumnName:@"DirectSupervisorCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        SupervisorPass = [[result1 objectForColumnName:@"DirectSupervisorPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Admin = [[result1 objectForColumnName:@"Admin"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        AdminPassword = [[result1 objectForColumnName:@"AdminPassword"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *encryptedPass = [encryptWrapper encrypt:txtPassword.text];
        if(!spvAdminBypass){
            if ([txtUsername.text isEqualToString:AgentName]) {
                if ([encryptedPass isEqualToString:AgentPassword]) {
                    successLog = TRUE;
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username/Password yang Anda masukkan salah" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    successLog = FALSE;
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username/Password yang Anda masukkan salah" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                successLog = FALSE;
            }
        }else{
            if([txtUsername.text isEqualToString:AgentName] || [txtUsername.text isEqualToString:SupervisorCode] || [txtUsername.text isEqualToString:Admin]){
                if (([txtUsername.text isEqualToString:AgentName] && [encryptedPass isEqualToString:AgentPassword])
                    ||([txtUsername.text isEqualToString:SupervisorCode] && [encryptedPass isEqualToString:SupervisorPass])
                    || ([txtUsername.text isEqualToString:Admin] && [encryptedPass isEqualToString:AdminPassword])) {
                    successLog = TRUE;
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username/Password yang Anda masukkan salah" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    successLog = FALSE;
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Username/Password yang Anda masukkan salah" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                successLog = FALSE;
            }
        }
    }
    
    [db close];
    
    return successLog;
}

-(BOOL) OfflineLogin
{
    return [self CredentialChecking:FALSE];
}

-(NSString*) getTodayDateInStr
{
    NSDate *today = [NSDate date]; 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    
    NSString *stringFromDate = [formatter stringFromDate:today];
    
    return stringFromDate;
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setLblForgotPwd:nil];
    [self setScrollViewLogin:nil];
    [self setOutletReset:nil];
    [self setOutletLogin:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSString *serverURL = [NSString stringWithFormat:@"%@/webservices/LoginSite.aspx", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    switch (alertView.tag) {
        case USERNAME_PASSWORD_VALIDATION:
        {
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:FALSE];
            [txtUsername becomeFirstResponder];
            break;
        }
        case 100:{
            if(buttonIndex == 0){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:serverURL]];
                [self appVersionChecker];
            }
            break;
        }
        default:
            break;
    }
}
@end
