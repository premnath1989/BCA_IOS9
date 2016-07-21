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
#import "ProfilResikoViewController.h"
#import "AnalisaKebutuhanNasabahViewController.h"
#import "PernyataanNasabahViewController.h"
#import "ProspectProfile.h"
#import "ModelProspectProfile.h"
#import "ModelCFFHtml.h"
#import "ModelCFFAnswers.h"

@interface CFFQuestionsViewController ()<PernyataanNasabahViewControllerDelegate,AreaPotensialDiskusiViewControllerDelegate,ProfilResikoViewControllerDelegate,AnalisaKebutuhanNasabahViewControllerDelegate>{
    ModelProspectProfile* modelProspectProfile;
    ModelCFFHtml* modelCFFHtml;
    ModelCFFAnswers* modelCFFAnswers;
}

@end

@implementation CFFQuestionsViewController{
    DataNasabahViewController* dataNasabahVC;
    AreaPotensialDiskusiViewController* areaPotensialDiskusiVC;
    AnalisaKebutuhanNasabahViewController* analisaKebutuhanNasabahVC;
    ProfilResikoViewController* profilResikoVC;
    PernyataanNasabahViewController* pernyataanNasabahVC;
    
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *childView;
    UIBarButtonItem* rightButton;

    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
    
    BOOL boolDataNasabah;
    BOOL boolAreaPotensial;
    BOOL boolProfileRisk;
    BOOL boolAnalisaKebutuhanNasabah;
    BOOL boolProteksi;
    BOOL boolPensiun;
    BOOL boolPendidikan;
    BOOL boolWarisan;
    BOOL boolInvestasi;
    BOOL boolPernyataanNasabah;
}
@synthesize prospectProfileID,cffTransactionID,cffID,cffHeaderSelectedDictionary;

-(void)viewWillAppear:(BOOL)animated{
    ProspectProfile* pp;
    NSMutableArray *ProspectTableData = [modelProspectProfile searchProspectProfileByID:[prospectProfileID intValue]];
    pp = [ProspectTableData objectAtIndex:0];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Customer Fact Find Untuk %@",pp.ProspectName]];
    
    [self setBooleanValidationValue];
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    modelCFFHtml=[[ModelCFFHtml alloc]init];
    modelCFFAnswers=[[ModelCFFAnswers alloc]init];
    
    dataNasabahVC = [[DataNasabahViewController alloc]initWithNibName:@"DataNasabahViewController" bundle:nil];
    
    areaPotensialDiskusiVC = [[AreaPotensialDiskusiViewController alloc]initWithNibName:@"AreaPotensialDiskusiViewController" bundle:nil];
    areaPotensialDiskusiVC.delegate = self;
    
    profilResikoVC = [[ProfilResikoViewController alloc]initWithNibName:@"ProfilResikoViewController" bundle:nil];
    profilResikoVC.delegate = self;
    
    analisaKebutuhanNasabahVC = [[AnalisaKebutuhanNasabahViewController alloc]initWithNibName:@"AnalisaKebutuhanNasabahViewController" bundle:nil];
    analisaKebutuhanNasabahVC.delegate=self;
    
    pernyataanNasabahVC = [[PernyataanNasabahViewController alloc]initWithNibName:@"PernyataanNasabahViewController" bundle:nil];
    pernyataanNasabahVC.delegate = self;
    
    NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5", nil];
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Data Nasabah", @"Area Potensial Untuk Diskusi", @"Profil Resiko Nasabah", @"Analisa Kebutuhan Nasabah",@"Pernyataan Nasabah", nil];
    
    boolDataNasabah = true;
    boolAreaPotensial = false;
    boolProfileRisk = false;
    boolAnalisaKebutuhanNasabah = true;
    boolPernyataanNasabah = false;
    
    [self loadDataNasabahView];
    [self voidCreateRightBarButton];
    // Do any additional setup after loading the view from its nib.
}




-(void)voidCreateRightBarButton{
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(actionRightBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(IBAction)actionRightBarButtonPressed:(UIBarButtonItem *)sender{
    if ([[dataNasabahVC.view.superview.subviews lastObject] isEqual: dataNasabahVC.view]){
        NSLog(@"bisa ");
    }
    else if ([[areaPotensialDiskusiVC.view.superview.subviews lastObject] isEqual: areaPotensialDiskusiVC.view]){
        NSLog(@"bisa ");
    }
    else if ([[profilResikoVC.view.superview.subviews lastObject] isEqual: profilResikoVC.view]){
        NSLog(@"bisa ");
    }
    else if ([[analisaKebutuhanNasabahVC.view.superview.subviews lastObject] isEqual: analisaKebutuhanNasabahVC.view]){
        NSLog(@"bisa ");
    }
    else if ([[pernyataanNasabahVC.view.superview.subviews lastObject] isEqual: pernyataanNasabahVC.view]){
        NSLog(@"bisa ");
        [pernyataanNasabahVC voidDoneCFFData];
    }
}

#pragma mark UIBarButtonItem Action

-(void)voidDataNasabahDoneButton:(UIBarButtonItem *)sender{
    //[pernyataanNasabahVC voidDoneCFFData];
}
-(void)voidAreaPotensialDiskusiDoneButton:(UIBarButtonItem *)sender{
    [areaPotensialDiskusiVC voidDoneAreaPotential];
}
-(void)voidProfileRiskDoneButton:(UIBarButtonItem *)sender{
    [profilResikoVC voidDoneProfileRisk];
}
-(void)voidAnalisaKebutuhanNasabahDoneButton:(UIBarButtonItem *)sender{
    [analisaKebutuhanNasabahVC voidDoneAnalisaKebutuhanNasabah];
}

-(void)voidPernyataanNasabahDoneButton:(UIBarButtonItem *)sender{
    [pernyataanNasabahVC voidDoneCFFData];
}

#pragma mark load view controller
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
    cffID = [cffHeaderSelectedDictionary valueForKey:@"PotentialDiscussionCFFID"];
    NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"PD"];
    areaPotensialDiskusiVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:cffHeaderSelectedDictionary];
    areaPotensialDiskusiVC.prospectProfileID = prospectProfileID;
    areaPotensialDiskusiVC.cffTransactionID  = cffTransactionID;
    areaPotensialDiskusiVC.cffID = cffID;
    areaPotensialDiskusiVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
    if ([areaPotensialDiskusiVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:areaPotensialDiskusiVC.view];
    }
    else{
        [childView addSubview:areaPotensialDiskusiVC.view];
    }
}

-(void)loadProfilResikoNasabahView{
    cffID = [cffHeaderSelectedDictionary valueForKey:@"CustomerRiskCFFID"];
    NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"CR"];
    profilResikoVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:cffHeaderSelectedDictionary];
    profilResikoVC.prospectProfileID = prospectProfileID;
    profilResikoVC.cffTransactionID  = cffTransactionID;
    profilResikoVC.cffID = cffID;
    profilResikoVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
    //profilResikoVC.htmlFileName = @"index2.html";
    if ([profilResikoVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:profilResikoVC.view];
    }
    else{
        [childView addSubview:profilResikoVC.view];
    }
}

-(void)loadAnalisaKebutuhanNasabahView{
    analisaKebutuhanNasabahVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:cffHeaderSelectedDictionary];
    analisaKebutuhanNasabahVC.prospectProfileID = prospectProfileID;
    analisaKebutuhanNasabahVC.cffTransactionID  = cffTransactionID;
    analisaKebutuhanNasabahVC.cffID = cffID;
    if ([analisaKebutuhanNasabahVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:analisaKebutuhanNasabahVC.view];
    }
    else{
        [childView addSubview:analisaKebutuhanNasabahVC.view];
    }
}

-(void)loadPernyataanNasabahView{
    cffID = [cffHeaderSelectedDictionary valueForKey:@"CustomerStatementCFFID"];
    NSMutableArray *arrayHtml = [modelCFFHtml selectHtmlData:[cffID intValue] HtmlSection:@"CS"];
    pernyataanNasabahVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:cffHeaderSelectedDictionary];
    pernyataanNasabahVC.prospectProfileID = prospectProfileID;
    pernyataanNasabahVC.cffTransactionID  = cffTransactionID;
    pernyataanNasabahVC.cffID = cffID;
    pernyataanNasabahVC.htmlFileName = [[arrayHtml objectAtIndex:0]valueForKey:@"CFFHtmlName"];
    if ([pernyataanNasabahVC.view isDescendantOfView:childView]){
        [childView bringSubviewToFront:pernyataanNasabahVC.view];
    }
    else{
        [childView addSubview:pernyataanNasabahVC.view];
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
            [rightButton setTitle:@""];
            [rightButton setAction:@selector(voidDataNasabahDoneButton:)];
            break;
        case 1:
            [self loadAreaPotensialDiskusiView];
            [rightButton setTitle:@"Simpan"];
            [rightButton setAction:@selector(voidAreaPotensialDiskusiDoneButton:)];
            break;
        case 2:
            [self loadProfilResikoNasabahView];
            [rightButton setTitle:@"Simpan"];
            [rightButton setAction:@selector(voidProfileRiskDoneButton:)];
            break;
        case 3:
            [self loadAnalisaKebutuhanNasabahView];
            [rightButton setTitle:@"Simpan"];
            [rightButton setAction:@selector(voidAnalisaKebutuhanNasabahDoneButton:)];
            break;
        case 4:
            [self loadPernyataanNasabahView];
            [rightButton setTitle:@"Done"];
            [rightButton setAction:@selector(voidPernyataanNasabahDoneButton:)];
            break;
        default:
            break;
    }
}

-(bool)getValidation:(int)CFFTransactionID CFFSection:(NSString *)stringCFFSection{
    int countReturn;
    countReturn = [modelCFFAnswers getCFFAnswersCount:CFFTransactionID CFFSection:stringCFFSection];
    if (countReturn>0) {
        return true;
    }
    else{
        return false;
    }
}

-(void)setBooleanValidationValue{
    boolDataNasabah=true;
    boolAreaPotensial = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"PD"];
    boolProfileRisk = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"CR"];
    
    boolProteksi = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"PRT"];
    boolPensiun = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"PSN"];
    boolPendidikan = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"PND"];
    boolWarisan = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"WRS"];
    boolInvestasi = [self getValidation:[[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"] intValue] CFFSection:@"INV"];
    
    if ((boolProteksi)||(boolInvestasi)||(boolPensiun)||(boolPendidikan)||(boolWarisan)){
        boolAnalisaKebutuhanNasabah=true;
    }
    else{
        boolAnalisaKebutuhanNasabah=false;
    }
    
    if ((boolAreaPotensial)&&(boolProfileRisk)){
        boolPernyataanNasabah=true;
    }
    else{
        boolPernyataanNasabah=false;
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
    UIColor *selectedColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];
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
    
    bgColorView.backgroundColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.labelNumber setText:[NumberListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelWide setText:@""];
    
    if (boolDataNasabah){
        if (indexPath.row == 0){
            [cell setBackgroundColor:selectedColor];
        }
        else{
        
        }
    }
    if (boolAreaPotensial){
        if (indexPath.row == 1){
            [cell setBackgroundColor:selectedColor];
        }
        else if (indexPath.row == 2){
            [cell setUserInteractionEnabled:true];
        }
        else{
            
        }
    }
    else{
        if (indexPath.row == 2){
            [cell setUserInteractionEnabled:false];
        }
        else{
            
        }
    }
    
    if (boolProfileRisk){
        if (indexPath.row == 2){
            [cell setBackgroundColor:selectedColor];
        }
        else{
            
        }
    }
    if (boolAnalisaKebutuhanNasabah){
        if (indexPath.row == 3){
            [cell setBackgroundColor:selectedColor];
        }
        else{
            
        }
    }
    if (boolPernyataanNasabah){
        if (indexPath.row == 4){
            //[cell setBackgroundColor:selectedColor];
            [cell setUserInteractionEnabled:true];
        }
        else{
            
        }
    }
    else{
        if (indexPath.row == 4){
            [cell setUserInteractionEnabled:false];
        }
        else{
        
        }
    }
    
    [cell.button1 setEnabled:false];
    [cell.button2 setEnabled:false];
    [cell.button3 setEnabled:false];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

#pragma mark BOOL setter
-(void)voidSetAreaPotentialBoolValidate:(BOOL)boolValidate{
    [self setBooleanValidationValue];
    [myTableView reloadData];
    [self tableView:myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)voidSetProfileRiskBoolValidate:(BOOL)boolValidate{
    [self setBooleanValidationValue];
    [myTableView reloadData];
    [self tableView:myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)voidSetAnalisaKebutuhanNasabahBoolValidate:(BOOL)boolValidate{
    [self setBooleanValidationValue];
    [myTableView reloadData];
    [self tableView:myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

}

#pragma mark delegate
-(void)voidCompleteCFFData{
    [self.navigationController popViewControllerAnimated:YES];
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
