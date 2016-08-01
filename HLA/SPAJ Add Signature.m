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
#import "Theme.h"
#import "User Interface.h"
#import "Formatter.h"
#import "ModelSPAJTransaction.h"
#import "ModelSIPOData.h"
#import "ModelSPAJSignature.h"

@interface SPAJ_Add_Signature (){
    IBOutlet UILabel *labelSignatureParty;
    IBOutlet UITableView *tablePartiesSignature;
    IBOutlet UIView *viewChild;
    
    IBOutlet UIView *viewBorder;
    IBOutlet mySmoothLineView *viewToSign;
    
    UIAlertController *alertController;
}

@end

@implementation SPAJ_Add_Signature {
    Formatter* formatter;
    UserInterface *objectUserInterface;
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSIPOData* modelSIPOData;
    ModelSPAJSignature* modelSPAJSignature;
    
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
    
    NSString *stringSignatureLocation;
    
    NSString* stringSIRelation;
    int LAAge;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolOrangTuaWali;
    BOOL boolTenagaPenjual;
}

@synthesize SPAJAddSignatureDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    formatter = [[Formatter alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    
    viewBorder.layer.borderWidth=1.0;
    viewBorder.layer.borderColor=[UIColor blackColor].CGColor;
    [self voidArrayInitialization];
    objectUserInterface = [[UserInterface alloc] init];
    
    boolPemegangPolis = true;
    boolTertanggung = false;
    boolOrangTuaWali = false;
    boolTenagaPenjual = false;
    
    [self initializeBooleanBasedOnTheRule];
    // Do any additional setup after loading the view from its nib.
}

-(void)initializeBooleanBasedOnTheRule{
    NSString* stringEAppNumber = [SPAJAddSignatureDelegate voidGetEAPPNumber];
    NSString* SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAppNumber];
    
    NSDictionary* dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
    stringSIRelation = [dictionaryPOData valueForKey:@"RelWithLA"];
    LAAge = [[dictionaryPOData valueForKey:@"LA_Age"] intValue];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
            labelSignatureParty.text = @"Tanda Tangan Pemegang Polis";
            break;
        case 1:
            labelSignatureParty.text = @"Tanda Tangan Calon Tertanggung";
            break;
        case 2:
            labelSignatureParty.text = @"Tanda Tangan Orang Tua/Wali";
            break;
        case 3:
            labelSignatureParty.text = @"Tanda Tangan Tenaga Penjual";
            break;
        default:
            break;
    }
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

- (void)voidCreateAlertTwoOptionViewAndShow:(NSString *)message tag:(int)alertTag{
    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self voidSavePOSignature];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self voidDismissAlertSignature];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)voidCreateAlertTextFieldViewAndShow:(NSString *)message tag:(int)alertTag{
    alertController=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Location";
    }];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   UITextField * textField = alertController.textFields.firstObject;
                                                   [self voidSaveSignatureLocation:textField.text];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}


- (IBAction)actionClearSign:(UIButton *)sender {
    [viewToSign clearView];
    //viewToSign.layer.sublayers = nil;
}

- (IBAction)actionCompleteSignature:(id)sender{
    if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
        if (boolTenagaPenjual && boolPemegangPolis){
            boolPemegangPolis = true;
            boolTertanggung = false;
            boolOrangTuaWali =  false;
            boolTenagaPenjual = true;
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
            //update signature party4
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
            [modelSPAJSignature updateSPAJSignature:stringUpdate];
        }
        else if (boolPemegangPolis){
            NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
            NSString *time = [formatter getDateToday:@"hh:mm"];
            NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
            [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
            return;
        }
    }
    else{
        if (LAAge<21){
            if (boolTenagaPenjual && boolOrangTuaWali && boolPemegangPolis){
                boolPemegangPolis = true;
                boolTertanggung = false;
                boolOrangTuaWali =  true;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                //update signature party4
                NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
                [modelSPAJSignature updateSPAJSignature:stringUpdate];
            }
            else if (boolOrangTuaWali && boolPemegangPolis){
                boolPemegangPolis = true;
                boolTertanggung = false;
                boolOrangTuaWali =  true;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                //update signature party3
                NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty3=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
                [modelSPAJSignature updateSPAJSignature:stringUpdate];
            }
            else if (boolPemegangPolis){
                NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
                NSString *time = [formatter getDateToday:@"hh:mm"];
                NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
                [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
                return;
            }
        }
        else{
            if (boolTenagaPenjual  && boolPemegangPolis && boolTertanggung){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  false;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                //update signature party4
                NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
                [modelSPAJSignature updateSPAJSignature:stringUpdate];
            }
            else if (boolPemegangPolis && boolTertanggung){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  false;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                //update signature party2
                NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty2=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
                [modelSPAJSignature updateSPAJSignature:stringUpdate];
            }
            else if (boolPemegangPolis){
                NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
                NSString *time = [formatter getDateToday:@"hh:mm"];
                NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
                [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
                return;
            }
        }
    }
    /*if (boolTenagaPenjual && boolOrangTuaWali && boolPemegangPolis && boolTertanggung){
        boolPemegangPolis = true;
        boolTertanggung = true;
        boolOrangTuaWali =  true;
        boolTenagaPenjual = true;
        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
    }
    else if (boolOrangTuaWali && boolPemegangPolis && boolTertanggung){
        boolPemegangPolis = true;
        boolTertanggung = true;
        boolOrangTuaWali =  true;
        boolTenagaPenjual = true;
        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    }
    else if (boolPemegangPolis && boolTertanggung){
        boolPemegangPolis = true;
        boolTertanggung = true;
        boolOrangTuaWali =  true;
        boolTenagaPenjual = false;
        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    }
    else if (boolPemegangPolis){
        NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
        NSString *time = [formatter getDateToday:@"hh:mm"];
        NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
        [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
        return;
    }*/
    [self actionClearSign:nil];
    [tablePartiesSignature reloadData];
}

-(void)voidSavePOSignature{
    if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
        boolPemegangPolis = true;
        boolTertanggung = false;
        boolOrangTuaWali =  false;
        boolTenagaPenjual = true;
        
        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    }
    else{
        if (LAAge<21){
            boolPemegangPolis = true;
            boolTertanggung = false;
            boolOrangTuaWali =  true;
            boolTenagaPenjual = false;
            
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        }
        else{
            boolPemegangPolis = true;
            boolTertanggung = true;
            boolOrangTuaWali =  false;
            boolTenagaPenjual = false;
            
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        }
    }
    [self actionClearSign:nil];
    [tablePartiesSignature reloadData];
    [alertController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty1=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
    [modelSPAJSignature updateSPAJSignature:stringUpdate];
    //update signature party1
}

-(void)voidDismissAlertSignature{
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

-(void)voidSaveSignatureLocation:(NSString *)stringSignatureLocationFromAlert{
    stringSignatureLocation = stringSignatureLocationFromAlert;
    [alertController dismissViewControllerAnimated:YES completion:nil];
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

    if (boolPemegangPolis){
        if (indexPath.row == 0){
            [cell setUserInteractionEnabled:true];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
        
        }
    }
    else{
        if (indexPath.row == 0){
            [cell setUserInteractionEnabled:false];
        }
        else{
            
        }
    }
    
    
    if (boolTertanggung){
        if (indexPath.row == 1){
            [cell setUserInteractionEnabled:true];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            
        }
    }
    else{
        if (indexPath.row == 1){
            [cell setUserInteractionEnabled:false];
        }
        else{
            
        }
    }
    
    if (boolOrangTuaWali){
        if (indexPath.row == 2){
            [cell setUserInteractionEnabled:true];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
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
    
    if (boolTenagaPenjual){
        if (indexPath.row == 3){
            [cell setUserInteractionEnabled:true];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
        }
        else{
            
        }
    }
    else{
        if (indexPath.row == 3){
            [cell setUserInteractionEnabled:false];
        }
        else{
            
        }
    }
    
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
