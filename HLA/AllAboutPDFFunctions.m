//
//  RadioButtonOutputValue.m
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AllAboutPDFFunctions.h"

@implementation AllAboutPDFFunctions

-(NSString *)GetOutputForYaTidakRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Ya"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Tidak"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForRelationWithPORadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Keluarga"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Referensi"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Tidak Sengaja"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Iklan"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Teman/ Kerabat"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Sub Keagenan"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Lainnya"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForDurationKnowPORadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Tidak Kenal"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"< 1 tahun"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"< 5 tahun"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Selama Hidup"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSMutableDictionary *)dictAnswers:(NSDictionary *)dictTransaction ElementID:(NSString *)elementID Value:(NSString *)value{
    NSMutableDictionary *dictAnswer=[[NSMutableDictionary alloc]init];
    [dictAnswer setObject:@"0" forKey:@"SPAJHtmlID"];
    [dictAnswer setObject:[dictTransaction valueForKey:@"SPAJTransactionID"] forKey:@"SPAJTransactionID"];
    [dictAnswer setObject:@"AF" forKey:@"SPAJHtmlSection"];
    [dictAnswer setObject:@"1" forKey:@"CustomerID"];
    [dictAnswer setObject:@"1" forKey:@"SPAJID"];
    [dictAnswer setObject:value forKey:@"Value"];
    [dictAnswer setObject:elementID forKey:@"elementID"];
    return dictAnswer;
}

-(NSDictionary *)createDictionaryForSave:(NSMutableArray *)arrayAnswers{
    NSDictionary* dictAnswers = [[NSDictionary alloc]initWithObjectsAndKeys:arrayAnswers,@"SPAJAnswers", nil];
    
    NSDictionary* dictSPAJAnswers = [[NSDictionary alloc]initWithObjectsAndKeys:dictAnswers,@"data",@"onError",@"errorCallback",@"onSuccess",@"successCallBack", nil];
    return dictSPAJAnswers;
}

@end
