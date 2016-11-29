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
#import "ModelSIPOData.h"
#import "Model_SI_Master.h"
#import "ModelSIULBasicPlan.h"
#import "ModelSIULFundAllocation.h"
#import "ModelSIULSpecialOption.h"

@interface SIMenuUnitLinkedViewController ()<ULPolicyHolderViewControllerDelegate,ULLifeAssuredViewControllerDelegate,ULBasicPlanViewControllerDelegate,ULRiderViewControllerDelegate,ULSpecialOptionViewControllerDelegate,ULFundAllocationViewControllerDelegate,ULQuotationViewControllerDelegate>{
    SIUnitLinkedRiderViewController * siUnitLinkedRiderVC;
    SIUnitLinkedBasicPlanViewController *siUnitLinkedBasicPlanVC;
    SIUnitLinkedQuotationViewController *siUnitLinkedQuotationVC;
    SIUnitLinkedFundAllocationViewController *siUnitLinkedFundAllocationVC;
    SIUnitLinkedLifeAssuredViewController *siUnitLinkedLifeAssuredVC;
    SIUnitLinkedPolicyHolderViewController *siUnitLinkedPolicyHolderVC;
    SIUnitLinkedSpecialOptionViewController *siUnitLinkedSpecialOptionVC;
    
    ModelSIPOData *modelSIPOData;
    ModelSIULBasicPlan *modelSIULBasicPlan;
    Model_SI_Master *modelSIMaster;
    ModelSIULFundAllocation* modelSIULFundAllocation;
    ModelSIULSpecialOption *modelSIULSpecialOption;
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
    [siUnitLinkedPolicyHolderVC setDelegate:self];
    
    siUnitLinkedLifeAssuredVC =[[SIUnitLinkedLifeAssuredViewController alloc]initWithNibName:@"SIUnitLinkedLifeAssuredViewController" bundle:nil];
    [siUnitLinkedLifeAssuredVC.view setTag:1];
    [siUnitLinkedLifeAssuredVC setDelegate:self];
    
    siUnitLinkedBasicPlanVC =[[SIUnitLinkedBasicPlanViewController alloc]initWithNibName:@"SIUnitLinkedBasicPlanViewController" bundle:nil];
    [siUnitLinkedBasicPlanVC.view setTag:2];
    [siUnitLinkedBasicPlanVC setDelegate:self];
    
    siUnitLinkedFundAllocationVC =[[SIUnitLinkedFundAllocationViewController alloc]initWithNibName:@"SIUnitLinkedFundAllocationViewController" bundle:nil];
    [siUnitLinkedFundAllocationVC.view setTag:3];
    [siUnitLinkedFundAllocationVC setDelegate:self];
    
    siUnitLinkedRiderVC = [[SIUnitLinkedRiderViewController alloc]initWithNibName:@"SIUnitLinkedRiderViewController" bundle:nil];
    [siUnitLinkedRiderVC.view setTag:4];
    [siUnitLinkedRiderVC setDelegate:self];
    
    siUnitLinkedSpecialOptionVC =[[SIUnitLinkedSpecialOptionViewController alloc]initWithNibName:@"SIUnitLinkedSpecialOptionViewController" bundle:nil];
    [siUnitLinkedSpecialOptionVC.view setTag:5];
    [siUnitLinkedSpecialOptionVC setDelegate:self];
    
    siUnitLinkedQuotationVC =[[SIUnitLinkedQuotationViewController alloc]initWithNibName:@"SIUnitLinkedQuotationViewController" bundle:nil];
    [siUnitLinkedQuotationVC.view setTag:6];
    [siUnitLinkedQuotationVC setDelegate:self];
    
    
    arrayUnitLinkedModuleView = [[NSMutableArray alloc]initWithObjects:siUnitLinkedPolicyHolderVC.view,siUnitLinkedLifeAssuredVC.view,siUnitLinkedBasicPlanVC.view,siUnitLinkedFundAllocationVC.view,siUnitLinkedRiderVC.view,siUnitLinkedSpecialOptionVC.view,siUnitLinkedQuotationVC.view, nil];
    
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSIULBasicPlan = [[ModelSIULBasicPlan alloc]init];
    modelSIMaster = [[Model_SI_Master alloc] init];
    modelSIULFundAllocation = [[ModelSIULFundAllocation alloc]init];
    modelSIULSpecialOption = [[ModelSIULSpecialOption alloc]init];
    
    arrayIntValidate = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5",@"6",@"7", nil];
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Pemegang Polis", @"Tertanggung", @"Asuransi Dasar", @"Alokasi Uang",@"Asuransi Tambahan",@"Special Option",@"Ilustrasi", nil];

    
    //load pemegang polis view
    [self showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
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
                [siUnitLinkedPolicyHolderVC loadDataFromList];
            }
            else if (i==1){
                [siUnitLinkedLifeAssuredVC loadDataFromList];
            }
            [viewRightView addSubview:[arrayUnitLinkedModuleView objectAtIndex:i]];
        }
    }
    [myTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

-(NSString *)getRunnigSINumber{
    return stringSINumber;
}
#pragma mark Save SIMaster

-(void)saveSIMaster{
    NSMutableDictionary *dictionaryMasterForInsert = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[self getPOLADictionary] valueForKey:@"SINO"],@"SINO",@"1.1",@"SI_Version",@"Not Created",@"ProposalStatus", nil];
    
    [modelSIMaster saveSIMaster:dictionaryMasterForInsert];
}

#pragma mark delegate Fund Allocation
-(void)setInitialULFundAllocationDictionary{
    dictParentULFundAllocationData = [[NSMutableDictionary alloc]initWithDictionary:[modelSIULFundAllocation getULFundAllocationDataFor:stringSINumber]];
}

-(void)setULFundAllocationDictionary:(NSMutableDictionary *)dictULBasicPlanData{
    dictParentULFundAllocationData = [[NSMutableDictionary alloc]initWithDictionary:dictULBasicPlanData];
}

-(NSMutableDictionary *)getULFundAllocationDictionary{
    return dictParentULFundAllocationData ;
}

#pragma mark delegate Special Option
-(void)setInitialULSpecialOptionDictionary{
    arraySpecialOptionData = [[NSMutableArray alloc]initWithArray:[modelSIULSpecialOption getULSpecialOptionDataFor:stringSINumber]];
}

-(void)setULSpecialOptionArray:(NSMutableArray *)arraySpecialOption{
    arraySpecialOptionData = [[NSMutableArray alloc]initWithArray:arraySpecialOption];
}

-(NSMutableArray *)getULSpecialOptionArray{
    return arraySpecialOptionData ;
}

#pragma mark delegate Rider
-(void)setInitialULRiderDictionary{
    dictParentULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:[modelSIULBasicPlan getULBasicPlanDataFor:stringSINumber]];
}

-(void)setULRiderDictionary:(NSMutableDictionary *)dictULBasicPlanData{
    dictParentULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:dictULBasicPlanData];
}

-(NSMutableDictionary *)getULRiderDictionary{
    return dictParentULBasicPlanData ;
}


#pragma mark delegate basic plan
-(void)setInitialULBasicPlanDictionary{
    dictParentULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:[modelSIULBasicPlan getULBasicPlanDataFor:stringSINumber]];
}

-(void)setBasicPlanDictionary:(NSMutableDictionary *)dictULBasicPlanData{
    dictParentULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:dictULBasicPlanData];
}

-(NSMutableDictionary *)getBasicPlanDictionary{
    return dictParentULBasicPlanData ;
}

#pragma mark delegate POLA
-(void)setInitialPOLADictionary{
    dictParentPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[modelSIPOData getPOLADataFor:stringSINumber]];
}

-(void)setPOLADictionary:(NSMutableDictionary *)dictPOLAData{
    dictParentPOLAData = [[NSMutableDictionary alloc]initWithDictionary:dictPOLAData];
}

-(NSMutableDictionary *)getPOLADictionary{
    return dictParentPOLAData ;
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
