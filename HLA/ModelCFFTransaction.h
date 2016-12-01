//
//  ModelCFFTransaction.h
//  BLESS
//
//  Created by Basvi on 6/14/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@protocol CFFTransactionModelDelegate
-(void)voidCFFCompleted;
@end

@interface ModelCFFTransaction : NSObject{
    FMResultSet *results;
}

 @property (nonatomic,weak) id <CFFTransactionModelDelegate> delegate;

-(void)saveCFFTransaction:(NSDictionary *)cffTransactionDictionary;
-(NSMutableArray *)getAllCFF:(NSString *)sortedBy SortMethod:(NSString *)sortMethod;
-(NSMutableArray *)searchCFF:(NSDictionary *)dictSearch;
-(void)deleteCFFTransaction:(int)cffTransactionID;
-(void)updateCFFDateModified:(int)cffTransactionID;
-(void)updateCFFStatu:(NSString *)stringCFFStatus CFFTransactionID:(int)intCFFTransactionID;
@end
