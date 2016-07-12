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
-(void)updateHtmlData:(NSDictionary *)dictHtmlData;
-(NSMutableArray *)selectHtmlData:(int)CFFHtmlID HtmlSection:(NSString *)cffHtmlSection;
-(NSDictionary *)selectActiveHtml;
-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection;
@end
