//
//  SPAJ Calon Tertanggung.m
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJ Calon Tertanggung.h"

@interface SPAJ_Calon_Tertanggung ()

@end

@implementation SPAJ_Calon_Tertanggung
@synthesize htmlFileName;
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",htmlFileName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
}


- (void)viewDidLoad {
    modelProspectProfile = [[ModelProspectProfile alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
    modelSIPData = [[ModelSIPOData alloc]init];
    
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

-(void)voidDoneSPAJCalonTertanggung{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('save').click()"]];
}

- (void)savetoDB:(NSDictionary *)params{
    //add another key to db
    NSString*spajTransactionID = [modelSPAJTransaction getSPAJTransactionData:@"SPAJTransactionID" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    //cffID = [cffHeaderSelectedDictionary valueForKey:@"PotentialDiscussionCFFID"];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    [modifiedParams setObject:[[modelSPAJHtml selectActiveHtmlForSection:@"TR"] valueForKey:@"SPAJHtmlID"] forKey:@"SPAJHtmlID"];
    [modifiedParams setObject:spajTransactionID forKey:@"SPAJTransactionID"];
    //[modifiedParams setObject:cffID forKey:@"SPAJID"];
    //[modifiedParams setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
    
    NSMutableArray* arraySPAJAnswers = [[NSMutableArray alloc]initWithArray:[modifiedParams valueForKey:@"SPAJAnswers"]];
    NSMutableArray* modifiedArrayCFFAnswers = [[NSMutableArray alloc]init];
    if ([arraySPAJAnswers count]>0){
        for (int i = 0;i<[arraySPAJAnswers count];i++){
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[arraySPAJAnswers objectAtIndex:i]];
            [tempDict setObject:[[modelSPAJHtml selectActiveHtmlForSection:@"PO"] valueForKey:@"SPAJHtmlID"] forKey:@"SPAJHtmlID"];
            [tempDict setObject:spajTransactionID forKey:@"SPAJTransactionID"];
            //[tempDict setObject:cffID forKey:@"SPAJID"];
            //[tempDict setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
            [tempDict setObject:@"TR" forKey:@"SPAJHtmlSection"];
            int indexNo = [modelSPAJAnswers voidGetDuplicateRowID:tempDict];
            
            if (indexNo>0){
                [tempDict setObject:[NSNumber numberWithInt:indexNo] forKey:@"IndexNo"];
            }
            [modifiedArrayCFFAnswers addObject:tempDict];
        }
    }
    
    NSMutableDictionary* finalArrayDictionary = [[NSMutableDictionary alloc]init];
    [finalArrayDictionary setObject:modifiedArrayCFFAnswers forKey:@"SPAJAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:finalArrayDictionary forKey:@"data"];
    //[modelCFFTransaction updateCFFDateModified:[cffTransactionID intValue]];
    
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    [super savetoDB:finalDictionary];
    [delegate voidSetCalonTertnggungBoolValidate:true];
}

- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    NSString *SPAJTransactionID = [modelSPAJTransaction getSPAJTransactionData:@"SPAJTransactionID" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[modifiedParams valueForKey:@"SPAJAnswers"]];
    NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and SPAJID=%@ and SPAJTransactionID=%@ and SPAJHtmlSection='TR'",@"1",@"1",SPAJTransactionID];
    [tempDict setObject:stringWhere forKey:@"where"];
    
    NSMutableDictionary* answerDictionary = [[NSMutableDictionary alloc]init];
    [answerDictionary setObject:tempDict forKey:@"SPAJAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:answerDictionary forKey:@"data"];
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    return [super readfromDB:finalDictionary];
}

-(NSString *)getLAIndexNumber{
    NSString *SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:SINO]];
    NSString *stringPOClientID = [dictPOData valueForKey:@"LA_ClientID"];
    return stringPOClientID;
}

-(NSDictionary *)dictForAutoPopulate{
    NSMutableArray* columnNames = [[NSMutableArray alloc]initWithArray:[modelProspectProfile getColumnNames:@"prospect_profile"]];
    NSMutableArray* columnValue = [[NSMutableArray alloc]initWithArray:[modelProspectProfile getColumnValue:[self getLAIndexNumber] ColumnCount:[columnNames count]]];
    
    //create dictionary
    NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]init];
    for (int i=0;i<[columnNames count];i++){
        [dictDetail setObject:[columnValue objectAtIndex:i] forKey:[columnNames objectAtIndex:i]];
    }
    
    NSDictionary *readFromDB=[[NSDictionary alloc]initWithObjectsAndKeys:dictDetail,@"readFromDB", nil];
    NSDictionary *result=[[NSDictionary alloc]initWithObjectsAndKeys:readFromDB,@"result", nil];
    
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //autoPopulate()
    NSLog(@"dictPopulate %@",[self dictForAutoPopulate]);
    NSString *jsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictForAutoPopulate]
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"AutoPopulate('%@');", jsonString]];
        NSLog(@"json string %@",jsonString);
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

@end
