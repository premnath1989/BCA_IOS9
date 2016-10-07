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
#import "Alert.h"
#import "ModelAgentProfile.h"
#import "ModelProspectProfile.h"
#import "ClassImageProcessing.h"
#import "ModelSPAJHtml.h"
#import "AllAboutPDFGeneration.h"

@interface SPAJ_Add_Signature ()<PDFGenerationDelegate>{
    IBOutlet UILabel *labelSignatureFooter;
    IBOutlet UILabel *labelSignatureParty;
    IBOutlet UITableView *tablePartiesSignature;
    IBOutlet UIView *viewChild;
    
    IBOutlet UIView *viewBorder;
    IBOutlet mySmoothLineView *viewToSign;
    
    UIAlertController *alertController;
    Alert* alert;
}

@end

@implementation SPAJ_Add_Signature {
    Formatter* formatter;
    UserInterface *objectUserInterface;
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSIPOData* modelSIPOData;
    ModelSPAJSignature* modelSPAJSignature;
    ModelAgentProfile* modelAgentProfile;
    ModelProspectProfile* modelProspectProfile;
    ModelSPAJHtml* modelSPAJHtml;
    AllAboutPDFGeneration* allAboutPDFGeneration;
    ClassImageProcessing *classImageProcessing;
    
    NSDictionary* dictionaryPOData;
    
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
    
    int indexSelected;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolOrangTuaWali;
    BOOL boolTenagaPenjual;
}

@synthesize SPAJAddSignatureDelegate;
@synthesize dictTransaction;
@synthesize textFieldLocation,okAction;

-(void)viewWillAppear:(BOOL)animated{
    [self voidCreateDotInLine:viewBorder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dictionaryPOData = [[NSDictionary alloc]init];
    
    alert = [[Alert alloc]init];
    formatter = [[Formatter alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelAgentProfile=[[ModelAgentProfile alloc]init];
    modelProspectProfile = [[ModelProspectProfile alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
    allAboutPDFGeneration.delegatePDFGeneration = self;
    classImageProcessing = [[ClassImageProcessing alloc]init];
    
    [self setNavigationBar];

    boolPemegangPolis = false;
    boolTertanggung = false;
    boolOrangTuaWali = false;
    boolTenagaPenjual = false;
    
    [self initializeBooleanBasedOnTheRule];
    
    [self voidArrayInitialization];
    objectUserInterface = [[UserInterface alloc] init];
    
    [self voidCheckBooleanLastState];
    // Do any additional setup after loading the view from its nib.
}

-(void)setNavigationBar{
    [self.navigationItem setTitle:@"To Obtain e-Signatures From Respective Parties"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
}

-(void)initializeBooleanBasedOnTheRule{
    NSString* stringEAppNumber = [dictTransaction valueForKey:@"SPAJEappNumber"];//[SPAJAddSignatureDelegate voidGetEAPPNumber];
    NSString* SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAppNumber];
    
    dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
    stringSIRelation = [dictionaryPOData valueForKey:@"RelWithLA"];
    LAAge = [[dictionaryPOData valueForKey:@"LA_Age"] intValue];
}

-(void)voidCheckBooleanLastState {
    boolPemegangPolis = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty1"];
    boolTertanggung = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty2"];
    boolOrangTuaWali = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty3"];
    boolTenagaPenjual = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty4"];
    
    [self voidTableCellLastStateChecker:boolPemegangPolis BOOLTR:boolTertanggung BOOLOW:boolOrangTuaWali BOOLTP:boolTenagaPenjual];
}

-(void)voidTableCellLastStateChecker:(BOOL)boolPO BOOLTR:(BOOL)boolTR BOOLOW:(BOOL)boolOW BOOLTP:(BOOL)boolTP{
    if (boolPO){
        if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        }
        else{
            if (LAAge<21){
                if (boolOW){
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                }
                else{
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                }
            }
            else{
                if (boolTR){
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                }
                else{
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                }
            }
        }
    }
    else{
        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    [tablePartiesSignature selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexSelected inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

    
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    indexSelected = indexPath.row;
    NSString* dateNow = [formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
    
    switch (indexPath.row) {
        case 0:
        {
            labelSignatureParty.text = @"Tanda Tangan Pemegang Polis";
            NSString* stringIDNumber = [modelProspectProfile selectProspectData:@"OtherIDTypeNo" ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]]?:@"";
            [labelSignatureFooter setText:[NSString stringWithFormat:@"%@/%@/%@",[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row],stringIDNumber,dateNow]];
            break;
        }
        case 1:
        {
            labelSignatureParty.text = @"Tanda Tangan Calon Tertanggung";
            NSString* stringIDNumber = [modelProspectProfile selectProspectData:@"OtherIDTypeNo" ProspectIndex:[[dictionaryPOData valueForKey:@"LA_ClientID"] intValue]]?:@"";
            [labelSignatureFooter setText:[NSString stringWithFormat:@"%@/%@/%@",[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row],stringIDNumber,dateNow]];
            break;
        }
        case 2:
        {
            labelSignatureParty.text = @"Tanda Tangan Orang Tua/Wali";
            [labelSignatureFooter setText:[NSString stringWithFormat:@"%@/%@/%@",[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row],@"-",dateNow]];
            break;
        }
        case 3:
        {
            labelSignatureParty.text = @"Tanda Tangan Tenaga Penjual";
            [labelSignatureFooter setText:[NSString stringWithFormat:@"%@/%@/%@",[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row],@"-",dateNow]];
            break;
        }
        default:
            break;
    }
}

-(void)voidArrayInitialization{
    NSDictionary *dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    NSString* AgentName = [dictionaryForAgentProfile valueForKey:@"AgentName"];
    
    stringNamaPemegangPolis = [dictionaryPOData valueForKey:@"PO_Name"]?:@"";
    stringNamaTertanggung = [dictionaryPOData valueForKey:@"LA_Name"]?:@"";
    stringNamaOrangTuaWali = @"-";
    stringNamaTenagaPenjual = AgentName?:@"";
    
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
        //textField.delegate = self;
        textField.placeholder = @"Location";
        textFieldLocation = textField;
        [textField addTarget:self action:@selector(alertControllerTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   UITextField * textField = alertController.textFields.firstObject;
                                                       [self voidSaveSignatureLocation:textField.text];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    okAction.enabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)alertControllerTextFieldDidChange:(UITextField *)sender {
    UIAlertController *alertControllerLocation = (UIAlertController *)self.presentedViewController;
    if (alertControllerLocation) {
        UITextField *someTextField = alertControllerLocation.textFields.firstObject;
        //UIAlertAction *okActionNew = alertControllerLocation.actions.lastObject;
        okAction.enabled = someTextField.text.length > 0;
    }
}

-(void)voidCreateDotInLine:(UIView *)sender {
    CGFloat lineWidth = sender.frame.size.width;
    CGFloat dotWidth = 5;
    int numberOfDot = (lineWidth/2);
    int xStart=0;
    for (int i=0;i<numberOfDot;i++){
        UIView* viewDot = [[UIView alloc]initWithFrame:CGRectMake(xStart, 0, dotWidth, 1)];
        [viewDot setBackgroundColor:[UIColor blackColor]];
        [sender addSubview:viewDot];
        xStart = dotWidth * i * 2;
    }
}


- (IBAction)actionClearSign:(UIButton *)sender {
    [viewToSign clearView];
    //viewToSign.layer.sublayers = nil;
}

- (IBAction)actionCompleteSignature:(id)sender{
    if (!boolTenagaPenjual){
        if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
            //if (boolTenagaPenjual && boolPemegangPolis){
            if (indexSelected == 3){
                /*NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self voidSaveSignatureToPDF:3];
                });
                [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                //update signature party4
                NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
                NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1,SPAJDateSignatureParty4='%@',SPAJSignatureTempImageParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                [modelSPAJSignature updateSPAJSignature:stringUpdate];
                [modelSPAJTransaction updateSPAJTransaction:@"SPAJCompleteness" StringColumnValue:@"Lengkap" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];*/
                [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                [self voidCheckBooleanLastState];
                return;
            }
            else if (indexSelected==2){
            
            }
            else if (indexSelected == 1){
            
            }
            //else if (boolPemegangPolis){
            else if (indexSelected == 0){
                //NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
                //NSString *time = [formatter getDateToday:@"hh:mm"];
                NSString* date = [formatter getDateTodayByAddingDays:@"dd-MM-yyyy" DaysAdded:30];
                NSString* time = [formatter getDateTodayByAddingDays:@"HH:mm" DaysAdded:30];
                NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
                [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
                return;
            }
        }
        else{
            if (LAAge<21){
                //if (boolTenagaPenjual && boolOrangTuaWali && boolPemegangPolis){
                if (indexSelected == 3){
                    [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                    /*NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self voidSaveSignatureToPDF:3];
                    });
                    [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                    //update signature party4
                    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1,SPAJDateSignatureParty4='%@',SPAJSignatureTempImageParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                    [modelSPAJSignature updateSPAJSignature:stringUpdate];
                    [modelSPAJTransaction updateSPAJTransaction:@"SPAJCompleteness" StringColumnValue:@"Lengkap" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];*/
                    [self voidCheckBooleanLastState];
                    return;
                }
                //else if (boolOrangTuaWali && boolPemegangPolis){
                else if (indexSelected == 2){
                    NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
                        [self voidSaveSignatureToPDF:2];
                    });
                    //update signature party3
                    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty3=1,SPAJDateSignatureParty3='%@',SPAJSignatureTempImageParty3='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                    [modelSPAJSignature updateSPAJSignature:stringUpdate];
                    [self voidCheckBooleanLastState];
                }
                else if (indexSelected == 1){
                
                }
                //else if (boolPemegangPolis){
                else if (indexSelected == 0){
                    //NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
                    //NSString *time = [formatter getDateToday:@"hh:mm"];
                    NSString* date = [formatter getDateTodayByAddingDays:@"dd-MM-yyyy" DaysAdded:30];
                    NSString* time = [formatter getDateTodayByAddingDays:@"HH:mm" DaysAdded:30];
                    NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
                    [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
                    return;
                }
            }
            else{
                //if (boolTenagaPenjual  && boolPemegangPolis && boolTertanggung){
                if (indexSelected == 3){
                    [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                    /*NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self voidSaveSignatureToPDF:3];
                    });
                    [self voidCreateAlertTextFieldViewAndShow:@"Masukkan lokasi pengambilan tanda tangan" tag:0];
                    //update signature party4
                    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty4=1,SPAJDateSignatureParty4='%@',SPAJSignatureTempImageParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                    [modelSPAJSignature updateSPAJSignature:stringUpdate];
                    [modelSPAJTransaction updateSPAJTransaction:@"SPAJCompleteness" StringColumnValue:@"Lengkap" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];*/
                    [self voidCheckBooleanLastState];
                    return;
                }
                else if (indexSelected == 2){}
                //else if (boolPemegangPolis && boolTertanggung){
                else if (indexSelected == 1){
                    NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
                        [self voidSaveSignatureToPDF:1];
                    });
                    //update signature party2
                    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty2=1,SPAJDateSignatureParty2='%@',SPAJSignatureTempImageParty2='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                    [modelSPAJSignature updateSPAJSignature:stringUpdate];
                    [self voidCheckBooleanLastState];
                }
                //else if (boolPemegangPolis){
                else if (indexSelected == 0){
                    //NSString *date = [formatter getDateToday:@"dd/MM/yyyy"];
                    //NSString *time = [formatter getDateToday:@"hh:mm"];
                    NSString* date = [formatter getDateTodayByAddingDays:@"dd-MM-yyyy" DaysAdded:30];
                    NSString* time = [formatter getDateTodayByAddingDays:@"HH:mm" DaysAdded:30];
                    NSString* alertString = [NSString stringWithFormat:@"Mohon agar menandatangani aplikasi dengan benar dan menyerahkannya sebelum tanggal (%@) dan waktu (%@ WIB). Jika tidak maka aplikasi ini akan menjadi tidak valid.\n\nTidak diperbolehkan adanya perubahan data pada aplikasi setelah Anda menyimpannya.\nApakah Anda yakin ingin menyimpan ?",date,time];
                    [self voidCreateAlertTwoOptionViewAndShow:alertString tag:0];
                    return;
                }
            }
        }
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateModified" StringColumnValue:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [self actionClearSign:nil];
        [tablePartiesSignature reloadData];
    }
    else{
        UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_LOCK", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_LOCK", nil)];
        [self presentViewController:alertLockForm animated:YES completion:nil];
    }
}

-(void)voidSavePOSignature{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
            
    //[self voidSaveSignatureForImages];
    [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
    [self voidSaveSignatureToPDF:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self actionClearSign:nil];
            [tablePartiesSignature reloadData];
            [alertController dismissViewControllerAnimated:YES completion:nil];
            NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty1=1,SPAJDateSignatureParty1='%@',SPAJSignatureTempImageParty1='%@'  where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJSignature updateSPAJSignature:stringUpdate];
            
            NSString* dateExpired = [formatter getDateTodayByAddingDays:@"yyyy-MM-dd HH:mm:ss" DaysAdded:30];
            [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateExpired" StringColumnValue:dateExpired StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
            
            [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateModified" StringColumnValue:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
            
            [self voidCheckBooleanLastState];
        });
    });
}

-(void)voidSaveSignatureToPDF:(int)index{
    UIView *view = viewToSign;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* imageSignature = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted = [classImageProcessing changeColor:imageSignature fromColor:fromColor toColor:toColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawSignatureInPDF:imageConverted Index:index];
    });
}



-(void)drawSignatureInPDF:(UIImage *)signatureImage Index:(int)index{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self addSignature:signatureImage onPDFData:data Index:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self joinMultiplePDF:index];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeSPAJSigned];
                    });
                });
            });
        });
    }
}

-(void) addSignatureForPage1:(UIImage *)imgSignature onPDFData:(NSData *)pdfData Index:(int)index{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pdfFilePathPage1 =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];

    NSMutableData* outputPDFDataPage1 = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumerPage1 = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFDataPage1);

    CFMutableDictionaryRef attrDictionaryPage1 = NULL;
    attrDictionaryPage1 = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionaryPage1, kCGPDFContextTitle, CFSTR("My Doc"));
    CGContextRef pdfContextPage1 = CGPDFContextCreate(dataConsumerPage1, NULL, attrDictionaryPage1);
    CFRelease(dataConsumerPage1);
    CFRelease(attrDictionaryPage1);
    CGRect pageRectPage1;

    // Draw the old "pdfData" on pdfContext
    CFDataRef myPDFDataPage1 = (__bridge CFDataRef) pdfData;
    CGDataProviderRef providerPage1 = CGDataProviderCreateWithCFData(myPDFDataPage1);
    CGPDFDocumentRef pdfPage1 = CGPDFDocumentCreateWithProvider(providerPage1);
    CGDataProviderRelease(providerPage1);
    CGPDFPageRef pagePage1 = CGPDFDocumentGetPage(pdfPage1, 1);
    pageRectPage1 = CGPDFPageGetBoxRect(pagePage1, kCGPDFMediaBox);
    CGContextBeginPage(pdfContextPage1, &pageRectPage1);
    CGContextDrawPDFPage(pdfContextPage1, pagePage1);

    // Draw the signature on pdfContext
    //pageRect = CGRectMake(343, 35,101 , 43);
    pageRectPage1 = CGRectMake(617, 435,80, 37);
    CGImageRef pageImagePage1 = [imgSignature CGImage];
    CGContextDrawImage(pdfContextPage1, pageRectPage1, pageImagePage1);

    // release the allocated memory
    CGPDFContextEndPage(pdfContextPage1);
    CGPDFContextClose(pdfContextPage1);
    CGContextRelease(pdfContextPage1);

    // write new PDFData in "outPutPDF.pdf" file in document directory
    [outputPDFDataPage1 writeToFile:pdfFilePathPage1 atomically:YES];
}

-(void) addSignatureForPage9:(UIImage *)imgSignature onPDFData:(NSData *)pdfData Index:(int)index{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pdfFilePathPage1 =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSMutableData* outputPDFDataPage1 = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumerPage1 = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFDataPage1);
    
    CFMutableDictionaryRef attrDictionaryPage1 = NULL;
    attrDictionaryPage1 = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionaryPage1, kCGPDFContextTitle, CFSTR("My Doc"));
    CGContextRef pdfContextPage1 = CGPDFContextCreate(dataConsumerPage1, NULL, attrDictionaryPage1);
    CFRelease(dataConsumerPage1);
    CFRelease(attrDictionaryPage1);
    CGRect pageRectPage1;
    
    // Draw the old "pdfData" on pdfContext
    CFDataRef myPDFDataPage1 = (__bridge CFDataRef) pdfData;
    CGDataProviderRef providerPage1 = CGDataProviderCreateWithCFData(myPDFDataPage1);
    CGPDFDocumentRef pdfPage1 = CGPDFDocumentCreateWithProvider(providerPage1);
    CGDataProviderRelease(providerPage1);
    CGPDFPageRef pagePage1 = CGPDFDocumentGetPage(pdfPage1, 9);
    pageRectPage1 = CGPDFPageGetBoxRect(pagePage1, kCGPDFMediaBox);
    CGContextBeginPage(pdfContextPage1, &pageRectPage1);
    CGContextDrawPDFPage(pdfContextPage1, pagePage1);
    
    // Draw the signature on pdfContext
    //pageRect = CGRectMake(343, 35,101 , 43);
    if (index == 0){
        pageRectPage1 = CGRectMake(67, 476,96 , 53);
    }
    else{
        pageRectPage1 = CGRectMake(575, 476,96 , 53);
    }
    
    CGImageRef pageImagePage1 = [imgSignature CGImage];
    CGContextDrawImage(pdfContextPage1, pageRectPage1, pageImagePage1);
    
    // release the allocated memory
    CGPDFContextEndPage(pdfContextPage1);
    CGPDFContextClose(pdfContextPage1);
    CGContextRelease(pdfContextPage1);
    
    // write new PDFData in "outPutPDF.pdf" file in document directory
    [outputPDFDataPage1 writeToFile:pdfFilePathPage1 atomically:YES];
}

-(void) addSignature:(UIImage *)imgSignature onPDFData:(NSData *)pdfData Index:(int)index{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pdfFilePath =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSMutableData* outputPDFData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputPDFData);
    
    CFMutableDictionaryRef attrDictionary = NULL;
    attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, CFSTR("My Doc"));
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
    CFRelease(dataConsumer);
    CFRelease(attrDictionary);
    CGRect pageRect;
    
    // Draw the old "pdfData" on pdfContext
    CFDataRef myPDFData = (__bridge CFDataRef) pdfData;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
    CGDataProviderRelease(provider);
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 8);
    pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(pdfContext, &pageRect);
    CGContextDrawPDFPage(pdfContext, page);
    
    // Draw the signature on pdfContext
    //pageRect = CGRectMake(343, 35,101 , 43);
    switch (index) {
        case 0:
            pageRect = CGRectMake(67, 486,96 , 53);
            [self addSignatureForPage1:imgSignature onPDFData:pdfData Index:index];
            [self addSignatureForPage9:imgSignature onPDFData:pdfData Index:index];
            break;
        case 1:
            pageRect = CGRectMake(239, 486,96 , 53);
            break;
        case 2:
            pageRect = CGRectMake(407, 486,96 , 53);
            break;
        case 3:
            pageRect = CGRectMake(575, 486,96 , 53);
            [self addSignatureForPage9:imgSignature onPDFData:pdfData Index:index];
            break;
            
        default:
            break;
    }
    
    CGImageRef pageImage = [imgSignature CGImage];
    CGContextDrawImage(pdfContext, pageRect, pageImage);
    
    // release the allocated memory
    CGPDFContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    CGContextRelease(pdfContext);
    
    // write new PDFData in "outPutPDF.pdf" file in document directory
    [outputPDFData writeToFile:pdfFilePath atomically:YES];
}

-(void)joinMultiplePDF:(int)indexParty{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // File paths
    NSString* filePath = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage9 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSString *pdfPathOutput = filePath;
    
    // File URLs - bridge casting for ARC
    CFURLRef pdfURLFilePath = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)filePath];//(CFURLRef) NSURL
    CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath1];//(CFURLRef) NSURL
    CFURLRef pdfURLPage1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathPage1];//(CFURLRef)
    CFURLRef pdfURLPage9 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathPage9];//(CFURLRef)
    
    //NSURL
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
    
    // File references
    CGPDFDocumentRef pdfRefFilePath = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLFilePath);
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
    CGPDFDocumentRef pdfRefPage1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLPage1);
    CGPDFDocumentRef pdfRefPage9 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLPage9);
    
    // Number of pages
    NSInteger numberOfPagesFilePath = CGPDFDocumentGetNumberOfPages(pdfRefFilePath);
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    // Read the first PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPagesFilePath);
    //for (int i=1; i<=numberOfPagesFilePath-1; i++) {
    if (indexParty == 0){
        page = CGPDFDocumentGetPage(pdfRefPage1, 1);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
        
        for (int i=2; i<=numberOfPagesFilePath-2; i++) {
            page = CGPDFDocumentGetPage(pdfRefFilePath, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
    }
    else{
        for (int i=1; i<=numberOfPagesFilePath-2; i++) {
            page = CGPDFDocumentGetPage(pdfRefFilePath, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
    }
    
    page = CGPDFDocumentGetPage(pdfRef1, 1);
    mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(writeContext, &mediaBox);
    CGContextDrawPDFPage(writeContext, page);
    CGContextEndPage(writeContext);
    
    if ((indexParty==0)||(indexParty==3)){
        page = CGPDFDocumentGetPage(pdfRefPage9, 1);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    else{
        page = CGPDFDocumentGetPage(pdfRefFilePath, 9);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    
    // Release from memory
    CFRelease(pdfURLFilePath);
    //CFRelease(pdfURL1);
    
    CFRelease(pdfURLOutput);
    CGPDFDocumentRelease(pdfRefFilePath);
    //CGPDFDocumentRelease(pdfRef1);
    
    CGContextRelease(writeContext);
}

-(void)removeSPAJSigned{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // File paths
    NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:pdfPath1 error:&error];
    BOOL successPage1 = [fileManager removeItemAtPath:pdfPathPage1 error:&error];
    if (success) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    if (successPage1) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}


-(void)voidDismissAlertSignature{
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

-(void)voidSaveSignatureLocation:(NSString *)stringSignatureLocationFromAlert{
    stringSignatureLocation = stringSignatureLocationFromAlert;
    NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureLocation='%@'  where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringSignatureLocation,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    [modelSPAJSignature updateSPAJSignature:stringUpdate];
    
    [modelSPAJTransaction updateSPAJTransaction:@"SPAJCompleteness" StringColumnValue:@"Lengkap" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
    
    //update signature party4
    [allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[allAboutPDFGeneration voidSaveSignatureForImages:dictTransaction DictionaryPOData:dictionaryPOData];
        [self voidSaveSignatureToPDF:3];
    });

    NSString* signatureImage = [formatter encodedSignatureImage:viewToSign];
    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringUpdateSignature = [NSString stringWithFormat:@" set SPAJSignatureParty4=1,SPAJDateSignatureParty4='%@',SPAJSignatureTempImageParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",dateToday,signatureImage,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    [modelSPAJSignature updateSPAJSignature:stringUpdateSignature];
    
    //[modelSPAJTransaction updateSPAJTransaction:@"SPAJCompleteness" StringColumnValue:@"Lengkap" StringWhereName:@"SPAJTransactionID" StringWhereValue:[dictTransaction valueForKey:@"SPAJTransactionID"]];
    
    
    [alertController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)voidSaveSignatureForImages{
    NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    
    NSData* imageParty1=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty1 options:0];;
    NSData* imageParty2=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty2 options:0];;
    NSData* imageParty3=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty3 options:0];;
    NSData* imageParty4=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty4 options:0];;
    
    UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
    UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
    UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
    UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
    
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
    
    NSMutableArray *arrayIMGName;
    NSMutableArray *arrayPureIMGName = [[NSMutableArray alloc]init];
    if ([[dictionaryPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH"]];
    }
    else{
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_IN"]];
    }
    
    for (int i=0;i<[arrayIMGName count];i++){
        NSString *pureName = [allAboutPDFGeneration getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:i]];
        [arrayPureIMGName addObject:pureName];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int x=0;x<[arrayPureIMGName count];x++){
            [self saveSignatureForImage:imageConverted1 ImageSigned2:imageConverted2 ImageSigned3:imageConverted3 ImageSigned4:imageConverted4 FileName:[arrayPureIMGName objectAtIndex:x]];
        }
    });
}


-(void)saveSignatureForImage:(UIImage *)imageSigned1 ImageSigned2:(UIImage *)imageSigned2 ImageSigned3:(UIImage *)imageSigned3 ImageSigned4:(UIImage *)imageSigned4 FileName:(NSString *)stringFileName{
    
    NSString *mainFileName = [NSString stringWithFormat:@"%@_%@.jpg",[dictTransaction valueForKey:@"SPAJEappNumber"],stringFileName];
    NSString *fullpath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    fullpath = [NSString stringWithFormat:@"%@/%@",fullpath,mainFileName];
    
    UIImage *baseImage = [UIImage imageWithContentsOfFile:fullpath];
    if ([stringFileName rangeOfString:@"amandment"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(360,  2150, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(960, 2150, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 2150, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1560, 2150, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
        
    }
    else if ([stringFileName rangeOfString:@"chestpain"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"diabetes"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"digestion"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"epilepsy"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"hypertension"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"respiratory"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"tumor"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"diving"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"oilgas"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"military"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"flight"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [allAboutPDFGeneration generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else {
        NSLog(@"string contains bla!");
    }
};

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
    if (indexPath.row<3){
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    else{
        [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
    [cell setSelectedBackgroundView:bgColorView];

    [cell.labelSubtitle setHidden:NO];
    
    
    [cell.labelNumber setText:[mutableArrayNumberListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelDesc setText:[mutableArrayListOfSubMenu objectAtIndex:indexPath.row]];
    [cell.labelWide setText:@""];
    [cell.labelSubtitle setText:[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row]];
    
    [cell.button1 setEnabled:false];
    [cell.button2 setEnabled:false];
    [cell.button3 setEnabled:false];
    
    if (boolPemegangPolis){
        if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
            if ((indexPath.row == 0)||(indexPath.row == 3)){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
        else{
            if (LAAge<21){
                if (boolOrangTuaWali){
                    if ((indexPath.row == 0)||(indexPath.row == 2)||(indexPath.row == 3)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }
                else{
                    if ((indexPath.row == 0)||(indexPath.row == 2)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }
            }
            else{
                if (boolTertanggung){
                    if ((indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 3)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }
                else{
                    if ((indexPath.row == 0)||(indexPath.row == 1)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }
            }
        }
    }
    else{
        if (indexPath.row == 0){
            [cell setUserInteractionEnabled:true];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
        }
        else{
            [cell setUserInteractionEnabled:false];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

#pragma mark delegate
-(void)imgSigned{

}

-(void)allImgSigned{

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
