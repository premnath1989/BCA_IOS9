//
//  AddChildViewController.m
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#define NUMBERS_ONLY @"0123456789"

#import "AddChildViewController.h"
#import "SIDate.h"
#import "Nationality.h"
#import "IDTypeViewController.h"
#import "OccupationList.h"
#import "ColorHexCode.h"
#import "ModelProspectChild.h"
#import "ModelPopover.h"
#import "CFFValidation.h"
#import "ProspectProfile.h"
#import "ModelProspectProfile.h"
#import "Formatter.h"
#import "ModelIdentificationType.h"

@interface AddChildViewController ()<SIDateDelegate,IDTypeDelegate,NatinalityDelegate,OccupationListDelegate,UITextFieldDelegate>{
    Formatter* formatter;
    SIDate* datePickerViewController;
    ProspectProfile* pp;
    IDTypeViewController *IDTypePicker;
    Nationality *nationalityList;
    OccupationList *occupationList;
    ModelProspectChild *modelProspectChild;
    ModelIdentificationType* modelIdentificationType;
    ModelPopover* modelPopOver;
    ModelProspectProfile* modelProspectProfile;
    CFFValidation* cffValidation;
}

@end

@implementation AddChildViewController{
    NSString *IDTypeCodeSelected;
    NSString *OccupCodeSelected;
    NSString *gender;
    NSString *ClientSmoker;
    NSMutableArray *ProspectTableData;
    
    UITextField *activeField;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIScrollView *scrollAddChild;
    IBOutlet UIScrollView *myScrollView;
    IBOutlet UIView *viewParent;
    IBOutlet UIButton *outletRelation;
    IBOutlet UIButton *outletDOB;
    IBOutlet UIButton *OtherIDType;
    IBOutlet UITextField *txtOtherIDType;
    IBOutlet UITextField *txtYearsInsured;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtAge;
    IBOutlet UIButton *outletNationality;
    IBOutlet UIButton *outletOccupation;
    IBOutlet UISegmentedControl *segGender;
    IBOutlet UISegmentedControl *segSmoker;
    UIPopoverController *popoverController;
    
    UIColor *borderColor;
}

@synthesize prospectProfileID,cffTransactionID,delegate,DictChildData;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //self.view.superview.bounds = CGRectMake(0, 0, 824, 415);
    //[self.view.superview setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadChildData];
}

-(void)viewDidAppear:(BOOL)animated{
    [cffValidation setProspectProfileID:prospectProfileID];
    [cffValidation  setCffTransactionID:cffTransactionID];
    
    myScrollView.contentSize = CGSizeMake(801, 500);
    [self loadChildData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelProspectChild = [[ModelProspectChild alloc]init];
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    modelIdentificationType = [[ModelIdentificationType alloc]init];
    modelPopOver = [[ModelPopover alloc]init];
    cffValidation = [[CFFValidation alloc]init];
    formatter = [[Formatter alloc]init];
    
    ProspectTableData = [modelProspectProfile searchProspectProfileByID:[prospectProfileID intValue]];
    pp = [ProspectTableData objectAtIndex:0];
    
    borderColor=[[UIColor alloc]initWithRed:0/255.0 green:102.0/255.0 blue:179.0/255.0 alpha:1.0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]}];
    
    [self setButtonImageAndTextAlignment];
    [self setTextfieldBorder];
    [outletRelation setTitle:@"Anak" forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

-(void)setButtonImageAndTextAlignment{
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletDOB.imageEdgeInsets = UIEdgeInsetsMake(0., outletDOB.frame.size.width - (24 + 10.0), 0., 0.);
    outletDOB.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletDOB.layer.borderColor = borderColor.CGColor;
    //outletDOB.layer.borderWidth = 1.0;
    
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    OtherIDType.imageEdgeInsets = UIEdgeInsetsMake(0., OtherIDType.frame.size.width - (24 + 10.0), 0., 0.);
    OtherIDType.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    OtherIDType.layer.borderColor = borderColor.CGColor;
    //OtherIDType.layer.borderWidth = 1.0;
    
    outletNationality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletNationality.imageEdgeInsets = UIEdgeInsetsMake(0., outletNationality.frame.size.width - (24 + 10.0), 0., 0.);
    outletNationality.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletNationality.layer.borderColor = borderColor.CGColor;
    //outletNationality.layer.borderWidth = 1.0;
    
    outletOccupation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletOccupation.imageEdgeInsets = UIEdgeInsetsMake(0., outletOccupation.frame.size.width - (24 + 10.0), 0., 0.);
    outletOccupation.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletOccupation.layer.borderColor = borderColor.CGColor;
    //outletOccupation.layer.borderWidth = 1.0;
    
    /*outletRelation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletRelation.imageEdgeInsets = UIEdgeInsetsMake(0., outletRelation.frame.size.width - (24 + 10.0), 0., 0.);
    outletRelation.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletRelation.layer.borderColor = borderColor.CGColor;*/
}

-(void)setTextfieldBorder{
    UIFont *fontSegment= [UIFont fontWithName:@"BPreplay" size:16.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:fontSegment forKey:UITextAttributeFont];
    //[segSmoker setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //[segGender setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UIFont *font= [UIFont fontWithName:@"BPreplay" size:16.0f];
    for (UIView *view in [viewParent subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.layer.borderColor=borderColor.CGColor;
            textField.layer.borderWidth=1.0;
            textField.delegate=self;
            [textField setFont:font];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    
    for (UIView *view in [viewParent subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            button.layer.borderColor=borderColor.CGColor;
            //button.layer.borderWidth=1.0;
        }
    }
    
}


-(void)setNavigationAttribute{
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
    [navigationBar setTitleTextAttributes:newAttributes];
    [navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]}];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionDismissModal:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)actionSaveChild:(id)sender{
    if ([cffValidation validateChild:[self setDictionaryObjectChild]]){
        NSString* nasabahID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:pp.OtherIDType],pp.OtherIDTypeNo];
        NSString* childIDInterface = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:IDTypeCodeSelected],txtOtherIDType.text];
        NSString* childID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:[DictChildData valueForKey:@"OtherIDType"]],[DictChildData valueForKey:@"OtherIDTypeNo"]];
        
        if (![childIDInterface isEqualToString:childID]){
            if ([cffValidation validateOtherIDNumberForChild:OtherIDType TextIDNumber:txtOtherIDType IDNasabah:nasabahID IDTypeCodeSelected:IDTypeCodeSelected]){
                if ([DictChildData count]>0){
                    if ([modelProspectChild chekcExistingRecord:[[DictChildData valueForKey:@"IndexNo"] intValue]]>0){
                        [modelProspectChild updateProspectChild:[self setDictionaryChild]];
                    }
                    else{
                        [modelProspectChild saveProspectChild:[self setDictionaryChild]];
                    }
                }
                else{
                    [modelProspectChild saveProspectChild:[self setDictionaryChild]];
                }
                
                [self dismissViewControllerAnimated:YES completion:^{[delegate reloadProspectData];}];
            }
        }
        else{
            if ([DictChildData count]>0){
                if ([modelProspectChild chekcExistingRecord:[[DictChildData valueForKey:@"IndexNo"] intValue]]>0){
                    [modelProspectChild updateProspectChild:[self setDictionaryChild]];
                }
                else{
                    [modelProspectChild saveProspectChild:[self setDictionaryChild]];
                }
            }
            else{
                [modelProspectChild saveProspectChild:[self setDictionaryChild]];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{[delegate reloadProspectData];}];
        }
        
    }
    else{
    
    }
}

- (IBAction)actionNationality:(id)sender
{
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (nationalityList == nil) {
        nationalityList = [[Nationality alloc] initWithStyle:UITableViewStylePlain];
        nationalityList.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:nationalityList];
    //}
    [popoverController presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


- (IBAction)actionDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString;
    if ([outletDOB.titleLabel.text length]>0){
        dateString= outletDOB.titleLabel.text;
    }
    else{
        dateString= [dateFormatter stringFromDate:[NSDate date]];
    }
    
    //if (datePickerViewController == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        datePickerViewController = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        datePickerViewController.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
    //}
    datePickerViewController.ProspectDOB = dateString;
    [popoverController setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [popoverController presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
}

- (IBAction)actionOtherIDType:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    //if (IDTypePicker == nil) {
        IDTypePicker = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        IDTypePicker.delegate = self;
        IDTypePicker.requestType = @"CO";
        popoverController = [[UIPopoverController alloc] initWithContentViewController:IDTypePicker];
    //}
    [popoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)actionOccupationList:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (occupationList == nil) {
        occupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        occupationList.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:occupationList];
    //}
    [popoverController presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)ActionGender:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"MALE";
    } else if([segGender selectedSegmentIndex]==1) {
        gender = @"FEMALE";
    }
}

- (IBAction)ActionSmoker:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segSmoker selectedSegmentIndex]==0) {
        ClientSmoker = @"Y";
    } else if ([segSmoker selectedSegmentIndex]==1) {
        ClientSmoker = @"N";
    }
}

#pragma mark load Data
-(void)loadChildData{
    if ([DictChildData count]>0){
        NSDictionary* dictOccup=[[NSDictionary alloc]initWithDictionary:[modelPopOver getOccupationByCode:[DictChildData valueForKey:@"ProspectChildOccupationCode"]]];
        txtName.text = [DictChildData valueForKey:@"ProspectChildName"];
        [outletDOB setTitle:[DictChildData valueForKey:@"ProspectChildDOB"] forState:UIControlStateNormal];
        IDTypeCodeSelected = [DictChildData valueForKey:@"OtherIDType"];
        [OtherIDType setTitle:[modelIdentificationType getOtherTypeDesc:[DictChildData valueForKey:@"OtherIDType"]] forState:UIControlStateNormal];
        txtOtherIDType.text=[DictChildData valueForKey:@"OtherIDTypeNo"];
        [outletNationality setTitle:[DictChildData valueForKey:@"Nationality"] forState:UIControlStateNormal];
        [outletRelation setTitle:[DictChildData valueForKey:@"Relation"] forState:UIControlStateNormal];
        txtYearsInsured.text=[DictChildData valueForKey:@"YearsInsured"];
        [outletOccupation setTitle:[dictOccup valueForKey:@"OccpDesc"] forState:UIControlStateNormal];
        OccupCodeSelected = [dictOccup valueForKey:@"OccpCode"];
         [txtAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:[DictChildData valueForKey:@"ProspectChildDOB"]]]];
        if ([[DictChildData valueForKey:@"ProspectChildGender"] isEqualToString:@"MALE"]) {
            gender = @"MALE";
            segGender.selectedSegmentIndex = 0;
        }
        else {
            gender = @"FEMALE";
            segGender.selectedSegmentIndex = 1;
        }
        
        if ([[DictChildData valueForKey:@"Smoker"] isEqualToString:@"Y"]) {
            ClientSmoker = @"Y";
            segSmoker.selectedSegmentIndex = 0;
        }
        else {
            ClientSmoker = @"N";
            segSmoker.selectedSegmentIndex = 1;
        }
    }
    else{
        txtName.text = @"";
        [outletDOB setTitle:@"" forState:UIControlStateNormal];
        [OtherIDType setTitle:@"" forState:UIControlStateNormal];
        txtOtherIDType.text=@"";
        [outletNationality setTitle:@"" forState:UIControlStateNormal];
        [outletRelation setTitle:@"Anak" forState:UIControlStateNormal];
        txtYearsInsured.text=@"";
        [outletOccupation setTitle:@"" forState:UIControlStateNormal];
        OccupCodeSelected = @"";
        gender = @"";
        segGender.selectedSegmentIndex = 0;
        ClientSmoker = @"";
        segSmoker.selectedSegmentIndex = 0;
    }
}

-(NSMutableDictionary *)setDictionaryChild{
    NSMutableDictionary* dictionaryChild;
    NSString* childName = txtName.text;
    NSString* childDOB = outletDOB.titleLabel.text;
    NSString* childOtherIDType = OtherIDType.titleLabel.text;
    NSString* childOtherIDNumber = txtOtherIDType.text;
    NSString* childNationality = outletNationality.titleLabel.text;
    NSString* childRelation = outletRelation.titleLabel.text;
    NSString* childYearsInsured = txtYearsInsured.text;
    NSString* childOccupationCode = OccupCodeSelected;
    
    dictionaryChild = [[NSMutableDictionary alloc]initWithObjectsAndKeys:childName,@"ProspectChildName",
                        childDOB,@"ProspectChildDOB",
                        IDTypeCodeSelected,@"OtherIDType",
                        childOtherIDNumber,@"OtherIDTypeNo",
                        childNationality,@"Nationality",
                        childRelation,@"Relation",
                        childYearsInsured,@"YearsInsured",
                        childOccupationCode,@"ProspectChildOccupationCode",
                        prospectProfileID,@"ProspectIndexNo",
                        cffTransactionID,@"CFFTransactionID",
                        gender,@"ProspectChildGender",
                        ClientSmoker,@"Smoker",nil];
    
    if ([DictChildData count]>0){
        [dictionaryChild setObject:[DictChildData valueForKey:@"IndexNo"] forKey:@"IndexNo"];
    }
    return dictionaryChild;
}

-(NSMutableDictionary *)setDictionaryObjectChild{
    NSMutableDictionary* dictionaryChild;
    
    dictionaryChild = [[NSMutableDictionary alloc]initWithObjectsAndKeys:txtName,@"ProspectChildName",
                       outletDOB,@"ProspectChildDOB",
                       OtherIDType,@"OtherIDType",
                       txtOtherIDType,@"OtherIDTypeNo",
                       outletNationality,@"Nationality",
                       outletRelation,@"Relation",
                       txtYearsInsured,@"YearsInsured",
                       outletOccupation,@"ProspectChildOccupationCode",
                       prospectProfileID,@"ProspectIndexNo",
                       cffTransactionID,@"CFFTransactionID",
                       segGender,@"ProspectChildGender",
                       segSmoker,@"Smoker",nil];
    return dictionaryChild;
}

#pragma mark keyboard appearance
- (void)keyboardWasShown:(NSNotification *)notification
{
    /*added by faiz*/
    // Step 1: Get the size of the keyboard.
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+44, 0.0);
    scrollAddChild.contentInset = contentInsets;
    scrollAddChild.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - (kbSize.height-15));
        [scrollAddChild setContentOffset:scrollPoint animated:YES];
    }
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollAddChild.contentInset = contentInsets;
    scrollAddChild.scrollIndicatorInsets = contentInsets;
}

#pragma mark delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    //NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == txtYearsInsured){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return ([string isEqualToString:filtered]);
    }
    if (textField == txtName)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength <= 40);
    }

    return YES;
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [popoverController dismissPopoverAnimated:YES];
}

-(void)selectedNationality:(NSString *)selectedNationality
{
    if([selectedNationality isEqualToString:@"- SELECT -"]) {
        outletNationality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        outletNationality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    outletNationality.titleLabel.text = selectedNationality;
    [outletNationality setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",selectedNationality]forState:UIControlStateNormal];
    [outletNationality setBackgroundColor:[UIColor clearColor]];
    [popoverController dismissPopoverAnimated:YES];
}


-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:strDate];
    
    NSDateFormatter *dateformatter;
    NSString *dateString;
    NSString *clientDateString;
    
    dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter* clientDateFormmater = [[NSDateFormatter alloc] init];
    [clientDateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [dateformatter stringFromDate:[NSDate date]];
    clientDateString = [clientDateFormmater stringFromDate:d2];
    
    int differenceDay = [formatter calculateDifferenceDay:strDate];
    int age  = [formatter calculateAge:strDate];
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else if (differenceDay<180){
        NSString *validationTanggalLahirFuture=@"Usia tidak boleh kurang dari 180 hari";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else if (age>99){
        NSString *validationTanggalLahirFuture=@"Usia tidak boleh lebih dari 99 tahun";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else{
        outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDOB setBackgroundColor:[UIColor clearColor]];
        [txtAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:strDate]]];
    }
    df = Nil, d = Nil, d2 = Nil;
}


-(void)IDTypeCodeSelected:(NSString *)IDTypeCode {
    IDTypeCodeSelected = IDTypeCode;
}

- (void)IDTypeCodeSelectedWithIdentifier:(NSString *) IDTypeCode Identifier:(NSString *)identifier{
    IDTypeCodeSelected = identifier;
}

-(void)IDTypeDescSelected:(NSString *)selectedIDType
{
    ColorHexCode *CustomColor = [[ColorHexCode alloc] init ];
    if ([selectedIDType isEqualToString:@"- SELECT -"]) {
        OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        txtOtherIDType.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
        [txtOtherIDType setText:@""];
        txtOtherIDType.enabled = NO;
    }
    else{
        OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        txtOtherIDType.backgroundColor = [UIColor whiteColor];
        txtOtherIDType.enabled = YES;
    }
    [OtherIDType setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",selectedIDType]forState:UIControlStateNormal];
    [OtherIDType setBackgroundColor:[UIColor clearColor]];
    [popoverController dismissPopoverAnimated:YES];
}

- (void)OccupCodeSelected:(NSString *)OccupCode {
    OccupCodeSelected = OccupCode;
}

- (void)OccupDescSelected:(NSString *)color
{
    [outletOccupation setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
    [outletOccupation setBackgroundColor:[UIColor clearColor]];
    
    [self.view endEditing:YES];
    [self resignFirstResponder];
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if([color isEqualToString:@"- SELECT -"]) {
        outletOccupation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        outletOccupation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    [popoverController dismissPopoverAnimated:YES];
}

-(void)OccupClassSelected:(NSString *)OccupClass
{
    
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
