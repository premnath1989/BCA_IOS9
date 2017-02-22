//
//  ProductInfoItems.h
//  BLESS
//
//  Created by Erwin Lim  on 3/24/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRRequestListDirectory.h"
#import "BRRequestCreateDirectory.h"
#import "BRRequestUpload.h"
#import "BRRequestDownload.h"
#import "BRRequestDelete.h"
#import "BRRequest+_UserData.h"
#import "ProductInfoItemsDelegate.h"

@interface ProductInfoItems : NSObject<BRRequestDelegate>{
    BRRequestListDirectory *listDir;
    NSMutableData *downloadData;
    BRRequestDownload * downloadFile;
    NSData *uploadData;
    BRRequestUpload *uploadFile;
    NSString *fileName;
}

- (void) listDirectory;
- (void) downloadFile:(NSString *)fileNameTemp FTPPath:(NSString *)FTPPath;
- (void) cancelAction;
- (void) uploadFile:(NSString *)filePath destinationFolder:(NSString *)destinationFolder
           fileName:(NSString *)fileNameUpload;
@property (nonatomic, assign) id<ProductInfoItemsDelegate>  ftpDelegate;

@end
