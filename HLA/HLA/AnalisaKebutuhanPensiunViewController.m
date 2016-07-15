//
//  AnalisaKebutuhanPensiunViewController.m
//  BLESS
//
//  Created by Basvi on 7/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AnalisaKebutuhanPensiunViewController.h"
#import "ModelCFFTransaction.h"
#import "ModelCFFHtml.h"

@interface AnalisaKebutuhanPensiunViewController (){
    ModelCFFTransaction* modelCFFTransaction;
    ModelCFFHtml* modelCFFHtml;
}


@end

@implementation AnalisaKebutuhanPensiunViewController
@synthesize prospectProfileID,cffTransactionID,htmlFileName,cffID,cffHeaderSelectedDictionary;
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"CFFfolder"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"CFFfolder/%@",htmlFileName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
}
- (void)viewDidLoad {
    modelCFFTransaction = [[ModelCFFTransaction alloc]init];
    modelCFFHtml = [[ModelCFFHtml alloc]init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //define the webview coordinate
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 745,728)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    //
    cffID = [cffHeaderSelectedDictionary valueForKey:@"PensiunCFFID"];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    [modifiedParams setObject:[[modelCFFHtml selectActiveHtmlForSection:@"PSN"] valueForKey:@"CFFHtmlID"] forKey:@"CFFHtmlID"];
    //[modifiedParams setObject:@"1" forKey:@"CFFHtmlID"];
    [modifiedParams setObject:[cffTransactionID stringValue] forKey:@"CFFTransactionID"];
    [modifiedParams setObject:[cffID stringValue] forKey:@"CFFID"];
    [modifiedParams setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
    
    NSMutableArray* arrayCFFAnswers = [[NSMutableArray alloc]initWithArray:[modifiedParams valueForKey:@"CFFAnswers"]];
    NSMutableArray* modifiedArrayCFFAnswers = [[NSMutableArray alloc]init];
    if ([arrayCFFAnswers count]>0){
        for (int i = 0;i<[arrayCFFAnswers count];i++){
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[arrayCFFAnswers objectAtIndex:i]];
            [tempDict setObject:[[modelCFFHtml selectActiveHtmlForSection:@"PSN"] valueForKey:@"CFFHtmlID"] forKey:@"CFFHtmlID"];
            [tempDict setObject:[cffTransactionID stringValue] forKey:@"CFFTransactionID"];
            [tempDict setObject:[cffID stringValue] forKey:@"CFFID"];
            [tempDict setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
            
            [modifiedArrayCFFAnswers addObject:tempDict];
        }
    }
    
    NSMutableDictionary* finalArrayDictionary = [[NSMutableDictionary alloc]init];
    [finalArrayDictionary setObject:modifiedArrayCFFAnswers forKey:@"CFFAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:finalArrayDictionary forKey:@"data"];
    [modelCFFTransaction updateCFFDateModified:[cffTransactionID intValue]];
    
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    [super savetoDB:finalDictionary];
}

- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    return [super readfromDB:params];
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
