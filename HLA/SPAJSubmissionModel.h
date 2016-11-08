//
//  SPAJSubmissionModel.h
//  BLESS
//
//  Created by Basvi on 11/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Formatter.h"
@interface SPAJSubmissionModel : NSObject{
    FMResultSet *results;
    Formatter *formatter;
    sqlite3 *contactDB;
}
-(NSString *)stringPaymentMethod:(NSString *)stringPaymentMethod;
-(NSString *)stringCurrencyNumber:(NSString *)stringCurrency;
-(NSString *)getBlessVersion;
-(NSDictionary *)getSubsmissionInfo:(NSString *)SPAJEappNumber;
-(NSDictionary *)getChannelInfo:(NSString *)SPAJSINumber;
-(NSDictionary *)getAgentInfo;
-(NSString *)querySPAJDetailValue:(int)transactionID StringElementName:(NSString *)stringElementName;
-(NSArray *)getFileNamesFor:(NSString *)stringFileNameFilter DictTransaction:(NSDictionary *)dictTransaction;
-(NSString *)getFormNameFromFileName:(NSString *)stringFileName;
-(NSString *)getPersonType:(NSString *)stringFileName AtIndex:(int)indexString;
-(NSString *)getIDType:(NSString *)stringFileName AtIndex:(int)indexString;

-(NSString *)GetSexCode:(NSString *)stringSex;
-(NSString *)GetIDTypeCode:(NSString *)stringIDType;
-(NSString *)GetMaritalStatusCode:(NSString *)stringMaritalStatus;
-(NSString *)GetReligionCode:(NSString *)stringReligion;
-(NSString *)GetCorrespondenceAddressCode:(NSString *)stringCorrespondenceAddress;
-(NSString *)getStringFromString:(NSString *)stringFileName StringSeparator:(NSString *)stringSeparator AtIndex:(int)indexReturn;
-(NSString *)getPartTimeConfirmation:(NSString *)stringPartTimeWork;
-(NSMutableArray *)getSPAJAnswerElementValueForSubmission:(int)spajTransactionID Section:(NSString *)stringSection;
-(NSString *)getAnswerValue:(NSString *)stringAnswerValue;
-(NSString *)getAnswerType:(NSString *)stringElementID;
-(NSString *)stringFromArray:(NSMutableArray *)OriginalArray StringFilter:(NSString *)stringFilter;
@end
