//
//  AddSpouseViewController.m
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AddSpouseViewController.h"
#import "SIDate.h"
#import "Nationality.h"
#import "IDTypeViewController.h"
#import "OccupationList.h"
#import "ColorHexCode.h"
#import "ModelProspectSpouse.h"
#import "ModelPopover.h"

@interface AddSpouseViewController ()<SIDateDelegate,IDTypeDelegate,NatinalityDelegate,OccupationListDelegate>{
    SIDate* datePickerViewController;
    IDTypeViewController *IDTypePicker;
    Nationality *nationalityList;
    OccupationList *occupationList;
    ModelProspectSpouse *modelProspectSpouse;
    ModelPopover* modelPopOver;
}

@end

@implementation AddSpouseViewController{
    NSString *IDTypeCodeSelected;
    NSString *OccupCodeSelected;
    NSString *gender;
    NSString *ClientSmoker;
    
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIButton *outletRelation;
    IBOutlet UIButton *outletDOB;
    IBOutlet UIButton *OtherIDType;
    IBOutlet UITextField *txtOtherIDType;
    IBOutlet UITextField *txtYearsInsured;
    IBOutlet UITextField *txtName;
    IBOutlet UIButton *outletNationality;
    IBOutlet UIButton *outletOccupation;
    IBOutlet UISegmentedControl *segGender;
    IBOutlet UISegmentedControl *segSmoker;
    UIPopoverController *popoverController;
    
    UIColor *borderColor;
}
@synthesize prospectProfileID,cffTransactionID,delegate,DictSpouseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    modelProspectSpouse = [[ModelProspectSpouse alloc]init];
    modelPopOver = [[ModelPopover alloc]init];
    borderColor=[[UIColor alloc]initWithRed:250.0/255.0 green:175.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    [self setButtonImageAndTextAlignment];
    [outletRelation setTitle:@"Spouse" forState:UIControlStateNormal];
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
    
    outletRelation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletRelation.imageEdgeInsets = UIEdgeInsetsMake(0., outletRelation.frame.size.width - (24 + 10.0), 0., 0.);
    outletRelation.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletRelation.layer.borderColor = borderColor.CGColor;
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

-(IBAction)actionSaveSpouse:(id)sender{
    if ([DictSpouseData count]>0){
        if ([modelProspectSpouse chekcExistingRecord:[[DictSpouseData valueForKey:@"IndexNo"] intValue]]>0){
            [modelProspectSpouse updateProspectSpouse:[self setDictionarySpouse]];
        }
        else{
            [modelProspectSpouse saveProspectSpouse:[self setDictionarySpouse]];
        }
    }
    else{
        [modelProspectSpouse saveProspectSpouse:[self setDictionarySpouse]];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{[delegate reloadProspectData];}];
}

- (IBAction)actionNationality:(id)sender
{
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (nationalityList == nil) {
        nationalityList = [[Nationality alloc] initWithStyle:UITableViewStylePlain];
        nationalityList.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:nationalityList];
    }
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
    
    if (datePickerViewController == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        datePickerViewController = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        datePickerViewController.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
    }
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
    
    if (IDTypePicker == nil) {
        IDTypePicker = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        IDTypePicker.delegate = self;
        IDTypePicker.requestType = @"CO";
        popoverController = [[UIPopoverController alloc] initWithContentViewController:IDTypePicker];
    }
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
    
    if (occupationList == nil) {
        occupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        occupationList.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:occupationList];
    }
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
-(void)loadSpouseData:(NSDictionary *)dictSpouseData{
    if ([dictSpouseData count]>0){
        NSDictionary* dictOccup=[[NSDictionary alloc]initWithDictionary:[modelPopOver getOccupationByCode:[dictSpouseData valueForKey:@"ProspectSpouseOccupationCode"]]];
        txtName.text = [dictSpouseData valueForKey:@"ProspectSpouseName"];
        [outletDOB setTitle:[dictSpouseData valueForKey:@"ProspectSpouseDOB"] forState:UIControlStateNormal];
        [OtherIDType setTitle:[dictSpouseData valueForKey:@"OtherIDType"] forState:UIControlStateNormal];
        txtOtherIDType.text=[dictSpouseData valueForKey:@"OtherIDTypeNo"];
        [outletNationality setTitle:[dictSpouseData valueForKey:@"Nationality"] forState:UIControlStateNormal];
        [outletRelation setTitle:[dictSpouseData valueForKey:@"Relation"] forState:UIControlStateNormal];
        txtYearsInsured.text=[dictSpouseData valueForKey:@"YearsInsured"];
        [outletOccupation setTitle:[dictOccup valueForKey:@"OccpDesc"] forState:UIControlStateNormal];
        OccupCodeSelected = [dictOccup valueForKey:@"OccpCode"];
        
        if ([[dictSpouseData valueForKey:@"ProspectSpouseGender"] isEqualToString:@"MALE"]) {
            gender = @"MALE";
            segGender.selectedSegmentIndex = 0;
        }
        else {
            gender = @"FEMALE";
            segGender.selectedSegmentIndex = 1;
        }
        
        if ([[dictSpouseData valueForKey:@"Smoker"] isEqualToString:@"Y"]) {
            ClientSmoker = @"Y";
            segSmoker.selectedSegmentIndex = 0;
        }
        else {
            ClientSmoker = @"N";
            segSmoker.selectedSegmentIndex = 1;
        }
        
        /*dictionarySpouse = [[NSDictionary alloc]initWithObjectsAndKeys:spouseName,@"ProspectSpouseName",
                            spouseDOB,@"ProspectSpouseDOB",
                            spouseOtherIDType,@"OtherIDType",
                            spouseOtherIDNumber,@"OtherIDTypeNo",
                            spouseNationality,@"Nationality",
                            spouseRelation,@"Relation",
                            spouseYearsInsured,@"YearsInsured",
                            spouseOccupationCode,@"ProspectSpouseOccupationCode",
                            prospectProfileID,@"ProspectIndexNo",
                            cffTransactionID,@"CFFTransactionID",
                            gender,@"ProspectSpouseGender",
                            ClientSmoker,@"Smoker",nil];*/
    }
    else{
        txtName.text = @"";
        [outletDOB setTitle:@"" forState:UIControlStateNormal];
        [OtherIDType setTitle:@"" forState:UIControlStateNormal];
        txtOtherIDType.text=@"";
        [outletNationality setTitle:@"" forState:UIControlStateNormal];
        [outletRelation setTitle:@"Spouse" forState:UIControlStateNormal];
        txtYearsInsured.text=@"";
        [outletOccupation setTitle:@"" forState:UIControlStateNormal];
        OccupCodeSelected = @"";
        gender = @"";
        segGender.selectedSegmentIndex = 0;
        ClientSmoker = @"";
        segSmoker.selectedSegmentIndex = 0;
    }

}


#pragma mark setDictionary
-(NSMutableDictionary *)setDictionarySpouse{
    NSMutableDictionary* dictionarySpouse;
    NSString* spouseName = txtName.text;
    NSString* spouseDOB = outletDOB.titleLabel.text;
    NSString* spouseOtherIDType = OtherIDType.titleLabel.text;
    NSString* spouseOtherIDNumber = txtOtherIDType.text;
    NSString* spouseNationality = outletNationality.titleLabel.text;
    NSString* spouseRelation = outletRelation.titleLabel.text;
    NSString* spouseYearsInsured = txtYearsInsured.text;
    NSString* spouseOccupationCode = OccupCodeSelected;
    
    dictionarySpouse = [[NSMutableDictionary alloc]initWithObjectsAndKeys:spouseName,@"ProspectSpouseName",
                        spouseDOB,@"ProspectSpouseDOB",
                        spouseOtherIDType,@"OtherIDType",
                        spouseOtherIDNumber,@"OtherIDTypeNo",
                        spouseNationality,@"Nationality",
                        spouseRelation,@"Relation",
                        spouseYearsInsured,@"YearsInsured",
                        spouseOccupationCode,@"ProspectSpouseOccupationCode",
                        prospectProfileID,@"ProspectIndexNo",
                        cffTransactionID,@"CFFTransactionID",
                        gender,@"ProspectSpouseGender",
                        ClientSmoker,@"Smoker",nil];
    
    if ([DictSpouseData count]>0){
        [dictionarySpouse setObject:[DictSpouseData valueForKey:@"IndexNo"] forKey:@"IndexNo"];
    }
    
    return dictionarySpouse;
}


#pragma mark delegate
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
    
    NSDateFormatter *formatter;
    NSString *dateString;
    NSString *clientDateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter* clientDateFormmater = [[NSDateFormatter alloc] init];
    [clientDateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    clientDateString = [clientDateFormmater stringFromDate:d2];
    
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else{
        outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDOB setBackgroundColor:[UIColor clearColor]];
    }
    df = Nil, d = Nil, d2 = Nil;
}


-(void)IDTypeCodeSelected:(NSString *)IDTypeCode {
    IDTypeCodeSelected = IDTypeCode;
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
