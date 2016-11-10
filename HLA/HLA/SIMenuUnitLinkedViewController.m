//
//  SIMenuUnitLinkedViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIMenuUnitLinkedViewController.h"
#import "SIUnitLinkedRiderViewController.h"
#import "SIUnitLinkedBasicPlanViewController.h"
#import "SIUnitLinkedQuotationViewController.h"
#import "SIUnitLinkedFundAllocationViewController.h"
#import "SIUnitLinkedLifeAssuredViewController.h"
#import "SIUnitLinkedPolicyHolderViewController.h"
#import "SIUnitLinkedSpecialOptionViewController.h"

@interface SIMenuUnitLinkedViewController (){
    SIUnitLinkedRiderViewController * siUnitLinkedRiderVC;
    SIUnitLinkedBasicPlanViewController *siUnitLinkedBasicPlanVC;
    SIUnitLinkedQuotationViewController *siUnitLinkedQuotationVC;
    SIUnitLinkedFundAllocationViewController *siUnitLinkedFundAllocationVC;
    SIUnitLinkedLifeAssuredViewController *siUnitLinkedLifeAssuredVC;
    SIUnitLinkedPolicyHolderViewController *siUnitLinkedPolicyHolderVC;
    SIUnitLinkedSpecialOptionViewController *siUnitLinkedSpecialOptionVC;
}

@end

@implementation SIMenuUnitLinkedViewController{
    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
    NSMutableArray* arrayIntValidate;
    
    NSMutableArray* arrayUnitLinkedModuleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    siUnitLinkedPolicyHolderVC =[[SIUnitLinkedPolicyHolderViewController alloc]initWithNibName:@"SIUnitLinkedPolicyHolderViewController" bundle:nil];
    [siUnitLinkedPolicyHolderVC.view setTag:0];
    
    siUnitLinkedLifeAssuredVC =[[SIUnitLinkedLifeAssuredViewController alloc]initWithNibName:@"SIUnitLinkedLifeAssuredViewController" bundle:nil];
    [siUnitLinkedLifeAssuredVC.view setTag:1];
    
    siUnitLinkedBasicPlanVC =[[SIUnitLinkedBasicPlanViewController alloc]initWithNibName:@"SIUnitLinkedBasicPlanViewController" bundle:nil];
    [siUnitLinkedBasicPlanVC.view setTag:2];
    
    siUnitLinkedFundAllocationVC =[[SIUnitLinkedFundAllocationViewController alloc]initWithNibName:@"SIUnitLinkedFundAllocationViewController" bundle:nil];
    [siUnitLinkedFundAllocationVC.view setTag:3];
    
    siUnitLinkedRiderVC = [[SIUnitLinkedRiderViewController alloc]initWithNibName:@"SIUnitLinkedRiderViewController" bundle:nil];
    [siUnitLinkedRiderVC.view setTag:4];
    
    siUnitLinkedSpecialOptionVC =[[SIUnitLinkedSpecialOptionViewController alloc]initWithNibName:@"SIUnitLinkedSpecialOptionViewController" bundle:nil];
    [siUnitLinkedSpecialOptionVC.view setTag:5];
    
    siUnitLinkedQuotationVC =[[SIUnitLinkedQuotationViewController alloc]initWithNibName:@"SIUnitLinkedQuotationViewController" bundle:nil];
    [siUnitLinkedQuotationVC.view setTag:6];
    
    
    arrayUnitLinkedModuleView = [[NSMutableArray alloc]initWithObjects:siUnitLinkedPolicyHolderVC.view,siUnitLinkedLifeAssuredVC.view,siUnitLinkedBasicPlanVC.view,siUnitLinkedFundAllocationVC.view,siUnitLinkedRiderVC.view,siUnitLinkedSpecialOptionVC.view,siUnitLinkedQuotationVC.view, nil];
    
    arrayIntValidate = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5",@"6",@"7", nil];
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Pemegang Polis", @"Tertanggung", @"Asuransi Dasar", @"Alokasi Uang",@"Asuransi Tambahan",@"Special Option",@"Ilustrasi", nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIllustrationNumber:(NSString *)stringIllustrationNumber{
    stringSINumber = stringIllustrationNumber;
}

-(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath{
    for (int i=0;i<[arrayUnitLinkedModuleView count];i++){
        if (i == indexPath.row){
            if (i==0){
                [siUnitLinkedPolicyHolderVC.textIllustrationNumber setText:stringSINumber];
            }
            [viewRightView addSubview:[arrayUnitLinkedModuleView objectAtIndex:i]];
        }
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return ListOfSubMenu.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"Cell";
    SIMenuTableViewCell *cell = (SIMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UIView *bgColorView = [[UIView alloc] init];
    if (indexPath.row<[arrayIntValidate count]){
        if ([[arrayIntValidate objectAtIndex:indexPath.row] isEqualToString:@"1"]){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
    }
    else{
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    
    /*if (indexPath.row == 1){
        if (selfRelation){
            [cell setUserInteractionEnabled:NO];
        }
        else{
            [cell setUserInteractionEnabled:YES];
        }
    }*/
    
    bgColorView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell.button1 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button2 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button3 addTarget:self action:@selector(showviewControllerFromCellView:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.button1 setEnabled:false];
    [cell.button2 setEnabled:false];
    [cell.button3 setEnabled:false];
    
    if ([[NumberListOfSubMenu objectAtIndex:indexPath.row] isEqualToString:@"0"]){
        [cell.labelNumber setText:@""];
        [cell.labelDesc setText:@""];
        [cell.labelWide setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
    }
    else{
        [cell.labelNumber setText:[NumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showUnitLinkModuleAtIndex:indexPath];
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
