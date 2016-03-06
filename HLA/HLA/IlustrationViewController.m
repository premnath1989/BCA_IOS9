//
//  IlustrationViewController.m
//  BLESS
//
//  Created by Basvi on 3/1/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "IlustrationViewController.h"

@interface IlustrationViewController ()

@end

@implementation IlustrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    modelAgentProfile=[[ModelAgentProfile alloc]init];
    modelRate = [[RateModel alloc]init];

    page1 = [[UIBarButtonItem alloc] initWithTitle:@"Page 1" style:UIBarButtonItemStyleBordered target:self action:@selector(page1)];
    page2 = [[UIBarButtonItem alloc] initWithTitle:@"Page 2" style:UIBarButtonItemStyleBordered target:self action:@selector(page2)];
    page3 = [[UIBarButtonItem alloc] initWithTitle:@"Page 3" style:UIBarButtonItemStyleBordered target:self action:@selector(page3)];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:page3, page2, page1, Nil];
    self.title=@"Ilustration";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalWindow:) ];
    [self loadHTMLToWebView];
    //[self createPDFFile];
    // Do any additional setup after loading the view.
}

-(void)page1{
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"]isDirectory:NO]]];
}

-(void)page2{
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page2" ofType:@"html"]isDirectory:NO]]];
}

-(void)page3{
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page3" ofType:@"html"]isDirectory:NO]]];
}


- (void)closeModalWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDismissModal:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadHTMLToWebView{
   // NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"];
   // NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
   // [webIlustration loadHTMLString:htmlString baseURL:nil];
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"]isDirectory:NO]]];
}

-(void)createPDFFile{
    NSString *path = nil;
    path = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"];

    NSString *path2 = nil;
    path2 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page2" ofType:@"html"];
    
    NSString *path3 = nil;
    path3 = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page3" ofType:@"html"];

    NSURL *pathURL = [NSURL fileURLWithPath:path] ;
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:pathURL3];
    NSData *data2=[NSData dataWithContentsOfURL:pathURL2];
    NSData *data3=[NSData dataWithContentsOfURL:pathURL3];
    
    //[data appendData:data2];
    //[data appendData:data3];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];

    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
        NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
        // Converting HTML to PDF
        NSString *SIPDFName = [NSString stringWithFormat:@"tes.pdf"/*,self.getSINo*/];
        PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
                                             pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                               delegate:self
                                               pageSize:kPaperSizeA4
                                                margins:UIEdgeInsetsMake(10, 5, 10, 5)];
    }

}

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    /*NSURL *url = [NSURL fileURLWithPath:htmlToPDF.PDFpath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webIlustration loadRequest:requestObj];
    [webIlustration setScalesPageToFit:YES];*/
    BrowserViewController *controller = [[BrowserViewController alloc] initWithFilePath:htmlToPDF.PDFpath PDSorSI:@"SI" TradOrEver:@"Trad"];
    NSString *SIPDFName=@"Example.pdf";
    /*if ([PDSorSI isEqualToString:@"PDS"]) {
        SIPDFName = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
    } else if ([PDSorSI isEqualToString:@"UNDERWRITING"]) {
        SIPDFName = [NSString stringWithFormat:@"UNDERWRITING_%@.pdf",self.getSINo];
    } else {
        SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
    }*/
    controller.title = SIPDFName;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navController animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValuePage1{
    NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];
    
    NSString *javaScriptP1H1 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP1H2 = [NSString stringWithFormat:@"document.getElementById('HeaderLASex').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Gender"]];
    NSString *javaScriptP1H3 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP1H4 = [NSString stringWithFormat:@"document.getElementById('HeaderOccupation').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Occp"]];
    NSString *javaScriptP1H5 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP1H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    
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
    /*if (Age<21){
        rowNumber=20;
    }
    else{
        int remainingAge=Age-20;
        if (remainingAge%5 == 0){
            int addedRow = remainingAge/5;
            rowNumber=20+addedRow;
        }
        else{
            int addedRow = remainingAge/5;
            rowNumber=20+addedRow+1;
        }
    }*/
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
    
    int poAge=[[_dictionaryPOForInsert valueForKey:@"PO_Age"] intValue];
    int laAge=[[_dictionaryPOForInsert valueForKey:@"LA_Age"] intValue];
    int numberOfRow=[self calculateRowNumber:poAge];
    
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
    
    NSString *responseTable = [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTable(%d,%i,%f,%d,[%@],[%@],[%@])", poAge,numberOfRow,basicSumAssured,paymentTerm,string,string5Year,stringSurValue]];
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];

    [self setValuePage1];
    [self setValuePage2];
    [self setValuePage3];
    /*NSString *javaScript = [NSString stringWithFormat:@"document.getElementById('SINumber').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"SINO"]];

    NSString *javaScriptP1H1 = [NSString stringWithFormat:@"document.getElementById('HeaderLAName').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Name"]];
    NSString *javaScriptP1H2 = [NSString stringWithFormat:@"document.getElementById('HeaderLASex').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Gender"]];
    NSString *javaScriptP1H3 = [NSString stringWithFormat:@"document.getElementById('HeaderLADOB').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_DOB"]];
    NSString *javaScriptP1H4 = [NSString stringWithFormat:@"document.getElementById('HeaderOccupation').innerHTML =\"%@\";", [_dictionaryPOForInsert valueForKey:@"LA_Occp"]];
    NSString *javaScriptP1H5 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentPeriode').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Term"]];
    NSString *javaScriptP1H6 = [NSString stringWithFormat:@"document.getElementById('HeaderPaymentFrequency').innerHTML =\"%@\";", [_dictionaryForBasicPlan valueForKey:@"Payment_Frequency"]];
    
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
    NSString *response = [webView stringByEvaluatingJavaScriptFromString:javaScript];
    
    NSString *response1 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H1];
    NSString *response2 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H2];
    NSString *response3 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H3];
    NSString *response4 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H4];
    NSString *response5 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H5];
    NSString *response6 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP1H6];

    NSString *responseF1 = [webView stringByEvaluatingJavaScriptFromString:javaScriptF1];
    NSString *responseF2 = [webView stringByEvaluatingJavaScriptFromString:javaScriptF2];
    NSString *responseF3 = [webView stringByEvaluatingJavaScriptFromString:javaScriptF3];
    NSString *responseF4 = [webView stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
    NSString *responseP21 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H1];
    NSString *responseP22 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H2];
    NSString *responseP23 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H3];
    NSString *responseP24 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H4];
    NSString *responseP25 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H5];
    NSString *responseP26 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H6];
    NSString *responseP27 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H7];
    NSString *responseP28 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H8];
    NSString *responseP29 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H9];
    NSString *responseP210 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H10];
    NSString *responseP211 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H11];
    NSString *responseP212 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H12];
    NSString *responseP213 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H13];
    NSString *responseP214 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H14];
    NSString *responseP215 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H15];
    NSString *responseP216 = [webView stringByEvaluatingJavaScriptFromString:javaScriptP2H16];
    
    NSLog(@"javascript result: %@", response);
    NSLog(@"javascript result: %@", response1);
    NSLog(@"javascript result: %@", response2);
    NSLog(@"javascript result: %@", response3);
    NSLog(@"javascript result: %@", response4);
    NSLog(@"javascript result: %@", response5);
    NSLog(@"javascript result: %@", response6);

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
    NSLog(@"javascript result: %@", responseP216);*/
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
