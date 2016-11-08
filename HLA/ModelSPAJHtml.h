//
//  ModelSPAJHtml.h
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJHtml : NSObject{
    FMResultSet *results;
}

-(NSString *)selectHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection;
-(NSString *)selectHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection SPAJID:(int)spajID;
-(NSArray *)selectArrayHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection;
-(NSArray *)selectArrayHtmlFileName:(NSString *)stringColumnName SPAJSection:(NSString *)stringHtmlSection SPAJID:(int)spajID;
-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection;
-(int)selectActiveHtmlSPAJID;
@end
