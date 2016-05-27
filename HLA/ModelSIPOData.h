//
//  ModelSIPOData.h
//  MPOS
//
//  Created by Basvi on 2/25/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSIPOData : NSObject{
    FMResultSet *results;
}
-(void)savePODate:(NSDictionary *)dataPO;
-(void)savePartialPODate:(NSDictionary *)dataPO;
-(void)deletePOData:(NSString *)siNo;
-(NSDictionary *)getPO_DataFor:(NSString *)SINo;
-(void)updatePOData:(NSDictionary *)dataPO;
-(void)updatePartialPOData:(NSDictionary *)dataPO;
-(int)getPODataCount:(NSString *)SINo;
-(int)getLADataCount:(NSString *)prospectProfileID;
-(NSMutableArray *)getSINumberForProspectProfileID:(NSString *)prospectProfileID;
-(void)updatePODataDate:(NSString *)SINO Date:(NSString *)date;
@end
