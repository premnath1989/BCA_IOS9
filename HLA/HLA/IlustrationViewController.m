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
    //[self loadHTMLToWebView];
    [self createPDFFile];
    // Do any additional setup after loading the view.
}

-(void)loadHTMLToWebView{
   // NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"];
   // NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
   // [webIlustration loadHTMLString:htmlString baseURL:nil];
    [webIlustration loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eng_BCALH_Page1" ofType:@"html"]isDirectory:NO]]];
}

-(void)createPDFFile{
    NSString *path = nil;
    path = [[NSBundle mainBundle] pathForResource:@"SI/eng_BCALH_Page1" ofType:@"html"];

    NSString *path2 = nil;
    path2 = [[NSBundle mainBundle] pathForResource:@"SI/eng_BCALH_Page2" ofType:@"html"];
    
    NSString *path3 = nil;
    path3 = [[NSBundle mainBundle] pathForResource:@"SI/eng_BCALH_Page3" ofType:@"html"];

    NSURL *pathURL = [NSURL fileURLWithPath:path];
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data = [NSMutableData dataWithContentsOfURL:pathURL];
    NSData *data2=[NSData dataWithContentsOfURL:pathURL2];
    NSData *data3=[NSData dataWithContentsOfURL:pathURL3];
    
    [data appendData:data2];
    [data appendData:data3];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
