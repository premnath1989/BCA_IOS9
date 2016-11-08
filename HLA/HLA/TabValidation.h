//
//  TabValidation.h
//  BLESS
//
//  Created by Erwin Lim  on 3/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TabValidation : NSObject

+(TabValidation*)sharedMySingleton;

- (void) setValidTab1:(BOOL)flag;

- (void) setValidTab2:(BOOL)flag;

- (void) setValidTab3:(BOOL)flag;

- (BOOL) CheckTab1;
- (BOOL) CheckTab2;
- (BOOL) CheckTab3;
- (int) currentValidRow;

@end
