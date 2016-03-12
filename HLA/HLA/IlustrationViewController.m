//
//  IlustrationViewController.m
//  BLESS
//
//  Created by Basvi on 3/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//
#define kPaperSizeA4 CGSizeMake(842,655)

#import "IlustrationViewController.h"

@interface IlustrationViewController (){
    int page;
    bool pdfCreated;
}

@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

@implementation IlustrationViewController

-(void)viewWillAppear:(BOOL)animated{
    [webIlustration setHidden:YES];
    [viewspinBar setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    page =1;
    pdfCreated=false;
    [self loadPremi];
    [self joinHTML];
    //[self loadHTMLToWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    modelAgentProfile=[[ModelAgentProfile alloc]init];
    modelRate = [[RateModel alloc]init];
    
    
    email = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStyleBordered target:self action:@selector(email)];
    printSI = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(printSI)];
    pages = [[UIBarButtonItem alloc] initWithTitle:@"Pages" style:UIBarButtonItemStyleBordered target:self action:@selector(pagesSI:)];
    page4 = [[UIBarButtonItem alloc] initWithTitle:@"Page 4" style:UIBarButtonItemStyleBordered target:self action:@selector(page4)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:email,printSI, Nil];
    self.title=@"Ilustration";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalWindow:) ];
    
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
    
    NSString *pathImage = [[NSBundle mainBundle] pathForResource:@"LogoBCALife" ofType:@"jpg"]; //
    
    NSURL *pathURL1 = [NSURL fileURLWithPath:path1];
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];

    NSURL *pathURLImage = [NSURL fileURLWithPath:pathImage];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:pathURL1];
    NSData* data2 = [NSData dataWithContentsOfURL:pathURL2];
    NSData* data3 = [NSData dataWithContentsOfURL:pathURL3];
    [data appendData:data2];
    [data appendData:data3];

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
    [webIlustration setHidden:NO];
    [viewspinBar setHidden:YES];
}

-(void)createPDFFile{
    /*NSString *path = nil;
    path = [NSString stringWithFormat:@"%@tmp1.pdf",NSTemporaryDirectory()];
    
    NSString *path2 = nil;
    path2 = [NSString stringWithFormat:@"%@tmp2.pdf",NSTemporaryDirectory()];
    
    NSString *path3 = nil;
    path3 = [NSString stringWithFormat:@"%@tmp3.pdf",NSTemporaryDirectory()];

    NSURL *pathURL = [NSURL fileURLWithPath:path] ;
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:pathURL];
    NSData *data2=[NSData dataWithContentsOfURL:pathURL2];
    NSData *data3=[NSData dataWithContentsOfURL:pathURL3];
    
    [data appendData:data3];
    [data appendData:data2];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.pdf",documentsDirectory] atomically:YES];*/
    //NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
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
    NSString *javaScriptP1H3 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP1H4 = [NSString stringWithFormat:@"document.getElementById('HeaderOccupation').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Occp"]];
    NSString *javaScriptP1H5 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP1H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    
    NSString *javaScriptP1T1 = [NSString stringWithFormat:@"document.getElementById('BasicSA').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    NSString *javaScriptP1T2 = [NSString stringWithFormat:@"document.getElementById('Premi').innerHTML =\"%@\";", numberString];
    
    NSString *javaScriptP2H1 = [NSString stringWithFormat:@"document.getElementById('HeaderPOName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Name"]];
    NSString *javaScriptP2H2 = [NSString stringWithFormat:@"document.getElementById('HeaderSumAssured').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
    NSString *javaScriptP2H3 = [NSString stringWithFormat:@"document.getElementById('HeaderPODOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_DOB"]];
    NSString *javaScriptP2H4 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP2H5 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP2H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    NSString *javaScriptP2H7 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP2H8 = [NSString stringWithFormat:@"document.getElementById('HeaderBasicPremi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"PremiumPolicyA"]];
    NSString *javaScriptP2H9 = [NSString stringWithFormat:@"document.getElementById('HeaderIlustrationDate').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SIDate"]];
    NSString *javaScriptP2H10 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiPercent').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"]];
    NSString *javaScriptP2H11 = [NSString stringWithFormat:@"document.getElementById('HeaderPOAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
    NSString *javaScriptP2H12 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiDuration').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];
    NSString *javaScriptP2H13 = [NSString stringWithFormat:@"document.getElementById('HeaderLAAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Age"]];
    NSString *javaScriptP2H14 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiUWLoading').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiumLoading"]];
    NSString *javaScriptP2H15 = [NSString stringWithFormat:@"document.getElementById('HeaderPOAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
    NSString *javaScriptP2H16 = [NSString stringWithFormat:@"document.getElementById('HeaderPremiPay').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"LA_Occp"]];
    
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[NSDate date]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
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
    
    NSString *responseP21 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H1];
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
    NSString *responseP216 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H16];
    
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
    
    NSLog(@"javascript result: %@", responseP21);
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
    NSLog(@"javascript result: %@", responseP216);

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
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    //int poAge=[[_dictionaryPOForInsert valueForKey:@"PO_Age"] intValue];
    int laAge=[[_dictionaryPOForInsert valueForKey:@"LA_Age"] intValue];
    int numberOfRow=[self calculateRowNumber:laAge];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:[_dictionaryForBasicPlan valueForKey:@"Sum_Assured"]];
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
    NSString *javaScriptP2H4 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP2H5 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP2H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    NSString *javaScriptP2H7 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP2H8 = [NSString stringWithFormat:@"document.getElementById('HeaderBasicPremi').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"PremiumPolicyA"]];
    NSString *javaScriptP2H9 = [NSString stringWithFormat:@"document.getElementById('HeaderIlustrationDate').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SIDate"]];
    NSString *javaScriptP2H10 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiPercent').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"]];
    NSString *javaScriptP2H11 = [NSString stringWithFormat:@"document.getElementById('HeaderPOAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
    NSString *javaScriptP2H12 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiDuration').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"]];
    NSString *javaScriptP2H13 = [NSString stringWithFormat:@"document.getElementById('HeaderLAAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Age"]];
    NSString *javaScriptP2H14 = [NSString stringWithFormat:@"document.getElementById('HeaderExtraPremiUWLoading').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"TotalPremiumLoading"]];
    NSString *javaScriptP2H15 = [NSString stringWithFormat:@"document.getElementById('HeaderPOAge').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"PO_Age"]];
    NSString *javaScriptP2H16 = [NSString stringWithFormat:@"document.getElementById('HeaderPremiPay').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"LA_Occp"]];
    
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[NSDate date]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    NSMutableArray* valRate1Year=[[NSMutableArray alloc]initWithArray:[self getRateTunggal:laAge]];
    NSString *string = [[valRate1Year valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSMutableArray* valSurValue=[[NSMutableArray alloc]initWithArray:[self getSurValue:laAge]];
    NSString *stringSurValue = [[valSurValue valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSMutableArray* valRate5Year=[[NSMutableArray alloc]initWithArray:[self getRate5:laAge]];
    NSString *string5Year = [[valRate5Year valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSString *responseTable = [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTable(%d,%i,%f,%d,[%@],[%@],[%@])", laAge,numberOfRow,basicSumAssured,paymentTerm,string,string5Year,stringSurValue]];
    
    // Make the UIWebView method call
    NSString *response = [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
    NSString *responseF1 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    NSString *responseF2 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    NSString *responseF3 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    NSString *responseF4 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
    NSString *responseP21 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H1];
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
    NSString *responseP216 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptP2H16];
    
    NSLog(@"javascript result: %@", responseTable);
    NSLog(@"javascript result: %@", responseF1);
    NSLog(@"javascript result: %@", responseF2);
    NSLog(@"javascript result: %@", responseF3);
    NSLog(@"javascript result: %@", responseF4);
    
    NSLog(@"javascript result: %@", responseP21);
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
    NSLog(@"javascript result: %@", responseP216);

}

-(void)setValuePage3{
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[NSDate date]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [_dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    // Make the UIWebView method call
    NSString *response = [webIlustration stringByEvaluatingJavaScriptFromString:javaScript];
    
    NSString *responseF1 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    NSString *responseF2 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    NSString *responseF3 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    NSString *responseF4 = [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
    NSLog(@"javascript result: %@", response);
    
    NSLog(@"javascript result: %@", responseF1);
    NSLog(@"javascript result: %@", responseF2);
    NSLog(@"javascript result: %@", responseF3);
    NSLog(@"javascript result: %@", responseF4);
}

-(void)makePDF{
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:webIlustration.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 0.0f;
    float bottomPadding = 0.0f;
    float leftPadding = 0.0f;
    float rightPadding = 0.0f;
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
        [pdfData writeToFile:[NSString stringWithFormat:@"%@/SalesIlustration.pdf",documentsDirectory] atomically:YES];
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SalesIlustration.pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
    [webIlustration loadRequest:[NSURLRequest requestWithURL:targetURL]];
    pdfCreated=true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    [self setValuePage1];
    [self setValuePage2];
    [self setValuePage3];
    
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
