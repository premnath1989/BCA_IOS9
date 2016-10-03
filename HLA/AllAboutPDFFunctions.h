//
//  RadioButtonOutputValue.h
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAboutPDFFunctions : NSObject
-(NSString *)GetOutputForDurationKnowPORadioButton:(NSString *)stringSegmentSelected;
-(NSString *)GetOutputForRelationWithPORadioButton:(NSString *)stringSegmentSelected;
-(NSString *)GetOutputForYaTidakRadioButton:(NSString *)stringSegmentSelected;
-(NSString *)GetOutputForInsurancePurposeCheckBox:(NSString *)stringInsurancePurpose;
-(NSMutableDictionary *)dictAnswers:(NSDictionary *)dictTransaction ElementID:(NSString *)elementID Value:(NSString *)value Section:(NSString *)stringSection SPAJHtmlID:(NSString *)stringHtmlID;
-(NSDictionary *)createDictionaryForSave:(NSMutableArray *)arrayAnswers;
-(NSString *)GetOutputForRadioButton:(NSString *)stringSegmentSelected;
-(void)showDict;
-(void)createDictionaryForRadioButton;
-(void)createDictionaryRevertForRadioButton;
-(int)getRadioButtonIndexMapped:(NSString *)stringElementName;
-(void)createArrayRevertForRadioButton;

-(NSArray *)filterArrayByKey:(NSString *)stringKey;
@end
