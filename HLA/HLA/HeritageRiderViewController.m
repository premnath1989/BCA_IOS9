//
//  HeritageRiderViewController.m
//  BLESS
//
//  Created by Basvi on 6/2/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HeritageRiderViewController.h"
#import "Formatter.h"
#import "ULRiderTableViewCell.h"
#import "ModelSIRider.h"

@interface HeritageRiderViewController (){
    Formatter* formatter;
    ModelSIRider* modelSIRider;
    NSString* riderCode;
    NSMutableArray* arrayRiderData;
}

@end

@implementation HeritageRiderViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    formatter = [[Formatter alloc]init];
    modelSIRider = [[ModelSIRider alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDataFromList{
    NSMutableDictionary* dictPOLAData = [delegate getPOLAData];
    NSString* SINO = [dictPOLAData valueForKey:@"SINO"];
    arrayRiderData = [[NSMutableArray alloc]initWithArray:[delegate getHeritageRiderData:SINO]];
    if (arrayRiderData.count > 0){
        [tableRider reloadData];
        NSDictionary* dictDataRider = [arrayRiderData objectAtIndex:0];
        [self setRiderInformation:dictDataRider];
    }
    else{
        [self setInitialData];
    }
}

-(void)setRiderInformation:(NSDictionary *)dictRiderInfo{
//    NSMutableDictionary* dictBasicPlan = [delegate getBasicPlanData];
//    NSMutableDictionary* dictPOLAData = [delegate getPOLAData];
    NSNumber *numberSA = [NSNumber numberWithLongLong:[[dictRiderInfo valueForKey:@"SumAssured"] longLongValue]];
    riderCode = [dictRiderInfo valueForKey:@"RiderCode"];
    [btnRiderName setTitle:[dictRiderInfo valueForKey:@"RiderName"] forState:UIControlStateNormal];
    masaRiderAsuransiField.text = [dictRiderInfo valueForKey:@"MasaAsuransi"];
    sumAssuredField.text = [formatter numberToCurrencyDecimalFormatted:numberSA];
    extraPremiPercentField.text = [dictRiderInfo valueForKey:@"ExtraPremiPercent"];
    extraPremiNumberField.text = [dictRiderInfo valueForKey:@"ExtraPremiMil"];
    masaExtraPremiField.text = [dictRiderInfo valueForKey:@"MasaExtraPremi"];
    if ([[riderCode uppercaseString] isEqualToString:@"WAIVER"]){
        [segmentPersonType setSelectedSegmentIndex:0];
    }
    else{
        [segmentPersonType setSelectedSegmentIndex:1];
    }
    
    
}

-(void)setInitialData{
    NSMutableDictionary* dictBasicPlan = [delegate getBasicPlanData];
    NSMutableDictionary* dictPOLAData = [delegate getPOLAData];
    NSString* relWithLA = [dictPOLAData valueForKey:@"RelWithLA"];
    
    if ([[relWithLA uppercaseString] isEqualToString:@"DIRI SENDIRI"]){
        riderCode = @"Waiver";
        [segmentPersonType setSelectedSegmentIndex:0];
        [btnRiderName setTitle:@"BCA Life Waiver of Premium" forState:UIControlStateNormal];
    }
    else{
        riderCode = @"Payor";
        [segmentPersonType setSelectedSegmentIndex:1];
        [btnRiderName setTitle:@"BCA Life Payor Benefit" forState:UIControlStateNormal];
    }
    if ([[[dictBasicPlan valueForKey:@"Payment_Term"]uppercaseString] isEqualToString:@"PREMI TUNGGAL"]){
        masaRiderAsuransiField.text = @"1";
    }
    else{
        NSString* stringMasaAsuransi = [formatter getNumberFromString:[dictBasicPlan valueForKey:@"Payment_Term"]];
        masaRiderAsuransiField.text = stringMasaAsuransi;
    }
    sumAssuredField.text = [dictBasicPlan valueForKey:@"Sum_Assured"]?:@"";
    extraPremiPercentField.text = @"";
    extraPremiNumberField.text = @"";
    masaExtraPremiField.text = @"";
}



-(NSDictionary *)dictRiderData{
    NSDictionary *dictionaryForBasicPlan = [delegate getBasicPlanData];
    NSNumber *sumAssured = [NSNumber numberWithLongLong:[[dictionaryForBasicPlan valueForKey:@"Number_Sum_Assured"] longLongValue]];
    
    int extraPremiPercentage=[extraPremiPercentField.text intValue];
    int extraPremiumMil=[extraPremiNumberField.text intValue];
    int masaPremium=[masaExtraPremiField.text intValue];
    NSNumber* premiDasar = [formatter convertNumberFromStringCurrency:[dictionaryForBasicPlan valueForKey:@"PremiumPolicyA"]];
    NSNumber* premiExtra = [formatter convertNumberFromStringCurrency:[dictionaryForBasicPlan valueForKey:@"ExtraPremiumPolicy"]];
    NSMutableDictionary* dictRiderData=[[NSMutableDictionary alloc]initWithObjectsAndKeys:btnRiderName.currentTitle,@"RiderName",
               riderCode,@"RiderCode",
               sumAssured,@"SumAssured",
               masaRiderAsuransiField.text,@"MasaAsuransi",
               @"-",@"Unit",
               [NSNumber numberWithInt:extraPremiPercentage],@"ExtraPremiPerCent",
               [NSNumber numberWithInt:extraPremiumMil],@"ExtraPremiPerMil",
               [NSNumber numberWithInt:masaPremium],@"MasaExtraPremi",
               [formatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%@",premiExtra]],@"ExtraPremiRp",
               [formatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%@",premiDasar]],@"PremiRp",
               nil];
    return dictRiderData;
}

-(void)reloadTableRiderData{

}

-(IBAction)actionAddRider:(UIButton *)sender{
    [delegate saveRiderData:[self dictRiderData]];
    [self loadDataFromList];
}

-(IBAction)actionDoneRider:(id)sender{
    [delegate showPremiumPage];
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
    
    [cellULRider.labelManfaat setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"RiderName"]?:@""];
    [cellULRider.labelSumAssured setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"SumAssured"]?:@""];
    [cellULRider.labelMasaAsuransi setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"MasaAsuransi"]?:@""];
    [cellULRider.labelUnit setText:@""];
    [cellULRider.labelExtraPremiPercent setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"ExtraPremiPerCent"]?:@""];
    [cellULRider.labelExtraPremiPerMil setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"ExtraPremiPerMil"]?:@""];
    [cellULRider.labelMasaExtraPremi setText:[[arrayRiderData objectAtIndex:indexPath.row]valueForKey:@"MasaExtraPremi"]?:@""];
    [cellULRider.labelExtraPremiRp setText:@""];
    [cellULRider.labelPremiRp setText:[[arrayRiderData objectAtIndex:indexPath.row] valueForKey:@"PremiRp"]?:@""];
    return cellULRider;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self showRiderDataDetail:[arrayRiderData objectAtIndex:indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView==tableRider){
            NSMutableDictionary* dictPOLAData = [delegate getPOLAData];
            NSString* SINO = [dictPOLAData valueForKey:@"SINO"];
            [arrayRiderData removeObjectAtIndex:indexPath.row];
            [tableRider deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [modelSIRider deleteRiderData:SINO];
        }
    }
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
