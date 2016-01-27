//
//  FNASavings.m
//  iMobile Planner
//
//  Created by Meng Cheong on 7/29/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FNASavings.h"
#import "DataClass.h"
#import "SavingsPlans.h"
#import "ExistingSavingAndInvestmentPlans.h"

#define NUMBERS_ONLY @"1234567890."
#define CHARACTER_LIMIT15 13
#define CHARACTER_LIMIT70 70
#define CHARACTER_LIMIT100 100

@interface FNASavings (){
    DataClass *obj;
    bool gotPlans;
}

@end

@implementation FNASavings

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _required1.delegate = self;
    _current1.delegate = self;
    
    _customerAlloc.delegate = self;
    obj=[DataClass getInstance];
    
    if ([[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"HasSavings"] isEqualToString:@"0"]){
        hasSavings = TRUE;
        self.SavingsSelected = TRUE;
        [_SavingPlans setImage: [UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
        if ([[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"1"]){
            _plan1.text = [NSString stringWithFormat:@"Policy Owner: %@", [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1PolicyOwner"]];
            gotPlans = TRUE;
        }
        
        if ([[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"1"]){
            _plan2.text = [NSString stringWithFormat:@"Policy Owner: %@", [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2PolicyOwner"]];
            gotPlans = TRUE;
        }
        
        if ([[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings3"] isEqualToString:@"1"]){
            _plan3.text = [NSString stringWithFormat:@"Policy Owner: %@", [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings3PolicyOwner"]];
            gotPlans = TRUE;
        }
    }
    else{
        hasSavings = FALSE;
        self.SavingsSelected = FALSE;
        [_SavingPlans setImage: [UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
        _current1.enabled = FALSE;
    }
    
    _current1.text = [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"SavingsCurrent1"];
    _required1.text = [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"SavingsRequired1"];
    _difference1.text = [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"SavingsDifference1"];
    
    _customerAlloc.text = [[obj.CFFData objectForKey:@"SecF"] objectForKey:@"SavingsCustomerAlloc"];
    
    //_customerAlloc.text = @"csacasc";

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tap];
    
}

-(void)hideKeyboard{
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]] ||
        [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please add existing savings and investment details in sequence." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            if (indexPath.row == 2) {
                if (![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"1"] && ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"1"]) {
                    [alert show];
                    alert = nil;
                    return;
                }
            }
            else if (indexPath.row == 3) {
                if ((![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"1"] || ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"1"]) && ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings3"] isEqualToString:@"1"]) {
                    [alert show];
                    alert = nil;
                    return;
                }
            }
        }
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CFF_1" bundle:nil];
        
        SavingsPlans *vc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SavingsPlans"];
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.rowToUpdate = indexPath.row;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:NULL];
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFValidate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"SavingsNeedValidation"];
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFSave"];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please add existing savings and investment details in sequence." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            if (indexPath.row == 2) {
                if (![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"1"] && ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"1"]) {
                    [alert show];
                    alert = nil;
                    return;
                }
            }
            else if (indexPath.row == 3) {
                if ((![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"1"] || ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"1"]) && ![[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings3"] isEqualToString:@"1"]) {
                    [alert show];
                    alert = nil;
                    return;
                }
            }
        }
        
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CFF_1" bundle:nil];
        
        SavingsPlans *vc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SavingsPlans"];
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.rowToUpdate = indexPath.row;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:NULL];
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFValidate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"SavingsNeedValidation"];
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFSave"];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(615.0, 0.0, 100.0, 0.0)];
    customView.backgroundColor = [UIColor clearColor];
    
    // create the button object
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    headerBtn.backgroundColor = [UIColor clearColor];
    //headerBtn.opaque = NO;
    headerBtn.frame = CGRectMake(618.0, 15.0, 100.0, 30.0);
    
    [headerBtn setTitle:@"Clear All" forState:UIControlStateNormal];
    
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"merahBtn.png"]
                         forState:UIControlStateNormal];
    [headerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    [headerBtn addTarget:self action:@selector(ActionEventForButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [customView addSubview:headerBtn];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasSavings){
        _plan1.hidden = FALSE;
        _plan2.hidden = FALSE;
        _plan3.hidden = FALSE;
    }
    else{
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
            _plan1.hidden = TRUE;
            _plan2.hidden = TRUE;
            _plan3.hidden = TRUE;
            return 0;
        }
    }
    
    if (indexPath.row == 4){
        return 103;
    }
    else if (indexPath.row == 5){
        return 105;
    }
    return 44;
}

- (void) ActionEventForButton:(id)sender {
    
    //FIX BUG 2541
    if(self.SavingsSelected == FALSE)
        _current1.text = @"0.00";
    else
        _current1.text = @"";
    
    _required1.text = @"";
    _customerAlloc.text = @"";
    _difference1.text = @"";
    
    if (!hasSavings) {
        [_SavingPlans sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    if (!gotPlans) {
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"0" forKey:@"CFFValidate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"SavingsNeedValidation"];
        [[obj.CFFData objectForKey:@"SecFSavings"] setValue:@"0" forKey:@"Completed"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"Completed"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"Validate"];
    }
    
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsCurrent1"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsRequired1"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsDifference1"];
    
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsCustomerAlloc"];
    
    UIImageView *img = (UIImageView *)[self.parentViewController.view viewWithTag:3005];
    img.hidden = TRUE;
    img = nil;
}

- (void)ActionEventForButton1{
    
    //FIX BUG 2541
    if(self.SavingsSelected == FALSE)
        _current1.text = @"0.00";
    else
        _current1.text = @"";
    
    _required1.text = @"";
    _customerAlloc.text = @"";
    _difference1.text = @"";
    
    if (!hasSavings) {
        [_SavingPlans sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    if (!gotPlans) {
        [[obj.CFFData objectForKey:@"CFF"] setValue:@"0" forKey:@"CFFValidate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"SavingsNeedValidation"];
        [[obj.CFFData objectForKey:@"SecFSavings"] setValue:@"0" forKey:@"Completed"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"Completed"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"Validate"];
    }
    
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsCurrent1"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsRequired1"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsDifference1"];
    
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"SavingsCustomerAlloc"];
    
    UIImageView *img = (UIImageView *)[self.parentViewController.view viewWithTag:3005];
    img.hidden = TRUE;
    img = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {
    [self setSavingPlans:nil];
    [self setPlan1:nil];
    [self setPlan2:nil];
    [self setPlan3:nil];
    [self setCurrent1:nil];
    [self setRequired1:nil];
    [self setDifference1:nil];
    [self setCustomerAlloc:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
}
- (IBAction)SavingsPlansBtn:(id)sender {
    if (hasSavings){
        hasSavings = FALSE;
        self.SavingsSelected = FALSE;
    }
    else{
        hasSavings = TRUE;
        self.SavingsSelected = TRUE;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	[formatter setPositiveFormat:@"#,##0.00"];
    
    
    if (hasSavings){
        NSString *zero = @"";
        _current1.text = zero;
        _current1.enabled = TRUE;
        [_SavingPlans setImage: [UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"HasSavings"];
		[[obj.CFFData objectForKey:@"SecF"] setValue:zero forKey:@"SavingsCurrent1"];
    }
    else{
        NSString *zero = @"0.00";
        _current1.text = zero;
        _current1.enabled = FALSE;
        [[obj.CFFData objectForKey:@"SecF"] setValue:zero forKey:@"SavingsCurrent1"];
        [_SavingPlans setImage: [UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"-1" forKey:@"HasSavings"];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self CalcualeDifference];
    
    if (hasSavings) {
        //[[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"SavingsNeedValidation"];
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT15));
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _current1 || textField == _required1 || textField == _customerAlloc) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:0];
        textField.text = [[formatter stringFromNumber:[formatter numberFromString:textField.text]] stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
}


- (IBAction)current1Action:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	[formatter setPositiveFormat:@"#,##0.00"];
	_current1.text = [formatter stringFromNumber:[formatter numberFromString:_current1.text]];
    [[obj.CFFData objectForKey:@"SecF"] setValue:_current1.text forKey:@"SavingsCurrent1"];
    
    [self CalcualeDifference];
}
- (IBAction)required1Action:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	[formatter setPositiveFormat:@"#,##0.00"];
	_required1.text = [formatter stringFromNumber:[formatter numberFromString:_required1.text]];
    [[obj.CFFData objectForKey:@"SecF"] setValue:_required1.text forKey:@"SavingsRequired1"];
    
    [self CalcualeDifference];
}
- (IBAction)customerAllocAction:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	[formatter setPositiveFormat:@"#,##0.00"];
	_customerAlloc.text = [formatter stringFromNumber:[formatter numberFromString:_customerAlloc.text]];
    [[obj.CFFData objectForKey:@"SecF"] setValue:_customerAlloc.text forKey:@"SavingsCustomerAlloc"];
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFValidate"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"SavingsNeedValidation"];
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFSave"];
}

-(void)CalcualeDifference{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle: NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:2];
	[formatter setPositiveFormat:@"#,##0.00"];
    
    if ([_current1.text length] == 0 || [_required1.text length] == 0){
        _difference1.text = @"";
        [[obj.CFFData objectForKey:@"SecF"] setValue:_difference1.text forKey:@"SavingsDifference1"];
    }
    else{
        double stringFloat =  [[_required1.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]
        - [[_current1.text stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
        
        
        if (stringFloat < 0.00){
            _difference1.text = [formatter stringFromNumber:[formatter numberFromString:[NSString stringWithFormat:@"%f", stringFloat]]];
            _difference1.text = [_difference1.text stringByReplacingOccurrencesOfString:@"-"
                                                                             withString:@""];
            _difference1.text = [NSString stringWithFormat:@"(%@)",_difference1.text];
        }
        else{
            _difference1.text = [formatter stringFromNumber:[formatter numberFromString:[NSString stringWithFormat:@"%f", stringFloat]]];
        }
        [[obj.CFFData objectForKey:@"SecF"] setValue:_difference1.text forKey:@"SavingsDifference1"];
    }
    
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFValidate"];
    [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"SavingsNeedValidation"];
    [[obj.CFFData objectForKey:@"CFF"] setValue:@"1" forKey:@"CFFSave"];
    
    if (hasSavings && _current1.text.length == 0 && _required1.text.length == 0 && _customerAlloc.text.length == 0 && !gotPlans) {
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"SavingsNeedValidation"];
    }
}

-(void)ExistingSavingsPlansUpdate:(ExistingSavingAndInvestmentPlans *)controller rowToUpdate:(int)rowToUpdate{
    gotPlans = TRUE;
    if (rowToUpdate == 1){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"ExistingSavings1"];
        _plan1.text = [NSString stringWithFormat:@"Policy Owner: %@",controller.PolicyOwner.text];
    }
    else if (rowToUpdate == 2){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"ExistingSavings2"];
        _plan2.text = [NSString stringWithFormat:@"Policy Owner: %@",controller.PolicyOwner.text];
    }
    else if (rowToUpdate == 3){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"1" forKey:@"ExistingSavings3"];
        _plan3.text = [NSString stringWithFormat:@"Policy Owner: %@",controller.PolicyOwner.text];
    }
    
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)ExistingSavingsPlansDelete:(ExistingSavingAndInvestmentPlans *)controller rowToUpdate:(int)rowToUpdate{
    if (rowToUpdate == 1){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"ExistingSavings1"];
        _plan1.text = [NSString stringWithFormat:@"Add Existing Savings and Investment Plan (1)"];
    }
    else if (rowToUpdate == 2){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"ExistingSavings2"];
        _plan2.text = [NSString stringWithFormat:@"Add Existing Savings and Investment Plan (2)"];
    }
    else if (rowToUpdate == 3){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"0" forKey:@"ExistingSavings3"];
        _plan3.text = [NSString stringWithFormat:@"Add Existing Savings and Investment Plan (3)"];
    }
    
    if ([[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings1"] isEqualToString:@"0"] && [[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings2"] isEqualToString:@"0"] && [[[obj.CFFData objectForKey:@"SecF"] objectForKey:@"ExistingSavings3"] isEqualToString:@"0"]) {
        gotPlans = FALSE;
    }
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
@end