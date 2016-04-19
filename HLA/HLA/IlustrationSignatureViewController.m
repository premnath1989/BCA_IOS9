//
//  IlustrationSignatureViewController.m
//  BLESS
//
//  Created by Basvi on 4/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "IlustrationSignatureViewController.h"

@interface IlustrationSignatureViewController (){
    UIImage* imageCustomerSignature;
    UIImage* imageAgentSignature;
}

@end

@implementation IlustrationSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionCancelSign:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ActionSaveSign:(UIBarButtonItem *)sender {
    imageAgentSignature = viewToSign.image;
}

- (IBAction)ActionClearSign:(UIButton *)sender {
    [viewToSign clearView];
    //viewToSign.layer.sublayers = nil;
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
