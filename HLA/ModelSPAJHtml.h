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
-(NSDictionary *)selectActiveHtmlForSection:(NSString *)htmlSection;
@end
