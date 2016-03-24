//
//  ProductInfoItems.m
//  BLESS
//
//  Created by Erwin Lim  on 3/24/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ProductInfoItems.h"


@implementation ProductInfoItems


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
    listDir.path = @"/site/wwwroot";
    listDir.username = @"bcalife\\mpos";
    listDir.password = @"!nfoC0nnect";
    
    NSLog(@"%@ %@ %@ %@",listDir.hostname,listDir.path,listDir.username,listDir.password);
    
    [listDir start];
}

- (void)requestCompleted:(BRRequest *)request{
    if (request == listDir)
    {
        //called after 'request' is completed successfully
        NSLog(@"%@ completed!", request);
        
        //we print each of the files name
        for (NSDictionary *file in listDir.filesInfo)
        {
            NSLog(@"%@", [file objectForKey:(id)kCFFTPResourceName]);
        }
        
        NSLog(@"%@", listDir.filesInfo);
        
        listDir = nil;
    }

}

- (void)requestFailed:(BRRequest *)request{
    
}

- (void)requestDataAvailable:(BRRequestDownload *)request{
    
}

- (void) percentCompleted: (BRRequest *) request{
    
}

@end