//
//  ProductInfoItemsDelegate.h
//  BLESS
//
//  Created by Erwin Lim  on 3/28/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#ifndef ProductInfoItemsDelegate_h
#define ProductInfoItemsDelegate_h


#endif /* ProductInfoItemsDelegate_h */

#import <UIKit/UIKit.h>

@protocol ProductInfoItemsDelegate


- (void)itemsList:(NSMutableArray *)ftpItems;
- (void)failedConnectToFTP;
- (void)percentCompletedfromFTP:(float)percent;
- (void)downloadCompletedfromFTP;
- (void)uploadCompletedtoFTP;

@end