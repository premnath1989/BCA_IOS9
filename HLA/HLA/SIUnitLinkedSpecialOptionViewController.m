//
//  SIUnitLinkedSpecialOptionViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedSpecialOptionViewController.h"
#import "ModelSIULSpecialOption.h"
#import "UnitLinkedPopOverViewController.h"
#import "SpecialOptionTableViewCell.h"

@interface SIUnitLinkedSpecialOptionViewController ()<UIPopoverPresentationControllerDelegate,UnitLinkedPopOverDelegate>{
    ModelSIULSpecialOption  *modelSIULSpecialOption;
    UnitLinkedPopOverViewController* unitLinkedPopOverVC;
    UIPopoverPresentationController *popController;
    
    UIButton* buttonActive;
    
    NSMutableArray* arrayPolisYear;
    
    NSMutableArray* arraySpecialOption;
}

@end

@implementation SIUnitLinkedSpecialOptionViewController
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULSpecialOption = [[ModelSIULSpecialOption alloc]init];
    
    
    unitLinkedPopOverVC = [[UnitLinkedPopOverViewController alloc]initWithNibName:@"UnitLinkedPopOverViewController" bundle:nil];
    unitLinkedPopOverVC.UnitLinkedPopOverDelegate = self;
    // Do any additional setup after loading the view from its nib.
    
    arraySpecialOption = [[NSMutableArray alloc]init];

    arrayPolisYear = [[NSMutableArray alloc]init];
    
    for (int i=1;i<101;i++){
        [arrayPolisYear addObject:[NSString stringWithFormat:@"%i",i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDataFromList{
    arraySpecialOption=[[NSMutableArray alloc]init];
    arraySpecialOption = [delegate getULSpecialOptionArray];
    if ([arraySpecialOption count]!=0){
        [tableTopUp reloadData];
        [tableWithDrawal reloadData];
    }
    else{

    }
}


#pragma mark dictionary maker
-(void)setULSpecialOtionDictionary{
    /*NSMutableDictionary* dictSpecialOptionData = [[NSMutableDictionary alloc]init];
    [dictSpecialOptionData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictSpecialOptionData setObject:@"" forKey:@"Year"];
    [dictSpecialOptionData setObject:@"" forKey:@"Amount"];
    [dictSpecialOptionData setObject:stringOption forKey:@"Option"];*/
    
    [delegate setULSpecialOptionArray:arraySpecialOption];
}

-(IBAction)actionTopUpYearPopOver:(UIButton *)sender{
    NSMutableArray* arrayTableDesc = [[NSMutableArray alloc]initWithArray:arrayPolisYear];
    NSMutableArray* arrayTableCode = [[NSMutableArray alloc]initWithArray:arrayPolisYear];
    
    NSDictionary* dictTablePopOver = [[NSDictionary alloc]initWithObjectsAndKeys:arrayTableDesc,@"TableDesc",arrayTableCode,@"TableCode", nil];
    [unitLinkedPopOverVC setTablData:dictTablePopOver Title:@"Top Up Year"];
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    unitLinkedPopOverVC.modalPresentationStyle = UIModalPresentationPopover;
    unitLinkedPopOverVC.preferredContentSize = CGSizeMake(250, 300);
    
    popController = [unitLinkedPopOverVC popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;
    popController.delegate = self;
    
    buttonActive = buttonTopUpYear;
    [self presentViewController:unitLinkedPopOverVC animated:YES completion:nil];
}

-(IBAction)actionwithDrawalYearPopOver:(UIButton *)sender{
    
    NSMutableArray* arrayTableDesc = [[NSMutableArray alloc]initWithArray:arrayPolisYear];
    NSMutableArray* arrayTableCode = [[NSMutableArray alloc]initWithArray:arrayPolisYear];
    
    NSDictionary* dictTablePopOver = [[NSDictionary alloc]initWithObjectsAndKeys:arrayTableDesc,@"TableDesc",arrayTableCode,@"TableCode", nil];
    [unitLinkedPopOverVC setTablData:dictTablePopOver Title:@"Withdrawal Year"];
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    unitLinkedPopOverVC.modalPresentationStyle = UIModalPresentationPopover;
    unitLinkedPopOverVC.preferredContentSize = CGSizeMake(250, 300);
    
    popController = [unitLinkedPopOverVC popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;
    popController.delegate = self;
    
    buttonActive = buttonWithDrawalYear;
    [self presentViewController:unitLinkedPopOverVC animated:YES completion:nil];
}


#pragma mark addToArray
-(IBAction)actionAddTopUp:(id)sender{
    NSDictionary* dictTopUp = [[NSDictionary alloc]initWithObjectsAndKeys:buttonTopUpYear.currentTitle,@"Year",textTopUpAmount.text,@"Amount",@"TopUp",@"Option", nil];
    
    [arraySpecialOption addObject:dictTopUp];
    [tableTopUp reloadData];
}

-(IBAction)actionAddWithDrawal:(id)sender{
    NSDictionary* dictWithDrawal = [[NSDictionary alloc]initWithObjectsAndKeys:buttonWithDrawalYear.currentTitle,@"Year",textWithDrawalAmount.text,@"Amount",@"WithDraw",@"Option", nil];
    
    [arraySpecialOption addObject:dictWithDrawal];
    [tableWithDrawal reloadData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    //set the updated data to parent
    [self setULSpecialOtionDictionary];
    
    //get updated data from parent and save it.
    NSMutableArray* arraySpecialOptionForInsert = [[NSMutableArray alloc]initWithArray:[delegate getULSpecialOptionArray]];
    for (int i=0;i<[arraySpecialOptionForInsert count];i++){
        NSMutableDictionary *dictForInsert = [[NSMutableDictionary alloc]initWithDictionary:[arraySpecialOption objectAtIndex:i]];
        [dictForInsert setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
        
        [modelSIULSpecialOption saveULSpecialOptionData:dictForInsert];
    }
    
    [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:6 inSection:0]];
}

-(void)TableData:(NSString *)stringDesc TableCode:(NSString *)stringCode{
    if (buttonActive == buttonTopUpYear){
        [buttonTopUpYear setTitle:stringDesc forState:UIControlStateNormal];
    }
    else{
        [buttonWithDrawalYear setTitle:stringDesc forState:UIControlStateNormal];
    }
    
    [[popController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableWithDrawal){
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"WithDraw"]];
        return [filtered count];
    }
    else{
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"TopUp"]];
        return [filtered count];
    }
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
    SpecialOptionTableViewCell *cellSpecialOption = (SpecialOptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SpecialOptionTableViewCell"];
    
    if (cellSpecialOption == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SpecialOptionTableViewCell" owner:self options:nil];
        cellSpecialOption = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
    if (tableView == tableTopUp){
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"TopUp"]];
        [cellSpecialOption.labelPolicyYear setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"Year"]];
        [cellSpecialOption.labelAmount setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"Amount"]];
    }
    else{
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"WithDraw"]];
        [cellSpecialOption.labelPolicyYear setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"Year"]];
        [cellSpecialOption.labelAmount setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"Amount"]];
    }
    
    return cellSpecialOption;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableTopUp){
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"TopUp"]];
        [buttonTopUpYear setTitle:[[filtered objectAtIndex:indexPath.row] valueForKey:@"TopUpYear"] forState:UIControlStateNormal];
        [textTopUpAmount setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"TopUpValue"]];
    }
    else{
        NSArray *filtered = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"WithDraw"]];
        [buttonWithDrawalYear setTitle:[[filtered objectAtIndex:indexPath.row] valueForKey:@"WithDrawalYear"] forState:UIControlStateNormal];
        [textWithDrawalAmount setText:[[filtered objectAtIndex:indexPath.row] valueForKey:@"WithDrawalValue"]];
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
