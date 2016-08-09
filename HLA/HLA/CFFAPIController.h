//
//  CFFAPIController.h
//  BLESS
//
//  Created by Basvi on 7/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFAPIController : NSObject
-(void)apiCall:(NSString *)URL;
-(void)apiCallCFFHtmtable:(NSString *)URL;
-(void)apiCallHtmlTable:(NSString *)URL JSONKey:(NSArray *)jsonKey TableDictionary:(NSDictionary *)tableDictionary DictionaryDuplicateChecker:(NSDictionary *)dictDuplicate WebServiceModule:(NSString *)stringWebService;
-(void)apiCallCrateHtmlFile:(NSString *)URL RootPathFolder:(NSString *)rootPathFolder;
- (void)createDirectory:(NSString *)documentRootDirectory;
@end
