//
//  ModelSIPOData.h
//  BLESS
//
//  Created by Basvi on 2/25/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSIPOData : NSObject{
    FMResultSet *results;
}
-(void)savePODate:(NSDictionary *)dataPO;
-(NSDictionary *)getPO_DataFor:(NSString *)SINo;
@end
