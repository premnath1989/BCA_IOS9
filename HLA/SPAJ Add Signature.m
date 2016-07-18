//
//  SPAJ Add Signature.m
//  BLESS
//
//  Created by Basvi on 7/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJ Add Signature.h"
#import "SIMenuTableViewCell.h"
#import "mySmoothLineView.h"

@interface SPAJ_Add_Signature (){
    IBOutlet UITableView *tablePartiesSignature;
    IBOutlet UIView *viewChild;
    
    IBOutlet UIView *viewBorder;
    IBOutlet mySmoothLineView *viewToSign;
}

@end

@implementation SPAJ_Add_Signature {
    NSMutableArray *mutableArrayNumberListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubTitleMenu;
    
    NSString *stringNamaPemegangPolis;
    NSString *stringNamaTertanggung;
    NSString *stringNamaOrangTuaWali;
    NSString *stringNamaTenagaPenjual;
    
    NSString *stringTableRow1;
    NSString *stringTableRow2;
    NSString *stringTableRow3;
    NSString *stringTableRow4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewBorder.layer.borderWidth=1.0;
    viewBorder.layer.borderColor=[UIColor blackColor].CGColor;
    [self voidArrayInitialization];
    // Do any additional setup after loading the view from its nib.
}

-(void)voidArrayInitialization{
    stringNamaPemegangPolis = @"Nama Pemegang Polis";
    stringNamaTertanggung = @"Nama Tertanggung";
    stringNamaOrangTuaWali = @"Nama Orang Tua Wali";
    stringNamaTenagaPenjual = @"Nama Tenaga Penjual";
    
    stringTableRow1 = [NSString stringWithFormat:@"Calon Pemegang Polis \r%@",stringNamaPemegangPolis];
    stringTableRow2 = [NSString stringWithFormat:@"Calon Tertanggung \r%@",stringNamaTertanggung];
    stringTableRow3 = [NSString stringWithFormat:@"Orang Tua / Wali yang sah \r%@",stringNamaOrangTuaWali];
    stringTableRow4 = [NSString stringWithFormat:@"Tenaga Penjual \r%@",stringNamaTenagaPenjual];
    
    mutableArrayNumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    mutableArrayListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis \r\r", @"Calon Tertanggung \r\r", @"Orang Tua / Wali yang sah \r\r", @"Tenaga Penjual \r\r", nil];
    mutableArrayListOfSubTitleMenu = [[NSMutableArray alloc] initWithObjects:stringNamaPemegangPolis, stringNamaTertanggung,stringNamaOrangTuaWali, stringNamaTenagaPenjual, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClearSign:(UIButton *)sender {
    [viewToSign clearView];
    //viewToSign.layer.sublayers = nil;
}


#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutableArrayListOfSubMenu.count;
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
    /*UIView *bgColorView = [[UIView alloc] init];
    if (indexPath.row<5){
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    else{
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    
    bgColorView.backgroundColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];*/
    //[cell setSelectedBackgroundView:bgColorView];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    [cell.labelSubtitle setHidden:NO];
    
    [cell.labelNumber setTextColor:[UIColor blackColor]];
    [cell.labelDesc setTextColor:[UIColor blackColor]];
    [cell.labelWide setTextColor:[UIColor blackColor]];
    [cell.labelSubtitle setTextColor:[UIColor blackColor]];
    
    [cell.labelNumber setText:[mutableArrayNumberListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelDesc setText:[mutableArrayListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelWide setText:@""];
    [cell.labelSubtitle setText:[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row]];
    
    [cell.button1 setEnabled:false];
    [cell.button2 setEnabled:false];
    [cell.button3 setEnabled:false];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self showDetailsForIndexPath:indexPath];
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
