//
//  SPAJPDFWebViewController.m
//  BLESS
//
//  Created by Basvi on 8/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#define kPaperSizeA4 CGSizeMake(595,842)
#define kPaperSizeA4Portrait CGSizeMake(750,1300)

#import "SPAJPDFWebViewController.h"
#import "NDHTMLtoPDF.h"

@interface SPAJPDFWebViewController ()<UIWebViewDelegate>{
    IBOutlet UIWebView* webSPAJ;
    NDHTMLtoPDF *PDFCreator;
}

@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end

@implementation SPAJPDFWebViewController
@synthesize dictTransaction;

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 950, 768);
    [self.view.superview setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"page_spaj_pdf" ofType:@"html" inDirectory:@"Build/Page/HTML"]];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",htmlFileName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    [self loadHTML];*/
}

- (void)viewDidLoad {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //define the webview coordinate
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, 950,768)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadHTML{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"page_spaj_pdf" ofType:@"html" inDirectory:@"Build/Page/HTML"]];
    [webSPAJ loadRequest:[NSURLRequest requestWithURL:url]];
}

-(IBAction)actionMakePDF:(UIBarButtonItem *)sender{
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:webview.viewPrintFormatter startingAtPageAtIndex:0];
    //increase these values according to your requirement
    float topPadding = 0.0f;
    float bottomPadding = 0.0f;
    float leftPadding = 0.0f;
    float rightPadding = 0.0f;
    NSLog(@"size %@",NSStringFromCGSize(kPaperSizeA4Portrait));
    CGRect printableRect = CGRectMake(leftPadding,
                                      topPadding,
                                      kPaperSizeA4Portrait.width-leftPadding-rightPadding,
                                      kPaperSizeA4Portrait.height-topPadding-bottomPadding);
    CGRect paperRect = CGRectMake(0, 0, kPaperSizeA4Portrait.width, kPaperSizeA4Portrait.height);
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    NSData *pdfData = [render printToPDF];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    if (pdfData) {
        [pdfData writeToFile:[NSString stringWithFormat:@"%@/SPAJ/%@/SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]] atomically:YES];
        //NSLog(@"datat %@",[NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"PO_Name"],[_dictionaryPOForInsert valueForKey:@"SINO"]]);
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
    //pdfCreated=true;
    //[webSPAJ setHidden:YES];
    //[viewspinBar setHidden:YES];
    //[self seePDF];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionClosePage:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    /*NSString *SPAJTransactionID = [modelSPAJTransaction getSPAJTransactionData:@"SPAJTransactionID" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[modifiedParams valueForKey:@"SPAJAnswers"]];
    NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and SPAJID=%@ and SPAJTransactionID=%@ and SPAJHtmlSection='PO'",@"1",@"1",SPAJTransactionID];
    [tempDict setObject:stringWhere forKey:@"where"];
    
    NSMutableDictionary* answerDictionary = [[NSMutableDictionary alloc]init];
    [answerDictionary setObject:tempDict forKey:@"SPAJAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:answerDictionary forKey:@"data"];
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    return [super readfromDB:finalDictionary];*/
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('read').click()"]];
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
