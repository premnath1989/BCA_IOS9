//
//  SPAJIDCapturedViewController.m
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJIDCapturedViewController.h"

@interface SPAJIDCapturedViewController ()

@end

@implementation SPAJIDCapturedViewController
@synthesize dictionaryIDData;
@synthesize imageFront,imageBack;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 587, 600);
    [self.view.superview setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [self loadIDInformation];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadIDInformation{
    NSString* IDType  = [dictionaryIDData valueForKey:@"IDType"];
    NSString* stringName = [dictionaryIDData valueForKey:@"stringName"];
    
    [imageViewFront setImage:imageFront];
    [imageViewBack setImage:imageBack];
    [labelIDDesc setText:IDType];
    [labelName setText:stringName];
}


-(IBAction)actionClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
