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
}

@end

@implementation SIUnitLinkedLifeAssuredViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIPOData = [[ModelSIPOData alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [dictPOLAData setObject:@"" forKey:@"LA_ClientID"];
    [dictPOLAData setObject:@"" forKey:@"LA_Name"];
    [dictPOLAData setObject:@"" forKey:@"LA_DOB"];
    [dictPOLAData setObject:@"" forKey:@"LA_Age"];
    [dictPOLAData setObject:@"" forKey:@"LA_Gender"];
    [dictPOLAData setObject:@"" forKey:@"LA_OccpCode"];
    [dictPOLAData setObject:@"" forKey:@"LA_Occp"];
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
    [popoverViewer dismissPopoverAnimated:YES];
}

- (void)OccupDescSelected:(NSString *)color {
    [buttonOccupation setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
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
