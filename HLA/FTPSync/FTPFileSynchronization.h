//
//  FTPFileSynchronization.h
//  FTPFileSynchronization
//
//  Created by Erwin Lim  on 3/30/16.
//  Copyright © 2016 Erwin Lim . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoItemsDelegate.h"

@interface FTPFileSynchronization : NSObject

//ProductInfo Header
- (void) listDirectory;
- (void) downloadFile:(NSString *)fileNameTemp;
- (void) cancelAction;
@property (nonatomic, assign) id<ProductInfoItemsDelegate>  ftpDelegate;

@end
