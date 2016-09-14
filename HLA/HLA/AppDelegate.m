//
//  AppDelegate.m
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/getAllData"] //2

#import "AppDelegate.h"
#import "ClearData.h"
#import "DBUpdater.h"
#import "SessionManagement.h"
#import "Login.h"
#import "CFFListingViewController.h"
#import <CoreData/CoreData.h>
#import "CFFAPIController.h"

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


// SPAJ - CORE DATA

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


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
    ClearData *CleanData =[[ClearData alloc]init];
    [CleanData SPAJExpiredWipeOff];

#ifdef UAT_BUILD
    if (uatAgentCode != NULL && ![uatAgentCode isEqualToString:@"A8888888"]) {
#endif
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
    
    //first we get the version number of the JQueryLibrary from bundle
    NSBundle *myLibraryBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]
                                                         URLForResource:@"HTMLResources" withExtension:@"bundle"]];
    NSString *filePath   = [myLibraryBundle pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *infoBundleDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSString *jQueryBundleVer = [infoBundleDict objectForKey:@"CFBundleShortVersionString"];
    
    NSString *htmlPath = [[NSString alloc] initWithString:
                          [fileJqueryLibsPath stringByAppendingPathComponent: @"/Info.plist"]];
    NSMutableDictionary *infoDirDict = [[NSMutableDictionary alloc] initWithContentsOfFile:htmlPath];
    NSString *jQueryDirVer = [infoDirDict objectForKey:@"CFBundleShortVersionString"];
    
    NSInteger jQueryBundleVerInt = [jQueryBundleVer intValue];
    NSInteger jQueryDirVerInt = [jQueryDirVer intValue];
    
    //if the bundle version is higher, remove the folder
    if(jQueryBundleVerInt > jQueryDirVerInt){
        [[NSFileManager defaultManager] removeItemAtPath:fileJqueryLibsPath error:NULL];
    }
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
    
    NSError * error;
    for(NSString *fileName in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[myLibraryBundle resourcePath] error:&error]){
        [[NSFileManager defaultManager] copyItemAtPath: [[myLibraryBundle resourcePath]
                                                         stringByAppendingPathComponent:fileName]
                                                toPath:[fileJqueryLibsPath stringByAppendingPathComponent:fileName] error:NULL];
    }
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "my.com.infoconnect.Practice" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Bless_SPAJ" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bless_SPAJ.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
