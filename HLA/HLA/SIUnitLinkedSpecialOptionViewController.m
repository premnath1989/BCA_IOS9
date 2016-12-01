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
#import "Formatter.h"
#import "Alert.h"

@interface SIUnitLinkedSpecialOptionViewController ()<UIPopoverPresentationControllerDelegate,UnitLinkedPopOverDelegate>{
    Formatter *formatter;
    Alert* alert;
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
    
    formatter = [[Formatter alloc]init];
    alert = [[Alert alloc]init];
    unitLinkedPopOverVC = [[UnitLinkedPopOverViewController alloc]initWithNibName:@"UnitLinkedPopOverViewController" bundle:nil];
    unitLinkedPopOverVC.UnitLinkedPopOverDelegate = self;
    // Do any additional setup after loading the view from its nib.
    
    
    [textTopUpAmount addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    [textTopUpAmount addTarget:self action:@selector(AmountEditingEnd:) forControlEvents:UIControlEventEditingDidEnd];

    [textWithDrawalAmount addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if ((textField == textTopUpAmount)||(textField == textWithDrawalAmount))
    {
        BOOL return13digit = FALSE;
        //KY - IMPORTANT - PUT THIS LINE TO DETECT THE FIRST CHARACTER PRESSED....
        //This method is being called before the content of textField.text is changed.
        NSString * AI = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([AI rangeOfString:@"."].length == 1) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c > 15);
            
        } else if([AI rangeOfString:@"."].length == 0) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c  > 15);
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if( return13digit == TRUE) {
            return (([string isEqualToString:filtered])&&(newLength <= 15));
        } else {
            return (([string isEqualToString:filtered])&&(newLength <= 19));
        }
    }
    return YES;
}

-(void)AmountEditingEnd:(UITextField *)sender{
    NSString* textTopUp=sender.text;
    NSNumber *numberTopUp = [formatter convertAnyNonDecimalNumberToString:textTopUp];
    long long longPremi = [numberTopUp longLongValue];

    NSMutableDictionary* dictULBasicPlanDictionary = [delegate getBasicPlanDictionary];
    
    NSString* currency = [dictULBasicPlanDictionary valueForKey:@"PaymentCurrency"];
    
    NSString *stringAlertMinimumPremi=@"Premi minimal adalah Rp 10.000.000 atau USD 1,000";
    if ([currency isEqualToString:@"IDR"]){
        if (longPremi < 10000000){
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Peringatan" stringMessage:stringAlertMinimumPremi];
            [self presentViewController:alertEmptyImage animated:YES completion:^{
                [textTopUpAmount becomeFirstResponder];
            }];
        }
    }
    else{
        if (longPremi < 1000){
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Peringatan" stringMessage:stringAlertMinimumPremi];
            [self presentViewController:alertEmptyImage animated:YES completion:^{
                [textTopUpAmount becomeFirstResponder];
            }];
        }
    }
}


-(void)RealTimeFormat:(UITextField *)sender{
    NSNumber *plainNumber = [formatter convertAnyNonDecimalNumberToString:sender.text];
    [sender setText:[formatter numberToCurrencyDecimalFormatted:plainNumber]];
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
    
    //delete first
    [modelSIULSpecialOption deleteULSpecialOptionData:[delegate getRunnigSINumber]];
    
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
