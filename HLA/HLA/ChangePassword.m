//
//  ChangePassword.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/getAllData"] //2

#import "ChangePassword.h"
#import "Login.h"
#import "AppDelegate.h"
#import "WebServiceUtilities.h"
#import "CarouselViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLNode.h"
#import "SSKeychain.h"

#import "LoginMacros.h"

#import "CFFAPIController.h"

@interface ChangePassword ()

@end

@implementation ChangePassword
@synthesize txtOldPwd;
@synthesize txtNewPwd;
@synthesize txtConfirmPwd;
@synthesize outletSave, outletTips;
@synthesize lblMsg, lblTips;
@synthesize passwordDB;
@synthesize userID;
@synthesize PasswordTipPopover = _PasswordTipPopover;
@synthesize PasswordTips = _PasswordTips;
@synthesize txtAgentCode;
@synthesize btnBarCancel;
@synthesize btnBarDone;
@synthesize spinnerLoading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDelegate:(id)delegate firstLogin:(BOOL)firstLogin{
    loginDelegate = delegate;
    flagFirstLogin = firstLogin;
}

- (void)setAgentCode:(NSString *)agentCode{
    strAgentCode = agentCode;
}


- (void)gotoCarousel{
    UIStoryboard *carouselStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
    CarouselViewController* carouselMenu = [carouselStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselMenu.getInternet = @"No";
    [self presentViewController:carouselMenu animated:YES completion:Nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Receive userID:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    loginDB = [[LoginDBManagement alloc]init];
    btnBarDone.enabled = NO;
    [btnBarDone setTintColor: [UIColor clearColor]];
    
    
    encryptWrapper = [[EncryptDecryptWrapper alloc]init];
    spinnerLoading = [[SpinnerUtilities alloc]init];
    
    if(flagFirstLogin){
        btnBarCancel.enabled = NO;
        [btnBarCancel setTintColor: [UIColor clearColor]];
    }else{
        txtAgentCode.text = strAgentCode;
        txtAgentCode.backgroundColor = [UIColor lightGrayColor];
        txtAgentCode.enabled = NO;
    }
    
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    self.userID = zzz.indexNo;
    
    outletSave.layer.cornerRadius = 10.0f;
    outletSave.clipsToBounds = YES;
    
    lblMsg.hidden = TRUE;
    outletTips.hidden = TRUE;
    UITapGestureRecognizer *gestureQOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DisplayTips)];
    gestureQOne.numberOfTapsRequired = 1;
    
    [lblTips addGestureRecognizer:gestureQOne ];
    lblTips.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
}

-(void) setFirstLogin
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"UPDATE Agent_Profile set FirstLogin = \"1\" "];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE){
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
        querySQL = Nil;
    }
    statement = nil;
}

-(void)hideKeyboard{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
}

- (void)viewDidUnload
{
    [self setTxtOldPwd:nil];
    [self setTxtNewPwd:nil];
    [self setTxtConfirmPwd:nil];
    [self setOutletSave:nil];
    [self setLblMsg:nil];
    [self setOutletTips:nil];
    [self setLblTips:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}

-(void)validateExistingPwd
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT AgentPassword FROM User_Profile WHERE IndexNO=\"%d\"",self.userID];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT AgentPassword FROM Agent_Profile WHERE IndexNO=\"%d\"",self.userID];
        
        //        NSLog(@"%@", querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                passwordDB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)validatePassword
{
    if ([txtOldPwd.text isEqualToString:passwordDB]){
        
        [self saveChanges];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Password did not match! Please enter correct old password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtOldPwd becomeFirstResponder];
        txtOldPwd.text = @"";
        txtNewPwd.text = @"";
        txtConfirmPwd.text = @"";
        
    }
}

-(void)saveChanges
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        // NSString *querySQL = [NSString stringWithFormat:@"UPDATE User_Profile SET AgentPassword= \"%@\" WHERE IndexNo=\"%d\"",txtNewPwd.text,self.userID];
        
        NSString *encryptedPass = [encryptWrapper encrypt:txtNewPwd.text];
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentPassword= \"%@\" WHERE IndexNo=\"%d\"",encryptedPass,self.userID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                txtOldPwd.text = @"";
                txtNewPwd.text = @"";
                txtConfirmPwd.text = @"";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password save!\n You need to re-login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert setTag:01];
                [alert show];
                
            } else {
                lblMsg.text = @"Failed to update!";
                lblMsg.textColor = [UIColor redColor];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}



- (IBAction)btnChange:(id)sender {
    bool valid;
    
    if ([txtAgentCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length <= 0 ) {
        [self hideKeyboard];
        valid = FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Agent Code harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtOldPwd becomeFirstResponder];
        
    }
    else{
        if([txtOldPwd.text isEqualToString:txtNewPwd.text]) {
            [self hideKeyboard];
            valid = FALSE;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password lama tidak boleh sama dengan password baru" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtNewPwd becomeFirstResponder];
        }else{
            if ([txtOldPwd.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length <= 0 ) {
                [self hideKeyboard];
                valid = FALSE;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password lama harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [txtOldPwd becomeFirstResponder];
            }
            else {
                if ([txtNewPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""  ].length <= 0) {
                    valid = FALSE;
                    [self hideKeyboard];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password baru harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [txtNewPwd becomeFirstResponder];
                }
                else {
                    if ([txtConfirmPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""  ].length <= 0) {
                        valid = FALSE;
                        [self hideKeyboard];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Confirm password harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        [txtConfirmPwd becomeFirstResponder];
                        
                    }
                    else {
                        valid = TRUE;
                        
                    }
                }
            }
        }
    }
    
    if(valid == TRUE) {
        
        if (txtNewPwd.text.length < 6 || txtNewPwd.text.length > 20 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Password Baru paling pendek 6 karakter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtNewPwd becomeFirstResponder];
        }
        else {
            if ([txtNewPwd.text isEqualToString:txtConfirmPwd.text]) {
                [spinnerLoading startLoadingSpinner:self.view label:@"Loading..."];
                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                NSString *encryptedOldPass = [encryptWrapper encrypt:txtOldPwd.text];
                NSString *encryptedNewPass = [encryptWrapper encrypt:txtNewPwd.text];
                if(flagFirstLogin){
                    WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                    [webservice checkuserpass:txtAgentCode.text password:encryptedOldPass delegate:self];
                }else{
                    
                    [webservice chgPassword:self AgentCode:txtAgentCode.text password:encryptedOldPass newPassword:encryptedNewPass UUID:[loginDB getUniqueDeviceIdentifierAsString]];
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password Baru tidak sesuai dengan Confirm Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                txtOldPwd.text = @"";
                txtNewPwd.text = @"";
                txtConfirmPwd.text = @"";
            }
        }
    }
}

//here is our function for every response from webservice
- (void) operation:(AgentWSSoapBindingOperation *)operation
completedWithResponse:(AgentWSSoapBindingResponse *)response
{
    NSArray *responseBodyParts = response.bodyParts;
    if([[response.error localizedDescription] caseInsensitiveCompare:@""] != NSOrderedSame){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alert show];
        [spinnerLoading stopLoadingSpinner];
        if(flagFullSync){
            [loginDB DeleteAgentProfile];
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
            if(flagFullSync){
                [loginDB DeleteAgentProfile];
            }
        }
        
        /****
         * is it AgentWS_ChangePasswordResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_ChangePasswordResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_ChangePasswordResponse* rateResponse = bodyPart;
            if([rateResponse.ChangePasswordResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ubah Password Sukses!"message:[NSString stringWithFormat:@"Password Anda telah berhasil di ubah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                NSString *encryptedPass = [encryptWrapper encrypt:txtNewPwd.text];
                [loginDB updatePassword:encryptedPass];
                [self dismissModalViewControllerAnimated:YES];
            }else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ubah Password Gagal!"message:[NSString stringWithFormat:@"Password Anda gagal di ubah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        /****
         * is it AgentWS_SyncdatareferralResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_SyncdatareferralResponse class]]) {
            [spinnerLoading stopLoadingSpinner];
            AgentWS_SyncdatareferralResponse* rateResponse = bodyPart;
            if([rateResponse.strstatus caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                      rateResponse.SyncdatareferralResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                [self parseXML:root objBuff:returnObj index:0];
                int result = [loginDB ReferralSyncTable:returnObj];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinnerLoading stopLoadingSpinner];
                    [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 4/4"];
                    
                    dispatch_async(dispatch_get_global_queue(
                                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                        NSString *encryptedNewPass = [encryptWrapper encrypt:txtNewPwd.text];
                        NSString *encryptedOldPass = [encryptWrapper encrypt:txtOldPwd.text];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [webservice FirstTimeLogin:self AgentCode:txtAgentCode.text password:encryptedOldPass newPassword:encryptedNewPass UUID:[loginDB getUniqueDeviceIdentifierAsString]];
                        });
                    });
                });
            }else{
                dispatch_async(dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                    NSString *encryptedNewPass = [encryptWrapper encrypt:txtNewPwd.text];
                    NSString *encryptedOldPass = [encryptWrapper encrypt:txtOldPwd.text];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [webservice FirstTimeLogin:self AgentCode:txtAgentCode.text password:encryptedOldPass newPassword:encryptedNewPass UUID:[loginDB getUniqueDeviceIdentifierAsString]];
                    });
                });

            }
        }
        
        
        /****
         * is it AgentWS_LoginAPIResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_LoginAPIResponse class]]) {
            AgentWS_LoginAPIResponse* rateResponse = bodyPart;
            if([rateResponse.LoginAPIResult caseInsensitiveCompare:@"TRUE"]== NSOrderedSame){
                
                [spinnerLoading stopLoadingSpinner];
                [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 1/4"];
                
                flagFullSync = TRUE;
                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                [webservice fullSync:txtAgentCode.text delegate:self];
            }else{
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ubah Password Gagal!" message:[NSString stringWithFormat:@"Username/Password yang di masukan salah"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        /****
         * is it AgentWS_FullSyncTableResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_FullSyncTableResponse class]]) {
            AgentWS_FullSyncTableResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                
                //nested async to avoid ui changes in same queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinnerLoading stopLoadingSpinner];
                    [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 2/4"];
                    
                    dispatch_async(dispatch_get_global_queue(
                                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        flagFullSync = FALSE;
                        // create XMLDocument object
                        DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                              rateResponse.FullSyncTableResult.xmlDetails options:0 error:nil];
                        
                        // Get root element - DataSetMenu for your XMLfile
                        DDXMLElement *root = [xml rootElement];
                        WebResponObj *returnObj = [[WebResponObj alloc]init];
                        [self parseXML:root objBuff:returnObj index:0];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [spinnerLoading stopLoadingSpinner];
                            [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 3/4"];
                            
                            dispatch_async(dispatch_get_global_queue(
                                                                     DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                //we insert/update the table
                                [loginDB fullSyncTable:returnObj];
                                
                                
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                    //we update the referral data serially
                                    WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                                    [webservice dataReferralSync:[loginDB getLastUpdateReferral] delegate:self];
                                 });

                            });
                        });
                    });
                });
                
                [self getHTMLDataTable];
            }else if([rateResponse.strStatus caseInsensitiveCompare:@"False"] == NSOrderedSame){
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Proses Login anda gagal, periksa username dan password anda" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
                [alert show];
            }
        }
        
        /****
         * is it AgentWS_ReceiveFirstLoginResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_ReceiveFirstLoginResponse class]]) {
            AgentWS_ReceiveFirstLoginResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                
                NSString *serverURL = [NSString stringWithFormat:@"%@/Service2.svc/AllocateSpajForAgent?agentCode=%@",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL], [loginDB AgentCodeLocal]];
                
                NSURLSession *session = [NSURLSession sharedSession];
                [[session dataTaskWithURL:[NSURL URLWithString:serverURL]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [spinnerLoading stopLoadingSpinner];
                            });
                            // handle response
                            if(data != nil){
                                NSMutableDictionary* json = [NSJSONSerialization
                                                             JSONObjectWithData:data //1
                                                             options:NSJSONReadingMutableContainers
                                                             error:&error];
                                NSMutableDictionary *ResponseDict = [[NSMutableDictionary alloc]init];
                                NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
                                
                                
                                //set the date
                                NSDate *today = [NSDate date];
                                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                [dateFormat setDateFormat:@"dd/MM/yyyy"];
                                NSString *dateString = [dateFormat stringFromDate:today];
                                
                                [[json valueForKey:@"d"] setValue:dateString forKey:@"CreatedDate"];
                                [[json valueForKey:@"d"] setValue:dateString forKey:@"UpdatedDate"];
                                [[json valueForKey:@"d"] setValue:@"ACTIVE" forKey:@"Status"];
                                [[json valueForKey:@"d"] removeObjectForKey:@"__type"];
                                [jsonArray addObject:[json valueForKey:@"d"]];
                                [ResponseDict setValue:jsonArray forKey:@"SPAJPackNumber"];
                                NSLog(@"%@",ResponseDict);
                                
                                [loginDB insertTableFromJSON:ResponseDict databasePath:@"hladb.sqlite"];
                               
                            }else{
                               
                            }
                        }] resume];

                
                flagFirstLogin = false;
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:rateResponse.ReceiveFirstLoginResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                [self parseXML:root objBuff:returnObj index:0];
                if([loginDB fullSyncTable:returnObj]){
                    [loginDB updateLoginDate];
                    [self gotoCarousel];
                }
            }else if([rateResponse.strStatus caseInsensitiveCompare:@"False"] == NSOrderedSame){
                [spinnerLoading stopLoadingSpinner];
                [loginDB DeleteAgentProfile];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Username/Password yang di masukan salah" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
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
            if([[DataSetMenuElement name] caseInsensitiveCompare:@"xs:element"]!=NSOrderedSame){
                NSArray *elements = [root elementsForName:[DataSetMenuElement name]];
                if([[[elements objectAtIndex:0]stringValue] caseInsensitiveCompare:@""] != NSOrderedSame){
                    NSString *tableName = [NSString stringWithFormat:@"%@&%d",[[[DataSetMenuElement parent] parent]name], index];
                    [obj addRow:tableName columnNames:[[DataSetMenuElement parent]name] data:[[elements objectAtIndex:0]stringValue]];
                }else{
                    NSString *tableName = [NSString stringWithFormat:@"%@&%d",[[DataSetMenuElement parent]name], index];
                    [obj addRow:tableName columnNames:[DataSetMenuElement name] data:[[elements objectAtIndex:0]stringValue]];
                }
            }
        }else{
            DDXMLNode *name = [DataSetMenuElement attributeForName: @"diffgr:id"];
            if(name != nil){
                index++;
            }
        }
        [self parseXML:DataSetMenuElement objBuff:obj index:index];
    }
}


- (BOOL) isPasswordLegal:(NSString*) password
{
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    
    BOOL lower = [password rangeOfCharacterFromSet:lowerCaseChars].location != NSNotFound;
    BOOL upper = [password rangeOfCharacterFromSet:upperCaseChars].location != NSNotFound;
    BOOL numb = [password rangeOfCharacterFromSet:numbers].location != NSNotFound;
    
    if ( lower && upper && numb )
    {
        NSLog(@"ok this password is ok");
        return true;
    }else
    {
        NSLog(@"this password not ok");
        return false;
    }
}



- (IBAction)btnCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnDone:(id)sender {
    bool valid;
    bool passwordValid = [self isPasswordLegal:txtNewPwd.text];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([txtOldPwd.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length <= 0 ) {
        
        valid = FALSE;
        [self hideKeyboard];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password lama harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 10;
        [alert show];
        //[txtOldPwd becomeFirstResponder];
        
    }
    else {
        if ([txtNewPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""  ].length <= 0) {
            valid = FALSE;
            [self hideKeyboard];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password baru harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 11;
            [alert show];
            //[txtNewPwd becomeFirstResponder];
        }
        else {
            if ([txtConfirmPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""  ].length <= 0) {
                valid = FALSE;
                [self hideKeyboard];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Confirm password harap di isi" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 12;
                [alert show];
                //[txtConfirmPwd becomeFirstResponder];
                
            }
            else {
                valid = TRUE;
                
            }
        }
    }
    
    if(valid == TRUE) {
        
        if(passwordValid)
        {
            if (txtNewPwd.text.length < 6 ) {
                [self hideKeyboard];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                message:@"Password baru minimal 6 karakter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                txtNewPwd.text = @"";
                txtConfirmPwd.text = @"";
                alert.tag = 03;
                [alert show];
                //[txtNewPwd becomeFirstResponder];
                
            }
            else {
                if (txtNewPwd.text.length > 20) {
                    [self hideKeyboard];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                                    message:@"Password baru minimal 6 karakter" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    txtNewPwd.text = @"";
                    txtConfirmPwd.text = @"";
                    alert.tag = 03;
                    [alert show];
                }
                else {
                    if ([txtNewPwd.text isEqualToString:txtConfirmPwd.text]) {
                        [self validatePassword];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Password baru tidak sesuai dengan Confirm password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        txtNewPwd.text = @"";
                        txtConfirmPwd.text = @"";
                    }
                }
            }
        }else
        {
            [self hideKeyboard];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"The password must be in a combination of lowercase, uppercase and numbers." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 03;
            [alert show];
            txtNewPwd.text = @"";
            txtConfirmPwd.text = @"";
        }
        
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 01) {
        if (buttonIndex == 0) {
            
            Login *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    }else
        if (alertView.tag == 10) {
            [txtOldPwd becomeFirstResponder];
        }else
            if (alertView.tag == 11) {
                [txtNewPwd becomeFirstResponder];
            }else
                if (alertView.tag == 12) {
                    [txtConfirmPwd becomeFirstResponder];
                }else
                    if (alertView.tag == 03) {
                        [txtNewPwd becomeFirstResponder];
                    }
    
}
- (IBAction)btnTips:(id)sender {
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_PasswordTips == Nil) {
        self.PasswordTips = [self.storyboard instantiateViewControllerWithIdentifier:@"Tip"];
        _PasswordTips.delegate = self;
        self.PasswordTipPopover = [[UIPopoverController alloc] initWithContentViewController:_PasswordTips];
        
    }
    [self.PasswordTipPopover setPopoverContentSize:CGSizeMake(1050, 330)];
    [self.PasswordTipPopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)DisplayTips{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_PasswordTips == Nil) {
        self.PasswordTips = [self.storyboard instantiateViewControllerWithIdentifier:@"Tip"];
        _PasswordTips.delegate = self;
        self.PasswordTipPopover = [[UIPopoverController alloc] initWithContentViewController:_PasswordTips];
        
    }
    [self.PasswordTipPopover setPopoverContentSize:CGSizeMake(1050, 330)];
    [self.PasswordTipPopover presentPopoverFromRect:[lblTips frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)CloseWindow{
    //NSLog(@"received");
    [self.PasswordTipPopover dismissPopoverAnimated:YES];
}

#pragma mark gethtml table
-(void)getHTMLDataTable{
    CFFAPIController* cffAPIController;
    cffAPIController = [[CFFAPIController alloc]init];
    
    NSArray* arrayJSONKey = [[NSArray alloc]initWithObjects:@"CFFId",@"FileName",@"Status",@"CFFSection",@"FolderName", nil];
    NSArray* tableColumn= [[NSArray alloc]initWithObjects:@"CFFID",@"CFFHtmlName",@"CFFHtmlStatus",@"CFFHtmlSection", nil];
    NSDictionary *dictCFFTable = [[NSDictionary alloc]initWithObjectsAndKeys:@"CFFHtml",@"tableName",tableColumn,@"columnName", nil];
    
    NSMutableDictionary* dictDuplicateChecker = [[NSMutableDictionary alloc]init];
    [dictDuplicateChecker setObject:@"CFFHtmlID" forKey:@"DuplicateCheckerColumnName"];
    [dictDuplicateChecker setObject:@"CFFHtml" forKey:@"DuplicateCheckerTableName"];
    [dictDuplicateChecker setObject:@"CFFID" forKey:@"DuplicateCheckerWhere1"];
    [dictDuplicateChecker setObject:@"CFFHtmlName" forKey:@"DuplicateCheckerWhere2"];
    [dictDuplicateChecker setObject:@"CFFHtmlStatus" forKey:@"DuplicateCheckerWhere3"];
    [dictDuplicateChecker setObject:@"CFFHtmlSection" forKey:@"DuplicateCheckerWhere4"];
    
    //[cffAPIController apiCallHtmlTable:@"http://mposws.azurewebsites.net/Service2.svc/getAllData" JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"CFF"];
    NSString* stringURL = [NSString stringWithFormat:@"%@/Service2.svc/GetAllData",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    [cffAPIController apiCallHtmlTable:stringURL JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"CFF"];
}

-(void)getCFFHTMLFile{
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(createHTMLFile:)
                               withObject:data waitUntilDone:YES];
    });
}

-(void)createHTMLFile:(NSData *)responseData{
    CFFAPIController* cffAPIController;
    cffAPIController = [[CFFAPIController alloc]init];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* arrayFileName = [[json objectForKey:@"d"] valueForKey:@"FileName"]; //2
    for (int i=0;i<[arrayFileName count];i++){
        [cffAPIController apiCallCrateHtmlFile:[NSString stringWithFormat:@"http://mposws.azurewebsites.net/Service2.svc/GetHtmlFile?fileName=%@",[arrayFileName objectAtIndex:i]] RootPathFolder:@"CFFfolder"];
    }
}

@end
