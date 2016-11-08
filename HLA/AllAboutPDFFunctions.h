//
//  RadioButtonOutputValue.h
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassImageProcessing.h"
#import "ModelSPAJSignature.h"
#import "ModelSPAJHtml.h"
#import "Formatter.h"

@protocol PDFFunctionDelegate

- (void) allSignatureCreated;

@end


@interface AllAboutPDFFunctions : NSObject{
    ClassImageProcessing *classImageProcessing;
    ModelSPAJSignature *modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    Formatter* formatter;
}
@property (nonatomic,weak) id <PDFFunctionDelegate> delegatePDFFunctions;

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

- (void)createFileDirectory:(NSString *)fileTimeDirectory;
-(NSMutableArray *)createImageSignatureForEapp:(NSDictionary *)dictTransaction;
@end
