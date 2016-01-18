//
//  RetirementPlans.m
//  iMobile Planner
//
//  Created by Meng Cheong on 8/22/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RetirementPlans.h"
#import "DataClass.h"
#import "ExistingRetirementPlans.h"
#import "textFields.h" //fix for bug 2624

@interface RetirementPlans (){
    DataClass *obj;
}

@end

@implementation RetirementPlans
@synthesize ExistingRetirementPlansVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"CFF_1" bundle:nil];
    
    
    BOOL doesContain = [self.myView.subviews containsObject:self.ExistingRetirementPlansVC.view];
    if (!doesContain){
        self.ExistingRetirementPlansVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"ExistingRetirementPlans"];
        self.ExistingRetirementPlansVC.rowToUpdate = self.rowToUpdate;
        [self addChildViewController:self.ExistingRetirementPlansVC];
        [self.myView addSubview:self.ExistingRetirementPlansVC.view];
    }
    
    obj=[DataClass getInstance];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	tap.delegate = self;
	[self.view addGestureRecognizer:tap];
    
}

-(void)hideKeyboard{
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Disallow recognition of tap gestures in the button.
    if ([touch.view.superview isKindOfClass:[UINavigationBar class]]) {
        return NO;
    }
    else if ([touch.view isKindOfClass:[UITextField class]] ||
             [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000){
        [self.ExistingRetirementPlansVC.PolicyOwner becomeFirstResponder];
    }
    else if (alertView.tag == 1001){
        [self.ExistingRetirementPlansVC.Company becomeFirstResponder];
    }
    else if (alertView.tag == 1002){
        [self.ExistingRetirementPlansVC.TypeOfPlan becomeFirstResponder];
    }
    else if (alertView.tag == 1003){
        [self.ExistingRetirementPlansVC.Premium becomeFirstResponder];
    }
    else if (alertView.tag == 1005){
        [self.ExistingRetirementPlansVC.StartDate becomeFirstResponder];
    }
    else if (alertView.tag == 1006){
        [self.ExistingRetirementPlansVC.MaturityDate becomeFirstResponder];
    }
    else if (alertView.tag == 1007){
        [self.ExistingRetirementPlansVC.SumMaturity becomeFirstResponder];
    }
    else if (alertView.tag == 1008){
        [self.ExistingRetirementPlansVC.IncomeMaturity becomeFirstResponder];
    }
	//fix for bug 2624 start
	else if (alertView.tag == 1009){
        [self.ExistingRetirementPlansVC.PolicyOwner becomeFirstResponder];
    }
	//fix for bug 2624 end
}

- (IBAction)doSave:(id)sender {
    [self hideKeyboard];
    [self.ExistingRetirementPlansVC doPremium:nil];
    [self.ExistingRetirementPlansVC doIncomeMaturity:nil];
    [self.ExistingRetirementPlansVC doProjectedLumpSum:nil];
    
    if([textFields trimWhiteSpaces:self.ExistingRetirementPlansVC.PolicyOwner.text].length == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Policy Owner is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1000;
        [alert show];
        alert = Nil;
        return;
    }
	//fix for bug 2624 start
	else if([textFields validateString:self.ExistingRetirementPlansVC.PolicyOwner.text]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"The same alphabet cannot be repeated more than 3 times for Policy Owner."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1009;
        [alert show];
        alert = Nil;
        return;
    }
	//fix for bug 2624 end
    else if ([textFields validateString3:self.ExistingRetirementPlansVC.PolicyOwner.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Invalid name format. Input must be alphabet A to Z, space, apostrophe(‘), alias(@), slash(/), dash(-), bracket(( )) or dot(.)."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1009;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([textFields trimWhiteSpaces:self.ExistingRetirementPlansVC.Company.text].length == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Company is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([textFields validateString:self.ExistingRetirementPlansVC.Company.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"The same alphabet cannot be repeated more than 3 times for Company."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([textFields validateOtherID:self.ExistingRetirementPlansVC.Company.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Invalid name format. Input must be alphabet A to Z, space, apostrophe(‘), alias(@), slash(/), dash(-), bracket(( )) or dot(.)."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([textFields trimWhiteSpaces:self.ExistingRetirementPlansVC.TypeOfPlan.text].length == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Type of Plan is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1002;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.Premium.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Premium is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1003;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.Premium.text isEqualToString:@"0.00"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Premium (RM) must be numerical value. It must be greater than zero, maximum 13 digits with 2 decimal points."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1003;
        [alert show];
        alert = Nil;
        return;
    }
    else if (self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex == -1){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Frequency is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        //alert.tag = 1004;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.StartDate.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Start Date is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1005;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.StartDate.text length] != 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (self.ExistingRetirementPlansVC.StartDate.text.length == 4) {
            [dateFormatter setDateFormat:@"yyyy"];
        }
        else if (self.ExistingRetirementPlansVC.StartDate.text.length == 8) {
            [dateFormatter setDateFormat:@"ddMMyyyy"];
        }
        else if (self.ExistingRetirementPlansVC.StartDate.text.length == 10) {
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @" "
                                  message:@"Invalid Date format. Input must be in dd/mm/yyyy or yyyy"
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 1005;
            [alert show];
            alert = Nil;
            return;
        }
        NSDate *date = [dateFormatter dateFromString:self.ExistingRetirementPlansVC.StartDate.text];
        if (!date) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @" "
                                  message:@"Invalid Date format. Input must be in dd/mm/yyyy or yyyy"
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 1005;
            [alert show];
            alert = Nil;
            return;
        }
        
    }
    if ([self.ExistingRetirementPlansVC.MaturityDate.text length] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Maturity Date is required."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1006;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.MaturityDate.text length] != 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (self.ExistingRetirementPlansVC.MaturityDate.text.length == 4) {
            [dateFormatter setDateFormat:@"yyyy"];
        }
        else if (self.ExistingRetirementPlansVC.MaturityDate.text.length == 8) {
            [dateFormatter setDateFormat:@"ddMMyyyy"];
        }
        else if (self.ExistingRetirementPlansVC.MaturityDate.text.length == 10) {
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @" "
                                  message:@"Invalid Date format. Input must be in dd/mm/yyyy or yyyy"
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 1006;
            [alert show];
            alert = Nil;
            return;
        }
        NSDate *date = [dateFormatter dateFromString:self.ExistingRetirementPlansVC.MaturityDate.text];
        if (!date) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @" "
                                  message:@"Invalid Date format. Input must be in dd/mm/yyyy or yyyy"
                                  delegate: self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            alert.tag = 1006;
            [alert show];
            alert = Nil;
            return;
        }
        
    }
    if ([self.ExistingRetirementPlansVC.SumMaturity.text isEqualToString:@"0.00"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Amount available at maturity must be numerical value. It must be greater than zero, maximum 13 digits with 2 decimal points."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1007;
        [alert show];
        alert = Nil;
        return;
    }
    else if ([self.ExistingRetirementPlansVC.IncomeMaturity.text isEqualToString:@"0.00"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @" "
                              message:@"Amount available at maturity must be numerical value. It must be greater than zero, maximum 13 digits with 2 decimal points."
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = 1008;
        [alert show];
        alert = Nil;
        return;
    }
    if (self.rowToUpdate == 1){
        [self.ExistingRetirementPlansVC doPremium:nil];
        [self.ExistingRetirementPlansVC doIncomeMaturity:nil];
        [self.ExistingRetirementPlansVC doProjectedLumpSum:nil];
        
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.PolicyOwner.text forKey:@"ExistingRetirement1PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Company.text forKey:@"ExistingRetirement1Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.TypeOfPlan.text forKey:@"ExistingRetirement1TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Premium.text forKey:@"ExistingRetirement1Premium"];
        if (self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex != -1){
            [[obj.CFFData objectForKey:@"SecF"] setValue:[self.ExistingRetirementPlansVC.Frequency titleForSegmentAtIndex:self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex] forKey:@"ExistingRetirement1Frequency"];
        }
        else{
            [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1Frequency"];
        }
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.StartDate.text forKey:@"ExistingRetirement1StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.MaturityDate.text forKey:@"ExistingRetirement1MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.SumMaturity.text forKey:@"ExistingRetirement1SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.IncomeMaturity.text forKey:@"ExistingRetirement1IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.AdditionalBenefit.text forKey:@"ExistingRetirement1AdditionalBenefit"];
    }
    else if (self.rowToUpdate == 2){
        [self.ExistingRetirementPlansVC doPremium:nil];
        [self.ExistingRetirementPlansVC doIncomeMaturity:nil];
        [self.ExistingRetirementPlansVC doProjectedLumpSum:nil];
        
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.PolicyOwner.text forKey:@"ExistingRetirement2PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Company.text forKey:@"ExistingRetirement2Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.TypeOfPlan.text forKey:@"ExistingRetirement2TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Premium.text forKey:@"ExistingRetirement2Premium"];
        if (self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex != -1){
            [[obj.CFFData objectForKey:@"SecF"] setValue:[self.ExistingRetirementPlansVC.Frequency titleForSegmentAtIndex:self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex] forKey:@"ExistingRetirement2Frequency"];
        }
        else{
            [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2Frequency"];
        }
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.StartDate.text forKey:@"ExistingRetirement2StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.MaturityDate.text forKey:@"ExistingRetirement2MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.SumMaturity.text forKey:@"ExistingRetirement2SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.IncomeMaturity.text forKey:@"ExistingRetirement2IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.AdditionalBenefit.text forKey:@"ExistingRetirement2AdditionalBenefit"];
    }
    else if (self.rowToUpdate == 3){
        [self.ExistingRetirementPlansVC doPremium:nil];
        [self.ExistingRetirementPlansVC doIncomeMaturity:nil];
        [self.ExistingRetirementPlansVC doProjectedLumpSum:nil];
        
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.PolicyOwner.text forKey:@"ExistingRetirement3PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Company.text forKey:@"ExistingRetirement3Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.TypeOfPlan.text forKey:@"ExistingRetirement3TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.Premium.text forKey:@"ExistingRetirement3Premium"];
        if (self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex != -1){
            [[obj.CFFData objectForKey:@"SecF"] setValue:[self.ExistingRetirementPlansVC.Frequency titleForSegmentAtIndex:self.ExistingRetirementPlansVC.Frequency.selectedSegmentIndex] forKey:@"ExistingRetirement3Frequency"];
        }
        else{
            [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3Frequency"];
        }
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.StartDate.text forKey:@"ExistingRetirement3StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.MaturityDate.text forKey:@"ExistingRetirement3MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.SumMaturity.text forKey:@"ExistingRetirement3SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.IncomeMaturity.text forKey:@"ExistingRetirement3IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:self.ExistingRetirementPlansVC.AdditionalBenefit.text forKey:@"ExistingRetirement3AdditionalBenefit"];
    }
    
    [self.delegate ExistingRetirementPlansUpdate:self.ExistingRetirementPlansVC rowToUpdate:self.rowToUpdate];
}

-(void)doDelete:(int)rowToUpdate{
    if (self.rowToUpdate == 1){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1Premium"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1Frequency"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement1AdditionalBenefit"];
    }
    else if (self.rowToUpdate == 2){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2Premium"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2Frequency"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement2AdditionalBenefit"];
    }
    else if (self.rowToUpdate == 3){
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3PolicyOwner"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3Company"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3TypeOfPlan"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3Premium"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3Frequency"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3StartDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3MaturityDate"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3SumMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3IncomeMaturity"];
        [[obj.CFFData objectForKey:@"SecF"] setValue:@"" forKey:@"ExistingRetirement3AdditionalBenefit"];
    }
    [self.delegate ExistingRetirementPlansDelete:self.ExistingRetirementPlansVC rowToUpdate:self.rowToUpdate];
}

- (IBAction)doCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)viewDidUnload {
    [self setMyView:nil];
    [super viewDidUnload];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
