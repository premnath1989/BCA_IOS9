//
//  WebResponObj.m
//  MPOS
//
//  Created by Erwin on 23/02/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "WebResponObj.h"

@implementation dataCollection

@synthesize tableName;
@synthesize dataRows;

- (instancetype)init{
    dataRows = [[NSMutableDictionary alloc]init];
    return self;
}

@end

@implementation WebResponObj


- (instancetype)init{
    DataWrapper = [[NSMutableArray alloc]init];
    return self;
}

- (void)addRow:(NSString *)TableNames columnNames:(NSString *)column data:(NSString *)data{
    int index = 0;
    for(dataCollection *buffer in DataWrapper){
        if([buffer.tableName caseInsensitiveCompare:TableNames] == NSOrderedSame){
            [buffer.dataRows setValue:data forKey:column];
            index = 1;
            return;
        }
    }
    if(index == 0){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:data forKey:column];
        
        dataCollection *db = [[dataCollection alloc]init];
        db.tableName = TableNames;
        db.dataRows = dict;
        
        [DataWrapper addObject:db];
    }
    
}

- (void)setValueinRow:(NSString *)TableNames columnNames:(NSString *)column data:(NSString *)data{
//    dataCollection *DataBuffer = [[dataCollection alloc]init];
//    DataBuffer.tableName = TableNames;
//    [DataBuffer setValue:@"" forKey:column];
//    int index = [DataWrapper indexOfObject:DataBuffer];
//    [DataBuffer setValue:data forKey:column];
//    [DataWrapper replaceObjectAtIndex:index withObject:DataBuffer];
}

-(NSMutableArray *)getDataWrapper{
    return DataWrapper;
}



@end
