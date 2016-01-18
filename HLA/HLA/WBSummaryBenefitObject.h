//
//  WBSummaryBenefitObject.h
//  iMobile Planner
//
//  Created by CK Quek on 9/1/15.
//  Copyright (c) 2015 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSummaryBenefitObject : NSObject

@property(nonatomic,strong)NSString* Title;
@property (nonatomic, assign,readwrite) int term;
@property (nonatomic, assign,readwrite) double sceA;
@property (nonatomic, assign,readwrite) double sceB;

@end
