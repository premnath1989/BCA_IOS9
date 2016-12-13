//
//  SIUnitLinkedPolicyHolderViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedPolicyHolderViewController.h"
#import "OccupationList.h"
#import "DateViewController.h"
#import "RelationshipPopoverViewController.h"
#import "ListingTbViewController.h"
#import "PlanList.h"
#import "ModelOccupation.h"
#import "Formatter.h"
#import "ModelSIPOData.h"
#import "PlanList.h"
#import "Alert.h"

@interface SIUnitLinkedPolicyHolderViewController ()<DateViewControllerDelegate,OccupationListDelegate,RelationshipPopoverViewControllerDelegate,ListingTbViewControllerDelegate,PlanListDelegate>{
    ListingTbViewController *prospectList;
    DateViewController *laDate;
    OccupationList *occupationList;
    RelationshipPopoverViewController *relationShipTypePicker;
    PlanList *planList;
    ModelOccupation *modelOccupation;
    ModelSIPOData *modelSIPOData;
    Alert* alert;
    
    Formatter *formatter;
    
    UIColor *themeColour;
    
    UIPopoverController *popoverViewer;
    
    NSNumber *numberBoolQuickQuote;
    int clientProfileID;
    NSString *sex;
    NSString *smoker;
    NSString *occupationCode;
    NSString *occupationDesc;
    NSString *relWithLA;
    NSString *productCode;
    NSNumber *numberIntInternalStaff;
}

@end

@implementation SIUnitLinkedPolicyHolderViewController
@synthesize textIllustrationNumber;
@synthesize delegate;
@synthesize scrollPolicyHolder;
-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    prospectList = [[ListingTbViewController alloc]init];
    laDate = [[DateViewController alloc]init];
    formatter = [[Formatter alloc]init];
    modelOccupation = [[ModelOccupation alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    planList = [[PlanList alloc] init];
    alert = [[Alert alloc]init];
    
    planList.TradOrEver = @"TRAD";
    planList.delegate = self;
    
    [buttonIllustrationDate setTitle:[formatter getDateToday:@"dd/MM/yyyy"] forState:UIControlStateNormal];
    //occupationList = [[OccupationList alloc]init];
    //relationShipTypePicker = [[RelationshipPopoverViewController alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == textPO)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        /*NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz./@'()-"] invertedSet];
         NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
         return (([string isEqualToString:filtered]) && newLength <= 40);*/
        return (newLength <= 40);
    }
    
    return YES;
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]init];
    dictPOLAData = [delegate getPOLADictionary];
    if ([dictPOLAData count]!=0){
        numberBoolQuickQuote = [NSNumber numberWithInt:[[dictPOLAData valueForKey:@"QuickQuote"] intValue]];
        
        if ([numberBoolQuickQuote intValue]==0){
            [quickQuoteFlag setOn:false];
        }
        else{
            [quickQuoteFlag setOn:true];
        }
        [self QuickQuoteFunc:quickQuoteFlag];
        
        textIllustrationNumber.text = [dictPOLAData valueForKey:@"SINO"];
        textPOAge.text = [dictPOLAData valueForKey:@"PO_Age"];
        textPO.text = [dictPOLAData valueForKey:@"PO_Name"];
        [buttonPlan setTitle:[dictPOLAData valueForKey:@"ProductName"] forState:UIControlStateNormal];
        [buttonIllustrationDate setTitle:[dictPOLAData valueForKey:@"SIDate"] forState:UIControlStateNormal];
        [buttonDOB setTitle:[dictPOLAData valueForKey:@"PO_DOB"] forState:UIControlStateNormal];
        [buttonOccupation setTitle:[dictPOLAData valueForKey:@"PO_Occp"] forState:UIControlStateNormal];
        [buttonRelation setTitle:[dictPOLAData valueForKey:@"RelWithLA"] forState:UIControlStateNormal];
        
        sex = [dictPOLAData valueForKey:@"PO_Gender"];
        smoker = [dictPOLAData valueForKey:@"PO_Smoker"];
        
        if ([sex isEqualToString:@"MALE"]){
            [segmentSex setSelectedSegmentIndex:0];
        }
        else{
            [segmentSex setSelectedSegmentIndex:1];
        }
        
        if ([smoker isEqualToString:@"Y"]){
            [segmentSmoker setSelectedSegmentIndex:0];
        }
        else{
            [segmentSmoker setSelectedSegmentIndex:1];
        }
        
        occupationDesc = [dictPOLAData valueForKey:@"PO_Occp"];
        occupationCode = [dictPOLAData valueForKey:@"PO_OccpCode"];
        clientProfileID = [[dictPOLAData valueForKey:@"PO_ClientID"] intValue];
        productCode = [dictPOLAData valueForKey:@"ProductCode"];
        relWithLA = [dictPOLAData valueForKey:@"RelWithLA"];
    }
    else{
        [textIllustrationNumber setText:[delegate getRunnigSINumber]];
        productCode = @"BCALUL";
        [buttonPlan setTitle:@"BCA Life Unit Linked" forState:UIControlStateNormal];
    }
}

-(NSNumber *)getQuickQuoteState{
    if ([quickQuoteFlag isOn]){
        numberBoolQuickQuote = [NSNumber numberWithInt:1];
    }
    else{
        numberBoolQuickQuote = [NSNumber numberWithInt:0];
    }
    return numberBoolQuickQuote;
}

- (IBAction)QuickQuoteFunc:(UISwitch *)sender
{
    if([sender isOn])
    {
        [buttonDOB setTitle:@"--Please Select--" forState:UIControlStateNormal];
        [segmentSex setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [buttonOccupation setTitle:@"--Please Select--" forState:UIControlStateNormal];
        textPOAge.enabled = FALSE;
        textPOAge.text =@"";
        textPO.text =@"";
        textPO.enabled = YES;
        buttonDOB.enabled = YES;
        segmentSex.enabled = YES;
        buttonOccupation.enabled = YES;
        buttonPOlist.enabled = NO;

        [labelQuickQuote setTextColor:themeColour];
        numberBoolQuickQuote = [NSNumber numberWithInt:1];
        clientProfileID = -1;
    }
    else
    {
        [buttonDOB setTitle:@"--Please Select--" forState:UIControlStateNormal];
        [segmentSex setSelectedSegmentIndex:-1];
        [buttonOccupation setTitle:@"--Please Select--" forState:UIControlStateNormal];
        textPOAge.enabled = FALSE;
        textPOAge.text =@"";
        textPO.text =@"";
        textPO.enabled = NO;
        buttonDOB.enabled = NO;
        segmentSex.enabled = NO;
        buttonOccupation.enabled = NO;
        buttonPOlist.enabled = YES;
        
        [labelQuickQuote setTextColor:[UIColor lightGrayColor]];
        numberBoolQuickQuote = [NSNumber numberWithInt:0];
    }
}

-(IBAction)actionSegmentGender:(UISegmentedControl *)sender{
    if ([segmentSex selectedSegmentIndex]==0) {
        sex = @"MALE";
    } else if (segmentSex.selectedSegmentIndex == 1) {
        sex = @"FEMALE";
    }
}

-(IBAction)actionSegmentSmoker:(UISegmentedControl *)sender{
    if ([segmentSmoker selectedSegmentIndex]==0) {
        smoker = @"Y";
    } else if (segmentSmoker.selectedSegmentIndex == 1) {
        smoker = @"N";
    }
}

-(NSString *)getSmokerFromSegment:(UISegmentedControl *)sender{
    if ([segmentSmoker selectedSegmentIndex]==0) {
        smoker = @"Y";
    } else if (segmentSmoker.selectedSegmentIndex == 1) {
        smoker = @"N";
    }
    
    return smoker;
}

-(IBAction)actionPlan:(UIButton *)sender{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:planList];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [popoverViewer setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [popoverViewer presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionDOB:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    laDate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    laDate.delegate = self;
    laDate.btnSender = 1;
    laDate.msgDate = sender.titleLabel.text;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:laDate];
    [popoverViewer setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:scrollPolicyHolder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionCommencementDate:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    laDate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    laDate.delegate = self;
    laDate.btnSender = 1;
    laDate.msgDate = sender.titleLabel.text;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:laDate];
    [popoverViewer setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:scrollPolicyHolder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionPORelation:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    [self.view endEditing:YES];
    
    relationShipTypePicker = [[RelationshipPopoverViewController alloc] initWithStyle:UITableViewStylePlain];
    relationShipTypePicker.delegate = self;
    
    [relationShipTypePicker loadData:[NSNumber numberWithInteger:2]];
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:relationShipTypePicker];
    [popoverViewer presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(IBAction)actionPOOccupation:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    occupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
    occupationList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:occupationList];
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:scrollPolicyHolder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionPOList:(UIButton *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    prospectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
    prospectList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:prospectList];
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    [popoverViewer presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

#pragma mark dictionary maker
-(void)setPOLADictionary{
    NSMutableDictionary* originalDictPOLAData = [[NSMutableDictionary alloc]init];
    originalDictPOLAData = [delegate getPOLADictionary];

    numberIntInternalStaff = [NSNumber numberWithInt:0];
    
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]init];
    [dictPOLAData setObject:textIllustrationNumber.text forKey:@"SINO"];
    [dictPOLAData setObject:productCode forKey:@"ProductCode"];
    [dictPOLAData setObject:buttonPlan.currentTitle forKey:@"ProductName"];
    [dictPOLAData setObject:numberBoolQuickQuote?:[self getQuickQuoteState] forKey:@"QuickQuote"];
    [dictPOLAData setObject:buttonIllustrationDate.currentTitle forKey:@"SIDate"];
    [dictPOLAData setObject:textPO.text forKey:@"PO_Name"];
    [dictPOLAData setObject:buttonDOB.currentTitle forKey:@"PO_DOB"];
    [dictPOLAData setObject:sex forKey:@"PO_Gender"];
    [dictPOLAData setObject:textPOAge.text forKey:@"PO_Age"];
    [dictPOLAData setObject:occupationCode forKey:@"PO_OccpCode"];
    [dictPOLAData setObject:occupationDesc forKey:@"PO_Occp"];
    [dictPOLAData setObject:[NSNumber numberWithInt:clientProfileID] forKey:@"PO_ClientID"];
    [dictPOLAData setObject:relWithLA forKey:@"RelWithLA"];
    [dictPOLAData setObject:numberIntInternalStaff forKey:@"IsInternalStaff"];
    [dictPOLAData setObject:smoker?:[self getSmokerFromSegment:segmentSmoker] forKey:@"PO_Smoker"];
    
    if ([relWithLA isEqualToString:@"DIRI SENDIRI"]){
        [dictPOLAData setObject:[NSNumber numberWithInt:clientProfileID] forKey:@"LA_ClientID"];
        [dictPOLAData setObject:textPO.text forKey:@"LA_Name"];
        [dictPOLAData setObject:buttonDOB.currentTitle forKey:@"LA_DOB"];
        [dictPOLAData setObject:textPOAge.text forKey:@"LA_Age"];
        [dictPOLAData setObject:sex forKey:@"LA_Gender"];
        [dictPOLAData setObject:occupationCode forKey:@"LA_OccpCode"];
        [dictPOLAData setObject:occupationDesc forKey:@"LA_Occp"];
        
        [dictPOLAData setObject:smoker?:[self getSmokerFromSegment:segmentSmoker] forKey:@"LA_Smoker"];
        [dictPOLAData setObject:@"" forKey:@"LA_CommencementDate"];
        [dictPOLAData setObject:@"" forKey:@"LA_MonthlyIncome"];
    }
    else{
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_ClientID"]?:@"" forKey:@"LA_ClientID"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_Name"]?:@"" forKey:@"LA_Name"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_DOB"]?:@"" forKey:@"LA_DOB"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_Age"]?:@"" forKey:@"LA_Age"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_Gender"]?:@"" forKey:@"LA_Gender"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_OccpCode"]?:@"" forKey:@"LA_OccpCode"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_Occp"]?:@"" forKey:@"LA_Occp"];
        
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_Smoker"]?:@"" forKey:@"LA_Smoker"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_CommencementDate"]?:@"" forKey:@"LA_CommencementDate"];
        [dictPOLAData setObject:[originalDictPOLAData valueForKey:@"LA_MonthlyIncome"]?:@"" forKey:@"LA_MonthlyIncome"];
    }
    
    
    [dictPOLAData setObject:@"" forKey:@"PO_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"PO_MonthlyIncome"];
    
    [delegate setPOLADictionary:dictPOLAData];
}

#pragma mark validation
-(BOOL)ValidateSave{
    NSString *namaProduk = buttonPlan.currentTitle;
    NSString *namaPemegangPolis = textPO.text;
    NSString *tanggalLahir = buttonDOB.currentTitle;
    //jenis kelamin
    //perokok
    NSString *pekerjaan = buttonOccupation.currentTitle;
    NSString *relasi = buttonRelation.currentTitle;
    
    NSString *alertNamaProduk = @"Produk harus diisi.";
    NSString *alertNamaPemegangPolis = @"Nama Pemegang harus diisi.";
    NSString *alertTanggalLahir = @"Tanggal Lahir Pemegang Polis";
    NSString *alertJenisKelamin = @"Jenis kelamin Pemegang Polis harus diisi.";
    NSString *alertPerokok = @"Status Merokok Pemegang Polis harus diisi.";
    NSString *alertPekerjaan = @"Pekerjaan Pemegang Polis harus diisi.";
    NSString *alertRelasi = @"Hubungan Dengan Tertannggung harus diisi";
    
    UIAlertController *alertvalidation;
    if ([namaProduk isEqualToString:@"(null)"]||[namaProduk isEqualToString:@" - SELECT -"]||[namaProduk isEqualToString:@"- SELECT -"]||[namaProduk isEqualToString:@"--Please Select--"] ||[namaProduk length]<=0){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertNamaProduk];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if ([namaPemegangPolis length]<=0){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertNamaPemegangPolis];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if ([tanggalLahir isEqualToString:@"(null)"]||[tanggalLahir isEqualToString:@" - SELECT -"]||[tanggalLahir isEqualToString:@"- SELECT -"]||[tanggalLahir isEqualToString:@"--Please Select--"] ||[tanggalLahir length]<=0){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertTanggalLahir];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if (segmentSex.selectedSegmentIndex == UISegmentedControlNoSegment){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertJenisKelamin];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if (segmentSmoker.selectedSegmentIndex == UISegmentedControlNoSegment){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertPerokok];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if ([pekerjaan isEqualToString:@"(null)"]||[pekerjaan isEqualToString:@" - SELECT -"]||[pekerjaan isEqualToString:@"- SELECT -"]||[pekerjaan isEqualToString:@"--Please Select--"] ||[pekerjaan length]<=0){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertPekerjaan];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    if ([relasi isEqualToString:@"(null)"]||[relasi isEqualToString:@" - SELECT -"]||[relasi isEqualToString:@"- SELECT -"]||[relasi isEqualToString:@"--Please Select--"] ||[relasi length]<=0){
        alertvalidation = [alert alertInformation:@"Peringatan" stringMessage:alertRelasi];
        [self presentViewController:alertvalidation animated:YES completion:nil];
        return false;
    }
    return true;
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([self ValidateSave]){
        //set the updated data to parent
        [self setPOLADictionary];
        
        //get updated data from parent and save it.
        [modelSIPOData savePOLAData:[delegate getPOLADictionary]];
        
        //save SIMaster
        [delegate saveSIMaster];
        
        if ([relWithLA isEqualToString:@"DIRI SENDIRI"]){
            //changePage
            [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:2 inSection:0]];
        }
        else{
            //changePage
            [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:1 inSection:0]];
        }
    }
}

#pragma mark delegate
-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    clientProfileID = [aaIndex intValue];
    textPO.text = aaName;
    [buttonDOB setTitle:aaDOB forState:UIControlStateNormal];
    [textPOAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aaDOB]]];
    [buttonOccupation setTitle:[modelOccupation getOccupationDesc:aaCode] forState:UIControlStateNormal];
    occupationCode = aaCode;
    occupationDesc = [modelOccupation getOccupationDesc:aaCode];
    if ([aaGender isEqualToString:@"MALE"] || [aaGender isEqualToString:@"M"] ) {
        segmentSex.selectedSegmentIndex = 0;
        sex = @"MALE";

    } else {
        segmentSex.selectedSegmentIndex = 1;
        sex = @"FEMALE";

    }
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    int poAge = [formatter calculateAge:aDate];
    
    if ((poAge<21)||(poAge>70)){
        NSString* stringAlertPOAge = @"Usia pemegang polis tidak boleh kurang dari 21 atau lebih dari 70 tahun";
        UIAlertController *alertEmptyImage = [alert alertInformation:@"Peringatan" stringMessage:stringAlertPOAge];
        [popoverViewer dismissPopoverAnimated:YES];
        [self presentViewController:alertEmptyImage animated:YES completion:nil];
    }
    else{
        [buttonDOB setTitle:aDate forState:UIControlStateNormal];
        [textPOAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aDate]]];
        [popoverViewer dismissPopoverAnimated:YES];
    }
    
}

- (void)OccupCodeSelected:(NSString *)OccupCode
{
    occupationCode = OccupCode;
    [popoverViewer dismissPopoverAnimated:YES];
}

- (void)OccupDescSelected:(NSString *)color {
    [buttonOccupation setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
    occupationDesc = color;
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)OccupClassSelected:(NSString *)OccupClass{
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
    productCode = aaCode;
    [buttonPlan setTitle:aaDesc forState:UIControlStateNormal];
    [buttonRelation setTitle:@"--Please Select--" forState:UIControlStateNormal];
    
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)selectedRship:(NSString *)selectedRship :(NSString *)SelectedPshipCode;
{
    relWithLA = selectedRship;
    [buttonRelation setTitle:selectedRship forState:UIControlStateNormal];
    [popoverViewer dismissPopoverAnimated:YES];
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
