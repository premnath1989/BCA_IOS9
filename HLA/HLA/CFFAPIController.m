//
//  CFFAPIController.m
//  BLESS
//
//  Created by Basvi on 7/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "CFFAPIController.h"
#import "ModelCFFHtml.h"
#import "AppDelegate.h"


@implementation CFFAPIController{
    ModelCFFHtml* modelCFFHtml;
}

-(id)init{
    self = [super init];
    modelCFFHtml=[[ModelCFFHtml alloc]init];
    return self;
}


#pragma mark AFNetworking
-(void)apiCallCFFHtmtable:(NSString *)URL{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                [self insertJsonToDB:data];
            }] resume];
}

-(void)insertJsonToDB:(NSData *)jsonData{
    NSError *error =  nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *items = [json valueForKeyPath:@"d"];
    
    if ([[json valueForKeyPath:@"d"] isKindOfClass:[NSArray class]]){
        NSEnumerator *enumerator = [items objectEnumerator];
        NSDictionary* item;
        while (item = (NSDictionary*)[enumerator nextObject]) {
            NSDictionary* dictHtmlData=[[NSDictionary alloc]initWithObjectsAndKeys:[item objectForKey:@"CFFId"],@"CFFID",
                                        [item objectForKey:@"CFFSection"],@"CFFHtmlSection",
                                        [item objectForKey:@"FileName"],@"CFFHtmlName",
                                        [item objectForKey:@"Status"],@"CFFHtmlStatus", nil];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [modelCFFHtml updateHtmlData:dictHtmlData];
                // Some long running task you want on another thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [modelCFFHtml saveHtmlData:dictHtmlData];
                });
            });
        }
    }
    else{
        NSDictionary *itemsDict = [json valueForKeyPath:@"d"];
        NSDictionary* dictHtmlData=[[NSDictionary alloc]initWithObjectsAndKeys:[itemsDict objectForKey:@"CFFId"],@"CFFID",
                                    [itemsDict objectForKey:@"CFFSection"],@"CFFHtmlSection",
                                    [itemsDict objectForKey:@"FileName"],@"CFFHtmlName",
                                    [itemsDict objectForKey:@"Status"],@"CFFHtmlStatus", nil];
        [modelCFFHtml saveHtmlData:dictHtmlData];
    }
}



#pragma mark AFNetworking For Global Use
-(void)apiCall:(NSString *)URL {
    // handle response
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    NSString *stringPath = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"json %@",stringPath);
                }
            }] resume];
}

-(void)apiCallHtmlTable:(NSString *)URL JSONKey:(NSArray *)jsonKey TableDictionary:(NSDictionary *)tableDictionary DictionaryDuplicateChecker:(NSDictionary *)dictDuplicate WebServiceModule:(NSString *)stringWebService{
    // handle response
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    [self insertJsonToDB:data JSONKey:jsonKey TableDictionary:tableDictionary DictionaryDuplicateChecker:dictDuplicate];
                    [self getCFFHTMLFile:stringWebService];
                }
            }] resume];
}

-(void)getCFFHTMLFile :(NSString *)stringWebService{
    
    NSString *kLatestKivaLoansURL = [NSString stringWithFormat:@"%@/Service2.svc/getAllData", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    
    NSString *SPAJkLatestKivaLoansURL = [NSString stringWithFormat:@"%@/SPAJHTMLForm.svc/GetAllData", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    
    // handle response
    NSLog(@"getCFFHTMLFile");
    dispatch_async(kBgQueue, ^{
        NSData* data ;
        if ([stringWebService isEqualToString:@"CFF"]){
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kLatestKivaLoansURL]];
        }
        else if ([stringWebService isEqualToString:@"SPAJ"]){
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:SPAJkLatestKivaLoansURL]];
        }
        
        NSLog(@"respond getCFFHTMLFile exceeded");
        if(data != nil)
            dispatch_sync(dispatch_get_main_queue(), ^{
                //[self doSomething:1 b:2 c:3 d:4 e:5];
                [self createHTMLFile:data WebServiceModule:stringWebService];
            });
            //[self performSelectorOnMainThread:@selector(createHTMLFile:) withObject:data waitUntilDone:YES];
    });
}

-(void)createHTMLFile:(NSData *)responseData WebServiceModule:(NSString *)stringWebService{
    CFFAPIController* cffAPIController;
    cffAPIController = [[CFFAPIController alloc]init];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:kNilOptions
                          error:&error];
    
    NSArray* arrayFileName = [[json objectForKey:@"d"] valueForKey:@"FileName"]; //2
    if ([stringWebService isEqualToString:@"CFF"]){
        for (int i=0;i<[arrayFileName count];i++){
            [cffAPIController apiCallCrateHtmlFile:[NSString stringWithFormat:@"%@/Service2.svc/GetHtmlFile?fileName=%@", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL],[arrayFileName objectAtIndex:i]] RootPathFolder:@"CFFfolder"];
        }
    }
    else if ([stringWebService isEqualToString:@"SPAJ"]){
        for (int i=0;i<[arrayFileName count];i++){
            [cffAPIController apiCallCrateHtmlFile:[NSString stringWithFormat:@"%@/SPAJHTMLForm.svc/GetHtmlFile?fileName=%@",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL],[arrayFileName objectAtIndex:i]] RootPathFolder:@"SPAJ"];
        }
    }
}


-(void)insertJsonToDB:(NSData *)jsonData JSONKey:(NSArray *)jsonKey TableDictionary:(NSDictionary *)tableDictionary DictionaryDuplicateChecker:(NSDictionary *)dictDuplicate{
    @try {
        NSError *error =  nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *items = [json valueForKeyPath:@"d"];
        
        if ([[json valueForKeyPath:@"d"] isKindOfClass:[NSArray class]]){
            NSEnumerator *enumerator = [items objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) {
                NSString* stringID=[NSString stringWithFormat:@"\"%@\"",[item objectForKey:[jsonKey objectAtIndex:0]]];
                NSString* stringFileName=[NSString stringWithFormat:@"\"%@/\%@\"",[item objectForKey:[jsonKey objectAtIndex:4]],[item objectForKey:[jsonKey objectAtIndex:1]]];
                NSString* stringStatus=[NSString stringWithFormat:@"\"%@\"",[item objectForKey:[jsonKey objectAtIndex:2]]];
                NSString* stringSection=[NSString stringWithFormat:@"\"%@\"",[item objectForKey:[jsonKey objectAtIndex:3]]];
                NSString* stringServerID=[NSString stringWithFormat:@"\"%@\"",[item objectForKey:[jsonKey objectAtIndex:5]]];
                
                NSString* numberServerID = [NSString stringWithFormat:@"%@",[item objectForKey:[jsonKey objectAtIndex:5]]];
                
                NSString* stringDuplicateCheckerColumnName = [dictDuplicate valueForKey:@"DuplicateCheckerColumnName"];
                NSString* stringDuplicateCheckerTableName = [dictDuplicate valueForKey:@"DuplicateCheckerTableName"];
                NSString* stringDuplicateCheckerWhere1 = [dictDuplicate valueForKey:@"DuplicateCheckerWhere1"];
                NSString* stringDuplicateCheckerWhere2 = [dictDuplicate valueForKey:@"DuplicateCheckerWhere2"];
                NSString* stringDuplicateCheckerWhere3 = [dictDuplicate valueForKey:@"DuplicateCheckerWhere3"];
                NSString* stringDuplicateCheckerWhere4 = [dictDuplicate valueForKey:@"DuplicateCheckerWhere4"];
                NSString* stringDuplicateCheckerWhere5 = [dictDuplicate valueForKey:@"DuplicateCheckerWhere5"];
                
                NSMutableArray* tableValue = [[NSMutableArray alloc]initWithObjects:stringID,stringFileName,stringStatus,stringSection,stringServerID, nil];
                NSMutableArray* tableColumn = [[NSMutableArray alloc] initWithArray:[tableDictionary valueForKey:@"columnName"]];
                
                NSString* stringTableName = [tableDictionary valueForKey:@"tableName"];
                
                NSMutableArray* arrayServerID = [[NSMutableArray alloc]initWithArray:[modelCFFHtml selectHtmlServerID:stringTableName ColumnName:stringDuplicateCheckerWhere5]];
                
                if ([arrayServerID containsObject:numberServerID]){
                    NSString* stringSet = [NSString stringWithFormat:@"%@=%@,%@=%@,%@=%@,%@=%@",stringDuplicateCheckerWhere1,stringID,stringDuplicateCheckerWhere2,stringFileName,stringDuplicateCheckerWhere3,stringStatus,stringDuplicateCheckerWhere4,stringSection];
                    NSString* stringWhere = [NSString stringWithFormat:@"%@=%@",stringDuplicateCheckerWhere5,stringServerID];
                    
                    [modelCFFHtml updateGlobalHtml:stringTableName StringSet:stringSet StringWhere:stringWhere];
                }
                else{
                    //check duplicate value
                    //NSString* query=[NSString stringWithFormat:@"select CFFHtmlID from CFFHtml where CFFID=%@ and CFFHtmlName=%@ and CFFHtmlStatus=%@ and CFFHtmlSection=%@",stringID,stringFileName,stringStatus,stringSection];
                    NSString* query=[NSString stringWithFormat:@"select count(%@) as Count,%@ from %@ where %@=%@ and %@=%@ and %@=%@ and %@=%@",stringDuplicateCheckerColumnName,stringDuplicateCheckerColumnName,stringDuplicateCheckerTableName,stringDuplicateCheckerWhere1,stringID,stringDuplicateCheckerWhere2,stringFileName,stringDuplicateCheckerWhere3,stringStatus,stringDuplicateCheckerWhere4,stringSection];
                    //NSString* columnReturn = @"CFFHtmlID";
                    
                    
                    NSString* columnReturn = @"Count";
                    
                    int duplicateRow = [modelCFFHtml voidGetDuplicateRowID:query ColumnReturn:columnReturn];
                    int htmlID = [modelCFFHtml voidGetDuplicateRowID:query ColumnReturn:stringDuplicateCheckerColumnName];
                    if (duplicateRow>0){
                        [tableColumn addObject:stringDuplicateCheckerColumnName];
                        [tableValue addObject:[NSNumber numberWithInt:htmlID]];
                    }
                    
                    NSMutableDictionary* dictDataTable = [[NSMutableDictionary alloc]initWithDictionary:tableDictionary];
                    [dictDataTable setObject:tableValue forKey:@"columnValue"];
                    [dictDataTable setObject:tableColumn forKey:@"columnName"];
                    
                    [modelCFFHtml saveGlobalHtmlData:dictDataTable];
                }
                /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [modelCFFHtml updateGlobalHtmlData:[item objectForKey:[jsonKey objectAtIndex:3]]];
                    // Some long running task you want on another thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [modelCFFHtml saveGlobalHtmlData:dictDataTable];
                    });
                });*/
            }
        }
        else{
            NSDictionary *itemsDict = [json valueForKeyPath:@"d"];
            NSArray* tableValue= [[NSArray alloc]initWithObjects:[itemsDict objectForKey:[jsonKey objectAtIndex:0]],[itemsDict objectForKey:[jsonKey objectAtIndex:1]],[itemsDict objectForKey:[jsonKey objectAtIndex:2]],[itemsDict objectForKey:[jsonKey objectAtIndex:3]], nil];
            NSMutableDictionary* dictDataTable = [[NSMutableDictionary alloc]initWithDictionary:tableDictionary];
            [dictDataTable setObject:tableValue forKey:@"columnValue"];
            
            [modelCFFHtml saveGlobalHtmlData:dictDataTable];
            /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [modelCFFHtml updateGlobalHtmlData:[itemsDict objectForKey:[jsonKey objectAtIndex:3]]];
                // Some long running task you want on another thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [modelCFFHtml saveGlobalHtmlData:dictDataTable];
                });
            });*/
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

#pragma mark create html
-(void)apiCallCrateHtmlFile:(NSString *)URL RootPathFolder:(NSString *)rootPathFolder{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                [self createHTMLFile:data RootPathFolder:rootPathFolder];
            }] resume];
}

-(void)createHTMLFile:(NSData *)jsonData RootPathFolder:(NSString *)rootPathFolder{
    @try {
        NSError *error =  nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if ([[json valueForKeyPath:@"d"] isKindOfClass:[NSArray class]]){
            NSArray *items = [json valueForKeyPath:@"d"];
            NSEnumerator *enumerator = [items objectEnumerator];
            NSDictionary* item;
            while (item = (NSDictionary*)[enumerator nextObject]) {
                NSString* base64String = [NSString stringWithFormat:@"%@",[item objectForKey:@"Base64File"]];
                NSString* folderName = [NSString stringWithFormat:@"%@",[item objectForKey:@"FolderName"]];
                NSString* fileName = [NSString stringWithFormat:@"%@",[item objectForKey:@"FileName"]];
                
                NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *filePathApp = [docsDir stringByAppendingPathComponent:rootPathFolder];
                [self createDirectory:filePathApp];
                
                [self createFileDirectory:[NSString stringWithFormat:@"%@/%@",filePathApp,folderName]];
                
                NSData *htmlData = [self dataFromBase64EncodedString:base64String];
                [htmlData writeToFile:[NSString stringWithFormat:@"%@/%@/%@",filePathApp,folderName,fileName] options:NSDataWritingAtomic error:&error];
            }
        }
        else{
            NSDictionary *itemsDict = [json valueForKeyPath:@"d"];
            NSString* base64String = [NSString stringWithFormat:@"%@",[itemsDict objectForKey:@"Base64File"]];
            NSString* folderName = [NSString stringWithFormat:@"%@",[itemsDict objectForKey:@"FolderName"]];
            NSString* fileName = [NSString stringWithFormat:@"%@",[itemsDict objectForKey:@"FileName"]];
            
            NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePathApp = [docsDir stringByAppendingPathComponent:rootPathFolder];
            
            [self createDirectory:filePathApp];
            
            [self createFileDirectory:[NSString stringWithFormat:@"%@/%@",filePathApp,folderName]];
            
            NSData *htmlData = [self dataFromBase64EncodedString:base64String];
            [htmlData writeToFile:[NSString stringWithFormat:@"%@/%@/%@",filePathApp,folderName,fileName] options:NSDataWritingAtomic error:&error];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}

- (void)createDirectory:(NSString *)documentRootDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentRootDirectory])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:documentRootDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

- (void)createFileDirectory:(NSString *)fileTimeDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileTimeDirectory])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:fileTimeDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

@end
