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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *) url {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:12 * 60 * 60] forKey:@"sessionExpiration"];

    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if ([text isEqualToString:@"logout"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSDate date] forKey:@"sessionExpiration"];
        [defaults synchronize];

        UIApplication *app = [UIApplication sharedApplication];
        NSURL *hlafastUrl = [NSURL URLWithString:[@"com.hla.fast://" stringByAppendingString:[@"hlafast" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if ([app canOpenURL:hlafastUrl]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [app openURL:hlafastUrl];
            });
            return YES;
        }
    }
    
    checkLoginStatus = ([text length] == 0);
    [self checkAgentStatus:text];
#ifdef UAT_BUILD
    if (uatAgentCode != NULL && ![uatAgentCode isEqualToString:@"A8888888"]) {
#endif
        ClearData *CleanData =[[ClearData alloc]init];
        [CleanData ClientWipeOff];        
#ifdef UAT_BUILD
    }
#endif
    return YES;
}

- (void)presentTerminatedView {
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    if (! [[topController restorationIdentifier] isEqualToString:@"AppDataWipe"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AppDataWipeStoryboard" bundle:nil];
        UIViewController *dataWipedViewController = [storyboard instantiateViewControllerWithIdentifier:@"AppDataWipe"];

        [topController presentViewController:dataWipedViewController animated:YES completion:NULL];
    }
}

- (void)checkSessionExpired {
    NSDate *now = [NSDate date];

    NSDate *expiration = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionExpiration"];

    if (expiration == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:12 * 60 * 60] forKey:@"sessionExpiration"];

        NSLog(@"Error: Expiration not set");

    } else if ([now compare:expiration] == NSOrderedDescending) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *hlafastUrl = [NSURL URLWithString:[@"com.hla.fast://" stringByAppendingString:[@"imsLoginAssistant" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if ([app canOpenURL:hlafastUrl]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [app openURL:hlafastUrl];
            });
        }
    }
}

- (void)checkAgentStatus:(NSString *)text {
    NSMutableDictionary *queryDictionary = [ [NSMutableDictionary alloc] init];
    NSArray *queryTokens = [text componentsSeparatedByString:@"&"];
    BOOL newAgent = YES;

    sqlite3 *hladb;
    sqlite3_stmt *statement;

    if (queryTokens.count == 0) {
        checkLoginStatus = YES;
        return;
    }

    for(NSString *keyValueString in queryTokens) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        if ([keyValueArray count] != 2) {
            NSLog(@"Error: Key-Value not found");
            exit(1);
        } else {
            [queryDictionary setObject:[keyValueArray objectAtIndex:1] forKey:[keyValueArray objectAtIndex:0]];
        }
    }

    NSString *agentCode = [queryDictionary objectForKey:@"agentCode"];
    
#ifdef UAT_BUILD
    uatAgentCode = agentCode;
#endif
    if ([[queryDictionary objectForKey:@"AgentState"] isEqualToString:@"T"]) {
        [self presentTerminatedView];

        return;
    } else if (agentCode != nil) {
        databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"hladb.sqlite"];
        
        if (sqlite3_open([databasePath UTF8String ], &hladb) == SQLITE_OK) {
            NSString *querySQL;
            
            querySQL = [NSString stringWithFormat: @"select agentCode FROM agent_profile where agentCode = '%@' ", agentCode];

            if (sqlite3_prepare_v2(hladb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    NSString *ac = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    if ([ac isEqualToString:agentCode]) {
                        newAgent = NO;
                    }
                }
                sqlite3_finalize(statement);
                sqlite3_close(hladb);
            }

        } else {
            NSLog(@"Error: Could not open hladb");
        }
    }
#ifdef UAT_BUILD
    if (newAgent) {
        newAgent = ![uatAgentCode isEqualToString:@"A8888888"];
    }
#endif

    if (newAgent) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *temp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"hladb.sqlite"];
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];

        [fileManager moveItemAtPath:databasePath toPath:temp error:nil];
        [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:nil];
//        [SIUtilities InstallUpdate:databasePath];
        [fileManager removeItemAtPath:temp error:nil];

        NSString* agentCode = [queryDictionary objectForKey:@"agentCode"];
        NSString* agentName = [queryDictionary objectForKey:@"agentName"];
        NSString* agentType = [queryDictionary objectForKey:@"agentType"];
        NSString* immediateLeaderCode = [queryDictionary objectForKey:@"immediateLeaderCode"];
        NSString* immediateLeaderName = [queryDictionary objectForKey:@"immediateLeaderName"];
        NSString* BusinessRegNumber = [queryDictionary objectForKey:@"BusinessRegNumber"];
        NSString* agentEmail = [queryDictionary objectForKey:@"agentEmail"];
        NSString* agentLoginId = [queryDictionary objectForKey:@"agentLoginId"];
        NSString* agentIcNo = [queryDictionary objectForKey:@"agentIcNo"];
        NSString* agentContractDate = [queryDictionary objectForKey:@"agentContractDate"];
        NSString* agentAddr1 = [queryDictionary objectForKey:@"agentAddr1"];
        NSString* agentAddr2 = [queryDictionary objectForKey:@"agentAddr2"];
        NSString* agentAddr3 = [queryDictionary objectForKey:@"agentAddr3"];
        NSString* agentAddrPostcode = [queryDictionary objectForKey:@"agentAddrPostcode"];
        NSString* agentContactNumber = [queryDictionary objectForKey:@"agentContactNumber"];
        NSString* agentPassword = [queryDictionary objectForKey:@"agentPassword"];
        NSString* agentStatus = [queryDictionary objectForKey:@"agentStatus"];
        NSString* channel = [queryDictionary objectForKey:@"channel"];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:agentCode forKey:@"agentCode"];
        [defaults synchronize];

        if (sqlite3_open([databasePath UTF8String ], &hladb) == SQLITE_OK) {
            NSString *querySQL;
            BOOL newRec = FALSE;

            querySQL = [NSString stringWithFormat:@"select agentCode FROM agent_profile where agentCode = '%@' ", agentCode ];

            if (sqlite3_prepare_v2(hladb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) != SQLITE_ROW) {
                    newRec = TRUE;
                }
                sqlite3_finalize(statement);
            }

            if (newRec == FALSE) {
                querySQL = [NSString stringWithFormat: @"Delete FROM agent_profile "];

                if (sqlite3_prepare_v2(hladb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
            }

            querySQL = [NSString stringWithFormat:
                        @"insert into Agent_profile (agentCode, AgentName, AgentType, AgentContactNo, ImmediateLeaderCode, ImmediateLeaderName, BusinessRegNumber, AgentEmail, AgentLoginID, AgentICNo, "
                        "AgentContractDate, AgentAddr1, AgentAddr2, AgentAddr3, AgentAddr4, AgentPortalLoginID, AgentPortalPassword, AgentContactNumber, AgentPassword, AgentStatus, Channel, AgentAddrPostcode, agentNRIC ) VALUES "
                        "('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '%@') ",
                        agentCode, agentName, agentType, agentContactNumber, immediateLeaderCode, immediateLeaderName,BusinessRegNumber, agentEmail, agentLoginId, agentIcNo, agentContractDate, agentAddr1, agentAddr2, agentAddr3, @"", agentLoginId, agentPassword, agentContactNumber, agentPassword, agentStatus, channel, agentAddrPostcode, agentIcNo ];

            if (sqlite3_prepare_v2(hladb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }

            sqlite3_close(hladb);
            querySQL = Nil;
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults boolForKey:@"Terminated"]) {
//        [self presentTerminatedView];
//    } else {
//        [self checkSessionExpired];
//    }
}


@end
