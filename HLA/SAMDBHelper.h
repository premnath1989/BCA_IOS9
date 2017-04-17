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
- (SAMModel *) ReadSAMData: (NSString *) customerID;
- (SAMModel *) InsertSAMData;
- (SAMModel *) InsertSAMDataWithLastID: (NSString *)lastID;
- (BOOL) UpdateSAMData:(SAMModel *) model;

@end
