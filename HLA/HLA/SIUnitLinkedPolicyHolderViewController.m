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

@interface SIUnitLinkedPolicyHolderViewController ()<DateViewControllerDelegate,OccupationListDelegate,RelationshipPopoverViewControllerDelegate,ListingTbViewControllerDelegate,PlanListDelegate>{
    ListingTbViewController *prospectList;
    DateViewController *laDate;
    OccupationList *occupationList;
    RelationshipPopoverViewController *relationShipTypePicker;
    PlanList *planList;
    ModelOccupation *modelOccupation;
    ModelSIPOData *modelSIPOData;
    
    Formatter *formatter;
    
    UIColor *themeColour;
    
    UIPopoverController *popoverViewer;
}

@end

@implementation SIUnitLinkedPolicyHolderViewController
@synthesize textIllustrationNumber;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    
    prospectList = [[ListingTbViewController alloc]init];
    laDate = [[DateViewController alloc]init];
    formatter = [[Formatter alloc]init];
    modelOccupation = [[ModelOccupation alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    
    [buttonIllustrationDate setTitle:[formatter getDateToday:@"dd/MM/yyyy"] forState:UIControlStateNormal];
    //occupationList = [[OccupationList alloc]init];
    //relationShipTypePicker = [[RelationshipPopoverViewController alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setInfoNewIllustration:(NSDictionary *)dictIllustration{

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
    }
}

-(IBAction)actionPlan:(UIButton *)sender{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    planList = [[PlanList alloc] init];
    planList.TradOrEver = @"TRAD";
    planList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:planList];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [popoverViewer setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [popoverViewer presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionDOB:(UIButton *)sender{
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
    [self.view endEditing:YES];
    
    relationShipTypePicker = [[RelationshipPopoverViewController alloc] initWithStyle:UITableViewStylePlain];
    relationShipTypePicker.delegate = self;
    
    [relationShipTypePicker loadData:[NSNumber numberWithInteger:0]];
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:relationShipTypePicker];
    [popoverViewer presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(IBAction)actionPOOccupation:(UIButton *)sender{
    occupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
    occupationList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:occupationList];
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:scrollPolicyHolder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionPOList:(UIButton *)sender{
    prospectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
    prospectList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:prospectList];
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    [popoverViewer presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

#pragma mark dictionary maker
-(void)setPOLADictionary{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]init];
    [dictPOLAData setObject:@"" forKey:@"SINO"];
    [dictPOLAData setObject:@"" forKey:@"ProductCode"];
    [dictPOLAData setObject:@"" forKey:@"ProductName"];
    [dictPOLAData setObject:@"" forKey:@"QuickQuote"];
    [dictPOLAData setObject:@"" forKey:@"SIDate"];
    [dictPOLAData setObject:@"" forKey:@"PO_Name"];
    [dictPOLAData setObject:@"" forKey:@"PO_DOB"];
    [dictPOLAData setObject:@"" forKey:@"PO_Gender"];
    [dictPOLAData setObject:@"" forKey:@"PO_Age"];
    [dictPOLAData setObject:@"" forKey:@"PO_OccpCode"];
    [dictPOLAData setObject:@"" forKey:@"PO_Occp"];
    [dictPOLAData setObject:@"" forKey:@"PO_ClientID"];
    [dictPOLAData setObject:@"" forKey:@"RelWithLA"];
    [dictPOLAData setObject:@"" forKey:@"LA_ClientID"];
    [dictPOLAData setObject:@"" forKey:@"LA_Name"];
    [dictPOLAData setObject:@"" forKey:@"LA_DOB"];
    [dictPOLAData setObject:@"" forKey:@"LA_Age"];
    [dictPOLAData setObject:@"" forKey:@"LA_Gender"];
    [dictPOLAData setObject:@"" forKey:@"LA_OccpCode"];
    [dictPOLAData setObject:@"" forKey:@"LA_Occp"];
    [dictPOLAData setObject:@"" forKey:@"IsInternalStaff"];
    [dictPOLAData setObject:@"" forKey:@"PO_Smoker"];
    [dictPOLAData setObject:@"" forKey:@"PO_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"PO_MonthlyIncome"];
    [dictPOLAData setObject:@"" forKey:@"LA_Smoker"];
    [dictPOLAData setObject:@"" forKey:@"LA_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"LA_MonthlyIncome"];
    
    [delegate setPOLADictionary:dictPOLAData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIButton *)sender{
    //set the updated data to parent
    [self setPOLADictionary];
    
    //get updated data from parent and save it.
    [modelSIPOData savePOLAData:[delegate getPOLADictionary]];
}

#pragma mark delegate
-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    textPO.text = aaName;
    [buttonDOB setTitle:aaDOB forState:UIControlStateNormal];
    [textPOAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aaDOB]]];
    [buttonOccupation setTitle:[modelOccupation getOccupationDesc:aaCode] forState:UIControlStateNormal];
    
    if ([aaGender isEqualToString:@"MALE"] || [aaGender isEqualToString:@"M"] ) {
        segmentSex.selectedSegmentIndex = 0;
    } else {
        segmentSex.selectedSegmentIndex = 1;
    }
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    [buttonDOB setTitle:aDate forState:UIControlStateNormal];
    
    [textPOAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aDate]]];
    [popoverViewer dismissPopoverAnimated:YES];
}

- (void)OccupCodeSelected:(NSString *)OccupCode
{
    [popoverViewer dismissPopoverAnimated:YES];
}

- (void)OccupDescSelected:(NSString *)color {
    [buttonOccupation setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)OccupClassSelected:(NSString *)OccupClass{
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
    [buttonPlan setTitle:aaDesc forState:UIControlStateNormal];
    [buttonRelation setTitle:@"--Please Select--" forState:UIControlStateNormal];
    
    [popoverViewer dismissPopoverAnimated:YES];
}

-(void)selectedRship:(NSString *)selectedRship :(NSString *)SelectedPshipCode;
{
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
