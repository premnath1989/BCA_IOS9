//
//  AreaPotensialDiskusiViewController.m
//  BLESS
//
//  Created by Basvi on 6/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AreaPotensialDiskusiViewController.h"
#import "ModelCFFTransaction.h"
#import "ModelCFFHtml.h"
#import "Formatter.h"
#import "ModelCFFAnswers.h"
@interface AreaPotensialDiskusiViewController (){
    ModelCFFTransaction* modelCFFTransaction;
    ModelCFFHtml* modelCFFHtml;
    Formatter* formatter;
    ModelCFFAnswers* modelCFFAsnwers;
}

@end

@implementation AreaPotensialDiskusiViewController
@synthesize prospectProfileID,cffTransactionID,htmlFileName,cffID,cffHeaderSelectedDictionary;
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"CFFfolder"];
    [self createDirectory];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"CFFfolder/%@",htmlFileName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];

}

- (void)createDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

- (void)viewDidLoad {
    modelCFFTransaction = [[ModelCFFTransaction alloc]init];
    modelCFFHtml = [[ModelCFFHtml alloc]init];
    modelCFFAsnwers = [[ModelCFFAnswers alloc]init];
    formatter = [[Formatter alloc]init];
    
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

#pragma mark call save function in HTML
- (void)voidDoneAreaPotential{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('save').click()"]];
    
}

- (void)voidReadAreaPotential{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('read').click()"]];
}

- (void)voidSetPriorityData{
    NSLog(@"dob %@",[formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:[cffHeaderSelectedDictionary valueForKey:@"ProspectDOB"]]);
    NSString* prospectDOB  = [formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:[cffHeaderSelectedDictionary valueForKey:@"ProspectDOB"]];
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"calculatePriority('%@')", prospectDOB]];
}


- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    cffID = [cffHeaderSelectedDictionary valueForKey:@"PotentialDiscussionCFFID"];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    [modifiedParams setObject:[[modelCFFHtml selectActiveHtmlForSection:@"PD"] valueForKey:@"CFFHtmlID"] forKey:@"CFFHtmlID"];
    [modifiedParams setObject:[cffTransactionID stringValue] forKey:@"CFFTransactionID"];
    [modifiedParams setObject:cffID forKey:@"CFFID"];
    [modifiedParams setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
    
    NSMutableArray* arrayCFFAnswers = [[NSMutableArray alloc]initWithArray:[modifiedParams valueForKey:@"CFFAnswers"]];
    NSMutableArray* modifiedArrayCFFAnswers = [[NSMutableArray alloc]init];
    if ([arrayCFFAnswers count]>0){
        for (int i = 0;i<[arrayCFFAnswers count];i++){
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[arrayCFFAnswers objectAtIndex:i]];
            [tempDict setObject:[[modelCFFHtml selectActiveHtmlForSection:@"PD"] valueForKey:@"CFFHtmlID"] forKey:@"CFFHtmlID"];
            [tempDict setObject:[cffTransactionID stringValue] forKey:@"CFFTransactionID"];
            [tempDict setObject:cffID forKey:@"CFFID"];
            [tempDict setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
            [tempDict setObject:@"PD" forKey:@"CFFHtmlSection"];
            int indexNo = [modelCFFAsnwers voidGetDuplicateRowID:tempDict];
            
            if (indexNo>0){
                [tempDict setObject:[NSNumber numberWithInt:indexNo] forKey:@"IndexNo"];
            }
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
    [delegate voidSetAreaPotentialBoolValidate:true];
}

- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[modifiedParams valueForKey:@"CFFAnswers"]];
    NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and CFFID=%@ and CFFTransactionID=%@ and CFFHtmlSection='PD'",prospectProfileID,[cffHeaderSelectedDictionary valueForKey:@"PotentialDiscussionCFFID"],[cffHeaderSelectedDictionary valueForKey:@"CFFTransactionID"]];
    [tempDict setObject:stringWhere forKey:@"where"];
    
    NSMutableDictionary* answerDictionary = [[NSMutableDictionary alloc]init];
    [answerDictionary setObject:tempDict forKey:@"CFFAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:answerDictionary forKey:@"data"];
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    return [super readfromDB:finalDictionary];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self voidReadAreaPotential];
    [self voidSetPriorityData];
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
