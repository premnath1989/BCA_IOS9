//
//  SIUnitLinkedRiderViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedRiderViewController.h"
#import "ModelSIULRider.h"

@interface SIUnitLinkedRiderViewController (){
    ModelSIULRider* modelSIULRider;
}

@end

@implementation SIUnitLinkedRiderViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULRider = [[ModelSIULRider alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark dictionary maker
-(void)setULRiderDictionary{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]init];
    [dictPOLAData setObject:@"" forKey:@"SINO"];
    [dictPOLAData setObject:@"" forKey:@"ProductCode"];
    [dictPOLAData setObject:@"" forKey:@"ProductName"];
    [dictPOLAData setObject:@"" forKey:@"QuickQuote"];
    [dictPOLAData setObject:@"" forKey:@"SIDate"];
    [dictPOLAData setObject:@"" forKey:@"PO_Name"];
    [dictPOLAData setObject:@"" forKey:@"PO_DOB"];
    [dictPOLAData setObject:@"" forKey:@"PO_Gender"];
    [dictPOLAData setObject:@"" forKey:@"PO_Age"];
    [dictPOLAData setObject:@"" forKey:@"PO_OccpCode"];
    [dictPOLAData setObject:@"" forKey:@"PO_Occp"];
    [dictPOLAData setObject:@"" forKey:@"PO_ClientID"];
    [dictPOLAData setObject:@"" forKey:@"RelWithLA"];
    [dictPOLAData setObject:@"" forKey:@"LA_ClientID"];
    [dictPOLAData setObject:@"" forKey:@"LA_Name"];
    [dictPOLAData setObject:@"" forKey:@"LA_DOB"];
    [dictPOLAData setObject:@"" forKey:@"LA_Age"];
    [dictPOLAData setObject:@"" forKey:@"LA_Gender"];
    [dictPOLAData setObject:@"" forKey:@"LA_OccpCode"];
    [dictPOLAData setObject:@"" forKey:@"LA_Occp"];
    [dictPOLAData setObject:@"" forKey:@"IsInternalStaff"];
    [dictPOLAData setObject:@"" forKey:@"PO_Smoker"];
    [dictPOLAData setObject:@"" forKey:@"PO_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"PO_MonthlyIncome"];
    [dictPOLAData setObject:@"" forKey:@"LA_Smoker"];
    [dictPOLAData setObject:@"" forKey:@"LA_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"LA_MonthlyIncome"];
    
    [delegate setULRiderDictionary:dictPOLAData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIButton *)sender{
    //set the updated data to parent
    [self setULRiderDictionary];
    
    //get updated data from parent and save it.
    //[modelSIPOData savePOLAData:[delegate getPOLADictionary]];
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
