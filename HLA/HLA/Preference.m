//
//  Preference.m
//  MPOS
//
//  Created by Meng Cheong on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Preference.h"
#import "ColorHexCode.h"
#import "DataClass.h"

@interface Preference (){
    DataClass *obj;
}

@end

@implementation Preference
@synthesize sliderValue;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    
	ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"Customer Fact Find";
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDone:)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    obj=[DataClass getInstance];
    
    _programmaticallyCreatedSlider = [[UISlider alloc] initWithFrame:_sliderView.bounds];
    
    _programmaticallyCreatedSlider.maximumValue = 5;
    _programmaticallyCreatedSlider.minimumValue = 0;
    
    _programmaticallyCreatedSlider.frame = CGRectMake(60, -50, 620, 150);
    
    _markerImage = [UIImage imageNamed:@"marker.png"];
    _markerValueColor = [UIColor blackColor];
    _markerValueOffsetFromSlider = 10.00;
    
    UIImage *thumbImage = [_programmaticallyCreatedSlider thumbImageForState:UIControlStateNormal];
    float scaleFactor = (_programmaticallyCreatedSlider.frame.size.width - thumbImage.size.width) / (_programmaticallyCreatedSlider.maximumValue - _programmaticallyCreatedSlider.minimumValue);
    [_markerValueColor set];
    
    for(int index = 0 ; index + _programmaticallyCreatedSlider.minimumValue <= _programmaticallyCreatedSlider.maximumValue ; index ++){
        float x = (scaleFactor * 0.95 * index) + 70 ;
        float y = _programmaticallyCreatedSlider.center.y + _markerImage.size.height +_markerImageOffsetFromSlider;
        
        UIImageView *markerImageView  = [[UIImageView alloc] initWithImage:_markerImage];
        markerImageView.frame = CGRectMake(x, y, _markerImage.size.width, _markerImage.size.height);
        
        [self.sliderView insertSubview:markerImageView belowSubview:_programmaticallyCreatedSlider];
        
        NSString *value = [NSString stringWithFormat:@"%0.0lf",index + _programmaticallyCreatedSlider.minimumValue];
        CGSize size = [value sizeWithFont:[UIFont systemFontOfSize:10]];
        
        UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(markerImageView.frame.origin.x - (size.width/2),  markerImageView.frame.origin.y + markerImageView.frame.size.height + _markerValueOffsetFromSlider, 15, 20)];
        [yourLabel setTextColor:[UIColor blackColor]];
        yourLabel.text = value;
        [self.sliderView insertSubview:yourLabel belowSubview:_programmaticallyCreatedSlider];

        
    }
    
    [_programmaticallyCreatedSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //_programmaticallyCreatedSlider.value = 120.0;
    

    
	
    [_sliderView addSubview:_programmaticallyCreatedSlider];
    
    //	[_programmaticallyCreatedSlider]
    //    [_programmaticallyCreatedSlider setMarkerImageOffsetFromSlider:0];
    [_programmaticallyCreatedSlider setValue:[[[obj.CFFData objectForKey:@"SecE"] objectForKey:@"Preference"] intValue]];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
    //NSLog(@"rrr%@",[[obj.CFFData objectForKey:@"SecE"] objectForKey:@"Preference"]);
    
    sliderValue = [[obj.CFFData objectForKey:@"SecE"] objectForKey:@"Preference"];
    _changed = FALSE;
    if (sliderValue && ![sliderValue isEqualToString:@"0"]) {
        _changed = TRUE;
    }
    
    
}

- (void)valueChanged:(UISlider *)sender {
    //    NSLog(@"Delegate called");
	//NSLog(@"prefer: %d", sender.value);
    
    double value = _programmaticallyCreatedSlider.value;
    int calculatedValue = round(value);
    [_programmaticallyCreatedSlider setValue:calculatedValue];
    
    sliderValue = [NSString stringWithFormat:@"%.0f", sender.value];
    
    _changed = TRUE;
    if (sender.value != 0){
        UIImageView *imageView=(UIImageView *)[self.parentViewController.view viewWithTag:3004];
        //imageView.hidden = FALSE;
        imageView = nil;
        [[obj.CFFData objectForKey:@"SecE"] setValue:sliderValue forKey:@"Preference"];
        [[obj.CFFData objectForKey:@"SecE"] setValue:@"1" forKey:@"Completed"];
    }
    else{
        UIImageView *imageView=(UIImageView *)[self.parentViewController.view viewWithTag:3004];
        //imageView.hidden = TRUE;;
        imageView = nil;
        [[obj.CFFData objectForKey:@"SecE"] setValue:@"0" forKey:@"Preference"];
        [[obj.CFFData objectForKey:@"SecE"] setValue:@"0" forKey:@"Completed"];
    }
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFValidate"];
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFSave"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
