//
//  SegmentSPAJ.m
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SegmentSPAJ.h"

@implementation SegmentSPAJ
@synthesize segmentName;

-(void)setSegmentName:(NSString *)stringSegmentName{
    segmentName = stringSegmentName;
}

-(NSString *)getSegmentName{
    return segmentName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
