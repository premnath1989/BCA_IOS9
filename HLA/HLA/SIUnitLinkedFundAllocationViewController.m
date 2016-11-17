//
//  SIUnitLinkedFundAllocationViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedFundAllocationViewController.h"
#import "ModelSIULFundAllocation.h"


@interface SIUnitLinkedFundAllocationViewController (){
    ModelSIULFundAllocation* modelSIULFundAllocation;
}

@end

@implementation SIUnitLinkedFundAllocationViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULFundAllocation = [[ModelSIULFundAllocation alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark dictionary maker
-(void)setULFundAllocationDictionary{
    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]init];
    [dictFundAllocationData setObject:@"" forKey:@"SINO"];
    [dictFundAllocationData setObject:@"" forKey:@"ProductCode"];
    [dictFundAllocationData setObject:@"" forKey:@"ProductName"];
    [dictFundAllocationData setObject:@"" forKey:@"QuickQuote"];
    [dictFundAllocationData setObject:@"" forKey:@"SIDate"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_Name"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_DOB"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_Gender"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_Age"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_OccpCode"];
    [dictFundAllocationData setObject:@"" forKey:@"PO_Occp"];
    
    [delegate setULFundAllocationDictionary:dictFundAllocationData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIButton *)sender{
    //set the updated data to parent
    [self setULFundAllocationDictionary];
    
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
