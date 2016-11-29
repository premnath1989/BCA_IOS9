//
//  SIUnitLinkedQuotationViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#define kPaperSizeA4 CGSizeMake(842,595)

#import "NDHTMLtoPDF.h"
#import "SIUnitLinkedQuotationViewController.h"
#import "ReaderViewController.h"

@interface SIUnitLinkedQuotationViewController ()<ReaderViewControllerDelegate,NDHTMLtoPDFDelegate,UIWebViewDelegate>

@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDF;
@end


@implementation SIUnitLinkedQuotationViewController

-(void)viewDidAppear:(BOOL)animated{
    [self loadHTML];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadHTML{
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"eng_BCALULS_Page1" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webIlustration loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
}

-(void)loadPDF:(NSString *)pdfOutput{
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfOutput password:nil];
    
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:readerViewController animated:YES completion:Nil];
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
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
    [webIlustration setHidden:YES];
    [self seePDF];
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
   // pdfNeedToLoad=FALSE;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)dismissReaderViewControllerWithReload:(ReaderViewController *)viewController{
 //   pdfNeedToLoad=TRUE;
 //   [modelSIMaster signIlustrationMaster:[_dictionaryPOForInsert valueForKey:@"SINO"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*_dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    if ([[_dictionaryForBasicPlan valueForKey:@"ProductCode"] isEqualToString:@"BCAKK"]){
        [self setValueKeluargakuPage1];
        [self setValueKeluargakuPage2];
    }
    else{
        [self setValuePage1];
        [self setValuePage2];
        [self setValuePage3];
        [self setValuePage4];
    }*/
    
    //if (!pdfCreated){
        [self makePDF];
    //}
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
