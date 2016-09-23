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
-(NSMutableDictionary *)dictAnswers:(NSDictionary *)dictTransaction ElementID:(NSString *)elementID Value:(NSString *)value;
-(NSDictionary *)createDictionaryForSave:(NSMutableArray *)arrayAnswers;
@end
