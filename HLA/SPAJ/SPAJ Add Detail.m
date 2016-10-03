//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Add Detail.h"
#import "String.h"
#import "SPAJ Calon Pemegang Polis.h"
#import "SPAJ Calon Tertanggung.h"
#import "SPAJ Perusahaan.h"
#import "SPAJ Calon Penerima Manfaat.h"
#import "SPAJ Pembayaran Premi.h"
#import "ModelSPAJDetail.h"
#import "ModelSPAJHtml.h"
#import "SIMenuTableViewCell.h"
#import "Theme.h"
#import "User Interface.h"
#import "Formatter.h"
#import "ModelSPAJSignature.h"
#import "Alert.h"
#import "ModelSPAJTransaction.h"
#import "ModelSIPOData.h"
#import "ModelSPAJFormGeneration.h"
#import "AllAboutPDFGeneration.h"

// DECLARATION

@interface SPAJAddDetail ()<SPAJCalonPemegangPolisDelegate,SPAJCalonTertanggungDelegate,SPAJPerusahaanDelegate,SPAJCalonPenerimaManfaatDelegate,SPAJPembayaranPremiDelegate>



@end


// IMPLEMENTATION

@implementation SPAJAddDetail{
    UIAlertController *alertController;
    
    UIBarButtonItem* rightButton;
    
    AllAboutPDFGeneration *allAboutPDFGeneration;
    SPAJ_Calon_Pemegang_Polis* spajCalonPemegangPolis;
    SPAJ_Calon_Tertanggung* spajCalonTertanggung;
    SPAJ_Perusahaan* spajPerusahaan;
    SPAJ_Calon_Penerima_Manfaat* spajCalonPenerimaManfaat;
    SPAJ_Pembayaran_Premi* spajPembayaranPremi;
    Formatter *formatter;
    UserInterface *objectUserInterface;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    ModelSPAJDetail *modelSPAJDetail;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSIPOData* modelSIPData;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    Alert* alert;
    
    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
    
    int indexSelected;
    
    UIView *lastView;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolPerusahaan;
    BOOL boolPenerimaManfaat;
    BOOL boolPembayaranPremi;
    BOOL boolKesehatan;
    
    BOOL boolTenagaPenjualSigned;
}
@synthesize buttonCaptureBack,buttonCaptureFront;
@synthesize imageViewFront,imageViewBack;
@synthesize stringGlobalEAPPNumber;
@synthesize dictTransaction;


    -(void)viewDidAppear:(BOOL)animated{
        /*[_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:_tableSection didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];*/
        
    }

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        //INITIALIZATION
        objectUserInterface = [[UserInterface alloc] init];
        formatter = [[Formatter alloc]init];
        alert = [[Alert alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSIPData = [[ModelSIPOData alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
        
        [self setNavigationBar];
        
        spajCalonPemegangPolis = [[SPAJ_Calon_Pemegang_Polis alloc]initWithNibName:@"SPAJ Calon Pemegang Polis" bundle:nil];
        [spajCalonPemegangPolis setDelegate:self];
        
        spajCalonTertanggung = [[SPAJ_Calon_Tertanggung alloc]initWithNibName:@"SPAJ Calon Tertanggung" bundle:nil];
        [spajCalonTertanggung setDelegate:self];
        
        spajPerusahaan = [[SPAJ_Perusahaan alloc]initWithNibName:@"SPAJ Perusahaan" bundle:nil];
        [spajPerusahaan setDelegate:self];
        
        spajCalonPenerimaManfaat = [[SPAJ_Calon_Penerima_Manfaat alloc]initWithNibName:@"SPAJ Calon Penerima Manfaat" bundle:nil];
        [spajCalonPenerimaManfaat setDelegate:self];
        
        spajPembayaranPremi = [[SPAJ_Pembayaran_Premi alloc]initWithNibName:@"SPAJ Pembayaran Premi" bundle:nil];
        [spajPembayaranPremi setDelegate:self];
        
        modelSPAJHtml = [[ModelSPAJHtml alloc]init];
        modelSPAJDetail = [[ModelSPAJDetail alloc]init];
        
        [self loadSPAJCalonPemegangPolis];
        // LOCALIZATION
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER3", nil);
        
        _labelStep4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP4", nil);
        _labelHeader4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER4", nil);
        
        _labelStep5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP5", nil);
        _labelHeader5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER5", nil);
        
        _labelStep6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP6", nil);
        _labelHeader6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER6", nil);
        
        //ARRAY INITIALIZATION
        NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5",@"6", nil];
        ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis", @"Calon Tertanggung", @"Perusahaan / Berbadan Hukum", @"Calon Penerima Manfaat",@"Pembayaran Premi", @"Kesehatan", nil];
        
        boolPemegangPolis = false;
        boolTertanggung = false;
        boolPerusahaan = false;
        boolPenerimaManfaat = false;
        boolPembayaranPremi = false;
        boolKesehatan = false;
        [self voidCheckBooleanLastState];
        
        [self voidCreateRightBarButton];
    }

    -(void)voidCheckBooleanLastState {
        boolPemegangPolis = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail1"];
        boolTertanggung = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail2"];
        boolPerusahaan = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail3"];
        boolPenerimaManfaat = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail4"];
        boolPembayaranPremi = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail5"];
        boolKesehatan = [modelSPAJDetail voidCertainDetailCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] DetailParty:@"SPAJDetail6"] ;
        
        boolTenagaPenjualSigned = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty4"];
        [self voidTableCellLastStateChecker:boolPemegangPolis BOOLTR:boolTertanggung BOOLPR:boolPerusahaan BOOLPM:boolPenerimaManfaat BOOLPP:boolPembayaranPremi BOOLKS:boolKesehatan];
    }

    -(void)voidTableCellLastStateChecker:(BOOL)boolPO BOOLTR:(BOOL)boolTR BOOLPR:(BOOL)boolPR BOOLPM:(BOOL)boolPM BOOLPP:(BOOL)boolPP BOOLKS:(BOOL)boolKS{
        if (boolPO){
            if (boolTR){
                if (boolPR){
                    if (boolPM){
                        if (boolPP){
                            if (boolKS){
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                            else{
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        }
                    }
                    else{
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    }
                }
                else{
                    if (boolPM){
                        if (boolPP){
                            if (boolKS){
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                            else{
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        }
                    }
                    else{
                        //[self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    }
                }
            }
            else{
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            }
        }
        else{
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexSelected inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }


    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"Data Calon Pemegang Polis"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    -(void)voidCreateRightBarButton{
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Simpan" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(voidDoneSPAJCalonPemegangPolis:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    -(IBAction)actionRightBarButtonPressed:(UIBarButtonItem *)sender{
        if ([[spajCalonPemegangPolis.view.superview.subviews lastObject] isEqual: spajCalonPemegangPolis.view]){
            
        }
        else if ([[spajCalonTertanggung.view.superview.subviews lastObject] isEqual: spajCalonTertanggung.view]){
            
        }
        else if ([[spajPerusahaan.view.superview.subviews lastObject] isEqual: spajPerusahaan.view]){
            
        }
        else if ([[spajCalonPenerimaManfaat.view.superview.subviews lastObject] isEqual: spajCalonPenerimaManfaat.view]){
            
        }
        else if ([[spajPembayaranPremi.view.superview.subviews lastObject] isEqual: spajPembayaranPremi.view]){
            
            //[pernyataanNasabahVC voidDoneCFFData];
        }
    }



    // ACTION

    - (IBAction)actionGoToStep1:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO"];
        [spajCalonPemegangPolis setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonPemegangPolis];
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TR"];
        [spajCalonTertanggung setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonTertanggung];
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PR"];
        [spajPerusahaan setHtmlFileName:stringHTMLName];
        [self loadSPAJPerusahaan];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PM"];
        [spajCalonPenerimaManfaat setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonPenerimaManfaat];
    };

    - (IBAction)actionGoToStep5:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PP"];
        [spajPembayaranPremi setHtmlFileName:stringHTMLName];
        [self loadSPAJPembayaranPremi];
    };

    - (IBAction)actionGoToStep6:(id)sender
    {

    };

    - (IBAction)actionGoToStep7:(id)sender
    {
    
    };


    -(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
    {
        indexSelected=indexPath.row;
        [spajCalonPemegangPolis setDictTransaction:dictTransaction];
        switch (indexPath.row) {
            case 0:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO"];
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        [self.navigationItem setTitle:@"Data Calon Pemegang Polis"];
                        [spajCalonPemegangPolis setHtmlFileName:stringHTMLName];
                        //[self loadSPAJCalonPemegangPolis];
                        [spajCalonPemegangPolis loadFirstHTML:stringHTMLName PageSection:@"PO"];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    //NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO"];
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    [self.navigationItem setTitle:@"Data Calon Pemegang Polis"];
                    [spajCalonPemegangPolis setHtmlFileName:stringHTMLName];
                    //[self loadSPAJCalonPemegangPolis];
                    [spajCalonPemegangPolis loadFirstHTML:stringHTMLName PageSection:@"PO"];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    break;
                }
                break;
                
            }
            case 1:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TR" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        [spajCalonTertanggung setHtmlFileName:stringHTMLName];
                        [self.navigationItem setTitle:@"Data Calon Tertanggung"];
                        //[self loadSPAJCalonTertanggung];
                        [spajCalonPemegangPolis loadSecondHTML:stringHTMLName PageSection:@"TR"];
                        //[rightButton setAction:@selector(voidDoneSPAJCalonTertanggung:)];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TR" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    [spajCalonTertanggung setHtmlFileName:stringHTMLName];
                    [self.navigationItem setTitle:@"Data Calon Tertanggung"];
                    //[self loadSPAJCalonTertanggung];
                    [spajCalonPemegangPolis loadSecondHTML:stringHTMLName PageSection:@"TR"];
                    //[rightButton setAction:@selector(voidDoneSPAJCalonTertanggung:)];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                }
                break;
            }
            case 2:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PR" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        [spajPerusahaan setHtmlFileName:stringHTMLName];
                        [self.navigationItem setTitle:@"Data Perusahaan / Badan Hukum"];
                        //[self loadSPAJPerusahaan];
                        [spajCalonPemegangPolis loadThirdHTML:stringHTMLName PageSection:@"PR"];
                        //[rightButton setAction:@selector(voidDoneSPAJPerusahaan:)];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PR" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    [spajPerusahaan setHtmlFileName:stringHTMLName];
                    [self.navigationItem setTitle:@"Data Perusahaan / Badan Hukum"];
                    //[self loadSPAJPerusahaan];
                    [spajCalonPemegangPolis loadThirdHTML:stringHTMLName PageSection:@"PR"];
                    //[rightButton setAction:@selector(voidDoneSPAJPerusahaan:)];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                }
                break;
            }
            case 3:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PM" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        [spajCalonPenerimaManfaat setHtmlFileName:stringHTMLName];
                        [self.navigationItem setTitle:@"Data Calon Penerima Manfaat"];
                        //[self loadSPAJCalonPenerimaManfaat];
                        [spajCalonPemegangPolis loadFourthHTML:stringHTMLName PageSection:@"PM"];
                        //[rightButton setAction:@selector(voidDoneSPAJPenerimaManfaat:)];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PM" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    [spajCalonPenerimaManfaat setHtmlFileName:stringHTMLName];
                    [self.navigationItem setTitle:@"Data Calon Penerima Manfaat"];
                    //[self loadSPAJCalonPenerimaManfaat];
                    [spajCalonPemegangPolis loadFourthHTML:stringHTMLName PageSection:@"PM"];
                    //[rightButton setAction:@selector(voidDoneSPAJPenerimaManfaat:)];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                }
                break;
            }
            case 4:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        [spajPembayaranPremi setHtmlFileName:stringHTMLName];
                        [self.navigationItem setTitle:@"Data Pembayaran Premi"];
                        //[self loadSPAJPembayaranPremi];
                        [spajCalonPemegangPolis loadFivethHTML:stringHTMLName PageSection:@"PP"];
                        //[rightButton setAction:@selector(voidDoneSPAJPembayaranPremi:)];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PP" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    [spajPembayaranPremi setHtmlFileName:stringHTMLName];
                    [self.navigationItem setTitle:@"Data Pembayaran Premi"];
                    //[self loadSPAJPembayaranPremi];
                    [spajCalonPemegangPolis loadFivethHTML:stringHTMLName PageSection:@"PP"];
                    //[rightButton setAction:@selector(voidDoneSPAJPembayaranPremi:)];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                }
                break;
            }
            case 5:
            {
                NSString* flagEdited = [spajCalonPemegangPolis getStringFlagEdited];
                if ([allAboutPDFGeneration doesString:flagEdited containCharacter:@"true"]){
                    NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
                    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"KS_PH" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                        //[self loadSPAJPembayaranPremi];
                        [self.navigationItem setTitle:@"Data Kesehatan"];
                        [spajCalonPemegangPolis loadSixthHTML:stringHTMLName PageSection:@"KS_PH"];
                        //[rightButton setAction:@selector(voidDoneSPAJPembayaranPremi:)];
                        [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
                else{
                    NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"KS_PH" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
                    //[self loadSPAJPembayaranPremi];
                    [self.navigationItem setTitle:@"Data Kesehatan"];
                    [spajCalonPemegangPolis loadSixthHTML:stringHTMLName PageSection:@"KS_PH"];
                    //[rightButton setAction:@selector(voidDoneSPAJPembayaranPremi:)];
                    [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                }
                break;
            }
            default:
                break;
        }
    }

    #pragma mark UIBarButtonItem Action
    -(void)setRightButtonEnable:(BOOL)boolEnabled{
        [rightButton setEnabled:boolEnabled];
    }

    -(void)voidDoneSPAJCalonPemegangPolis:(UIBarButtonItem *)sender{
        if (!boolTenagaPenjualSigned){
            [spajCalonPemegangPolis voidDoneSPAJCalonPemegangPolis];
        }
        else{
            UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_LOCK", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_LOCK", nil)];
            [self presentViewController:alertLockForm animated:YES completion:nil];
        }
    }
    -(void)voidDoneSPAJCalonTertanggung:(UIBarButtonItem *)sender{
        [spajCalonTertanggung voidDoneSPAJCalonTertanggung];
    }
    -(void)voidDoneSPAJPerusahaan:(UIBarButtonItem *)sender{
        [spajPerusahaan voidDoneSPAJPerusahaan];
    }
    -(void)voidDoneSPAJPenerimaManfaat:(UIBarButtonItem *)sender{
        [spajCalonPenerimaManfaat voidDoneSPAJPenerimaManfaat];
    }

    -(void)voidDoneSPAJPembayaranPremi:(UIBarButtonItem *)sender{
        [spajPembayaranPremi voidDoneSPAJPembayaranPremi];
    }

    #pragma mark load view controller
    -(void)loadSPAJCalonPemegangPolis{
//        if ([spajCalonPemegangPolis.view isDescendantOfView:_viewContent]){
//            [_viewContent bringSubviewToFront:spajCalonPemegangPolis.view];
//        }
//        else{
            [_viewContent addSubview:spajCalonPemegangPolis.view];
            lastView = spajCalonPemegangPolis.view;
//        }
    }
    -(void)loadSPAJCalonTertanggung{
//        if ([spajCalonTertanggung.view isDescendantOfView:_viewContent]){
//            [_viewContent bringSubviewToFront:spajCalonTertanggung.view];
//        }
//        else{
            [spajCalonPemegangPolis.view removeFromSuperview];
            //[lastView removeFromSuperview];
            [_viewContent addSubview:spajCalonTertanggung.view];
            lastView = spajCalonTertanggung.view;
//        }
    }
    -(void)loadSPAJPerusahaan{
//        if ([spajPerusahaan.view isDescendantOfView:_viewContent]){
//            [_viewContent bringSubviewToFront:spajPerusahaan.view];
//        }
//        else{
            [spajCalonPemegangPolis.view removeFromSuperview];
            [spajCalonTertanggung.view removeFromSuperview];
            [_viewContent addSubview:spajPerusahaan.view];
            lastView = spajPerusahaan.view;
//        }
    }
    -(void)loadSPAJCalonPenerimaManfaat{
//        if ([spajCalonPenerimaManfaat.view isDescendantOfView:_viewContent]){
//            [_viewContent bringSubviewToFront:spajCalonPenerimaManfaat.view];
//        }
//        else{
            lastView = spajCalonPemegangPolis.view;
            [_viewContent addSubview:spajCalonPenerimaManfaat.view];
            lastView = spajCalonPenerimaManfaat.view;
//        }
    }
    -(void)loadSPAJPembayaranPremi{
//        if ([spajPembayaranPremi.view isDescendantOfView:_viewContent]){
//            [_viewContent bringSubviewToFront:spajPembayaranPremi.view];
//        }
//        else{
            [lastView removeFromSuperview];
            [_viewContent addSubview:spajPembayaranPremi.view];
            lastView = spajPembayaranPremi.view;
//        }
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
        //UIColor *selectedColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row<5){
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        [cell setSelectedBackgroundView:bgColorView];
        
        [cell.labelNumber setText:[NumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
        
        if (boolPemegangPolis){
            if (boolTertanggung){
                if (boolPerusahaan){
                    
                    if (boolPenerimaManfaat){
                        
                        if (boolPembayaranPremi){
                            
                            if (boolKesehatan){
                                if (indexPath.row < 6){
                                    [cell setUserInteractionEnabled:true];
                                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                                }
                                else{
                                    [cell setUserInteractionEnabled:false];
                                }
                            }
                            else{
                                if (indexPath.row < 6){
                                    [cell setUserInteractionEnabled:true];
                                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                                }
                                else{
                                    [cell setUserInteractionEnabled:false];
                                }
                            }
                            
                        }
                        
                        else{
                            if (indexPath.row < 5){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }
                    }
                    
                    else{
                        if (indexPath.row < 4){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                    }
                }
                
                else{
                    //perusahaan is not mandatory. so after tertanggung filled, then set perusahaan and calon penerima manfaat cell to active
                    //if (indexPath.row < 3){
                    if (boolPenerimaManfaat){
                        if (boolPembayaranPremi){
                            
                            if (boolKesehatan){
                                if (indexPath.row < 6){
                                    [cell setUserInteractionEnabled:true];
                                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                                }
                                else{
                                    [cell setUserInteractionEnabled:false];
                                }
                            }
                            else{
                                if (indexPath.row < 6){
                                    [cell setUserInteractionEnabled:true];
                                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                                }
                                else{
                                    [cell setUserInteractionEnabled:false];
                                }
                            }
                            
                        }
                        
                        else{
                            if (indexPath.row < 5){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }
                    }
                    else{
                        if (indexPath.row < 4){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                    }
                    
                }
            }
            else{
                if (indexPath.row < 2){
                    [cell setUserInteractionEnabled:true];
                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                }
                else{
                    [cell setUserInteractionEnabled:false];
                }
            }
        }
        else{
            if (indexPath.row < 1){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
        
        if (indexPath.row == 2){
            [cell setUserInteractionEnabled:false];
            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
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



#pragma mark crop function
    - (UIImage *)crop:(UIImage *)image {
        
        CGRect originalrect = imagePickerRect;
        CGSize frameSize = CGSizeMake(738,562.50);
        
        //float CalX=(originalrect.size.width-frameSize.width)/2;
        float CalX=15;
        //float CalY=(originalrect.size.height-frameSize.height)/2;
        float CalY=94;
        
        //CGRect frameRect = CGRectMake(CalX-55, CalY-55, frameSize.width, frameSize.height);
        CGRect frameRect = CGRectMake(CalX, CalY-74, frameSize.width, frameSize.height);
        //CGRect frameRect = CGRectMake(15, 94, frameSize.width, frameSize.height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self imageWithImage:image scaledToSize:CGSizeMake(512,360)].CGImage, frameRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
        UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(result, 0.7)];
        CGImageRelease(imageRef);
        //return lowResImage;
        return image;
    }

    -(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
    {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    }

#pragma mark delegate
    -(NSString *)voidGetEAPPNumber{
        //return stringGlobalEAPPNumber;
        return [dictTransaction valueForKey:@"SPAJEappNumber"];
    }

    -(void)voidSetCalonPemegangPolisBoolValidate:(BOOL)boolValidate StringSection:(NSString *)stringSection{
        [rightButton setEnabled:YES];
        BOOL boolSPAJPDF = [modelSPAJFormGeneration voidCertainFormGenerateCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] FormType:@"SPAJFormGeneration1"];
        if (boolSPAJPDF){
            //UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_FORM_GENERATION", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_FORM_GENERATION", nil)];
            
            UIAlertController *alertLockForm = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_FORM_GENERATION", nil) message:NSLocalizedString(@"ALERT_MESSAGE_FORM_GENERATION", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alertLockForm addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ([stringSection isEqualToString:@"KS_IN"]){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }]];

            [self presentViewController:alertLockForm animated:YES completion:nil];
            
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJFormGeneration1=0 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJFormGeneration updateSPAJFormGeneration:stringUpdate];
        }
        
        
        if ([stringSection isEqualToString:@"PO"]){
            [self.navigationItem setTitle:@"Data Calon Tertanggung"];
            //NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:1 inSection:0];
            //[self showDetailsForIndexPath:indexPathSelect];
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail1=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJDetail updateSPAJDetail:stringUpdate];
            //[_tableSection reloadData];
            //[_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self voidCheckBooleanLastState];
        }
        else if ([stringSection isEqualToString:@"TR"]){
            //[self voidSetCalonTertnggungBoolValidate:true];
            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail2=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
            [modelSPAJDetail updateSPAJDetail:stringUpdate];
            [self voidSetPerusahaanBoolValidate:true];
        }
        else if ([stringSection isEqualToString:@"PR"]){
            [self voidSetPerusahaanBoolValidate:true];
        }
        else if ([stringSection isEqualToString:@"PM"]){
            [self voidSetPenerimaManfaatBoolValidate:true];
        }
        else if ([stringSection isEqualToString:@"PP"]){
            [self voidSetPembayaranPremiBoolValidate:true];
        }
        else if ([stringSection isEqualToString:@"KS_PH"]){
            [self voidSetKesehatanBoolValidate:true];
        }
        else if ([stringSection isEqualToString:@"KS_IN"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateModified" StringColumnValue:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        
    }

    -(void)voidSetCalonTertnggungBoolValidate:(BOOL)boolValidate{
        [self.navigationItem setTitle:@"Data Perusahaan / Badan Hukum"];
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail2=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [modelSPAJDetail updateSPAJDetail:stringUpdate];
        //[_tableSection reloadData];
        //[_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self voidCheckBooleanLastState];
    }

    -(void)voidSetPerusahaanBoolValidate:(BOOL)boolValidate{
        //boolPenerimaManfaat = true;
        [self.navigationItem setTitle:@"Data Calon Penerima Manfaat"];
        //NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:3 inSection:0];
        //[self showDetailsForIndexPath:indexPathSelect];
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail3=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [modelSPAJDetail updateSPAJDetail:stringUpdate];
        //[_tableSection reloadData];
        //[_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self voidCheckBooleanLastState];
    }

    -(void)voidSetPenerimaManfaatBoolValidate:(BOOL)boolValidate{
        //boolPembayaranPremi = true;
        [self.navigationItem setTitle:@"Data Pembayaran Premi"];
        //NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:4 inSection:0];
        //[self showDetailsForIndexPath:indexPathSelect];
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail4=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [modelSPAJDetail updateSPAJDetail:stringUpdate];
        //[_tableSection reloadData];
        //[_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self voidCheckBooleanLastState];
    }

    -(void)voidSetPembayaranPremiBoolValidate:(BOOL)boolValidate{
        //boolKesehatan = true;
        [self.navigationItem setTitle:@"Data Kesehatan"];
        //NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:5 inSection:0];
        //[self showDetailsForIndexPath:indexPathSelect];
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail5=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [modelSPAJDetail updateSPAJDetail:stringUpdate];
        //[_tableSection reloadData];
        //[_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self voidCheckBooleanLastState];
    }

    -(void)voidSetKesehatanBoolValidate:(BOOL)boolValidate{
        boolKesehatan = true;
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJDetail6=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        [modelSPAJDetail updateSPAJDetail:stringUpdate];
        [self voidCheckBooleanLastState];
        //[self.navigationController popViewControllerAnimated:YES];
        
        NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:[dictTransaction valueForKey:@"SPAJSINO"]]];
        if ([[dictPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"KS_IN" SPAJID:[[dictTransaction valueForKey:@"SPAJID"] intValue]];
            [spajCalonPemegangPolis loadSeventhHTML:stringHTMLName PageSection:@"KS_IN"];
        }
    }
#pragma mark delegate image picker
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [self crop:originalimage];
        if (cameraFront){
            [imageViewFront setImage:image];
        }
        else{
            [imageViewBack setImage:image];
        }
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
        /*NSMutableDictionary *dic = [[_snapArr objectAtIndex:selectedRow]mutableCopy];
        if (snapMode== kFrontSnap) {
            [dic setObject:image forKey:@"frontSnap"];
            [_frontImageView setImage:image];
            _CheckView.hidden =YES;
            _CheckView1.hidden =YES;
        }
        else
        {
            [dic setObject:image forKey:@"backSnap"];
            [_backImageView setImage:image];
        }
        
        [_snapArr removeObjectAtIndex:selectedRow];
        [_snapArr insertObject:dic atIndex:selectedRow];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [_tableView reloadData];*/
        //    [self performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    }

// DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end