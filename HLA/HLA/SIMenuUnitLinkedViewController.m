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
#import "ModelSIULRider.h"
#import "LoginDBManagement.h"

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
    ModelSIULRider *modelSIULRider;
    
    BOOL isPOFilled;
    BOOL isLAFilled;
    BOOL isBasicPlanFilled;
    BOOL isRiderFilled;
    BOOL isFundAllocationFilled;
    BOOL isSpecialOptionFilled;
}

@end

@implementation SIMenuUnitLinkedViewController{
    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
    NSMutableArray* arrayIntValidate;
    
    NSMutableArray* arrayUnitLinkedModuleView;
    NSMutableArray* arrayUnitLinkedModule;
}
@synthesize delegate;
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
    
    arrayUnitLinkedModule = [[NSMutableArray alloc]initWithObjects:siUnitLinkedPolicyHolderVC,siUnitLinkedLifeAssuredVC,siUnitLinkedBasicPlanVC,siUnitLinkedFundAllocationVC,siUnitLinkedRiderVC,siUnitLinkedSpecialOptionVC,siUnitLinkedQuotationVC, nil];
    
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSIULBasicPlan = [[ModelSIULBasicPlan alloc]init];
    modelSIMaster = [[Model_SI_Master alloc] init];
    modelSIULFundAllocation = [[ModelSIULFundAllocation alloc]init];
    modelSIULSpecialOption = [[ModelSIULSpecialOption alloc]init];
    modelSIULRider = [[ModelSIULRider alloc]init];
    
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
            else if (i==6){
                [self setSaveAsMode:stringSINumber];
                [delegate showQuotation:siUnitLinkedQuotationVC SINumber:stringSINumber];
                break;
            }
            [[arrayUnitLinkedModule objectAtIndex:i] loadDataFromList];
            [viewRightView addSubview:[arrayUnitLinkedModuleView objectAtIndex:i]];
        }
    }
    [self setBOOLSectionFilled];
    
    [myTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void) checkEditingMode {
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:stringSINumber];
    //disable all text fields
    [self setSaveAsMode:stringSINumber];
    if([EditMode caseInsensitiveCompare:@"0"] == NSOrderedSame){
        //disable
        [siUnitLinkedPolicyHolderVC.scrollPolicyHolder setUserInteractionEnabled:false];
        [siUnitLinkedLifeAssuredVC.viewLifeAssured setUserInteractionEnabled:false];
        [siUnitLinkedBasicPlanVC.scrollBasicPlan setUserInteractionEnabled:false];
        [siUnitLinkedFundAllocationVC.scrollFundAllocation setUserInteractionEnabled:false];
        [siUnitLinkedRiderVC.viewRider setUserInteractionEnabled:true];
        [siUnitLinkedSpecialOptionVC.scrollSpecialOption setUserInteractionEnabled:false];
    }else{
        //enable
        [siUnitLinkedPolicyHolderVC.scrollPolicyHolder setUserInteractionEnabled:true];
        [siUnitLinkedLifeAssuredVC.viewLifeAssured setUserInteractionEnabled:true];
        [siUnitLinkedBasicPlanVC.scrollBasicPlan setUserInteractionEnabled:true];
        [siUnitLinkedFundAllocationVC.scrollFundAllocation setUserInteractionEnabled:true];
        [siUnitLinkedRiderVC.viewRider setUserInteractionEnabled:true];
        [siUnitLinkedSpecialOptionVC.scrollSpecialOption setUserInteractionEnabled:true];
    }
}

-(IBAction)brochureTapped:(id)sender{
    [delegate brochureTapped:nil];
}

-(IBAction)saveTapped:(id)sender{
    [delegate SetUnitLinkedSINumber:stringSINumber];
    [delegate SaveTapped:nil];
}

- (void)setSaveAsMode:(NSString *)SINO{
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:SINO];
    NSLog(@" Edit Mode second %@ : %@", EditMode, SINO);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] != NSOrderedSame){
        outletSaveAs.hidden = YES;
    }else{
        outletSaveAs.hidden = NO;
    }
}


-(NSString *)getRunnigSINumber{
    return stringSINumber;
}

-(void)setBOOLSectionFilled{
    isPOFilled = false;
    isLAFilled = false;
    isBasicPlanFilled = false;
    isRiderFilled = false;
    isFundAllocationFilled = false;
    isSpecialOptionFilled = false;
    
    if ([dictParentPOLAData count]>0){
        isPOFilled = true;
        if ([[dictParentPOLAData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
            isLAFilled = true;
        }
        else {
            if ([[dictParentPOLAData valueForKey:@"LA_Name"] isEqualToString:@""]){
                isLAFilled = false;
            }
            else{
                isLAFilled = true;
            }
            
        }
        
    }
    if ([dictParentULBasicPlanData count]>0){
        isBasicPlanFilled = true;
    }
    if ([dictParentULFundAllocationData count]>0){
        isFundAllocationFilled = true;
    }
    
    if ([arrayRiderData count]>0){
        isRiderFilled = true;
    }
    
    if ([arraySpecialOptionData count]>0){
        isSpecialOptionFilled = true;
    }
    
    [myTableView reloadData];
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
-(void)setInitialULRiderArray{
    arrayRiderData = [[NSMutableArray alloc]initWithArray:[modelSIULRider getULRiderDataFor:stringSINumber]];
}

-(void)setULRiderDictionary:(NSMutableArray *)arrayULRiderData{
    arrayRiderData = [[NSMutableArray alloc]initWithArray:arrayULRiderData];
}

-(NSMutableArray *)getULRiderArray{
    return arrayRiderData ;
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
-(void)dismissUnitLinkedView{
    [delegate dismissUnitLinkedView:[self getPOLADictionary]];
}

-(void)setExchangePOLADictionary:(NSMutableDictionary *)dictPOLAdata{
    dictParentPOLAData = [[NSMutableDictionary alloc]initWithDictionary:dictPOLAdata];
}

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
    
    if (indexPath.row==0){
        if (isPOFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        [cell setUserInteractionEnabled:true];
    }
    else if (indexPath.row==1){
        if (isLAFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
            if ([[dictParentPOLAData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
                [cell setUserInteractionEnabled:false];
            }
            else{
                [cell setUserInteractionEnabled:true];
            }
        }
        else{
            if (isPOFilled){
                if ([[dictParentPOLAData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
                    [cell setUserInteractionEnabled:false];
                }
                else{
                    [cell setUserInteractionEnabled:true];
                }
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
    }
    else if (indexPath.row==2){
        if (isBasicPlanFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            if (isLAFilled){
                [cell setUserInteractionEnabled:true];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
    }else if (indexPath.row==3){
        if (isFundAllocationFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            if (isBasicPlanFilled){
                [cell setUserInteractionEnabled:true];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
    }else if (indexPath.row==4){
        if (isRiderFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            if (isFundAllocationFilled){
                [cell setUserInteractionEnabled:true];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
    }else if (indexPath.row==5){
        if (isSpecialOptionFilled){
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1.0]];
        }
        else{
            if (isRiderFilled){
                [cell setUserInteractionEnabled:true];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
    }
    else if (indexPath.row==6){
        if (isSpecialOptionFilled){
            [cell setUserInteractionEnabled:true];
        }
        else{
            [cell setUserInteractionEnabled:false];
        }
    }
    
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
