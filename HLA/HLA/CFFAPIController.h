//
//  CFFAPIController.h
//  BLESS
//
//  Created by Basvi on 7/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFAPIController : NSObject
-(void)apiCallCFFHtmtable:(NSString *)URL;
-(void)apiCallHtmlTable:(NSString *)URL JSONKey:(NSArray *)jsonKey TableDictionary:(NSDictionary *)tableDictionary;
-(void)apiCallCrateHtmlFile:(NSString *)URL RootPathFolder:(NSString *)rootPathFolder;
@end
