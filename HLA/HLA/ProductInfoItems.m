//
//  ProductInfoItems.m
//  BLESS
//
//  Created by Erwin Lim  on 3/24/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ProductInfoItems.h"


@implementation ProductInfoItems

@synthesize ftpDelegate;

//-----
//
//				listDirectory
//
// synopsis:	[self listDirectory];
//
// description:	listDirectory is designed to
//
// errors:		none
//
// returns:		none
//

- (void) listDirectory
{
    listDir = [[BRRequestListDirectory alloc] initWithDelegate:self];
    
    listDir.hostname = @"waws-prod-sg1-011.ftp.azurewebsites.windows.net";
    listDir.path = @"/site/FTPBrochure";
    listDir.username = @"bcalife\\mpos";
    listDir.password = @"!nfoC0nnect";
    
    NSLog(@"ftp list :%@ %@ %@ %@",listDir.hostname,listDir.path,listDir.username,listDir.password);
    
    [listDir start];
}

//-----
//
//				downloadFile
//
// synopsis:	[self downloadFile];
//
// description:	downloadFile is designed to
//
// errors:		none
//
// returns:		none
//

- (void) downloadFile:(NSString *)fileNameTemp
{
    downloadData = [NSMutableData dataWithCapacity: 1];
    
    downloadFile = [[BRRequestDownload alloc] initWithDelegate:self];
    downloadFile.hostname = @"waws-prod-sg1-011.ftp.azurewebsites.windows.net";
    downloadFile.path = [NSString stringWithFormat: @"/site/FTPBrochure/%@",fileNameTemp];
    downloadFile.username = @"bcalife\\mpos";
    downloadFile.password = @"!nfoC0nnect";
    fileName = fileNameTemp;
    [downloadFile start];
}

//-----
//
//				percentCompleted
//
// synopsis:	[self percentCompleted:request];
//					BRRequest *request	-
//
// description:	percentCompleted is designed to
//
// errors:		none
//
// returns:		none
//

- (void) percentCompleted: (BRRequest *) request
{
    NSLog(@"%f completed...", request.percentCompleted);
    NSLog(@"%ld bytes this iteration", request.bytesSent);
    NSLog(@"%ld total bytes", request.totalBytesSent);
}

- (void)requestCompleted:(BRRequest *)request{
    NSMutableArray *ftpItemsList = [[NSMutableArray alloc]init];
    if (request == listDir)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        //we print each of the files name
        for (NSDictionary *file in listDir.filesInfo)
        {
            NSLog(@"%@", [file objectForKey:(id)kCFFTPResourceName]);
            NSMutableDictionary *itemInfo = [[NSMutableDictionary alloc]init];
            [itemInfo setValue:[file objectForKey:(id)kCFFTPResourceSize] forKey:[file objectForKey:(id)kCFFTPResourceName]];
            [ftpItemsList addObject:itemInfo];
        }
        
        NSLog(@"%@", listDir.filesInfo);
        
        listDir = nil;
        
        [ftpDelegate itemsList:ftpItemsList];
    }
    if (request == downloadFile)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        NSError *error;
        
        NSString *path;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Brochures/"];
        
        //----- save the downloadData as a file object
        NSString *filepath = [NSString stringWithFormat: @"%@/%@", path, fileName];
        
        [downloadData writeToFile: filepath atomically:NO];
        downloadData = nil;
        downloadFile = nil;
        [ftpDelegate reloadItemsTable];
    }
}

- (void)requestFailed:(BRRequest *)request{
    
}

- (void) requestDataAvailable: (BRRequestDownload *) request;
{
    [downloadData appendData: request.receivedData];
}


@end