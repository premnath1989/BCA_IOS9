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
@synthesize dictTransaction;

- (void)viewDidLoad {
    [super viewDidLoad];
    formatter = [[Formatter alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSIPOData = [[ModelSIPOData alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    
    [self setNavigationBar];
    
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

-(void)setNavigationBar{
    [self.navigationItem setTitle:@"To Obtain e-Signatures From Respective Parties"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
}

-(void)initializeBooleanBasedOnTheRule{
    NSString* stringEAppNumber = [dictTransaction valueForKey:@"SPAJEappNumber"];//[SPAJAddSignatureDelegate voidGetEAPPNumber];
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self voidSaveSignatureToPDF:3];
            });
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self voidSaveSignatureToPDF:3];
                });
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self voidSaveSignatureToPDF:2];
                });
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self voidSaveSignatureToPDF:3];
                });
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
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self voidSaveSignatureToPDF:1];
                });
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
    //[self voidSaveSignatureToPDF:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self voidSaveSignatureToPDF:0];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self actionClearSign:nil];
        [tablePartiesSignature reloadData];
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJSignatureParty1=1 where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",[SPAJAddSignatureDelegate voidGetEAPPNumber]];
        [modelSPAJSignature updateSPAJSignature:stringUpdate];
        });
    });
    //update signature party1
}

-(void)voidSaveSignatureToPDF:(int)index{
    UIView *view = viewToSign;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* imageSignature = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawSignatureInPDF:imageSignature Index:index];
    });
}

-(void)drawSignatureInPDF:(UIImage *)signatureImage Index:(int)index{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self addSignature:signatureImage onPDFData:data Index:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self joinMultiplePDF];
        });
    });
}

-(void) addSignature:(UIImage *)imgSignature onPDFData:(NSData *)pdfData Index:(int)index{
    
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
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 4);
    pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(pdfContext, &pageRect);
    CGContextDrawPDFPage(pdfContext, page);
    
    // Draw the signature on pdfContext
    //pageRect = CGRectMake(343, 35,101 , 43);
    switch (index) {
        case 0:
            pageRect = CGRectMake(67, 1195,96 , 53);
            break;
        case 1:
            pageRect = CGRectMake(239, 1195,96 , 53);
            break;
        case 2:
            pageRect = CGRectMake(407, 1195,96 , 53);
            break;
        case 3:
            pageRect = CGRectMake(575, 1195,96 , 53);
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
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pdfFilePath =[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    [outputPDFData writeToFile:pdfFilePath atomically:YES];
}

-(void)joinMultiplePDF{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // File paths
    NSString* filePath = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSString *pdfPathOutput = filePath;
    
    // File URLs - bridge casting for ARC
    CFURLRef pdfURLFilePath = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)filePath];//(CFURLRef) NSURL
    CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath1];//(CFURLRef) NSURL
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
    
    // File references
    CGPDFDocumentRef pdfRefFilePath = CGPDFDocumentCreateWithURL((CFURLRef) pdfURLFilePath);
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
    
    
    // Number of pages
    NSInteger numberOfPagesFilePath = CGPDFDocumentGetNumberOfPages(pdfRefFilePath);
    NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
    
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    // Read the first PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPagesFilePath);
    for (int i=1; i<=numberOfPagesFilePath-1; i++) {
        page = CGPDFDocumentGetPage(pdfRefFilePath, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    for (int i=1; i<=numberOfPages1; i++) {
        page = CGPDFDocumentGetPage(pdfRef1, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    
    // Release from memory
    CFRelease(pdfURLFilePath);
    CFRelease(pdfURL1);
    
    CFRelease(pdfURLOutput);
    CGPDFDocumentRelease(pdfRefFilePath);
    CGPDFDocumentRelease(pdfRef1);
    
    CGContextRelease(writeContext);
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
