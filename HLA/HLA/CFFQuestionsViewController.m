//
//  CFFQuestionsViewController.m
//  BLESS
//
//  Created by Basvi on 6/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//


#import "CFFQuestionsViewController.h"
#import "DataNasabahViewController.h"
#import "AreaPotensialDiskusiViewController.h"

@interface CFFQuestionsViewController ()

@end

@implementation CFFQuestionsViewController{
    DataNasabahViewController* dataNasabahVC;
    AreaPotensialDiskusiViewController* areaPotensialDiskusiVC;
    
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *childView;

    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
}
@synthesize prospectProfileID,cffTransactionID;

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataNasabahVC = [[DataNasabahViewController alloc]initWithNibName:@"DataNasabahViewController" bundle:nil];
    areaPotensialDiskusiVC = [[AreaPotensialDiskusiViewController alloc]initWithNibName:@"AreaPotensialDiskusiViewController" bundle:nil];
    
    NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5", nil];
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Data Nasabah", @"Area Potensial Untuk Diskusi", @"Profil Resiko Nasabah", @"Analisa Kebutuhan Nasabah",@"Pernyataan Nasabah", nil];
    
    [self loadDataNasabahView];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataNasabahView{
    dataNasabahVC.prospectProfileID = prospectProfileID;
    dataNasabahVC.cffTransactionID  = cffTransactionID;
    if ([dataNasabahVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:dataNasabahVC.view];
    }
    else{
        [childView addSubview:dataNasabahVC.view];
    }
    
}

-(void)loadAreaPotensialDiskusiView{
    areaPotensialDiskusiVC.prospectProfileID = prospectProfileID;
    areaPotensialDiskusiVC.cffTransactionID  = cffTransactionID;
    if ([areaPotensialDiskusiVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:areaPotensialDiskusiVC.view];
    }
    else{
        [childView addSubview:areaPotensialDiskusiVC.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self loadDataNasabahView];
            break;
        case 1:
            [self loadAreaPotensialDiskusiView];
            break;
        default:
            break;
    }
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ListOfSubMenu.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SIMenuTableViewCell *cell = (SIMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UIView *bgColorView = [[UIView alloc] init];
    if (indexPath.row<5){
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    else{
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    
    bgColorView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.labelNumber setText:[NumberListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelWide setText:@""];
    
    [cell.button1 setEnabled:false];
    [cell.button2 setEnabled:false];
    [cell.button3 setEnabled:false];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
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
