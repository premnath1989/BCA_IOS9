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

@interface ProductInfoItems : NSObject<BRRequestDelegate>{
    BRRequestListDirectory *listDir;
}

- (void) listDirectory;

@end