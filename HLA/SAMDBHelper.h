//
//  SAMDBHelper.h
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Formatter.h"
#import "SAMModel.h"

@interface SAMDBHelper : NSObject

@property Formatter *formatter;

- (NSMutableArray *) readAllSAMData;
- (SAMModel *) InsertSAMData;
- (SAMModel *) GetSAMData: (NSString *) customerID;
- (BOOL) UpdateSAMData:(SAMModel *) model;

@end
