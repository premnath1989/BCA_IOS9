//
//  SIUnitLinkedBasicPlanViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedBasicPlanViewController.h"
#import "UnitLinkedPopOverViewController.h"
#import "ModelSIULBasicPlan.h"

@interface SIUnitLinkedBasicPlanViewController ()<UIPopoverPresentationControllerDelegate,UnitLinkedPopOverDelegate>{
    UnitLinkedPopOverViewController* unitLinkedPopOverVC;
    UIPopoverPresentationController *popController;
    
    ModelSIULBasicPlan *modelSIULBasicPlan;
}

@end

@implementation SIUnitLinkedBasicPlanViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unitLinkedPopOverVC = [[UnitLinkedPopOverViewController alloc]initWithNibName:@"UnitLinkedPopOverViewController" bundle:nil];
    unitLinkedPopOverVC.UnitLinkedPopOverDelegate = self;
    
    modelSIULBasicPlan = [[ModelSIULBasicPlan alloc]init];
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

#pragma mark dictionary maker
-(void)setULBasicPlanDictionary{
    NSMutableDictionary* dictULBasicPlanData = [[NSMutableDictionary alloc]init];
    [dictULBasicPlanData setObject:@"" forKey:@"SINO"];
    [dictULBasicPlanData setObject:@"" forKey:@"PaymentMode"];
    [dictULBasicPlanData setObject:@"" forKey:@"PreferredPremium"];
    [dictULBasicPlanData setObject:@"" forKey:@"RegularTopUp"];
    [dictULBasicPlanData setObject:@"" forKey:@"Premium"];
    [dictULBasicPlanData setObject:@"" forKey:@"SumAssured"];
    [dictULBasicPlanData setObject:@"" forKey:@"PremiumHolidayTerm"];
    [dictULBasicPlanData setObject:@"" forKey:@"TotalUnAppliedPremium"];
    [dictULBasicPlanData setObject:@"" forKey:@"TargetValue"];
    
    [delegate setBasicPlanDictionary:dictULBasicPlanData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIButton *)sender{
    //set the updated data to parent
    [self setULBasicPlanDictionary];
    
    //get updated data from parent and save it.
    [modelSIULBasicPlan saveULBasicPlanData:[delegate getBasicPlanDictionary]];

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
