//
//  SpinnerUtilities.h
//  BLESS
//
//  Created by Erwin on 25/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpinnerUtilities : NSObject


@property (nonatomic,strong) UIView *_hudView;
@property (nonatomic,strong) UIActivityIndicatorView *_activityIndicatorView;
@property (nonatomic,strong) UILabel *_captionLabel;

- (instancetype) init;
- (void) stopLoadingSpinner;
- (void) startLoadingSpinner:(UIView *)view label:(NSString *)text;

@end