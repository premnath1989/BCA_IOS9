//
//  AppDelegate.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AppDelegate.h"
#import "ClearData.h"
#import "DBUpdater.h"
#import "SessionManagement.h"
#import "Login.h"
#import "CFFListingViewController.h"

@implementation AppDelegate
@synthesize indexNo;
@synthesize userRequest, MhiMessage;
@synthesize SICompleted,ExistPayor, HomeIndex, ProspectListingIndex, NewProspectIndex,NewSIIndex, SIListingIndex, ExitIndex, EverMessage;
@synthesize bpMsgPrompt, isNeedPromptSaveMsg, isSIExist, PDFpath,firstLAsex,planChoose,secondLAsex,checkLoginStatus,eappProposal;

@synthesize window = _window;
@synthesize eApp;
@synthesize checkList;
@synthesize ViewFromPendingBool;
@synthesize ViewFromSubmissionBool,ViewDeleteSubmissionBool, ViewFromEappBool;
NSString * const NSURLIsExcludedFromBackupKey =@"NSURLIsExcludedFromBackupKey";

#ifdef UAT_BUILD
NSString *uatAgentCode;
#endif
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIViewController *cffListingNavigation=[[CFFListingViewController alloc]initWithNibName:@"CFFListingViewController" bundle:nil];
    self.navController=[[UINavigationController alloc]initWithRootViewController:cffListingNavigation];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    
    NSLog(@"db path %@",databasePath);
    [SIUtilities makeDBCopy:databasePath];

    SICompleted = YES;
    ExistPayor = YES;

    checkLoginStatus = YES;

    HomeIndex = 0;
    ProspectListingIndex = 1;
    SIListingIndex = 2;
    NewSIIndex = 3;
    ExitIndex = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];

    [self copyJqueryLibstoDir];
    
#ifdef UAT_BUILD
    if (uatAgentCode != NULL && ![uatAgentCode isEqualToString:@"A8888888"]) {
#endif
    ClearData *CleanData =[[ClearData alloc]init];
    [CleanData ClientWipeOff];            
#ifdef UAT_BUILD
    }
#endif
    DBUpdater *dbupdater = [[DBUpdater alloc]init];
    [dbupdater updateDatabase];
    return YES;
}

-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog (@"time exceeded!!");
    
    //This is where storyboarding vs xib files comes in. Whichever view controller you want to revert back to, on your storyboard, make sure it is given the identifier that matches the following code. In my case, "mainView". My storyboard file is called MainStoryboard.storyboard, so make sure your file name matches the storyboardWithName property.
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *mainLogin = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    if(![topController isKindOfClass:[Login class]]){
        [topController presentViewController:mainLogin animated:YES completion:NULL];
    }
}

- (void)copyJqueryLibstoDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    fileJqueryLibsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"jqueryLibrary"];
    [self createDirectory];
}

- (void)createDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileJqueryLibsPath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:fileJqueryLibsPath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    [self moveLibs];
}

- (void)moveLibs{
    NSBundle *myLibraryBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]
                                                         URLForResource:@"HTMLResources" withExtension:@"bundle"]];
    NSString *addJSPath   = [[myLibraryBundle resourcePath]
                             stringByAppendingPathComponent:@"additional-methods.min.js"];
    NSString *JqueryPath   = [[myLibraryBundle resourcePath] stringByAppendingPathComponent:@"jquery-1.11.1.min.js"];
    NSString *JMobileJSPath   = [[myLibraryBundle resourcePath] stringByAppendingPathComponent:@"jquery.mobile-1.4.5.min.js"];
    NSString *JMobilecssJSPath   = [[myLibraryBundle resourcePath] stringByAppendingPathComponent:@"jquery.mobile-1.4.5.min.css"];
    NSString *JvalidatePath   = [[myLibraryBundle resourcePath] stringByAppendingPathComponent:@"jquery.validate.min.js"];
    
    [[NSFileManager defaultManager] copyItemAtPath:addJSPath toPath:[fileJqueryLibsPath stringByAppendingPathComponent:@"additional-methods.min.js"] error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:JqueryPath toPath:[fileJqueryLibsPath stringByAppendingPathComponent:@"jquery-1.11.1.min.js"] error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:JMobileJSPath toPath:[fileJqueryLibsPath stringByAppendingPathComponent:@"jquery.mobile-1.4.5.min.js"] error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:JMobilecssJSPath toPath:[fileJqueryLibsPath stringByAppendingPathComponent:@"jquery.mobile-1.4.5.min.css"] error:NULL];
    [[NSFileManager defaultManager] copyItemAtPath:JvalidatePath toPath:[fileJqueryLibsPath stringByAppendingPathComponent:@"jquery.validate.min.js"] error:NULL];
}

@end
