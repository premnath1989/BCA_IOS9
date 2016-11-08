//
//  SpinnerUtilities.m
//  BLESS
//
//  Created by Erwin on 25/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "SpinnerUtilities.h"


@implementation SpinnerUtilities


@synthesize _hudView;
@synthesize _activityIndicatorView;
@synthesize _captionLabel;

- (instancetype) init{
    
    _hudView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
    _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _hudView.clipsToBounds = YES;
    _hudView.layer.cornerRadius = 10.0;

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.frame = CGRectMake(65, 40, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
    [_hudView addSubview:_activityIndicatorView];

    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    _captionLabel.backgroundColor = [UIColor clearColor];
    _captionLabel.textColor = [UIColor whiteColor];
    _captionLabel.adjustsFontSizeToFitWidth = YES;
    _captionLabel.textAlignment = NSTextAlignmentCenter;
    [_hudView addSubview:_captionLabel];
    
    return self;
}

- (void)startLoadingSpinner:(UIView *)view label:(NSString *)text{
    _hudView.center = view.center;
    _captionLabel.text = text;
    _hudView.hidden = false;
    [_activityIndicatorView startAnimating];
    [view addSubview:_hudView];
}

- (void)stopLoadingSpinner{
    _hudView.hidden = TRUE;
    _captionLabel.text = @"";
    [_activityIndicatorView stopAnimating];
    [_hudView removeFromSuperview];
}

@end