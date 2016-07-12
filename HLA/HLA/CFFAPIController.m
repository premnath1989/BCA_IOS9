//
//  CFFAPIController.m
//  BLESS
//
//  Created by Basvi on 7/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CFFAPIController.h"
#import "ModelCFFHtml.h"


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
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"result" ofType:@"json"];
    //NSString *jsonString =[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
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

#pragma mark create html
-(void)apiCallCrateCFFHtml:(NSString *)URL{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                [self createHTMLFile:data];
            }] resume];
}

-(void)createHTMLFile:(NSData *)jsonData{
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"result" ofType:@"json"];
    //NSString *jsonString =[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *error =  nil;
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
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
            NSString *filePathApp = [docsDir stringByAppendingPathComponent:@"CFFfolder"];
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
        NSString *filePathApp = [docsDir stringByAppendingPathComponent:@"CFFfolder"];
        
        [self createDirectory:filePathApp];
        
        [self createFileDirectory:[NSString stringWithFormat:@"%@/%@",filePathApp,folderName]];
        
        NSData *htmlData = [self dataFromBase64EncodedString:base64String];
        [htmlData writeToFile:[NSString stringWithFormat:@"%@/%@/%@",filePathApp,folderName,fileName] options:NSDataWritingAtomic error:&error];
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
