//
//  SIUtilities.h
//  iMobile Planner
//
//  Created by shawal sapuan on 5/13/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"


@interface SIUtilities : NSObject

+ (BOOL)makeDBCopy:(NSString *)path;
+ (BOOL)addColumnTable:(NSString *)table column:(NSString *)columnName type:(NSString *)columnType dbpath:(NSString *)path;
+ (BOOL)updateTable:(NSString *)table set:(NSString *)column value:(NSString *)val where:(NSString *)param equal:(NSString *)val2 dbpath:(NSString *)path;
+ (NSString *)WSLogin;
+ (void)runQuery:(NSString *)path withQuery:(NSString *)query;
+ (BOOL)InstallUpdate:(NSString *)path;

@end
