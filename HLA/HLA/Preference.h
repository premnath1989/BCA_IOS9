//
//  Preference.h
//  MPOS
//
//  Created by Meng Cheong on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVCalibratedSlider.h"
#import "TVSlider.h"

@interface Preference : UITableViewController<TVCalibratedSliderDelegate>{
    UIColor  *_markerValueColor;
    UISlider *_programmaticallyCreatedSlider;
    UIImage  *_markerImage;
    float    _markerImageOffsetFromSlider;
    float    _markerValueOffsetFromSlider;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *sliderView;
@property (strong, nonatomic) NSString *sliderValue;
@property (nonatomic, assign) bool changed;

@end
