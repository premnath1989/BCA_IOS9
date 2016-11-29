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
    NSMutableDictionary* dictPremiData;
}

@end

@implementation SIUnitLinkedFundAllocationViewController
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULFundAllocation = [[ModelSIULFundAllocation alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    NSDictionary* dictFundAllocationData=[[NSDictionary alloc]init];
    dictFundAllocationData = [delegate getULFundAllocationDictionary];
    if ([dictFundAllocationData count]!=0){
        if ([[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"] isEqualToString:@""]){
            [textFixedIncome setText:[dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"]];
            [textEquityIncome setText:[dictFundAllocationData valueForKey:@"IDREquityIncomeFund"]];
        }
        else{
            [textFixedIncome setText:[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"]];
            [textEquityIncome setText:[dictFundAllocationData valueForKey:@"USDEquityIncomeFund"]];
        }
    }
    else{
        
    }
}

#pragma mark dictionary maker
-(void)setULFundAllocationDictionary{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];

    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]init];
    [dictFundAllocationData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaProteksiNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaEkuitasNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaObligasiNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"BNPParibasCashInvestFund"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaProgresifNusantara"];
    
    if ([[dictPremiData valueForKey:@"PaymentCurrency"] isEqualToString:@"USD"]){
        [dictFundAllocationData setObject:@"" forKey:@"IDRFixedIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"IDREquityIncomeFund"];
        [dictFundAllocationData setObject:textFixedIncome.text forKey:@"USDFixedIncomeFund"];
        [dictFundAllocationData setObject:textEquityIncome.text forKey:@"USDEquityIncomeFund"];
    }
    else{
        [dictFundAllocationData setObject:textFixedIncome.text forKey:@"IDRFixedIncomeFund"];
        [dictFundAllocationData setObject:textEquityIncome.text forKey:@"IDREquityIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"USDFixedIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"USDEquityIncomeFund"];
    }
    
    [delegate setULFundAllocationDictionary:dictFundAllocationData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    //set the updated data to parent
    [self setULFundAllocationDictionary];
    
    //get updated data from parent and save it.
    [modelSIULFundAllocation saveULFundAllocationData:[delegate getULFundAllocationDictionary]];
    
    //go to next page
    [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:4 inSection:0]];
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
