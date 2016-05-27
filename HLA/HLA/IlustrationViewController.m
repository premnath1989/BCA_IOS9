//
//  IlustrationViewController.m
//  BLESS
//
//  Created by Basvi on 3/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//
#define kPaperSizeA4 CGSizeMake(842,595)

#import "IlustrationViewController.h"
#import "ProspectProfile.h"
#import "ModelProspectProfile.h"

@interface IlustrationViewController (){
    int page;
    bool pdfCreated;
    ModelProspectProfile *modelProspectProfile;
    
    BOOL pdfNeedToLoad;
    NSDictionary* dictMDBKK;
    NSDictionary* dictMBKK;
    NSDictionary* dictBebasPremi;
    
    double mdbkk;
    double mdbkkExtra;
    double bp;
    double bpExtra;
    
    double premiStandard;
    double extraPremi;
    double totalDibayar;
}

@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

@implementation IlustrationViewController
@synthesize navigationBar;

-(void)viewWillAppear:(BOOL)animated{
    [webIlustration setHidden:YES];
    [viewspinBar setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    page =1;
    pdfCreated=false;
    if ([[_dictionaryForBasicPlan valueForKey:@"ProductCode"] isEqualToString:@"BCAKK"]){
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"ProductName"],[_dictionaryPOForInsert valueForKey:@"SINO"]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pdfPathOutput];
        if (fileExists){
            if (pdfNeedToLoad){
                [self seePDF];
            }
            else{
                pdfNeedToLoad = TRUE;
            }
        }
        else{
            [self getRiderValue];
            [self joinHTMLKeluargaku];
        }
    }
    else{
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"ProductName"],[_dictionaryPOForInsert valueForKey:@"SINO"]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pdfPathOutput];
        if (fileExists){
            if (pdfNeedToLoad){
                [self seePDF];
            }
            else{
                pdfNeedToLoad = TRUE;
            }
        }
        else{
            [self loadPremi];
            [self joinHTML];
        }
    }
    
    //[self loadHTMLToWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    modelProspectProfile=[[ModelProspectProfile alloc]init];
    modelAgentProfile=[[ModelAgentProfile alloc]init];
    modelRate = [[RateModel alloc]init];
    formatter = [[Formatter alloc]init];
    modelSIRider = [[ModelSIRider alloc]init];
    riderCalculation = [[RiderCalculation alloc]init];
    modelSIMaster=[[Model_SI_Master alloc]init];
    pdfNeedToLoad = TRUE;
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
    [self.navigationBar setTitleTextAttributes:newAttributes];
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]}];
    
    /*email = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(email)];
    printSI = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(printSI)];
    pages = [[UIBarButtonItem alloc] initWithTitle:@"Pages" style:UIBarButtonItemStyleBordered target:self action:@selector(pagesSI:)];
    page4 = [[UIBarButtonItem alloc] initWithTitle:@"Page 4" style:UIBarButtonItemStyleBordered target:self action:@selector(page4)];*/
    
    /*self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:email,printSI, Nil];
    self.title=@"Ilustrasi";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalWindow:) ];*/
    
}

-(void)email{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/SalesIlustration.pdf",documentsDirectory];
    if ([MFMailComposeViewController canSendMail] == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please set up your default email account in iPad first"
                                                       delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = Nil;
        return;
    }
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:pdfPathOutput]; //document.fileURL;
    NSString *fileName = [pdfPathOutput lastPathComponent];//document.fileName; // Document
    
    NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
    
    if (attachment != nil) { // Ensure that we have valid document file attachment data
        MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
        
        [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
        [mailComposer setSubject:@"Ilustrasi"]; // Use the document file name for the subject
        
        mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
        mailComposer.mailComposeDelegate = self; // Set the delegate
        
        [self presentViewController:mailComposer animated:YES completion:nil];
        // Cleanup
    }
}

-(void)printSI{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/SalesIlustration.pdf",documentsDirectory];
    
    [_PagesPopover dismissPopoverAnimated:YES];
    Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
    
    if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
    {
        NSURL *fileURL = [NSURL fileURLWithPath:pdfPathOutput]; // Document file URL
        
        printInteraction = [printInteractionController sharedPrintController];
        
        if ([printInteractionController canPrintURL:fileURL] == YES) // Check first
        {
            UIPrintInfo *printInfo = [NSClassFromString(@"UIPrintInfo") printInfo];
            
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = [pdfPathOutput lastPathComponent];
            
            printInteraction.printInfo = printInfo;
            printInteraction.printingItem = fileURL;
            printInteraction.showsPageRange = YES;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                [printInteraction presentFromBarButtonItem:printSI animated:YES completionHandler:
                 ^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
                 {
#ifdef DEBUG
                     if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
#endif
                 }
                 ];
            }
        }
    }
}

-(void)pagesSI:(UIBarButtonItem *)sender        //--**added by bob
{
    if (_PagesList == nil) {
        
        _PagesList = [[PagesController alloc] initWithStyle:UITableViewStylePlain];
        _PagesList.delegate = self;
        //_PagesList.PDSorSI =_PDSorSI;
        //_PagesList.TradOrEver =_TradOrEver;
        _PagesPopover = [[UIPopoverController alloc] initWithContentViewController:_PagesList];
    }
    
    [_PagesPopover setPopoverContentSize:CGSizeMake(230.0f, 600.0f)];
    [_PagesPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


-(void)page4{

}

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF{

}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF{

}

- (void)closeModalWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDismissModal:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadHTMLToWebView{
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"]isDirectory:NO]]];
}

-(void)joinHTML{

    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"]; //changed for language
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page2" ofType:@"html"]; //changed for language
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page3" ofType:@"html"]; //changed for language
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page4" ofType:@"html"]; //changed for language
    
    NSString *pathImage = [[NSBundle mainBundle] pathForResource:@"LogoBCALife" ofType:@"jpg"]; //
    
    NSURL *pathURL1 = [NSURL fileURLWithPath:path1];
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];
    NSURL *pathURL4 = [NSURL fileURLWithPath:path4];

    NSURL *pathURLImage = [NSURL fileURLWithPath:pathImage];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data;
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if (IsInternalStaff==1){
        data = [NSMutableData dataWithContentsOfURL:pathURL4];
        NSData* data1 = [NSData dataWithContentsOfURL:pathURL1];
        NSData* data2 = [NSData dataWithContentsOfURL:pathURL2];
        NSData* data3 = [NSData dataWithContentsOfURL:pathURL3];
        [data appendData:data1];
        [data appendData:data2];
        [data appendData:data3];
    }
    else{
        data = [NSMutableData dataWithContentsOfURL:pathURL1];
        NSData* data2 = [NSData dataWithContentsOfURL:pathURL2];
        NSData* data3 = [NSData dataWithContentsOfURL:pathURL3];
        [data appendData:data2];
        [data appendData:data3];
    }
    

    NSData* dataImage = [NSData dataWithContentsOfURL:pathURLImage];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
    [dataImage writeToFile:[NSString stringWithFormat:@"%@/LogoBCALife.jpg",documentsDirectory] atomically:YES];
    
    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
    NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:HTMLPath encoding:NSUTF8StringEncoding error:nil];
    [webIlustration loadHTMLString:htmlString baseURL:baseURL];
    //[webIlustration loadRequest:[NSURLRequest requestWithURL:targetURL]];
}

-(void)createPDFFile{
        // File paths
    NSString *pdfPath1 = [NSString stringWithFormat:@"%@tmp1.pdf",NSTemporaryDirectory()];
    NSString *pdfPath2 = [NSString stringWithFormat:@"%@tmp2.pdf",NSTemporaryDirectory()];
    NSString *pdfPath3 = [NSString stringWithFormat:@"%@tmp3.pdf",NSTemporaryDirectory()];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/SI_Temp.pdf",documentsDirectory];//[cacheDir stringByAppendingPathComponent:@"out.pdf"];
    
    // File URLs - bridge casting for ARC
    CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath1];//(CFURLRef) NSURL
    CFURLRef pdfURL2 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath2];//(CFURLRef)
    CFURLRef pdfURL3 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)pdfPath3];//(CFURLRef)
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
    
    // File references
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
    CGPDFDocumentRef pdfRef2 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL2);
    CGPDFDocumentRef pdfRef3 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL3);
    
    // Number of pages
    NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
    NSInteger numberOfPages2 = CGPDFDocumentGetNumberOfPages(pdfRef2);
    NSInteger numberOfPages3 = CGPDFDocumentGetNumberOfPages(pdfRef3);
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    // Read the first PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 1 (%i)...", numberOfPages1);
    for (int i=1; i<=numberOfPages1; i++) {
        page = CGPDFDocumentGetPage(pdfRef1, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    // Read the second PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 2 (%i)...", numberOfPages2);
    for (int i=1; i<=numberOfPages2; i++) {
        page = CGPDFDocumentGetPage(pdfRef2, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }

    NSLog(@"GENERATING PAGES FROM PDF 3 (%i)...", numberOfPages3);
    for (int i=1; i<=numberOfPages3; i++) {
        page = CGPDFDocumentGetPage(pdfRef3, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }

    NSLog(@"DONE!");
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    
    // Release from memory
    CFRelease(pdfURL1);
    CFRelease(pdfURL2);
    CFRelease(pdfURL3);
    CFRelease(pdfURLOutput);
    CGPDFDocumentRelease(pdfRef1);
    CGPDFDocumentRelease(pdfRef2);
    CGPDFDocumentRelease(pdfRef3);
    CGContextRelease(writeContext);
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:pdfPathOutput];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webIlustration loadRequest:request];
    [webIlustration setHidden:NO];
    [viewspinBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValuePage1{
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    NSString *sex;
    if ([[_dictionaryPOForInsert valueForKey:@"LA_Gender"] isEqualToString:@"MALE"]){
        sex=@"Pria";
    }
    else{
        sex=@"Wanita";
    }
    
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: totalYear]];
    
    NSString *javaScriptP1H1 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP1H2 = [NSString stringWithFormat:@"document.getElementById('HeaderLASex').innerHTML =\"%@\";", sex];
    NSString *javaScriptP1H3 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Age"]];
    NSString *javaScriptP1H4 = [NSString stringWithFormat:@"document.getElementById('HeaderOccupation').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Occp"]];
    NSString *javaScriptP1H5 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP1H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    
    NSString *javaScriptP1T1 = [NSString stringWithFormat:@"document.getElementById('BasicSA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
   // NSString *javaScriptP1T2 = [NSString stringWithFormat:@"document.getElementById('Premi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiumLoading"]];
     NSString *javaScriptP1T2 = [NSString stringWithFormat:@"document.getElementById('Premi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiWithoutDiscount"]];
    
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    NSString *javaScriptTotalPage;
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if (IsInternalStaff==0){
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage1').innerHTML =\"%@\";", @"3"];
    }
    else{
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage1').innerHTML =\"%@\";", @"4"];
    }
    
    
    
    // Make the UIWebView method call
    NSString *response = [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
    NSString *response1 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H1];
    NSString *response2 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H2];
    NSString *response3 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H3];
    NSString *response4 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H4];
    NSString *response5 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H5];
    NSString *response6 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H6];

    NSString *response7 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T1];
    NSString *response8 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T2];
    
    NSString *responseF1 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    NSString *responseF2 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    NSString *responseF3 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    NSString *responseF4 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptTotalPage];
    /*NSString *responseP21 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H1];
    NSString *responseP22 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H2];
    NSString *responseP23 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H3];
    NSString *responseP24 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H4];
    NSString *responseP25 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H5];
    NSString *responseP26 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H6];
    NSString *responseP27 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H7];
    NSString *responseP28 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H8];
    NSString *responseP29 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H9];
    NSString *responseP210 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H10];
    NSString *responseP211 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H11];
    NSString *responseP212 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H12];
    NSString *responseP213 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H13];
    NSString *responseP214 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H14];
    NSString *responseP215 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H15];
    NSString *responseP216 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H16];*/
    
    NSLog(@"javascript result: %@", response);
    NSLog(@"javascript result: %@", response1);
    NSLog(@"javascript result: %@", response2);
    NSLog(@"javascript result: %@", response3);
    NSLog(@"javascript result: %@", response4);
    NSLog(@"javascript result: %@", response5);
    NSLog(@"javascript result: %@", response6);

    NSLog(@"javascript result: %@", response7);
    NSLog(@"javascript result: %@", response8);
    
    NSLog(@"javascript result: %@", responseF1);
    NSLog(@"javascript result: %@", responseF2);
    NSLog(@"javascript result: %@", responseF3);
    NSLog(@"javascript result: %@", responseF4);
    
    /*NSLog(@"javascript result: %@", responseP21);
    NSLog(@"javascript result: %@", responseP22);
    NSLog(@"javascript result: %@", responseP23);
    NSLog(@"javascript result: %@", responseP24);
    NSLog(@"javascript result: %@", responseP25);
    NSLog(@"javascript result: %@", responseP26);
    NSLog(@"javascript result: %@", responseP27);
    NSLog(@"javascript result: %@", responseP28);
    NSLog(@"javascript result: %@", responseP29);
    NSLog(@"javascript result: %@", responseP210);
    NSLog(@"javascript result: %@", responseP211);
    NSLog(@"javascript result: %@", responseP212);
    NSLog(@"javascript result: %@", responseP213);
    NSLog(@"javascript result: %@", responseP214);
    NSLog(@"javascript result: %@", responseP215);
    NSLog(@"javascript result: %@", responseP216);*/

}

-(int)calculateRowNumber:(int)Age{
    int rowNumber=0;
    rowNumber = 99 - Age;
    return rowNumber;
}

-(NSMutableArray *)getRate5:(int)age{
    NSMutableArray* arrayRate=[[NSMutableArray alloc]init];
    int rowNumber = 99 - age;
    NSString *gender =[[_dictionaryPOForInsert valueForKey:@"LA_Gender"]substringToIndex:1];
    for (int i=1;i<rowNumber;i++){
        [arrayRate addObject:[NSNumber numberWithDouble:[modelRate getCashSurValue5Year:@"HRT" EntryAge:age PolYear:i Gender:gender]]];
    }
    return arrayRate;
}

-(NSMutableArray *)getRateTunggal:(int)age{
    NSMutableArray* arrayRate=[[NSMutableArray alloc]init];
    int rowNumber = 99 - age;
    for (int i=1;i<rowNumber;i++){
        [arrayRate addObject:[NSNumber numberWithDouble:[modelRate getCashSurValue1Year:[_dictionaryPOForInsert valueForKey:@"LA_Gender"] BasicCode:@"HRT" EntryAge:age+i]]];
    }
    return arrayRate;
}

-(NSMutableArray *)getSurValue:(int)age{
    NSMutableArray* arrayRate=[[NSMutableArray alloc]init];
    int rowNumber = 99 - age;
    for (int i=1;i<rowNumber;i++){
        [arrayRate addObject:[NSNumber numberWithDouble:[modelRate getCashSurValue:[_dictionaryPOForInsert valueForKey:@"LA_Gender"] BasicCode:@"HRT" EntryAge:age PolYear:i]]];
    }
    return arrayRate;
}

-(void)setValuePage2{
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber2').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    //int poAge=[[_dictionaryPOForInsert valueForKey:@"PO_Age"] intValue];
    int laAge=[[_dictionaryPOForInsert valueForKey:@"LA_Age"] intValue];
    int numberOfRow=[self calculateRowNumber:laAge];
    
    NSString *sexPO;
    if ([[_dictionaryPOForInsert valueForKey:@"LA_Gender"] isEqualToString:@"MALE"]){
        sexPO=@"Pria";
    }
    else{
        sexPO=@"Wanita";
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    //NSNumber *myNumber = [f numberFromString:[_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    NSNumber *myNumber = [formatter convertAnyNonDecimalNumberToString:[_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    
    NSLog(@"formatted %@",[formatter numberToCurrencyDecimalFormatted:myNumber]);
    
    NSNumber *myNumberPremiB = [f numberFromString:[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumSum"]];
    double basicSumAssured = [myNumber doubleValue]/1000;
    
    int paymentTerm = 1;
    if ([[_dictionaryForBasicPlan valueForKey:@"Payment_Term"] isEqualToString:@"Premi Tunggal"]){
        paymentTerm = 1;
    }
    else{
        paymentTerm = 5;
    }
    NSString *javaScriptP2H1 = [NSString stringWithFormat:@"document.getElementById('HeaderPOName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Name"]];
    NSString *javaScriptP2H2 = [NSString stringWithFormat:@"document.getElementById('HeaderSumAssured').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    NSString *javaScriptP2H3 = [NSString stringWithFormat:@"document.getElementById('HeaderPODOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_DOB"]];
    NSString *javaScriptP2H4 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode1').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP2H5 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName1').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP2H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency1').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    NSString *javaScriptP2H7 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB2').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP2H8 = [NSString stringWithFormat:@"document.getElementById('HeaderBasicPremi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"PremiumPolicyA"]];
    NSString *javaScriptP2H9 = [NSString stringWithFormat:@"document.getElementById('HeaderIlustrationDate').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SIDate"]];
    
    NSString *javaScriptP2H10;
    if ([[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"] intValue]>0){
        javaScriptP2H10 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiPercent').innerHTML =\"%@\";", [NSString stringWithFormat:@":&nbsp;&nbsp;&nbsp;%@%%",[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"]]];
    }
    else{
        javaScriptP2H10 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiPercent').innerHTML =\"%@\";", [NSString stringWithFormat:@":&nbsp;&nbsp;&nbsp;%@%%",@"0"]];
    }
        
    NSString *javaScriptP2H11 = [NSString stringWithFormat:@"document.getElementById('HeaderPOAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
    
    NSString *javaScriptP2H12;
    if ([[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"] length]>0){
        javaScriptP2H12 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiDuration1').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];
    }
    else{
        javaScriptP2H12 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiDuration1').innerHTML =\"%@\";", @"0"];
    }
    
    NSString *javaScriptP2H13 = [NSString stringWithFormat:@"document.getElementById('HeaderLAAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Age"]];
    NSString *javaScriptP2H14 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiUWLoading').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPolicy"]];
    NSString *javaScriptP2H15 = [NSString stringWithFormat:@"document.getElementById('HeaderPOSex').innerHTML =\"%@\";", sexPO];
    //NSString *javaScriptP2H16 = [NSString stringWithFormat:@"document.getElementById('HeaderPremiPay').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiumLoading"]];
    NSString *javaScriptP2H16 = [NSString stringWithFormat:@"document.getElementById('HeaderPremiPay').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiWithoutDiscount"]];
    NSString *javaScriptP2H17;
    if ([myNumberPremiB intValue]>0){
        javaScriptP2H17 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiNumber').innerHTML =\"%@\";", [NSString stringWithFormat:@":&nbsp;&nbsp;&nbsp;%@‰",myNumberPremiB]];
    }
    else{
        javaScriptP2H17 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiNumber').innerHTML =\"%@\";", [NSString stringWithFormat:@":&nbsp;&nbsp;&nbsp;%@‰",@"0"]];
    }
    
    NSString *javaScriptP2H18;
    
    if (IsInternalStaff==1){
        javaScriptP2H18= [NSString stringWithFormat:@"document.getElementById('gstPage2').innerHTML =\"%@\";", @"<br/><br/>"];
    }
    else{
        javaScriptP2H18= [NSString stringWithFormat:@"document.getElementById('gstPage2').innerHTML =\"%@\";", @"<br/>"];
    }
    
    
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate2').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    NSString *javaScriptTotalPage;
    
    //int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if (IsInternalStaff==0){
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage2').innerHTML =\"%@\";", @"3"];
    }
    else{
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage2').innerHTML =\"%@\";", @"4"];
    }
    
    NSMutableArray* valRate1Year=[[NSMutableArray alloc]initWithArray:[self getRateTunggal:laAge]];
    NSString *string = [[valRate1Year valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSMutableArray* valSurValue=[[NSMutableArray alloc]initWithArray:[self getSurValue:laAge]];
    NSString *stringSurValue = [[valSurValue valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSMutableArray* valRate5Year=[[NSMutableArray alloc]initWithArray:[self getRate5:laAge]];
    NSString *string5Year = [[valRate5Year valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSString *responseTable = [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTable(%d,%i,%f,%d,[%@],[%@],[%@])", laAge,numberOfRow,basicSumAssured,paymentTerm,string,string5Year,stringSurValue]];
    
    // Make the UIWebView method call
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H1];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H2];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H3];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H4];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H5];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H6];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H7];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H8];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H9];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H10];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H11];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H12];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H13];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H14];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H15];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H16];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H17];
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H18];
    
     [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptTotalPage];
}

-(void)setValuePage3{
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber3').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName3').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate3').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode3').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch3').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    NSString *javaScriptTotalPage;
    int IsInternalStaff =[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue];
    if (IsInternalStaff==0){
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage3').innerHTML =\"%@\";", @"3"];
    }
    else{
        javaScriptTotalPage = [NSString stringWithFormat:@"document.getElementById('TotalPage3').innerHTML =\"%@\";", @"4"];
    }
    // Make the UIWebView method call
    NSString *response = [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
    NSString *responseF1 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    NSString *responseF2 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    NSString *responseF3 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    NSString *responseF4 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptTotalPage];
    
    NSLog(@"javascript result: %@", response);
    
    NSLog(@"javascript result: %@", responseF1);
    NSLog(@"javascript result: %@", responseF2);
    NSLog(@"javascript result: %@", responseF3);
    NSLog(@"javascript result: %@", responseF4);
}

-(void)setValuePage4{
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber4').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    NSString *javaScriptP4H1 = [NSString stringWithFormat:@"document.getElementById('SumAssured4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    NSString *javaScriptP4H2 = [NSString stringWithFormat:@"document.getElementById('FrekuensiPembayaran4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    NSString *javaScriptP4H3 = [NSString stringWithFormat:@"document.getElementById('BasicPremi4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"PremiumPolicyA"]];
    
    int discount = [[_dictionaryForBasicPlan valueForKey:@"Discount"] intValue];
    NSString *javaScriptP4H4;
    if (discount>0){
        javaScriptP4H4=[NSString stringWithFormat:@"document.getElementById('Diskon4').innerHTML =\"(%@)\";", [_dictionaryForBasicPlan valueForKey:@"Discount"]];
    }
    else{
        javaScriptP4H4=[NSString stringWithFormat:@"document.getElementById('Diskon4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Discount"]];
    }
    
    NSString *javaScriptP4H5 = [NSString stringWithFormat:@"document.getElementById('PremiAfterDiskon4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"SubTotalPremium"]];
    NSString *javaScriptP4H6 = [NSString stringWithFormat:@"document.getElementById('ExtraPremi4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPolicy"]];
    NSString *javaScriptP4H7 = [NSString stringWithFormat:@"document.getElementById('TotalPremi4').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiumLoading"]];
    
    NSString *javaScriptP4H81;
    NSString *javaScriptP4H82;
    NSString *javaScriptP4H83;
    NSString *javaScriptP4H84;
    NSString *javaScriptP4H85;
    NSString *javaScriptP4H9;
    NSString *javaScriptP4H10;
    if ([[_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"] isEqualToString:@"Tahunan"]){
        javaScriptP4H81 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.1').innerHTML =\"%@\";", @"per tahun"];
        javaScriptP4H82 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.2').innerHTML =\"%@\";", @"per tahun"];
        javaScriptP4H83 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.3').innerHTML =\"%@\";", @"per tahun"];
        javaScriptP4H84 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.4').innerHTML =\"%@\";", @"per tahun"];
        javaScriptP4H85 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.5').innerHTML =\"%@\";", @"per tahun"];
        javaScriptP4H9 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote1').innerHTML =\"%@\";", @"- Besarnya diskon premi yang diberikan akan sama setiap pembayaran premi selama 5 tahun masa pembayaran premi."];
        javaScriptP4H10 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote2').innerHTML =\"%@\";", @"- Total Premi yang dibayarkan mengacu kepada Total Premi Dibayar Setelah Diskon yang tercantum pada tabel diatas."];
    }
    else if ([[_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"] isEqualToString:@"Bulanan"]){
        javaScriptP4H81 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.1').innerHTML =\"%@\";", @"per bulan"];
        javaScriptP4H82 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.2').innerHTML =\"%@\";", @"per bulan"];
        javaScriptP4H83 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.3').innerHTML =\"%@\";", @"per bulan"];
        javaScriptP4H84 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.4').innerHTML =\"%@\";", @"per bulan"];
        javaScriptP4H85 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.5').innerHTML =\"%@\";", @"per bulan"];
        javaScriptP4H9 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote1').innerHTML =\"%@\";", @"- Besarnya diskon premi yang diberikan akan sama setiap pembayaran premi selama 5 tahun masa pembayaran premi."];
        javaScriptP4H10 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote2').innerHTML =\"%@\";", @"- Total Premi yang dibayarkan mengacu kepada Total Premi Dibayar Setelah Diskon yang tercantum pada tabel diatas."];
    }
    else{
        javaScriptP4H81 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.1').innerHTML =\"%@\";", @""];
        javaScriptP4H82 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.2').innerHTML =\"%@\";", @""];
        javaScriptP4H83 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.3').innerHTML =\"%@\";", @""];
        javaScriptP4H84 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.4').innerHTML =\"%@\";", @""];
        javaScriptP4H85 = [NSString stringWithFormat:@"document.getElementById('MasaPembayaran4.5').innerHTML =\"%@\";", @""];
        javaScriptP4H9 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote1').innerHTML =\"%@\";", @"- Total Premi yang dibayarkan mengacu kepada Total Premi Dibayar Setelah Diskon yang tercantum pada tabel diatas."];
        javaScriptP4H10 = [NSString stringWithFormat:@"document.getElementById('RegularAdditionalNote2').innerHTML =\"%@\";", @""];
    }
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName4').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate4').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode4').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch4').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    // Make the UIWebView method call
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H4];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H5];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H6];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H7];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H81];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H82];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H83];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H84];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H85];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H9];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP4H10];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
}


-(void)makePDF{
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:webIlustration.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 0.0f;
    float bottomPadding = 0.0f;
    float leftPadding = 0.0f;
    float rightPadding = 0.0f;
    NSLog(@"size %@",NSStringFromCGSize(kPaperSizeA4));
    CGRect printableRect = CGRectMake(leftPadding,
                                      topPadding,
                                      kPaperSizeA4.width-leftPadding-rightPadding,
                                      kPaperSizeA4.height-topPadding-bottomPadding);
    CGRect paperRect = CGRectMake(0, 0, kPaperSizeA4.width, kPaperSizeA4.height);
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    NSData *pdfData = [render printToPDF];

    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    if (pdfData) {
        [pdfData writeToFile:[NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"ProductName"],[_dictionaryPOForInsert valueForKey:@"SINO"]] atomically:YES];
        NSLog(@"datat %@",[NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"PO_Name"],[_dictionaryPOForInsert valueForKey:@"SINO"]]);
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
    pdfCreated=true;
    [webIlustration setHidden:YES];
    [viewspinBar setHidden:YES];
    [self seePDF];
}

- (void)seePDF{
    _dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"ProductName"],[_dictionaryPOForInsert valueForKey:@"SINO"]];
    //NSString *file = [[NSBundle mainBundle] pathForResource:@"Brochure_ProdukBCALIfeKeluargaku_21012016" ofType:@"pdf"];
    
    //compose the subject and body
    NSString *sexPO;
    if ([[_dictionaryPOForInsert valueForKey:@"PO_Gender"] isEqualToString:@"MALE"]){
        sexPO=@"Bapak";
    }
    else{
        sexPO=@"Ibu";
    }
    
    NSString* AgentName = [_dictionaryForAgentProfile valueForKey:@"AgentName"];
    NSString *mailComposerText=[NSString stringWithFormat:@"Kepada %@ %@ <br/><br/>Calon Nasabah BCA Life,Terima kasih atas kesempatan yang diberikan kepada Financial Advisor kami %@ untuk menjelaskan mengenai produk perlindungan asuransi yang %@ butuhkan. <br/><br/>Terlampir kami kirimkan Ilustrasi yang sudah dibuat oleh Financial Advisor kami. Silahkan buka dan pelajari apakah sudah sesuai dengan kebutuhan jaminan masa depan %@. <br/><br/>Untuk informasi produk asuransi lainnya, silahkan mengunjungi website kami di www.bcalife.co.id atau menghubungi customer service HALO BCA 1500888.<br/><br/>Terima Kasih<br/>PT Asuransi Jiwa BCA",sexPO,[_dictionaryPOForInsert valueForKey:@"PO_Name"],AgentName,sexPO,sexPO];

    ProspectProfile* pp;
    int clinetID = [[_dictionaryPOForInsert valueForKey:@"PO_ClientID"] intValue];
    NSMutableArray *ProspectTableData = [[NSMutableArray alloc]initWithArray:[modelProspectProfile searchProspectProfileByID:clinetID]];
    NSString* idTypeNo;
    if ([ProspectTableData count]>0){
        pp = [ProspectTableData objectAtIndex:0];
        NSString* idType = pp.OtherIDType;
        idTypeNo = pp.OtherIDTypeNo;
        if (![idType isEqualToString:@"1"]){
            idTypeNo = @"-";
        }
    }
    else{
        idTypeNo = @"-";
    }
    
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPathOutput password:nil];
    
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.bodyEmail = mailComposerText;
    readerViewController.subjectEmail = [NSString stringWithFormat:@"BCALife Illustration %@",[_dictionaryPOForInsert valueForKey:@"SINO"]];
    readerViewController.POName = [_dictionaryPOForInsert valueForKey:@"PO_Name"];
    readerViewController.POKtp = idTypeNo;
    readerViewController.AgentName = [_dictionaryForAgentProfile valueForKey:@"AgentName"];
    readerViewController.AgentKTP = [_dictionaryForAgentProfile valueForKey:@"AgentCode"];
    readerViewController.IsInternalStaff = [NSNumber numberWithInt:[[_dictionaryPOForInsert valueForKey:@"IsInternalStaff"] intValue]];
    BOOL illustrationSigned = [modelSIMaster isSignedIlustration:[_dictionaryPOForInsert valueForKey:@"SINO"]];
    readerViewController.illustrationSignature = illustrationSigned;
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:readerViewController animated:YES completion:Nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    if ([[_dictionaryForBasicPlan valueForKey:@"ProductCode"] isEqualToString:@"BCAKK"]){
        [self setValueKeluargakuPage1];
        [self setValueKeluargakuPage2];
    }
    else{
        [self setValuePage1];
        [self setValuePage2];
        [self setValuePage3];
        [self setValuePage4];
    }
    
    if (!pdfCreated){
       [self makePDF];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
    pdfNeedToLoad=FALSE;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)dismissReaderViewControllerWithReload:(ReaderViewController *)viewController{
    pdfNeedToLoad=TRUE;
    [modelSIMaster signIlustrationMaster:[_dictionaryPOForInsert valueForKey:@"SINO"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUGX
    NSLog(@"%s", __FUNCTION__);
#endif
    
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) {
        NSLog(@"%@", error);
    }
#endif
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadPremi{
    Pertanggungan_Dasar = [[_dictionaryForBasicPlan valueForKey:@"Number_Sum_Assured"] integerValue];
    PayorAge = [[_dictionaryForBasicPlan valueForKey:@"PO_Age"]integerValue];;
    PayorSex = [_dictionaryForBasicPlan valueForKey:@"LA_Gender"];
    Highlight =[_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"];
    Pertanggungan_ExtrePremi = [[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"] integerValue];
    ExtraPremiNumbValue  = [[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
    
    [self AnsuransiDasar];
    [self PremiDasarActB];
    [self ExtraPremiNumber];
    [self SubTotal];
    [self PremiDasarActB];
}

-(void)AnsuransiDasar
{
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",PayorSex,@"HRT",@"S",PayorAge];
    NSLog(@"query %@",AnsuransiDasarQuery);
    results = [database executeQuery:AnsuransiDasarQuery];
    
    NSString*RatesPremiumRate;
    int PaymentModeYear;
    int PaymentModeMonthly;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
    {
        if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
            RatesPremiumRate  = [results stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate  = [results stringForColumn:@"Female"];
        }
    }
    
    PaymentModeYear = 1;
    PaymentModeMonthly = 0.1;
    
    double RatesInt = [RatesPremiumRate doubleValue];
    AnssubtotalYear =(Pertanggungan_Dasar/1000)*(PaymentModeYear * RatesInt);
    //int RatesInt = [RatesPremiumRate intValue];
    AnssubtotalBulan =(Pertanggungan_Dasar/1000)*(0.1 * RatesInt);
}

-(void)PremiDasarActB
{
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",PayorSex,@"HRT",@"S",PayorAge];
    NSLog(@"query %@",AnsuransiDasarQuery);
    results = [database executeQuery:AnsuransiDasarQuery];
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
    {
        if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
            RatesPremiumRate  = [results stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate  = [results stringForColumn:@"Female"];
            
        }
        
    }
    PaymentMode = 1;
    PaymentMode = 0.1;
    
    
    double RatesInt = [RatesPremiumRate doubleValue];
    
    ExtraPercentsubtotalYear =(Pertanggungan_Dasar/1000)*(1.0 * RatesInt)*Pertanggungan_ExtrePremi;
    ExtraPercentsubtotalBulan =(Pertanggungan_Dasar/1000)*(0.1 * RatesInt)*Pertanggungan_ExtrePremi;
}


-(void)ExtraPremiNumber
{
    ExtraNumbsubtotalYear =(ExtraPremiNumbValue* 1.0) *(Pertanggungan_Dasar/1000);
    ExtraNumbsubtotalBulan =(ExtraPremiNumbValue* 0.1) *(Pertanggungan_Dasar/1000);
}

-(void)SubTotal
{
    totalYear = (AnssubtotalYear + ExtraNumbsubtotalYear + ExtraPercentsubtotalYear);
    totalBulanan = (AnssubtotalBulan + ExtraNumbsubtotalBulan + ExtraPercentsubtotalBulan);
}

#pragma mark Keluargaku
-(void)getRiderValue{
    dictMDBKK=[modelSIRider getRider:[_dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:@"MDBKK"];
    dictMBKK=[modelSIRider getRider:[_dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:@"MDKK"];
    dictBebasPremi=[modelSIRider getRider:[_dictionaryPOForInsert valueForKey:@"SINO"] RiderCode:@"BP"];
    
    NSString* mdbKKPremi = [dictMDBKK valueForKey:@"PremiRp"];
    NSString* mdbKKPremiExtra = [dictMDBKK valueForKey:@"ExtraPremiRp"];
    NSString* bpPremi = [dictBebasPremi valueForKey:@"PremiRp"];
    NSString* bpPremiExtra = [dictBebasPremi valueForKey:@"ExtraPremiRp"];
    
    mdbKKPremi = [mdbKKPremi stringByReplacingOccurrencesOfString:@" " withString:@""];
    mdbKKPremi = [mdbKKPremi stringByReplacingOccurrencesOfString:@"," withString:@""];
    mdbKKPremi = [mdbKKPremi stringByReplacingOccurrencesOfString:@"." withString:@""];
    mdbKKPremi = [mdbKKPremi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    mdbKKPremiExtra = [mdbKKPremiExtra stringByReplacingOccurrencesOfString:@" " withString:@""];
    mdbKKPremiExtra = [mdbKKPremiExtra stringByReplacingOccurrencesOfString:@"," withString:@""];
    mdbKKPremiExtra = [mdbKKPremiExtra stringByReplacingOccurrencesOfString:@"." withString:@""];
    mdbKKPremiExtra = [mdbKKPremiExtra stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    bpPremi = [bpPremi stringByReplacingOccurrencesOfString:@" " withString:@""];
    bpPremi = [bpPremi stringByReplacingOccurrencesOfString:@"," withString:@""];
    bpPremi = [bpPremi stringByReplacingOccurrencesOfString:@"." withString:@""];
    bpPremi = [bpPremi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    bpPremiExtra = [bpPremiExtra stringByReplacingOccurrencesOfString:@" " withString:@""];
    bpPremiExtra = [bpPremiExtra stringByReplacingOccurrencesOfString:@"," withString:@""];
    bpPremiExtra = [bpPremiExtra stringByReplacingOccurrencesOfString:@"." withString:@""];
    bpPremiExtra = [bpPremiExtra stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    mdbkk = [mdbKKPremi doubleValue];
    mdbkkExtra = [mdbKKPremiExtra doubleValue];
    bp = [bpPremi doubleValue];
    bpExtra = [bpPremiExtra doubleValue];
    
    
    premiStandard = mdbkk + bp;
    extraPremi = mdbkkExtra + bpExtra;
    totalDibayar = premiStandard + extraPremi;
}

-(void)setValueKeluargakuPage2{
    NSString* paymentDesc = [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"];
    int paymentFreq=[modelRate getKeluargakuMOPFreq:[riderCalculation getPaymentType:paymentDesc]];
    
    NSString* premiRP = [dictMDBKK valueForKey:@"PremiRp"];
    NSNumber* numberPremiRp=[formatter convertAnyNonDecimalNumberToString:premiRP];
    NSLog(@"numberpremi %@",numberPremiRp);
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber2').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
        //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate2').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch2').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTable(%@,%d)",numberPremiRp,paymentFreq]];
    // Make the UIWebView method call
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
}

- (void)setValueKeluargakuPage1{
    NSString *sexLA;
    if ([[_dictionaryPOForInsert valueForKey:@"LA_Gender"] isEqualToString:@"MALE"]){
        sexLA=@"Pria";
    }
    else{
        sexLA=@"Wanita";
    }

    NSString *sexPO;
    if ([[_dictionaryPOForInsert valueForKey:@"PO_Gender"] isEqualToString:@"MALE"]){
        sexPO=@"Pria";
    }
    else{
        sexPO=@"Wanita";
    }
    NSString* RelWithLA = [_dictionaryPOForInsert valueForKey:@"RelWithLA"];
    
    NSString *javaScriptP1H20;
    NSString *javaScriptP1H21;
    NSString *javaScriptP1H22;
    NSString *javaScriptP1H16;

    NSString *javaScriptP1H23;
    NSString *javaScriptP1H24;
    NSString *javaScriptP1H25;
    NSString *javaScriptP1H26;

    NSString* manfaatBebasPremiText;
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        javaScriptP1H20=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPercentLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"]];
        javaScriptP1H21=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPerMilLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumSum"]];
        javaScriptP1H22=[NSString stringWithFormat:@"document.getElementById('MasaExtraPremiLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];
        javaScriptP1H16=[NSString stringWithFormat:@"document.getElementById('SelfRelation').innerHTML =\"%@\";", @"Ya"];
        
        javaScriptP1H23=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPercentPO').innerHTML ="";"];
        javaScriptP1H24=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPerMilPO').innerHTML ="";"];
        javaScriptP1H25=[NSString stringWithFormat:@"document.getElementById('MasaExtraPremiPO').innerHTML ="";"];

        manfaatBebasPremiText = @"Jika Tertanggung cacat tetap total karena sebab apapun maka Polis menjadi Bebas Premi.";

    }
    else{
        javaScriptP1H20=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPercentLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"]];
        javaScriptP1H21=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPerMilLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumSum"]];
        javaScriptP1H22=[NSString stringWithFormat:@"document.getElementById('MasaExtraPremiLA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];

        javaScriptP1H23=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPercentPO').innerHTML =\"%@\";", [dictBebasPremi valueForKey:@"ExtraPremiPercent"]];
        javaScriptP1H24=[NSString stringWithFormat:@"document.getElementById('ExtraPremiPerMilPO').innerHTML =\"%@\";", [dictBebasPremi valueForKey:@"ExtraPremiMil"]];
        javaScriptP1H25=[NSString stringWithFormat:@"document.getElementById('MasaExtraPremiPO').innerHTML =\"%@\";", [dictBebasPremi valueForKey:@"MasaExtraPremi"]];
        javaScriptP1H16=[NSString stringWithFormat:@"document.getElementById('SelfRelation').innerHTML =\"%@\";", @"Tidak"];
        
        manfaatBebasPremiText = @"Jika Pemegang Polis meninggal dunia karena sebab apapun maka Polis menjadi Bebas Premi.";
    }
    
    
        NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber1').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
        NSString *javaScriptP1H2=[NSString stringWithFormat:@"document.getElementById('POName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Name"]];
        NSString *javaScriptP1H3=[NSString stringWithFormat:@"document.getElementById('PODOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_DOB"]];
        NSString *javaScriptP1H5=[NSString stringWithFormat:@"document.getElementById('POAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
        NSString *javaScriptP1H7=[NSString stringWithFormat:@"document.getElementById('POGender').innerHTML =\"%@\";", sexPO];
        NSString *javaScriptP1H9=[NSString stringWithFormat:@"document.getElementById('LAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
        NSString *javaScriptP1H11=[NSString stringWithFormat:@"document.getElementById('LADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
        NSString *javaScriptP1H13=[NSString stringWithFormat:@"document.getElementById('LAAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Age"]];
        NSString *javaScriptP1H15=[NSString stringWithFormat:@"document.getElementById('LAGender').innerHTML =\"%@\";", sexLA];
        NSString *javaScriptP1H18=[NSString stringWithFormat:@"document.getElementById('SIDate').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SIDate"]];

        int discount = [[_dictionaryForBasicPlan valueForKey:@"Discount"] intValue];
        NSString *javaScriptP1H14;
        NSNumber *myNumber = [formatter convertNumberFromString:[_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
        if (discount>0){
        javaScriptP1H14=[NSString stringWithFormat:@"document.getElementById('SIDiscount').innerHTML =\"(%@)\";", [_dictionaryForBasicPlan valueForKey:@"Discount"]];
        }
        else{
        javaScriptP1H14=[NSString stringWithFormat:@"document.getElementById('SIDiscount').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Discount"]];
        }
    
        NSString *javaScriptP1H17=[NSString stringWithFormat:@"document.getElementById('TotalPremi').innerHTML =\"%@\";", [NSString stringWithFormat:@"%@",[formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:totalDibayar]]]];
        NSString *javaScriptP1H1=[NSString stringWithFormat:@"document.getElementById('SumAssured').innerHTML =\"%@\";", [formatter numberToCurrencyDecimalFormatted:myNumber]];
        NSString *javaScriptP1H4=[NSString stringWithFormat:@"document.getElementById('Loading').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"LA_Name"]];
        NSString *javaScriptP1H6=[NSString stringWithFormat:@"document.getElementById('ExtraPremi').innerHTML =\"%@\";", [NSString stringWithFormat:@"%@",[formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:extraPremi]]]];
        NSString *javaScriptP1H8=[NSString stringWithFormat:@"document.getElementById('ExtraOccupation').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"LA_Name"]];
        NSString *javaScriptP1H10=[NSString stringWithFormat:@"document.getElementById('MasaExtraPremi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];
        NSString *javaScriptP1H12=[NSString stringWithFormat:@"document.getElementById('PremiDibayar').innerHTML =\"%@\";", [NSString stringWithFormat:@"%@",[formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiStandard]]]];
        NSString *javaScriptP1H19=[NSString stringWithFormat:@"document.getElementById('CaraBayarPremi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];

    
        NSString *javaScriptP1T1=[NSString stringWithFormat:@"document.getElementById('SumAssuredMDBKK').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictMDBKK valueForKey:@"SumAssured"]]];
        NSString *javaScriptP1T2=[NSString stringWithFormat:@"document.getElementById('MDBKKPremi').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictMDBKK valueForKey:@"PremiRp"]]];
        NSString *javaScriptP1T3=[NSString stringWithFormat:@"document.getElementById('MDBKKExtraPremi').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictMDBKK valueForKey:@"ExtraPremiRp"]]];
        NSString *javaScriptP1T4=[NSString stringWithFormat:@"document.getElementById('SumAssuredMDKK').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictMBKK valueForKey:@"SumAssured"]]];
        NSString *javaScriptP1T5=[NSString stringWithFormat:@"document.getElementById('BPPremi').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictBebasPremi valueForKey:@"PremiRp"]]];
        NSString *javaScriptP1T6=[NSString stringWithFormat:@"document.getElementById('BPExtraPremi').innerHTML =\"%@\";", [formatter stringToCurrencyDecimalFormatted:[dictBebasPremi valueForKey:@"ExtraPremiRp"]]];
    
        NSString *javaScriptP1C1=[NSString stringWithFormat:@"document.getElementById('ManfaatBebasPremi').innerHTML =\"%@\";", manfaatBebasPremiText];
    
    
        //footer agent data
        NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
        NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
        NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
        NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];

        [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1C1];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H1];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H2];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H3];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H4];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H5];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H6];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H7];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H8];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H9];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H10];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H11];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H12];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H13];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H14];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H15];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H16];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H17];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H18];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H19];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H20];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H21];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H22];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H23];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H24];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1H25];
    
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T1];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T2];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T3];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T4];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T5];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP1T6];
    
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
        [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
}
-(void)joinHTMLKeluargaku{
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"eng_BCALKK_Page1" ofType:@"html"]; //changed for language
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"eng_BCALKK_Page2" ofType:@"html"]; //changed for language
    
    NSString *pathImage = [[NSBundle mainBundle] pathForResource:@"LogoBCALife" ofType:@"jpg"]; //
    
    NSURL *pathURL1 = [NSURL fileURLWithPath:path1];
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    
    NSURL *pathURLImage = [NSURL fileURLWithPath:pathImage];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:pathURL1];
    NSData* data2 = [NSData dataWithContentsOfURL:pathURL2];
    [data appendData:data2];
    
    NSData* dataImage = [NSData dataWithContentsOfURL:pathURLImage];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp_Keluargaku.html",documentsDirectory] atomically:YES];
    [dataImage writeToFile:[NSString stringWithFormat:@"%@/LogoBCALife.jpg",documentsDirectory] atomically:YES];
    
    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp_Keluargaku.html"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:HTMLPath encoding:NSUTF8StringEncoding error:nil];
    [webIlustration loadHTMLString:htmlString baseURL:baseURL];
    //[webIlustration loadRequest:[NSURLRequest requestWithURL:targetURL]];
}

@end


@implementation UIPrintPageRenderer (PDF)
- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}
@end
