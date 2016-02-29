//
//  SpinnerUtilities.h
//  BLESS
//
//  Created by Erwin on 25/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpinnerUtilities : NSObject{
    UIView *_hudView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel *_captionLabel;
}

- (instancetype) init;
- (void) stopLoadingSpinner;
- (void) startLoadingSpinner:(UIView *)view label:(NSString *)text;

@end