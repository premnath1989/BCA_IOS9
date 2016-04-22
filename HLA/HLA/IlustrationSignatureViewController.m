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
    
    BOOL customerSigned;
    BOOL agentSigned;
}

@end

@implementation IlustrationSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    customerSigned = FALSE;
    agentSigned = FALSE;
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
    if (!customerSigned){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIView *view = viewToSign;
            UIGraphicsBeginImageContext(view.bounds.size);
            [view.layer renderInContext:UIGraphicsGetCurrentContext()];
            imageCustomerSignature = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                [self ActionClearSign:nil];
                [labelSigner setText:@"Tanda Tangan Agen Asuransi"];
                customerSigned = TRUE;
            });
        });
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIView *view = viewToSign;
            UIGraphicsBeginImageContext(view.bounds.size);
            [view.layer renderInContext:UIGraphicsGetCurrentContext()];
            imageAgentSignature = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                [self ActionClearSign:nil];
                agentSigned = TRUE;
                [_delegate capturedSignature:imageCustomerSignature AgentSignature:imageAgentSignature];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
    
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
