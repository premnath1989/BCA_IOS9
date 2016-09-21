//
//  SettingUserProfile.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 11/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/getAllData"] //2

#import "SettingUserProfile.h"
#import "Login.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SIUtilities.h"
#import "ChangePassword.h"
#import "LoginDatabaseManagement.h"
#import "ProgressBar.h"
#import "SPAJDisNumber.h"

#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLNode.h"

#import "CFFAPIController.h"
@interface SettingUserProfile ()

@end

@implementation SettingUserProfile

@synthesize username, code, name, contactNo ;
@synthesize leaderCode, leaderName, registerNo, email;
@synthesize idRequest, indexNo;
@synthesize btnContractDate,myScrollView;
@synthesize contDate,ICNo,Addr1,Addr2,Addr3, AgentPortalLoginID, AgentPortalPassword;
@synthesize datePopover = _datePopover;
@synthesize DatePicker = _DatePicker;
@synthesize previousElementName, elementName, getLatest;
@synthesize outletChgPassword;
@synthesize outletSave;
@synthesize outletSyncSPAJNumber;
@synthesize txtAgentCode;
@synthesize txtAgentName;
@synthesize txtCabang;
@synthesize txtKanwil;
@synthesize txtKCU;
@synthesize txtChannel;
@synthesize txtDirectSupervisor;
@synthesize txtAgentStatus;
@synthesize txtLicenseStart;
@synthesize txtLicenseEnd;
@synthesize txtAddress1;
@synthesize txtAddress2;
@synthesize txtAddress3;
@synthesize txtMobileNumber;
@synthesize txtEmail;


id temp;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *zzz = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    self.indexNo = zzz.indexNo;
    self.idRequest = zzz.userRequest;
    
    loginDB = [[LoginDBManagement alloc]init];
    agentDetails =[loginDB getAgentDetails];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    spinnerLoading = [[SpinnerUtilities alloc]init];
    [self setValueProperty];
    
    outletSave.layer.cornerRadius = 10.0f;
    outletSave.clipsToBounds = YES;
    
    outletChgPassword.layer.cornerRadius = 10.0f;
    outletChgPassword.clipsToBounds = YES;
    
    txtAddress1.delegate = self;
    txtAddress2.delegate = self;
    txtAddress3.delegate = self;
    
    txtAgentCode.enabled = FALSE;
    txtAgentName.enabled = FALSE;
    btnContractDate.enabled = FALSE;
}

- (void) setValueProperty{
    txtAgentCode.text = [agentDetails valueForKey:@"AgentCode"];
    txtAgentCode.enabled = NO;
    
    txtAgentName.text = [agentDetails valueForKey:@"AgentName"];
    txtAgentName.enabled = NO;
    txtCabang.text = [NSString stringWithFormat:@"%@ - %@",[agentDetails valueForKey:@"BranchCode"], [agentDetails valueForKey:@"BranchName"]];
    txtCabang.enabled = NO;
    txtKanwil.text = [NSString stringWithFormat:@"%@ - %@",[agentDetails valueForKey:@"KanwilCode"], [agentDetails valueForKey:@"Kanwil"]];
    txtKanwil.enabled = NO;
    txtKCU.text = [agentDetails valueForKey:@"KCU"];
    txtKCU.enabled = NO;
    txtChannel.text = [agentDetails valueForKey:@"ChannelName"];
    txtChannel.enabled = NO;
    txtDirectSupervisor.text = [NSString stringWithFormat:@"%@ - %@",[agentDetails valueForKey:@"DirectSupervisorCode"], [agentDetails valueForKey:@"DirectSupervisorName"]];
    txtDirectSupervisor.enabled = NO;
    txtAgentStatus.text = [agentDetails valueForKey:@"AgentStatus"];
    txtAgentStatus.enabled = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *startDate = [dateFormatter dateFromString:[agentDetails valueForKey:@"LicenseStartDate"]];
    NSDate *endDate = [dateFormatter dateFromString:[agentDetails valueForKey:@"LicenseExpiryDate"]];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    
    txtLicenseStart.text = [dateFormatter stringFromDate:startDate];
    txtLicenseStart.enabled = NO;
    txtLicenseEnd.text = [dateFormatter stringFromDate:endDate];
    txtLicenseEnd.enabled = NO;
    txtAddress1.text = [agentDetails valueForKey:@"AgentAddr1"];
    txtAddress1.enabled = NO;
    txtAddress2.text = [agentDetails valueForKey:@"AgentAddr2"];
    txtAddress2.enabled = NO;
    txtAddress3.text = [agentDetails valueForKey:@"AgentAddr3"];
    txtAddress3.enabled = NO;
    txtMobileNumber.text = [agentDetails valueForKey:@"AgentContactNumber"];
    txtMobileNumber.enabled = NO;
    txtEmail.text = [agentDetails valueForKey:@"AgentEmail"];
    txtEmail.enabled = NO;
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
    [self viewExisting];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if ([getLatest isEqualToString:@"Yes"]) { //not need check latest version when user edit on user profile
            NSString *strURL = [NSString stringWithFormat:@"%@eSubmissionWS/eSubmissionXMLService.asmx/"
                                "GetSIVersion_TRADUL?Type=IPAD_TRAD&Remarks=Agency&OSType=32", [SIUtilities WSLogin]];
            NSLog(@"%@", strURL);
            NSURL *url = [NSURL URLWithString:strURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFXMLRequestOperation *operation =
            [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                    
                                                                    XMLParser.delegate = self;
                                                                    [XMLParser setShouldProcessNamespaces:YES];
                                                                    [XMLParser parse];
                                                                    
                                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                                                                    NSLog(@"error in calling web service");
                                                                }];
            
            [operation start];
        }
        
    }
    else if (alertView.tag == 2 && buttonIndex == 0){
        //download latest version
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    @"http://www.hla.com.my/agencyportal/includes/DLrotate2.asp?file=iMP/iMP.plist"]];
        
    }
    else if (alertView.tag == 3){
        exit(0);
    }
}

- (IBAction)ChangePassword:(id)sender
{
    ChangePassword * UserProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwd"];
    [UserProfileView setDelegate:nil firstLogin:false];
    UserProfileView.modalPresentationStyle = UIModalPresentationFormSheet;
    UserProfileView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UserProfileView.preferredContentSize = CGSizeMake(600, 500);
    [UserProfileView setAgentCode:[agentDetails valueForKey:@"AgentCode"]];
    
    [self presentViewController:UserProfileView animated:YES completion:nil];
}

- (IBAction)syncSPAJNumber:(id)sender{
//    NSLog(@"Sync SPAJ Number");
//    [spinnerLoading startLoadingSpinner:self.view label:@"Requesting SPAJ Number"];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[session dataTaskWithURL:[NSURL
//                                   URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/getAllData"]
//                completionHandler:^(NSData *data,
//                                    NSURLResponse *response,
//                                    NSError *error){
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // handle response
//                        [spinnerLoading stopLoadingSpinner];
//                    });
//                }] resume];
//    });
    SPAJDisNumber * SPAJDisNum = [[SPAJDisNumber alloc] initWithNibName:@"SPAJDisNumber" bundle:nil];
    SPAJDisNum.modalPresentationStyle = UIModalPresentationPageSheet;
    SPAJDisNum.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:SPAJDisNum animated:YES completion:nil];
  

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    activeField = textField;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
    
    if (textField == txtAddress1 || textField == txtAddress2 || textField == txtAddress3 ) {
        if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 31) {
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        return YES;
    }
    
    
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 44, 768, 704-352);
    self.myScrollView.contentSize = CGSizeMake(768, 605);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 30;
    
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    activeField = nil;
    activeField = [[UITextField alloc] init ];
    
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 44, 768, 704);
}


#pragma mark - validation

-(BOOL) Validation
{
    
    if ([txtAgentCode.text isEqualToString:@""] || [txtAgentCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Agent Code is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtAgentCode becomeFirstResponder];
        return FALSE;
        
    }
    else {
        if (txtAgentCode.text.length != 8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Invalid Agent Code length. Agent Code length should be exact 8 characters long"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtAgentCode becomeFirstResponder];
            return FALSE;
        }
        
    }
    
    if ([txtAgentName.text isEqualToString:@""] || [txtAgentName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Agent Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtAgentName becomeFirstResponder];
        return FALSE;
        
        
    }
    else {
        
        BOOL valid;
        NSString *strToBeTest = [txtAgentName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] ;
        
        for (int i=0; i<strToBeTest.length; i++) {
            int str1=(int)[strToBeTest characterAtIndex:i];
            
            if((str1 >96 && str1 <123)  || (str1 >64 && str1 <91)){
                valid = TRUE;
                
            }else {
                valid = FALSE;
                break;
            }
        }
        if (!valid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Agent name is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtAgentName becomeFirstResponder];
            return false;
        }
    }
    
    if(![[txtMobileNumber.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@"" ]){
        if (txtMobileNumber.text.length > 11) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Contact number length must be less than 11 digits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtMobileNumber becomeFirstResponder ];
            return false;
        }
        
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtMobileNumber.text];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (!valid) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Contact number must be numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtMobileNumber becomeFirstResponder];
            return false;
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Agent's Contact No is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtMobileNumber becomeFirstResponder];
        return false;
    }
    
    if (![[txtDirectSupervisor.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        if (txtDirectSupervisor.text.length != 8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"Invalid Immediate Leader Code length. Immediate Leader Code length should be 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtDirectSupervisor becomeFirstResponder];
            return false;
        }
    }
    
    if (contDate.length == 0 || [self.btnContractDate.titleLabel.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Agent's Contract Date is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if ([[txtAddress1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Agent's Correspendence Address is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtAddress1 becomeFirstResponder];
        return false;
    }
    //end
    
    if (![[txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        if( [self NSStringIsValidEmail:txtEmail.text] == FALSE ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:@"You have entered an invalid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtEmail becomeFirstResponder];
            return FALSE;
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Email is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtEmail becomeFirstResponder];
        return FALSE;
    }
    return TRUE;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - action

- (IBAction)btnClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES ];
}


- (IBAction)btnSync:(id)sender { //no longer using
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 1/3"];
    WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
    [webservice fullSync:txtAgentCode.text delegate:self];}

//here is our function for every response from webservice
- (void) operation:(AgentWSSoapBindingOperation *)operation
completedWithResponse:(AgentWSSoapBindingResponse *)response
{
    NSArray *responseBodyParts = response.bodyParts;
    if([[response.error localizedDescription] caseInsensitiveCompare:@""] != NSOrderedSame){[spinnerLoading stopLoadingSpinner];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alert show];
    }
    for(id bodyPart in responseBodyParts) {
        
        /****
         * SOAP Fault Error
         ****/
        if ([bodyPart isKindOfClass:[SOAPFault class]]) {
            
            [spinnerLoading stopLoadingSpinner];
            //You can get the error like this:
            NSString* errorMesg = ((SOAPFault *)bodyPart).simpleFaultString;
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Please check your connection" message:errorMesg delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
            [alert show];
        }
        else if([bodyPart isKindOfClass:[AgentWS_PartialSyncResponse class]]) {
            
        }
        
        /****
         * is it AgentWS_FullSyncTableResponse
         ****/
        else if([bodyPart isKindOfClass:[AgentWS_FullSyncTableResponse class]]) {
            AgentWS_FullSyncTableResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                      rateResponse.FullSyncTableResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                
                //nested async to avoid ui changes in same queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinnerLoading stopLoadingSpinner];
                    [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 2/3"];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self parseXML:root objBuff:returnObj index:0];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [spinnerLoading stopLoadingSpinner];
                            [spinnerLoading startLoadingSpinner:self.view label:@"Sync sedang berjalan 3/3"];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                [self getSPAJHTMLDataTable];
            }else if([rateResponse.strStatus caseInsensitiveCompare:@"False"] == NSOrderedSame){
                [spinnerLoading stopLoadingSpinner];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Proses Login anda gagal" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
                [alert show];
            }
        }
        
        else if([bodyPart isKindOfClass:[AgentWS_CheckVersionResponse class]]) {
            AgentWS_CheckVersionResponse* rateResponse = bodyPart;
            if([rateResponse.strStatus caseInsensitiveCompare:@"True"] == NSOrderedSame){
                // create XMLDocument object
                DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:
                                      rateResponse.CheckVersionResult.xmlDetails options:0 error:nil];
                
                // Get root element - DataSetMenu for your XMLfile
                DDXMLElement *root = [xml rootElement];
                WebResponObj *returnObj = [[WebResponObj alloc]init];
                [self parseXML:root objBuff:returnObj index:0];
                //                 for(dataCollection *data in [returnObj getDataWrapper]){
                //                 }
                //partialsync
                NSString *xmlDummy = @"<?xml version='1.0'?><!-- This is a sample XML document --><Master><SyncDate>2016-02-25</SyncDate><TableName>Data_Cabang</TableName><TableName>eProposal_Credit_Card_Bank</TableName><TableName>eProposal_Identification</TableName></Master>";
                WebServiceUtilities *webservice = [[WebServiceUtilities alloc]init];
                [webservice partialSync:@"1024" delegate:self xml:xmlDummy];
            }else{
                NSLog(@"same version");
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
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Sync telah selesai" message:@"" delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
                    [alert show];
                });
                
            }else{
                
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

- (IBAction)btnDone:(id)sender {
    [loginDB updateLogoutDate];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil];
    Login *mainLogin = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login"];
    mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
    mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainLogin animated:YES completion:nil];
}

- (IBAction)btnContractDatePressed:(id)sender     //--bob
{
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    
    if (contDate.length==0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [btnContractDate setTitle:dateString forState:UIControlStateNormal];
        temp = btnContractDate.titleLabel.text;
    }
    else {
        temp = btnContractDate.titleLabel.text;
    }
    contDate = temp;
    
    if (_DatePicker == Nil) {
        
        self.DatePicker = [self.storyboard instantiateViewControllerWithIdentifier:@"showDate"];
        _DatePicker.delegate = self;
        _DatePicker.msgDate = temp;
        self.datePopover = [[UIPopoverController alloc] initWithContentViewController:_DatePicker];
    }
    
    [self.datePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.datePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    if (aDate == NULL) {
        [btnContractDate setTitle:temp forState:UIControlStateNormal];
        contDate = temp;
    }
    else {
        [self.btnContractDate setTitle:aDate forState:UIControlStateNormal];
        contDate = aDate;
    }
    NSLog(@"date:%@",contDate);
    
    [self.datePopover dismissPopoverAnimated:YES];
}


#pragma mark - XML parser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict  {
    
    self.previousElementName = self.elementName;
    
    if (qName) {
        self.elementName = qName;
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName){
        return;
    }
    
    if([self.elementName isEqualToString:@"LoginError"]){
        
        if ([string isEqualToString:@""]) {
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@" "
                                                              message:@"Record saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            success.tag = 1;
            [success show];
            
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat: @"UPDATE Agent_Profile set AgentStatus = \"1\" WHERE "
                                      "AgentLoginID=\"hla\" "];
                /* NSString *querySQL = [NSString stringWithFormat: @"UPDATE User_Profile set AgentStatus = \"1\" WHERE "
                 "AgentLoginID=\"hla\" "];*/
                
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
        else if ([string isEqualToString:@"Account suspended."]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"Your Account is suspended. Please contact Hong Leong Assurance."]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 3;
            [alert show];
            
            alert = Nil;
            
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
            {
                /*NSString *querySQL = [NSString stringWithFormat: @"UPDATE User_Profile set AgentStatus = \"0\" WHERE "
                 "AgentLoginID=\"hla\" "];*/
                NSString *querySQL = [NSString stringWithFormat: @"UPDATE Agent_Profile set AgentStatus = \"0\" WHERE "
                                      "AgentLoginID=\"hla\" "];
                
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
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:string delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            
            [alert show];
            
        }
        
    }
    
    else if([self.elementName isEqualToString:@"BadAttempts"]){
        
    }
    
    else if([self.elementName isEqualToString:@"string"]){
        
        NSString *strURL = [NSString stringWithFormat:@"%@",  string];
        NSLog(@"%@", strURL);
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFXMLRequestOperation *operation =
        [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                
                                                                XMLParser.delegate = self;
                                                                [XMLParser setShouldProcessNamespaces:YES];
                                                                [XMLParser parse];
                                                                
                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                                                                NSLog(@"error in calling web service");
                                                            }];
        
        [operation start];
    }
    else if ([self.elementName isEqualToString:@"SITradVersion"]){
        NSString * AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        
        if (![string isEqualToString:AppsVersion]) {
            NSLog(@"latest version is available %@", AppsVersion);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"Latest version is available for download. Do you want to download now ? "]
                                                           delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            alert.tag = 2;
            [alert show];
            alert = Nil;
        }
        NSLog(@"%@", string);
    }
    else if ([self.elementName isEqualToString:@"DLURL"]){
        NSLog(@"%@", string);
    }
    else if ([self.elementName isEqualToString:@"DLFilename"]){
        NSLog(@"%@", string);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.elementName = nil;
}

-(void) parserDidEndDocument:(NSXMLParser *)parser {
    
}

#pragma mark - sqlite DB

-(void)viewExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT IndexNo, AgentLoginID, AgentCode, AgentName, AgentContactNo, "
                              "ImmediateLeaderCode, ImmediateLeaderName, BusinessRegNumber, AgentEmail, AgentICNo, "
                              "AgentContractDate, AgentAddr1, AgentAddr2, AgentAddr3, AgentPortalLoginID, AgentPortalPassword "
                              "FROM Agent_Profile WHERE IndexNo=\"%d\"",
                              self.indexNo];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                username = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                const char *code2 = (const char*)sqlite3_column_text(statement, 2);
                code = code2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:code2];
                
                const char *name2 = (const char*)sqlite3_column_text(statement, 3);
                name = name2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:name2];
                
                const char *contactNo2 = (const char*)sqlite3_column_text(statement, 4);
                contactNo = contactNo2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:contactNo2];
                
                const char *leaderCode2 = (const char*)sqlite3_column_text(statement, 5);
                leaderCode = leaderCode2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:leaderCode2];
                
                const char *leaderName2 = (const char*)sqlite3_column_text(statement, 6);
                leaderName = leaderName2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:leaderName2];
                
                const char *register2 = (const char*)sqlite3_column_text(statement, 7);
                registerNo = register2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:register2];
                
                const char *email2 = (const char*)sqlite3_column_text(statement, 8);
                email = email2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:email2];
                
                const char *ic = (const char*)sqlite3_column_text(statement, 9);
                ICNo = ic == NULL ? @"" : [[NSString alloc] initWithUTF8String:ic];
                
                const char *date = (const char*)sqlite3_column_text(statement, 10);
                contDate = date == NULL ? @"" : [[NSString alloc] initWithUTF8String:date];
                
                const char *add1 = (const char*)sqlite3_column_text(statement, 11);
                Addr1 = add1 == NULL ? @"" : [[NSString alloc] initWithUTF8String:add1];
                
                const char *add2 = (const char*)sqlite3_column_text(statement, 12);
                Addr2 = add2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:add2];
                
                const char *add3 = (const char*)sqlite3_column_text(statement, 13);
                Addr3 = add3 == NULL ? @"" : [[NSString alloc] initWithUTF8String:add3];
                
                const char *temp1 = (const char*)sqlite3_column_text(statement, 14);
                AgentPortalLoginID = temp1 == NULL ? @"" : [[NSString alloc] initWithUTF8String:temp1];
                
                const char *temp2 = (const char*)sqlite3_column_text(statement, 15);
                AgentPortalPassword = temp2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:temp2];
                
                
                txtAgentCode.text = code;
                txtAgentName.text = name;
                txtEmail.text = email;
                
                [btnContractDate setTitle:contDate forState:UIControlStateNormal];
                
                
            } else {
                NSLog(@"Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


#pragma mark - memory release

- (void)viewDidUnload
{
    [self setAddr1:nil];
    [self setAddr2:nil];
    [self setAddr3:nil];
    [self setContDate:nil];
    [self setICNo:nil];
    [self setTxtICNo:nil];
    [self setBtnContractDate:nil];
    [self setMyScrollView:nil];
    [self setTxtAgentCode:nil];
    [self setTxtAgentName:nil];
    [self setTxtEmail:nil];
    [self setOutletSave:nil];
    [super viewDidUnload];
}

//-(void)updateUserData
//{
//    if([self Validation] == TRUE){
//        const char *dbpath = [databasePath UTF8String];
//        sqlite3_stmt *statement;
//
//
//        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
//        {
//
//            NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentCode= \"%@\", AgentName= \"%@\", "
//								  "AgentContactNo= \"%@\", ImmediateLeaderCode= \"%@\", ImmediateLeaderName= \"%@\", "
//								  "BusinessRegNumber = \"%@\", AgentEmail= \"%@\", AgentICNo=\"%@\", AgentContractDate=\"%@\", "
//								  "AgentAddr1=\"%@\", AgentAddr2=\"%@\", AgentAddr3=\"%@\", AgentPortalLoginID = \"%@\", "
//								  "AgentPortalPassword = \"%@\" WHERE IndexNo=\"%d\"",
//								  txtAgentCode.text, txtAgentName.text, txtAgentContactNo.text, txtLeaderCode.text,
//								  txtLeaderName.text,txtBixRegNo.text,txtEmail.text,txtICNo.text, contDate, txtAddr1.text,
//								  txtAddr2.text, txtAddr3.text, txtAgencyPortalLogin.text, txtAgencyPortalPwd.text, self.indexNo];
//
//
//            const char *query_stmt = [querySQL UTF8String];
//            
//            //NSLog(@"%@",querySQL);
//            
//            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
//            {
//                if (sqlite3_step(statement) == SQLITE_DONE)
//                {
//                    
//                    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@" "
//                                                                      message:@"Record saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
//                    success.tag = 1;
//                    [success show];
//					 
//                    
//                } else {
//                    //lblStatus.text = @"Failed to update!";
//                    //lblStatus.textColor = [UIColor redColor];
//                    
//                }
//                sqlite3_finalize(statement);
//            }
//            sqlite3_close(contactDB);
//        }
//		
//		//[self CheckAgentPortal];
//    }
//}


//-(void)CheckAgentPortal{
//	NSString *strURL = [NSString stringWithFormat:@"%@eSubmissionWS/eSubmissionXMLService.asmx/"
//									"ValidateLogin?strid=%@&strpwd=%@&strIPAddres=123&iBadAttempts=0&strFirstAgentCode=%@",
//						[SIUtilities WSLogin], txtAgencyPortalLogin.text, txtAgencyPortalPwd.text, txtAgentCode.text];
//
//		NSLog(@"%@", strURL);
//		NSURL *url = [NSURL URLWithString:strURL];
//		NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
//
//		AFXMLRequestOperation *operation =
//		[AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
//		 													success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
//			 													XMLParser.delegate = self;
//			 														[XMLParser setShouldProcessNamespaces:YES];
//			 														[XMLParser parse];
//
//			 													} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
//				 													NSLog(@"error in calling web service");
//																	UIAlertView *success = [[UIAlertView alloc] initWithTitle:@" "
//																													  message:@"Record saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
//																	success.tag = 1;
//																	[success show];
//																}];
//
//		[operation start];
//}


#pragma mark gethtml table
-(void)getHTMLDataTable{
    CFFAPIController* cffAPIController;
    cffAPIController = [[CFFAPIController alloc]init];
    
    NSArray* arrayJSONKey = [[NSArray alloc]initWithObjects:@"CFFId",@"FileName",@"Status",@"CFFSection",@"FolderName",@"Id" ,nil];
    NSArray* tableColumn= [[NSArray alloc]initWithObjects:@"CFFID",@"CFFHtmlName",@"CFFHtmlStatus",@"CFFHtmlSection",@"CFFServerID", nil];
    NSDictionary *dictCFFTable = [[NSDictionary alloc]initWithObjectsAndKeys:@"CFFHtml",@"tableName",tableColumn,@"columnName", nil];
    
    NSMutableDictionary* dictDuplicateChecker = [[NSMutableDictionary alloc]init];
    [dictDuplicateChecker setObject:@"CFFHtmlID" forKey:@"DuplicateCheckerColumnName"];
    [dictDuplicateChecker setObject:@"CFFHtml" forKey:@"DuplicateCheckerTableName"];
    [dictDuplicateChecker setObject:@"CFFID" forKey:@"DuplicateCheckerWhere1"];
    [dictDuplicateChecker setObject:@"CFFHtmlName" forKey:@"DuplicateCheckerWhere2"];
    [dictDuplicateChecker setObject:@"CFFHtmlStatus" forKey:@"DuplicateCheckerWhere3"];
    [dictDuplicateChecker setObject:@"CFFHtmlSection" forKey:@"DuplicateCheckerWhere4"];
    [dictDuplicateChecker setObject:@"CFFServerID" forKey:@"DuplicateCheckerWhere5"];
    
    NSString* stringURL = [NSString stringWithFormat:@"%@/Service2.svc/GetAllData",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    [cffAPIController apiCallHtmlTable:stringURL JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"CFF"];
    //[cffAPIController apiCallHtmlTable:@"http://mpos-sino-uat.cloudapp.net/Service2.svc/getAllData" JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"CFF"];
}

-(void)getSPAJHTMLDataTable{
    CFFAPIController* cffAPIController;
    cffAPIController = [[CFFAPIController alloc]init];
    
    NSArray* arrayJSONKey = [[NSArray alloc]initWithObjects:@"SPAJId",@"FileName",@"Status",@"SPAJSection",@"FolderName",@"Id", nil];
    NSArray* tableColumn= [[NSArray alloc]initWithObjects:@"SPAJID",@"SPAJHtmlName",@"SPAJHtmlStatus",@"SPAJHtmlSection",@"SPAJServerID", nil];
    NSDictionary *dictCFFTable = [[NSDictionary alloc]initWithObjectsAndKeys:@"SPAJHtml",@"tableName",tableColumn,@"columnName", nil];
    
    NSMutableDictionary* dictDuplicateChecker = [[NSMutableDictionary alloc]init];
    [dictDuplicateChecker setObject:@"SPAJHtmlID" forKey:@"DuplicateCheckerColumnName"];
    [dictDuplicateChecker setObject:@"SPAJHtml" forKey:@"DuplicateCheckerTableName"];
    [dictDuplicateChecker setObject:@"SPAJID" forKey:@"DuplicateCheckerWhere1"];
    [dictDuplicateChecker setObject:@"SPAJHtmlName" forKey:@"DuplicateCheckerWhere2"];
    [dictDuplicateChecker setObject:@"SPAJHtmlStatus" forKey:@"DuplicateCheckerWhere3"];
    [dictDuplicateChecker setObject:@"SPAJHtmlSection" forKey:@"DuplicateCheckerWhere4"];
    [dictDuplicateChecker setObject:@"SPAJServerID" forKey:@"DuplicateCheckerWhere5"];
    
    NSString* stringURL = [NSString stringWithFormat:@"%@/SPAJHTMLForm.svc/GetAllData",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    [cffAPIController apiCallHtmlTable:stringURL JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"SPAJ"];
    //[cffAPIController apiCallHtmlTable:@"http://mpos-sino-uat.cloudapp.net/SPAJHTMLForm.svc/GetAllData" JSONKey:arrayJSONKey TableDictionary:dictCFFTable DictionaryDuplicateChecker:dictDuplicateChecker WebServiceModule:@"SPAJ"];
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
        [cffAPIController apiCallCrateHtmlFile:[NSString stringWithFormat:@"%@/Service2.svc/GetHtmlFile?fileName=%@",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL],[arrayFileName objectAtIndex:i]] RootPathFolder:@"CFFfolder"];
    }
}
@end
