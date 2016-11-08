//
//  CFFHtml.h
//  BLESS
//
//  Created by Basvi on 6/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelCFFHtml : NSObject{
    FMResultSet *results;
}
-(void)saveHtmlData:(NSDictionary *)dictHtmlData;
-(void)saveGlobalHtmlData:(NSDictionary *)dictHtmlData;
-(void)updateGlobalHtmlData:(NSString *)htmlSection;
-(int)voidGetDuplicateRowID:(NSString *)stringQuery ColumnReturn:(NSString *)stringColumn;
-(void)updateHtmlData:(NSDictionary *)dictHtmlData;
-(void)updateGlobalHtml:(NSString *)tableName StringSet:(NSString *)stringSet StringWhere:(NSString *)stringWhere;
-(NSMutableArray *)selectHtmlData:(int)CFFHtmlID HtmlSection:(NSString *)cffHtmlSection;
-(NSDictionary *)selectActiveHtml;
-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection;
-(NSMutableArray *)selectHtmlServerID:(NSString *)TableName ColumnName:(NSString *)columnName;
@end
