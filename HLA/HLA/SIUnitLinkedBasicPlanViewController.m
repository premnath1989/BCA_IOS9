//
//  SIUnitLinkedBasicPlanViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedBasicPlanViewController.h"
#import "UnitLinkedPopOverViewController.h"

@interface SIUnitLinkedBasicPlanViewController ()<UIPopoverPresentationControllerDelegate,UnitLinkedPopOverDelegate>{
    UnitLinkedPopOverViewController* unitLinkedPopOverVC;
    UIPopoverPresentationController *popController;
}

@end

@implementation SIUnitLinkedBasicPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unitLinkedPopOverVC = [[UnitLinkedPopOverViewController alloc]initWithNibName:@"UnitLinkedPopOverViewController" bundle:nil];
    unitLinkedPopOverVC.UnitLinkedPopOverDelegate = self;
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)actionTargetAccountValue:(UIButton *)sender{
    NSMutableArray* arrayTableDesc = [[NSMutableArray alloc]initWithObjects:@"Pension Fund",@"Equal To SA", nil];
    NSMutableArray* arrayTableCode = [[NSMutableArray alloc]initWithObjects:@"PF",@"ESA", nil];
    
    NSDictionary* dictTablePopOver = [[NSDictionary alloc]initWithObjectsAndKeys:arrayTableDesc,@"TableDesc",arrayTableCode,@"TableCode", nil];
    [unitLinkedPopOverVC setTablData:dictTablePopOver Title:@"Target Account Value"];
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    unitLinkedPopOverVC.modalPresentationStyle = UIModalPresentationPopover;
    unitLinkedPopOverVC.preferredContentSize = CGSizeMake(350, 300);
    
    popController = [unitLinkedPopOverVC popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;
    popController.delegate = self;
    [self presentViewController:unitLinkedPopOverVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate
-(void)TableData:(NSString *)stringDesc TableCode:(NSString *)stringCode{
    [buttonTargetAccountValue setTitle:stringDesc forState:UIControlStateNormal];
    [[popController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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