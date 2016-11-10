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

@interface SIUnitLinkedLifeAssuredViewController ()<DateViewControllerDelegate,OccupationListDelegate,RelationshipPopoverViewControllerDelegate,ListingTbViewControllerDelegate,PlanListDelegate>{
    
    ListingTbViewController *prospectList;
    DateViewController *laDate;
    OccupationList *occupationList;
    ModelOccupation *modelOccupation;
    Formatter *formatter;
    
    UIColor *themeColour;
    
    UIPopoverController *popoverViewer;
}

@end

@implementation SIUnitLinkedLifeAssuredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
