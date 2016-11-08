//
//  WebResponObj.h
//  MPOS
//
//  Created by Erwin on 23/02/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class dataCollection;

@interface dataCollection : NSObject{
    NSString *tableName;
    NSMutableDictionary *dataRows;
}

@property (retain) NSString *tableName;
@property (retain) NSMutableDictionary *dataRows;
@end

@interface WebResponObj : NSObject{
    NSMutableArray *DataWrapper;
}

- (void)addRow:(NSString *)TableNames columnNames:(NSString *)column data:(NSString *)data;
- (void)setValueinRow:(NSString *)TableNames columnNames:(NSString *)column data:(NSString *)data;
- (NSMutableArray *)getDataWrapper;

@end