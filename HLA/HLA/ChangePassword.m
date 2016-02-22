//
//  ChangePassword.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ChangePassword.h"
#import "Login.h"
#import "AppDelegate.h"
#import "WebServiceUtilities.h"
#import "CarouselViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    CarouselViewController *carouselMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"carouselView"];
    carouselMenu.getInternet = @"No";
    [self presentViewController:carouselMenu animated:YES completion:Nil];
}
- (void) initLoadingSpinner{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    indicator.center = self.view.center;
    indicator.layer.cornerRadius = 05;
    indicator.opaque = NO;
    indicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [indicator setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Receive userID:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    btnBarDone.enabled = NO;
    [btnBarDone setTintColor: [UIColor clearColor]];
    [self initLoadingSpinner];

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
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentPassword= \"%@\" WHERE IndexNo=\"%d\"",txtNewPwd.text,self.userID];
        
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
    
    if(valid == TRUE) {
        
        if (txtNewPwd.text.length < 6 || txtNewPwd.text.length > 20 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Password Baru paling pendek 6 karakter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtNewPwd becomeFirstResponder];
        }
        else {
            if ([txtNewPwd.text isEqualToString:txtConfirmPwd.text]) {
                [indicator startAnimating];
                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                if(flagFirstLogin){
                    [webservice FirstTimeLogin:loginDelegate AgentCode:txtAgentCode.text password:txtOldPwd.text newPassword:txtNewPwd.text UUID:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
                }else{
                    [webservice chgPassword:self AgentCode:txtAgentCode.text password:txtOldPwd.text newPassword:txtNewPwd.text UUID:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
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
    [indicator stopAnimating];
    NSArray *responseBodyParts = response.bodyParts;
    if([[response.error localizedDescription] caseInsensitiveCompare:@""] != NSOrderedSame){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alert show];
    }
    for(id bodyPart in responseBodyParts) {
        
        /****
         * SOAP Fault Error
         ****/
        if ([bodyPart isKindOfClass:[SOAPFault class]]) {
            
            //You can get the error like this:
            NSString* errorMesg = ((SOAPFault *)bodyPart).simpleFaultString;
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Please check your connection" message:errorMesg delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
            [alert show];
        }
        
        /****
         * is it AgentWS_ChangePasswordResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_ChangePasswordResponse class]]) {
            AgentWS_ChangePasswordResponse* rateResponse = bodyPart;
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ubah Password Sukses!"message:[NSString stringWithFormat:@"%@ Password Anda telah berhasil di ubah",rateResponse.ChangePasswordResult] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
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
	
    /*
     if (txtOldPwd.text.length <= 0 || txtNewPwd.text.length <= 0 || txtConfirmPwd.text.length <= 0) {
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please fill up all field!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     
     }
     */
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
                    //[txtNewPwd becomeFirstResponder];
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

@end
