//
//  CarouselViewController.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/10/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CarouselViewController.h"
#import "SIListing.h"
#import "ProspectListing.h"
#import "MainScreen.h"
#import "Login.h"
#import "NewLAViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "eBrochureViewController.h"
#import "eBrochureListingViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "eSubmission.h"
#import "CustomerProfile.h"
#import "SettingUserProfile.h"
#import "SIUtilities.h"
#import "MainClient.h"
#import "MainCustomer.h"
#import "MaineApp.h"
#import <AdSupport/ASIdentifierManager.h>
#import "ClearData.h"

const int numberOfModule = 7;

@interface CarouselViewController ()<UIActionSheetDelegate>{
    
}

@end

@implementation CarouselViewController
@synthesize elementName, previousElementName, getInternet, getValid, indexNo, ErrorMsg,outletNavBar, outletClientProfile, outletCustomerFF, outletEAPP,outletSI;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews {
    [outletNavBar setBackgroundImage:[UIImage imageNamed:@"NewHLAHeader.png"] forBarMetrics:UIBarMetricsDefault];
    CGRect frame = CGRectMake(0, 20, 1024, 60);
    [outletNavBar setFrame:frame];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundWithBox.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn addTarget:self action:@selector(goToHome:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"house.png"] forState:UIControlStateNormal];
    exitBtn.frame = CGRectMake(980.1, 17, 27.0, 29.0);
    [outletNavBar addSubview:exitBtn];
    
    NSString *version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(3, 670, 600, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    
#ifdef UAT_BUILD
    label.text =[NSString stringWithFormat:@"App Version : %@ b%@ UAT",version, build];
#else
    label.text =[NSString stringWithFormat:@"App Version : %@ b%@",version, build];
#endif
    [self.view addSubview:label];
    
    UILabel  * labelbg = [[UILabel alloc] initWithFrame:CGRectMake(0, 670, 300, 50)];
    labelbg.backgroundColor = [UIColor grayColor];
    labelbg.alpha =0.3;
    labelbg.numberOfLines=0;
    labelbg.lineBreakMode=NSLineBreakByWordWrapping;
    [self.view addSubview:labelbg];

    
    NSString *id = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    UILabel  * label1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 700, 600, 50)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor=[UIColor blackColor];
    label1.numberOfLines=0;
    label1.lineBreakMode=NSLineBreakByWordWrapping;
    label1.text =[NSString stringWithFormat:@"Ad Id : %@",id];
    
    UILabel  * label2 = [[UILabel alloc] initWithFrame:CGRectMake(3, 640, 600, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor=[UIColor blackColor];
    label2.numberOfLines=0;
    label2.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSString *string =[SIUtilities WSLogin];
    
    if ([string rangeOfString:@"echannel.dev"].location == NSNotFound) {
        label2.text =[NSString stringWithFormat:@"App type : Production"];
    } else {
        label2.text =[NSString stringWithFormat:@"App type : Development"];
    }
    
    int width = 128;
    int height = 160;
    int positionY = 310;
    
    [outletClientProfile setFrame:CGRectMake(420, positionY, width, height)];
    [outletCustomerFF setFrame:CGRectMake(565, positionY, width, height)];
    [outletSI setFrame:CGRectMake(715, positionY, width, height)];
    [outletEAPP setFrame:CGRectMake(860, 300, width, 160)]; // EAPP words consist of one line only
}

#ifdef UAT_BUILD
- (NSString *) getAgentCode {
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"hladb.sqlite"];
    sqlite3 *hladb;
    NSString *ac;
    if (sqlite3_open([databasePath UTF8String ], &hladb) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"select agentCode FROM agent_profile"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(hladb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                ac = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
            sqlite3_close(hladb);
        }
        
    }
    return ac;
}
#endif

- (void)goToHome:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    NSString *URLEncodedText = [self encodeToPercentEscapeString:@"hlafast"];
    NSString *ourPath = [@"com.hla.fast://" stringByAppendingString:URLEncodedText];
    
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    
    if ([app canOpenURL:ourURL]) {
        [app openURL:ourURL];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HLA FAST" message:@"HLA FAST is not installed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
        [alertView show];
    }
    
}

-(NSString*) encodeToPercentEscapeString:(NSString *)string
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) string,
                                                                                 NULL,
                                                                                 (CFStringRef) @"!*'();:@&+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



-(void)viewDidAppear:(BOOL)animated{
    AppDelegate *appDele= (AppDelegate*)[[UIApplication sharedApplication] delegate ];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults boolForKey:@"Terminated"]) {
        if(appDele.checkLoginStatus == YES) {
            UIApplication *app = [UIApplication sharedApplication];
            NSURL *hlafastUrl = [NSURL URLWithString:[@"com.hla.fast://" stringByAppendingString:[@"imsLoginAssistant" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            if ([app canOpenURL:hlafastUrl]) {
                [app openURL:hlafastUrl];
            } else {
         //       [self showDialogAppLaunchWithHLAFast];
            }
        }
    }
}

-(void) showDialogAppLaunchWithHLAFast {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HLA FAST not installed"
                                                    message:@"Please install HLA FAST to continue using this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
    alert.tag = 1001;
    [alert show];
    alert = Nil;
}

- (void)ActionExit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: NSLocalizedString(@" ",nil)
                          message: NSLocalizedString(@"Are you sure you want to exit?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                          otherButtonTitles: NSLocalizedString(@"No",nil), nil];
    
	alert.tag = 0;
    [alert show ];
    alert = Nil;
}

#pragma mark - XML parser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict  {
    self.previousElementName = self.elementName;
    if (qName) {
        self.elementName = qName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName) {
        return;
    }
	
	if([self.elementName isEqualToString:@"string"]) {
		NSString *strURL = [NSString stringWithFormat:@"%@",  string];
		NSURL *url = [NSURL URLWithString:strURL];
		NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:20];
        
		AFXMLRequestOperation *operation =
		[AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
															success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
																
																XMLParser.delegate = self;
																[XMLParser setShouldProcessNamespaces:YES];
																[XMLParser parse];
																
															} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
															}];
		
		[operation start];
	} else if ([self.elementName isEqualToString:@"SITradVersion"]){
		NSString * AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
		if (![string isEqualToString:AppsVersion]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:[NSString stringWithFormat:@"Latest version is available for download. Do you want to download now ?"]
                                                           delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
			alert.tag = 2;
			[alert show];			
			alert = Nil;
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	self.elementName = nil;
}


-(void) parserDidEndDocument:(NSXMLParser *)parser {	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        exit(0);
    } else {
        if (buttonIndex == 0 && alertView.tag == 0 ) {
            [self updateDateLogout];
            
            Login *mainLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
            mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:mainLogin animated:YES completion:nil];
            
        } else if (buttonIndex == 0 && alertView.tag == 1) {
            SettingUserProfile * UserProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingUserProfile"];
            UserProfileView.modalPresentationStyle = UIModalPresentationPageSheet;
            UserProfileView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UserProfileView.indexNo = self.indexNo;
            UserProfileView.getLatest = @"Yes";
            [self presentViewController:UserProfileView animated:YES completion:nil];
            
            UserProfileView.view.superview.frame = CGRectMake(150, 50, 700, 748);
            UserProfileView = nil;
            
        } else if (buttonIndex == 0 && alertView.tag == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        @"http://www.hla.com.my/agencyportal/includes/DLrotate2.asp?file=iMP/iMP.plist"]];
        } else if (alertView.tag == 3){
            AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            MainScreen *mainScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            if (buttonIndex == 0) {
                mainScreen.tradOrEver = @"TRAD";
                mainScreen.modalPresentationStyle = UIModalPresentationFullScreen;
                mainScreen.IndexTab = appdlg.SIListingIndex;
                [self presentViewController:mainScreen animated:NO completion:Nil];
                mainScreen= Nil;
                appdlg = nil;
                
            } else {
                mainScreen.tradOrEver = @"EVER";
                mainScreen.modalPresentationStyle = UIModalPresentationFullScreen;
                mainScreen.IndexTab = appdlg.SIListingIndex;
                [self presentViewController:mainScreen animated:NO completion:Nil];
                mainScreen= Nil;
                appdlg = nil;
            }
            
        }
    }
}

-(void)updateDateLogout
{
    NSString *databasePath;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET LastLogoutDate= \"%@\" WHERE IndexNo=\"%d\"",dateString, 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        query_stmt = Nil;
        querySQL = Nil;
    }
    
    databasePath = Nil, dbpath = Nil, statement = Nil;
    dirPaths = Nil, docsDir = Nil, dateFormatter = Nil, dateString = Nil;    
    
}

-(void) goToHome
{
    UIApplication *app = [UIApplication sharedApplication];
    NSString *URLEncodedText = @"";
    NSString *ourPath = [@"com.hla.pitstop://" stringByAppendingString:URLEncodedText];
    
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    
    if ([app canOpenURL:ourURL]) {
        [app openURL:ourURL];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@" " message:@"HLA Fast is not installed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
        [alertView show];
    }
}

- (IBAction)selectClientProfile:(id)sender {
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainClient *mainClient = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainClient"];
    mainClient.modalPresentationStyle = UIModalPresentationFullScreen;
    mainClient.IndexTab = appdlg.ProspectListingIndex;
    [self presentViewController:mainClient animated:NO completion:Nil];
    appdlg = Nil;
    mainClient= Nil;
}

- (IBAction)selectSalesIllustration:(id)sender {
    // Override option, open the Traditional SI
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"HLAWPStoryboard" bundle:Nil];
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainScreen *mainScreen= [cpStoryboard instantiateViewControllerWithIdentifier:@"Main"];
    mainScreen.tradOrEver = @"TRAD";
    mainScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    mainScreen.IndexTab = appdlg.SIListingIndex;
    [self presentViewController:mainScreen animated:NO completion:Nil];
    mainScreen= Nil;
    appdlg = nil;
    
}

- (IBAction)selectCFF:(id)sender {
    UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"CFFStoryboard" bundle:Nil];
    MainCustomer *mainCustomer = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainCFF"];
    mainCustomer.modalPresentationStyle = UIModalPresentationFullScreen;
    mainCustomer.IndexTab = 1;
    [self presentViewController:mainCustomer animated:NO completion:Nil];
    mainCustomer = Nil;
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdlg.eApp=NO;
}

- (IBAction)selectEApp:(id)sender {
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"EappListing" bundle:Nil];
    MaineApp *mainEApp = [secondStoryboard instantiateViewControllerWithIdentifier:@"maineApp"];
    mainEApp.modalPresentationStyle = UIModalPresentationFullScreen;
    mainEApp.IndexTab = 1;
    [self presentViewController:mainEApp animated:NO completion:Nil];
    mainEApp = Nil;
    secondStoryboard = Nil;
    
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    appdlg.eApp=YES;
}

#pragma mark - other
- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self setMyView:nil];
    [self setCPBtn:nil];
    [self setOutletNavBar:nil];
    [self setOutletClientProfile:nil];
    [self setOutletCustomerFF:nil];
    [self setOutletSI:nil];
    [self setOutletEAPP:nil];
    [super viewDidUnload];
}

@end
