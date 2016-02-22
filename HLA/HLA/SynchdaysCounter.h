//
//  SynchdaysCounter.h
//  BLESS
//
//  Created by Erwin on 14/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynchdaysCounter : NSObject

+ (NSInteger)synchLeftDate;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end