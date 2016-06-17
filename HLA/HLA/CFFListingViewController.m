//
//  CFFListingViewController.m
//  BLESS
//
//  Created by Basvi on 6/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CFFListingViewController.h"
#import "ListingTbViewController.h"
#import "ModelCFFTransaction.h"
#import "Formatter.h"
@interface CFFListingViewController ()<ListingTbViewControllerDelegate>{
    ListingTbViewController *ProspectList;
    ModelCFFTransaction *modelCFFTransaction;
    Formatter* formatter;
}

@end

@implementation CFFListingViewController{
    IBOutlet UITableView *tableCFFListing;
    UIPopoverController *prospectPopover;
    int clientProfileID;
    
    NSMutableArray* arrayCFFTransaction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBlackStatusBar];
    
    modelCFFTransaction = [[ModelCFFTransaction alloc]init];
    formatter = [[Formatter alloc]init];
    
    [self loadCFFTransaction];
    // Do any additional setup after loading the view from its nib.
}

-(void)createBlackStatusBar{
    CGFloat statusBarHeight = 20.0;
    UIView* colorView = [[UIView alloc]initWithFrame:CGRectMake(0, -statusBarHeight, self.view.bounds.size.width, statusBarHeight)];
    [colorView setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:colorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    CFFQuestionsViewController* cFFQuestionsVC = [[CFFQuestionsViewController alloc]initWithNibName:@"CFFQuestionsViewController" bundle:nil];
    cFFQuestionsVC.prospectProfileID = [arrayCFFTransaction[indexPath.row] valueForKey:@"IndexNo"];
    cFFQuestionsVC.cffTransactionID = [arrayCFFTransaction[indexPath.row] valueForKey:@"CFFTransactionID"];
    [self.navigationController pushViewController:cFFQuestionsVC animated:YES];
}


#pragma mark select prospect from list
- (IBAction)selectProspect:(id)sender
{
    if (ProspectList == nil) {
        ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        ProspectList.delegate = self;
        prospectPopover = [[UIPopoverController alloc] initWithContentViewController:ProspectList];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [prospectPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)createAlertTwoOptionViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Konfirmasi pembuatan CFF"
                                                    message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = alertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) {
        if (buttonIndex==0){
            
        }
        else{
            [self CreateNewCFFTransaction];
            [self loadCFFTransaction];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayCFFTransaction count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProspectListingTableViewCell *cell1 = (ProspectListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    if (cell1 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProspectListingTableViewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    if (indexPath.row<[arrayCFFTransaction count]){
        NSString* prefix=[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"Prefix"];
        NSString* mobileNumber=[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ContactNo"];
        
        [cell1.labelName setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectName"]];
        [cell1.labelidNum setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"]];
        [cell1.labelDOB setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectDOB"]];
        [cell1.labelBranchName setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"Branch"]];
        [cell1.labelPhone1 setText: [NSString stringWithFormat:@"%@ - %@",prefix,mobileNumber]];
        [cell1.labelDateCreated setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFDateCreated"]];
        [cell1.labelDateModified setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFDateModified"]];
        [cell1.labelTimeRemaining setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFStatus"]];
    }
    return cell1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

#pragma mark - delegate
-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    clientProfileID = [aaIndex intValue];
    [self createAlertTwoOptionViewAndShow:@"Yakin ingin membuat CFF dengan data nasabah ini ?" tag:1];
    [prospectPopover dismissPopoverAnimated:YES];
}

#pragma mark save to CFFTransaction
-(void)CreateNewCFFTransaction{
    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd"];
    NSDictionary* dictCFFTransaction = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"CFFID",[NSNumber numberWithInteger:clientProfileID],@"ProspectIndexNo",dateToday,@"CFFDateCreated",@"",@"CreatedBy",dateToday,@"CFFDateModified",@"",@"ModifiedBy",@"Not Complete",@"CFFStatus", nil];
    [modelCFFTransaction saveCFFTransaction:dictCFFTransaction];
}

#pragma mark load CFFTransaction
-(void)loadCFFTransaction{
    arrayCFFTransaction=[[NSMutableArray alloc]initWithArray:[modelCFFTransaction getAllCFF]];
    [tableCFFListing reloadData];
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
