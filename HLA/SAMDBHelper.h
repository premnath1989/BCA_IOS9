//
//  SAMDBHelper.h
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SAMDBHelper : NSObject

- (NSMutableArray *) loadAllSAMData;

@end
