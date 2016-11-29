//
//  SIMenuUnitLinkedLifeAssuredViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedLifeAssuredViewController.h"
#import "OccupationList.h"
#import "DateViewController.h"
#import "RelationshipPopoverViewController.h"
#import "ListingTbViewController.h"
#import "PlanList.h"
#import "ModelOccupation.h"
#import "Formatter.h"
#import "ModelSIPOData.h"

@interface SIUnitLinkedLifeAssuredViewController ()<DateViewControllerDelegate,OccupationListDelegate,RelationshipPopoverViewControllerDelegate,ListingTbViewControllerDelegate,PlanListDelegate>{
    
    ListingTbViewController *prospectList;
    DateViewController *laDate;
    OccupationList *occupationList;
    ModelOccupation *modelOccupation;
    Formatter *formatter;
    ModelSIPOData *modelSIPOData;
    
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

@implementation SIUnitLinkedLifeAssuredViewController
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIPOData = [[ModelSIPOData alloc]init];
    formatter = [[Formatter alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]init];
    dictPOLAData = [delegate getPOLADictionary];
    if ([dictPOLAData count]!=0){
        numberBoolQuickQuote = [NSNumber numberWithInt:[[dictPOLAData valueForKey:@"QuickQuote"] intValue]];
        
        if ([numberBoolQuickQuote intValue]==0){
            [self QuickQuoteFunc:false];
        }
        else{
            [self QuickQuoteFunc:true];
        }
        
        textLAAge.text = [dictPOLAData valueForKey:@"LA_Age"];
        textLA.text = [dictPOLAData valueForKey:@"LA_Name"];
        [buttonDOB setTitle:[dictPOLAData valueForKey:@"LA_DOB"] forState:UIControlStateNormal];
        [buttonOccupation setTitle:[dictPOLAData valueForKey:@"LA_Occp"] forState:UIControlStateNormal];
        
        
        sex = [dictPOLAData valueForKey:@"LA_Gender"];
        smoker = [dictPOLAData valueForKey:@"LA_Smoker"];
        
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
        
        occupationDesc = [dictPOLAData valueForKey:@"LA_Occp"];
        occupationCode = [dictPOLAData valueForKey:@"LA_OccpCode"];
        clientProfileID = [[dictPOLAData valueForKey:@"LA_ClientID"] intValue];
        productCode = [dictPOLAData valueForKey:@"ProductCode"];
        relWithLA = [dictPOLAData valueForKey:@"RelWithLA"];
    }
    else{
        //[textIllustrationNumber setText:[delegate getRunnigSINumber]];
    }
}

- (void)QuickQuoteFunc:(BOOL)quickQuoteFlag
{
    if(quickQuoteFlag)
    {
        textLAAge.enabled = FALSE;
        textLA.enabled = YES;
        buttonDOB.enabled = YES;
        segmentSex.enabled = YES;
        buttonOccupation.enabled = YES;
        buttonPOlist.enabled = NO;
        
        numberBoolQuickQuote = [NSNumber numberWithInt:1];
        clientProfileID = -1;
    }
    else
    {
        textLAAge.enabled = FALSE;
        textLA.enabled = NO;
        buttonDOB.enabled = NO;
        segmentSex.enabled = NO;
        buttonOccupation.enabled = NO;
        buttonPOlist.enabled = YES;
        
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
    
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionPOOccupation:(UIButton *)sender{
    occupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
    occupationList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:occupationList];
    [popoverViewer presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)actionLAList:(UIButton *)sender{
    prospectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
    prospectList.delegate = self;
    popoverViewer = [[UIPopoverController alloc] initWithContentViewController:prospectList];
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    [popoverViewer presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

#pragma mark dictionary maker
-(void)setPOLADictionary{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    [dictPOLAData setObject:[NSNumber numberWithInt:clientProfileID] forKey:@"LA_ClientID"];
    [dictPOLAData setObject:textLA.text forKey:@"LA_Name"];
    [dictPOLAData setObject:buttonDOB.currentTitle forKey:@"LA_DOB"];
    [dictPOLAData setObject:textLAAge.text forKey:@"LA_Age"];
    [dictPOLAData setObject:sex forKey:@"LA_Gender"];
    [dictPOLAData setObject:occupationCode forKey:@"LA_OccpCode"];
    [dictPOLAData setObject:occupationDesc forKey:@"LA_Occp"];
    
    [dictPOLAData setObject:smoker forKey:@"LA_Smoker"];
    [dictPOLAData setObject:@"" forKey:@"LA_CommencementDate"];
    [dictPOLAData setObject:@"" forKey:@"LA_MonthlyIncome"];
    
    [delegate setPOLADictionary:dictPOLAData];
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    //set the updated data to parent
    [self setPOLADictionary];
    
    //get updated data from parent and save it.
    [modelSIPOData savePOLAData:[delegate getPOLADictionary]];
    
    //changePage
    [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:2 inSection:0]];
}

#pragma mark delegate
-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    textLA.text = aaName;
    [buttonDOB setTitle:aaDOB forState:UIControlStateNormal];
    [textLAAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aaDOB]]];
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
    
    [textLAAge setText:[NSString stringWithFormat:@"%i",[formatter calculateAge:aDate]]];
    [popoverViewer dismissPopoverAnimated:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
