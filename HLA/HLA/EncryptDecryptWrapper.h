//
//  EncryptDecryptWrapper.h
//  BLESS
//
//  Created by Erwin Lim  on 4/11/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface EncryptDecryptWrapper : NSObject

- (NSString *)encrypt:(NSString *)plainText;
- (void)decrypt:(NSString *)encryptedData key:(NSString *)keyText;

@end