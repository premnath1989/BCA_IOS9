//
//  SegmentSPAJ.h
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentSPAJ : UISegmentedControl
    @property (strong, nonatomic) NSString* segmentName;

-(void)setSegmentName:(NSString *)stringSegmentName;
-(NSString *)getSegmentName;
@end
