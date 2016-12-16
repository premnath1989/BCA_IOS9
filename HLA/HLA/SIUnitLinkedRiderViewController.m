//
//  SIUnitLinkedRiderViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedRiderViewController.h"
#import "ModelSIULRider.h"
#import "ULRiderTableViewCell.h"

@interface SIUnitLinkedRiderViewController (){
    IBOutlet UITableView *tableRider;
    IBOutlet UIButton *buttonManfaat;
    IBOutlet UITextField *textTerm;
    IBOutlet UITextField *textUangPertanggungan;
    IBOutlet UITextField *textKelasPekerjaan;
    IBOutlet UITextField *textOccpLoading;
    IBOutlet UITextField *textUnit;
    IBOutlet UITextField *textExtraPremiPercent;
    IBOutlet UITextField *textExtraPremiMil;
    IBOutlet UITextField *textMasaExtraPremi;
    
    ModelSIULRider* modelSIULRider;
    NSMutableArray* arrayRiderData;
    NSMutableDictionary *dictPremiData;
}

@end

@implementation SIUnitLinkedRiderViewController
@synthesize delegate;
-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    [tableRider reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULRider = [[ModelSIULRider alloc]init];
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDataFromList{
    arrayRiderData=[[NSMutableArray alloc]init];
    arrayRiderData = [delegate getULRiderArray];
    
    if ([arrayRiderData count]<=0){
        arrayRiderData = [[NSMutableArray alloc]initWithObjects:[self dictionaryRider1],/*[self dictionaryRider2],*/[self dictionaryRider3], nil];
    }
}

-(void)showRiderDataDetail:(NSDictionary *)dictRiderData{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    [buttonManfaat setTitle:[dictRiderData valueForKey:@"RiderDesc"] forState:UIControlStateNormal];
    [textTerm setText:@""];
    [textUangPertanggungan setText:[dictRiderData valueForKey:@"SumAssured"]];
    [textKelasPekerjaan setText:@""];
    [textOccpLoading setText:@""];
    [textUnit setText:@""];
    [textExtraPremiPercent setText:[dictRiderData valueForKey:@"ExtraPremiPercent"]];
    [textExtraPremiMil setText:[dictRiderData valueForKey:@"ExtraPremiMil"]];
    [textMasaExtraPremi setText:[dictPremiData valueForKey:@"ExtraPremiumTerm"]];
}

-(NSMutableDictionary *)dictionaryRider1{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    NSMutableDictionary* dictULRiderData = [[NSMutableDictionary alloc]init];
    [dictULRiderData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictULRiderData setObject:@"" forKey:@"RiderCode"];
    [dictULRiderData setObject:@"Meninggal Dunia" forKey:@"RiderDesc"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"SumAssured"] forKey:@"SumAssured"];
    [dictULRiderData setObject:@"" forKey:@"Term"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumMil"] forKey:@"ExtraPremiMil"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiMilTerm"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumPercentage"] forKey:@"ExtraPremiPercent"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiPercentTerm"];
    return dictULRiderData;
}

-(NSDictionary *)dictionaryRider2{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    NSMutableDictionary* dictULRiderData = [[NSMutableDictionary alloc]init];
    [dictULRiderData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictULRiderData setObject:@"" forKey:@"RiderCode"];
    [dictULRiderData setObject:@"Akhir Pertanggungan" forKey:@"RiderDesc"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"SumAssured"] forKey:@"SumAssured"];
    [dictULRiderData setObject:@"" forKey:@"Term"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumMil"] forKey:@"ExtraPremiMil"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiMilTerm"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumPercentage"] forKey:@"ExtraPremiPercent"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiPercentTerm"];
    return dictULRiderData;
}

-(NSDictionary *)dictionaryRider3{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    NSMutableDictionary* dictULRiderData = [[NSMutableDictionary alloc]init];
    [dictULRiderData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictULRiderData setObject:@"" forKey:@"RiderCode"];
    [dictULRiderData setObject:@"Terminal Illness" forKey:@"RiderDesc"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"SumAssured"] forKey:@"SumAssured"];
    [dictULRiderData setObject:@"" forKey:@"Term"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumMil"] forKey:@"ExtraPremiMil"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiMilTerm"];
    [dictULRiderData setObject:[dictPremiData valueForKey:@"ExtraPremiumPercentage"] forKey:@"ExtraPremiPercent"];
    [dictULRiderData setObject:@"" forKey:@"ExtraPremiPercentTerm"];
    return dictULRiderData;
}

#pragma mark dictionary maker
-(void)setULRiderDictionary{
    arrayRiderData = [[NSMutableArray alloc]initWithObjects:[self dictionaryRider1],/*[self dictionaryRider2],*/[self dictionaryRider3], nil];
    //NSMutableDictionary* dictRiderData = [[NSMutableDictionary alloc]init];
    [delegate setULRiderDictionary:arrayRiderData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    //set the updated data to parent
    [self setULRiderDictionary];
    
    //delete first
    [modelSIULRider deleteULRiderData:[delegate getRunnigSINumber]];
    
    //get updated data from parent and save it.
    NSMutableArray* arrayRiderForInsert = [[NSMutableArray alloc]initWithArray:[delegate getULRiderArray]];
    for (int i=0;i<[arrayRiderForInsert count];i++){
        NSMutableDictionary *dictForInsert = [[NSMutableDictionary alloc]initWithDictionary:[arrayRiderForInsert objectAtIndex:i]];
        [dictForInsert setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
        
        [modelSIULRider saveULRiderData:dictForInsert];
    }

    [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:5 inSection:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayRiderData count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    ULRiderTableViewCell *cellULRider = (ULRiderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ULRiderTableViewCell"];
    
    if (cellULRider == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"ULRiderTableViewCell" owner:self options:nil];
        cellULRider = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
    [cellULRider.labelManfaat setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"RiderDesc"]];
    [cellULRider.labelSumAssured setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"SumAssured"]];
    [cellULRider.labelMasaAsuransi setText:@""];
    [cellULRider.labelUnit setText:@""];
    [cellULRider.labelExtraPremiPercent setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"ExtraPremiPercent"]];
    [cellULRider.labelExtraPremiPerMil setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"ExtraPremiMil"]];
    [cellULRider.labelMasaExtraPremi setText:[dictPremiData valueForKey:@"ExtraPremiumTerm"]];
    [cellULRider.labelExtraPremiRp setText:@""];
    if (indexPath.row == 0){
        [cellULRider.labelPremiRp setText:[dictPremiData valueForKey:@"Premium"]];
    }
    else{
        [cellULRider.labelPremiRp setText:@""];
    }
    
    
    
    return cellULRider;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showRiderDataDetail:[arrayRiderData objectAtIndex:indexPath.row]];
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
