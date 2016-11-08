//
//  ModelKodepos.h
//  MPOS
//
//  Created by Basvi on 3/16/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelKodepos : NSObject{
    FMResultSet *results;
}

-(NSMutableArray *)getPropinsi;
-(NSMutableArray *)getKabupatengbyPropinsi:(NSString *)propinsi;

@end
