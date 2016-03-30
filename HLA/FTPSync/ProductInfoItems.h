//
//  ProductInfoItems.h
//  BLESS
//
//  Created by Erwin Lim  on 3/24/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRRequestListDirectory.h"
#import "BRRequestDownload.h"
#import "BRRequest+_UserData.h"
#import "ProductInfoItemsDelegate.h"

@interface ProductInfoItems : NSObject<BRRequestDelegate>{
    BRRequestListDirectory *listDir;
    NSMutableData *downloadData;
    BRRequestDownload * downloadFile;
    NSString *fileName;
}

- (void) listDirectory;
- (void) downloadFile:(NSString *)fileNameTemp;
- (void) cancelAction;
@property (nonatomic, assign) id<ProductInfoItemsDelegate>  ftpDelegate;

@end