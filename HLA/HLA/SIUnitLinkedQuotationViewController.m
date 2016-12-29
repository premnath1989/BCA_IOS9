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
#import "ModelAgentProfile.h"
#import "Formatter.h"
#import "SingleUnitLinkedCalculation.h"
#import "RateModel.h"
#import "Model_SI_Master.h"
#import "ProspectProfile.h"
#import "ModelProspectProfile.h"

@interface SIUnitLinkedQuotationViewController ()<ReaderViewControllerDelegate,NDHTMLtoPDFDelegate,UIWebViewDelegate>{
    NSMutableDictionary* dictionaryForAgentProfile;
    ModelAgentProfile* modelAgentProfile;
    Formatter* formatter;
    RateModel* rateModel;
    Model_SI_Master* modelSIMaster;
    ModelProspectProfile *modelProspectProfile;
    SingleUnitLinkedCalculation* singleUnitLinkedCalculation;
    NSMutableArray* arraySpecialOption;
    
    BOOL pdfNeedToLoad;
}


@end

@interface UIPrintPageRenderer (PDF)
- (NSData*) printToPDFFile;
@end


@implementation SIUnitLinkedQuotationViewController
@synthesize delegate;
-(void)viewDidAppear:(BOOL)animated{
    if (pdfNeedToLoad){
        NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[dictPOLAData valueForKey:@"ProductName"],[dictPOLAData valueForKey:@"SINO"]];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pdfPathOutput];
        if (fileExists){
            if (pdfNeedToLoad){
                [self loadPDF:pdfPathOutput];
            }
            else{
                pdfNeedToLoad = TRUE;
            }
        }
        else{
            [self joinHTML];
        }
        
    }
    else{
        pdfNeedToLoad = TRUE;
    }
}

-(void)loadDataFromList{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    formatter = [[Formatter alloc]init];
    modelAgentProfile=[[ModelAgentProfile alloc]init];
    modelSIMaster=[[Model_SI_Master alloc]init];
    dictionaryForAgentProfile = [[NSMutableDictionary alloc]initWithDictionary:[modelAgentProfile getAgentData]];
    singleUnitLinkedCalculation = [[SingleUnitLinkedCalculation alloc]init];
    arraySpecialOption = [[NSMutableArray alloc]init];
    rateModel = [[RateModel alloc]init];
    pdfNeedToLoad = TRUE;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)joinHTML{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"eng_BCALULS_Page1" ofType:@"html"]; //
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"eng_BCALULS_Page2" ofType:@"html"]; //
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"eng_BCALULS_Page3" ofType:@"html"]; //
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"eng_BCALULS_Page4" ofType:@"html"]; //
    
    NSString *pathImage = [[NSBundle mainBundle] pathForResource:@"LogoBCALife" ofType:@"jpg"]; //
    
    NSURL *pathURL1 = [NSURL fileURLWithPath:path1];
    NSURL *pathURL2 = [NSURL fileURLWithPath:path2];
    NSURL *pathURL3 = [NSURL fileURLWithPath:path3];
    NSURL *pathURL4 = [NSURL fileURLWithPath:path4];
    
    NSURL *pathURLImage = [NSURL fileURLWithPath:pathImage];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableData* data;
    data = [NSMutableData dataWithContentsOfURL:pathURL1];
    NSData* data2 = [NSData dataWithContentsOfURL:pathURL2];
    NSData* data3 = [NSData dataWithContentsOfURL:pathURL3];
    NSData* data4 = [NSData dataWithContentsOfURL:pathURL4];
    [data appendData:data2];
    [data appendData:data3];
    [data appendData:data4];
    
    NSData* dataImage = [NSData dataWithContentsOfURL:pathURLImage];
    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
    [dataImage writeToFile:[NSString stringWithFormat:@"%@/LogoBCALife.jpg",documentsDirectory] atomically:YES];
    
    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:HTMLPath encoding:NSUTF8StringEncoding error:nil];
    [webIlustration loadHTMLString:htmlString baseURL:baseURL];
}

-(void)loadDataPage1{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    NSMutableDictionary* dictULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getULFundAllocationDictionary]];
    
    double totalPremiSekaligus = [[formatter convertNumberFromStringCurrency:[dictULBasicPlanData valueForKey:@"Premium"]] doubleValue];
    double totalPremiTopUp = [singleUnitLinkedCalculation calculateTotalPremiTopUp:[delegate getRunnigSINumber]];
    double totalPremi = [singleUnitLinkedCalculation calculateTotalPremi:totalPremiSekaligus TotalPremiTopUp:totalPremiTopUp];
    
    NSString *stringSINumber1 = [delegate getRunnigSINumber];
    NSString *stringCurrency = [dictULBasicPlanData valueForKey:@"PaymentCurrency"];
    NSString *stringPOName = [dictPOLAData valueForKey:@"PO_Name"];
    NSString *stringLAName = [dictPOLAData valueForKey:@"LA_Name"];
    NSString *stringPOAge = [dictPOLAData valueForKey:@"PO_Age"];
    NSString *stringLAAge = [dictPOLAData valueForKey:@"LA_Age"];
    NSString *stringPOGender = [dictPOLAData valueForKey:@"PO_Gender"];
    NSString *stringLAGender = [dictPOLAData valueForKey:@"LA_Gender"];
    NSString *stringPOOccp = [dictPOLAData valueForKey:@"PO_Occp"];
    NSString *stringLAOccp = [dictPOLAData valueForKey:@"LA_Occp"];
    NSString *stringSumAssured = [dictULBasicPlanData valueForKey:@"SumAssured"];
    NSString *stringCostOfInsurance;
    NSString *stringTotalPremi = [formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:totalPremi]];
    NSString *stringPremiDasarSekaligus = [dictULBasicPlanData valueForKey:@"Premium"];
    NSString *stringPremiTopUpSekaligus = [formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:totalPremiTopUp]];
    NSString *stringIDRFixedIncome = [dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"];
    NSString *stringIDREquityIncome = [dictFundAllocationData valueForKey:@"IDREquityIncomeFund"];
    NSString *stringUSDFixedIncome = [dictFundAllocationData valueForKey:@"USDFixedIncomeFund"];
    NSString *stringUSDEquityIncome = [dictFundAllocationData valueForKey:@"USDEquityIncomeFund"];
    
    int laAge = [[dictPOLAData valueForKey:@"LA_Age"] intValue];
    NSMutableArray* rateBasicCharge = [[NSMutableArray alloc]initWithArray:[self getBasicChargeRate:laAge Gender:[dictPOLAData valueForKey:@"LA_Gender"] Smoker:[dictPOLAData valueForKey:@"LA_Smoker"]]];
    //double rateBasicCharge = 4.396;
    
    NSDictionary* dictInsuranceCharges = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:laAge],@"LAAge",[dictULBasicPlanData valueForKey:@"ExtraPremiumPercentage"],@"EMPercent",[dictULBasicPlanData valueForKey:@"ExtraPremiumMil"],@"EMMil",[formatter convertNumberFromStringCurrency:[dictULBasicPlanData valueForKey:@"SumAssured"]],@"SumAssured",rateBasicCharge,@"Rate",@"40",@"AlternativePremiHoliday",@"0",@"RTUPremi",[dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"],@"IDRFixedIncomeFund",[dictFundAllocationData valueForKey:@"IDREquityIncomeFund"],@"IDREquityIncomeFund",[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"],@"USDFixedIncomeFund",[dictFundAllocationData valueForKey:@"USDEquityIncomeFund"],@"USDEquityIncomeFund", nil];
    
    NSString *jsonInsuranceChargeString;
    NSError *error;
    NSData *jsonInsuranceChargeData = [NSJSONSerialization dataWithJSONObject:dictInsuranceCharges
                                                                      options:0 // Pass 0 if you don't care about the readability of the generated string
                                                                        error:&error];
    
    if (! jsonInsuranceChargeData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonInsuranceChargeString = [[NSString alloc] initWithData:jsonInsuranceChargeData encoding:NSUTF8StringEncoding];
    }
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getColN_1(%@);", jsonInsuranceChargeString]];
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringSINumber1').innerHTML =\"%@\";", stringSINumber1]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringCurrency').innerHTML =\"%@\";", stringCurrency]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPOName').innerHTML =\"%@\";", stringPOName]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringLAName').innerHTML =\"%@\";", stringLAName]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPOAge').innerHTML =\"%@\";", stringPOAge]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringLAAge').innerHTML =\"%@\";", stringLAAge]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPOGender').innerHTML =\"%@\";", stringPOGender]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringLAGender').innerHTML =\"%@\";", stringLAGender]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPOOccp').innerHTML =\"%@\";", stringPOOccp]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringLAOccp').innerHTML =\"%@\";", stringLAOccp]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringSumAssured').innerHTML =\"%@\";", stringSumAssured]];
    //[webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringCostOfInsurance').innerHTML =\"%@\";", stringCostOfInsurance]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringTotalPremi').innerHTML =\"%@\";", stringTotalPremi]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPremiDasarSekaligus').innerHTML =\"%@\";", stringPremiDasarSekaligus]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringPremiTopUpSekaligus').innerHTML =\"%@\";", stringPremiTopUpSekaligus]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringIDRFixedIncome').innerHTML =\"%@\";", stringIDRFixedIncome]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringIDREquityIncome').innerHTML =\"%@\";", stringIDREquityIncome]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringUSDFixedIncome').innerHTML =\"%@\";", stringUSDFixedIncome]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringUSDEquityIncome').innerHTML =\"%@\";", stringUSDEquityIncome]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
}

-(void)loadDataPage2{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    NSMutableDictionary* dictULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    arraySpecialOption = [delegate getULSpecialOptionArray];
    
    NSArray *filteredTopUp = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"TopUp"]];
    NSArray *filteredTopUpYear=[[NSArray alloc]initWithArray:[filteredTopUp valueForKey:@"Year"]];
    NSArray *filteredTopUpAmount=[[NSArray alloc]initWithArray:[filteredTopUp valueForKey:@"Amount"]];
    
    NSArray *filteredWithDraw = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"WithDraw"]];
    NSArray *filteredWithDrawYear=[[NSArray alloc]initWithArray:[filteredWithDraw valueForKey:@"Year"]];
    NSArray *filteredWithDrawAmount=[[NSArray alloc]initWithArray:[filteredWithDraw valueForKey:@"Amount"]];
    
    NSString* topUpYear = [filteredTopUpYear  componentsJoinedByString:@","];
    NSString* topUpAmount = [filteredTopUpAmount  componentsJoinedByString:@","];
    
    NSString* withDrawYear= [filteredWithDrawYear componentsJoinedByString:@","];
    NSString* withDrawAmount = [filteredWithDrawAmount componentsJoinedByString:@","];
    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getULFundAllocationDictionary]];
    
    int laAge = [[dictPOLAData valueForKey:@"LA_Age"] intValue];
    int numberOfRow=15  ;
    
    NSMutableArray* rateBasicCharge = [[NSMutableArray alloc]initWithArray:[self getBasicChargeRate:laAge Gender:[dictPOLAData valueForKey:@"LA_Gender"] Smoker:[dictPOLAData valueForKey:@"LA_Smoker"]]];
    
    NSDictionary* dictInsuranceCharges = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:laAge],@"LAAge",[dictULBasicPlanData valueForKey:@"ExtraPremiumPercentage"],@"EMPercent",[dictULBasicPlanData valueForKey:@"ExtraPremiumMil"],@"EMMil",[formatter convertNumberFromStringCurrency:[dictULBasicPlanData valueForKey:@"SumAssured"]],@"SumAssured",rateBasicCharge,@"Rate",@"99",@"AlternativePremiHoliday",@"0",@"RTUPremi",[dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"],@"IDRFixedIncomeFund",[dictFundAllocationData valueForKey:@"IDREquityIncomeFund"],@"IDREquityIncomeFund",[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"],@"USDFixedIncomeFund",[dictFundAllocationData valueForKey:@"USDEquityIncomeFund"],@"USDEquityIncomeFund",[dictULBasicPlanData valueForKey:@"PaymentCurrency"],@"PaymentCurrency", nil];

    
    NSString *jsonInsuranceChargeString;
    NSError *error;
    NSData *jsonInsuranceChargeData = [NSJSONSerialization dataWithJSONObject:dictInsuranceCharges
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonInsuranceChargeData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonInsuranceChargeString = [[NSString alloc] initWithData:jsonInsuranceChargeData encoding:NSUTF8StringEncoding];
    }
    
    NSString *stringSINumber2 = [delegate getRunnigSINumber];
    NSString *stringPremiDasarSekaligus = [dictULBasicPlanData valueForKey:@"Premium"];
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName2').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate2').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode2').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch2').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringSINumber2').innerHTML =\"%@\";", stringSINumber2]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTableSummary1(%i,%i,'%@','%@','%@','%@','%@',%@);", laAge,numberOfRow,stringPremiDasarSekaligus,topUpYear,topUpAmount,withDrawYear,withDrawAmount,jsonInsuranceChargeString]];
}

-(void)loadDataPage3{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    NSMutableDictionary* dictULBasicPlanData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];
    arraySpecialOption = [delegate getULSpecialOptionArray];
    
    NSArray *filteredTopUp = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"TopUp"]];
    NSArray *filteredTopUpYear=[[NSArray alloc]initWithArray:[filteredTopUp valueForKey:@"Year"]];
    NSArray *filteredTopUpAmount=[[NSArray alloc]initWithArray:[filteredTopUp valueForKey:@"Amount"]];
    
    NSArray *filteredWithDraw = [arraySpecialOption filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Option == %@)", @"WithDraw"]];
    NSArray *filteredWithDrawYear=[[NSArray alloc]initWithArray:[filteredWithDraw valueForKey:@"Year"]];
    NSArray *filteredWithDrawAmount=[[NSArray alloc]initWithArray:[filteredWithDraw valueForKey:@"Amount"]];
    
    NSString* topUpYear = [filteredTopUpYear  componentsJoinedByString:@","];
    NSString* topUpAmount = [filteredTopUpAmount  componentsJoinedByString:@","];
    
    NSString* withDrawYear= [filteredWithDrawYear componentsJoinedByString:@","];
    NSString* withDrawAmount = [filteredWithDrawAmount componentsJoinedByString:@","];
    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getULFundAllocationDictionary]];
    
    int laAge = [[dictPOLAData valueForKey:@"LA_Age"] intValue];
    int numberOfRow=15;
    
    NSMutableArray* rateBasicCharge = [[NSMutableArray alloc]initWithArray:[self getBasicChargeRate:laAge Gender:[dictPOLAData valueForKey:@"LA_Gender"] Smoker:[dictPOLAData valueForKey:@"LA_Smoker"]]];
    
    NSDictionary* dictInsuranceCharges = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:laAge],@"LAAge",[dictULBasicPlanData valueForKey:@"ExtraPremiumPercentage"],@"EMPercent",[dictULBasicPlanData valueForKey:@"ExtraPremiumMil"],@"EMMil",[formatter convertNumberFromStringCurrency:[dictULBasicPlanData valueForKey:@"SumAssured"]],@"SumAssured",rateBasicCharge,@"Rate",@"99",@"AlternativePremiHoliday",@"0",@"RTUPremi",[dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"],@"IDRFixedIncomeFund",[dictFundAllocationData valueForKey:@"IDREquityIncomeFund"],@"IDREquityIncomeFund",[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"],@"USDFixedIncomeFund",[dictFundAllocationData valueForKey:@"USDEquityIncomeFund"],@"USDEquityIncomeFund",[dictULBasicPlanData valueForKey:@"PaymentCurrency"],@"PaymentCurrency", nil];
    
    
    NSString *jsonInsuranceChargeString;
    NSError *error;
    NSData *jsonInsuranceChargeData = [NSJSONSerialization dataWithJSONObject:dictInsuranceCharges
                                                                      options:0 // Pass 0 if you don't care about the readability of the generated string
                                                                        error:&error];
    
    if (! jsonInsuranceChargeData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonInsuranceChargeString = [[NSString alloc] initWithData:jsonInsuranceChargeData encoding:NSUTF8StringEncoding];
    }

    
    NSString *stringSINumber3 = [delegate getRunnigSINumber];
    NSString *stringPremiDasarSekaligus = [dictULBasicPlanData valueForKey:@"Premium"];
    
    //footer agent data
    NSString *javaScriptF1 = [NSString stringWithFormat:@"document.getElementById('FooterAgentName3').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentName"]];
    NSString *javaScriptF2 = [NSString stringWithFormat:@"document.getElementById('FooterPrintDate3').innerHTML =\"%@\";",[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"]];
    NSString *javaScriptF3 = [NSString stringWithFormat:@"document.getElementById('FooterAgentCode3').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"AgentCode"]];
    NSString *javaScriptF4 = [NSString stringWithFormat:@"document.getElementById('FooterBranch3').innerHTML =\"%@\";", [dictionaryForAgentProfile valueForKey:@"BranchName"]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('stringSINumber3').innerHTML =\"%@\";", stringSINumber3]];
    
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF1];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF2];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF3];
    [webIlustration stringByEvaluatingJavaScriptFromString:javaScriptF4];
    
    //[webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTableSummary2(%i,%i,'%@','%@','%@','%@','%@');", laAge,numberOfRow,stringPremiDasarSekaligus,topUpYear,topUpAmount,withDrawYear,withDrawAmount]];
    [webIlustration stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"createTableSummary2(%i,%i,'%@','%@','%@','%@','%@',%@);", laAge,numberOfRow,stringPremiDasarSekaligus,topUpYear,topUpAmount,withDrawYear,withDrawAmount,jsonInsuranceChargeString]];
}

-(NSMutableArray *)getBasicChargeRate:(int)LAAge Gender:(NSString *)stringGender Smoker:(NSString *)stringSmoker{
    NSMutableArray* arrayRate = [[NSMutableArray alloc]init];
    NSString* rateType;
    
    if ([stringSmoker isEqualToString:@"Y"]){
        if ([stringGender isEqualToString:@"MALE"]){
            rateType = @"MS";
        }
        else{
            rateType = @"FS";
        }
    }
    else{
        if ([stringGender isEqualToString:@"MALE"]){
            rateType = @"MNS";
        }
        else{
            rateType = @"FNS";
        }
    }
    arrayRate = [rateModel getBasicChargesRate:rateType EntryAge:LAAge];
    
    return arrayRate;
}

-(void)loadPDF:(NSString *)pdfOutput{
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    
    NSString *sexPO;
    if ([[dictPOLAData valueForKey:@"PO_Gender"] isEqualToString:@"MALE"]){
        sexPO=@"Bapak";
    }
    else{
        sexPO=@"Ibu";
    }
    
    NSString* AgentName = [dictionaryForAgentProfile valueForKey:@"AgentName"];
    NSString *mailComposerText=[NSString stringWithFormat:@"Kepada %@ %@ <br/><br/>Calon Nasabah BCA Life,Terima kasih atas kesempatan yang diberikan kepada Financial Advisor kami %@ untuk menjelaskan mengenai produk perlindungan asuransi yang %@ butuhkan. <br/><br/>Terlampir kami kirimkan Ilustrasi yang sudah dibuat oleh Financial Advisor kami. Silahkan buka dan pelajari apakah sudah sesuai dengan kebutuhan jaminan masa depan %@. <br/><br/>Untuk informasi produk asuransi lainnya, silahkan mengunjungi website kami di www.bcalife.co.id atau menghubungi customer service HALO BCA 1500888.<br/><br/>Terima Kasih<br/>PT Asuransi Jiwa BCA",sexPO,[dictPOLAData valueForKey:@"PO_Name"],AgentName,sexPO,sexPO];
    
    ProspectProfile* pp;
    int clinetID = [[dictPOLAData valueForKey:@"PO_ClientID"] intValue];
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
    
    BOOL illustrationSigned = [modelSIMaster isSignedIlustration:[dictPOLAData valueForKey:@"SINO"]];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfOutput password:nil];
    
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.bodyEmail = mailComposerText;
    readerViewController.subjectEmail = [NSString stringWithFormat:@"BCALife Illustration %@",[dictPOLAData valueForKey:@"SINO"]];
    readerViewController.POName = [dictPOLAData valueForKey:@"PO_Name"];
    readerViewController.POKtp = idTypeNo;
    readerViewController.AgentName = [dictionaryForAgentProfile valueForKey:@"AgentName"];
    readerViewController.AgentKTP = [dictionaryForAgentProfile valueForKey:@"AgentCode"];
    readerViewController.IsInternalStaff = [NSNumber numberWithInt:1];
    readerViewController.illustrationSignature = illustrationSigned;
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
    NSData *pdfData = [render printToPDFFile];
    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    if (pdfData) {
        //[pdfData writeToFile:[NSString stringWithFormat:@"%@/BCA Life Unit Linked_%@.pdf",documentsDirectory,[delegate getRunnigSINumber]] atomically:YES];
        [pdfData writeToFile:[NSString stringWithFormat:@"%@/BCA Life Proteksi & Investasiku_%@.pdf",documentsDirectory,[delegate getRunnigSINumber]] atomically:YES];
    }
    else
    {
        NSLog(@"PDF couldnot be created");
    }
    [webIlustration setHidden:YES];
    //[self loadPDF:[NSString stringWithFormat:@"%@/BCA Life Unit Linked_%@.pdf",documentsDirectory,[delegate getRunnigSINumber]]];
    [self loadPDF:[NSString stringWithFormat:@"%@/BCA Life Proteksi & Investasiku_%@.pdf",documentsDirectory,[delegate getRunnigSINumber]]];
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
    pdfNeedToLoad=FALSE;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)dismissReaderViewControllerWithReload:(ReaderViewController *)viewController{
    pdfNeedToLoad=TRUE;
    NSMutableDictionary* dictPOLAData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getPOLADictionary]];
    [modelSIMaster signIlustrationMaster:[dictPOLAData valueForKey:@"SINO"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadDataPage1];
    [self loadDataPage2];
    [self loadDataPage3];
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

@end
@implementation UIPrintPageRenderer (PDFFile)
- (NSData*) printToPDFFile
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
