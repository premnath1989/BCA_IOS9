//
//  PremiumViewController.m
//  HLA
//
//  Created by shawal sapuan on 9/11/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PremiumViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"
#import "RiderViewController.h"
#import "LoginDBManagement.h"
#import "UIView+viewRecursion.h"

@interface PremiumViewController (){
    NSNumberFormatter *Premformatter;
    UIColor *themeColour;
}

@end

@implementation PremiumViewController
@synthesize lblMessage, delegate, simpan;
@synthesize WebView;
@synthesize requestBasicSA,requestBasicHL,requestMOP,requestTerm,requestPlanCode,requestSINo,requestAge,requestOccpCode;
@synthesize basicRate,LSDRate,riderCode,riderSA,riderHL1K,riderHL100,riderHLP,riderRate,riderTerm;
@synthesize riderDesc,planCodeRider,riderUnit,riderPlanOpt,riderDeduct,pentaSQL;
@synthesize plnOptC,planOptHMM,deducHMM,planHSPII,planMGII,planMGIV,PremiType;
@synthesize riderAge,riderCustCode,riderSmoker,Pertanggungan_ExtrePremi,ExtraPremiNumbValue;
@synthesize annualRiderTot,halfRiderTot,quarterRiderTot,monthRiderTot;
@synthesize htmlRider,occLoad,annualRider,halfYearRider,quarterRider,monthlyRider,annualRiderSum,halfRiderSum,monthRiderSum,quarterRiderSum,annualRiderOnly,halfYearRiderOnly,quarterRiderOnly,monthlyRiderOnly;
@synthesize premBH,age,riderSex,sex,waiverRiderAnn,waiverRiderHalf,waiverRiderQuar,waiverRiderMonth;
@synthesize basicPremAnn,basicPremHalf,basicPremMonth,basicPremQuar,ReportHMMRates;
@synthesize waiverRiderAnn2,waiverRiderHalf2,waiverRiderMonth2,waiverRiderQuar2,ReportFromAge,ReportToAge;
@synthesize riderOccp,strOccp,occLoadRider,getAge,SINo,getOccpCode,getMOP,getTerm,getBasicSA,getBasicHL,getPlanCode,getOccpClass;
@synthesize getBasicTempHL,requestBasicTempHL,requestOccpClass;
@synthesize BasicAnnually,BasicHalfYear,BasicMonthly,BasicQuarterly,getBasicPlan,requestBasicPlan,RelWithLA;
@synthesize OccpLoadA,OccpLoadH,OccpLoadM,OccpLoadQ;
@synthesize BasicHLAnnually,BasicHLHalfYear,BasicHLMonthly,BasicHLQuarterly;
@synthesize LSDAnnually,LSDHalfYear,LSDMonthly,LSDQuarterly;
@synthesize basicTotalA,basicTotalM,basicTotalQ,basicTotalS,riderTempHL1K,headerTitle,myToolBar,fromReport,EAPPorSI,premPayOpt,executeMHI;
//@synthesize simenu = _simenu;
@synthesize gstPremAnn, gstPremHalf, gstPremQuar, gstPremMonth, Highlight,LASex;
@synthesize navItem;
@synthesize navigationBar;
+(NSString *)getMsgTypeL100
{
    return @"MsgTypeL100";
}

+(NSString *)getMsgTypeWealthPlan
{
    return @"MsgTypeWealthPlan";
}

- (void)viewDidAppear:(BOOL)animated{
    [self calculateReport];
    [self checkEditingMode];
}

- (void) checkEditingMode {
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:[self.requestSINo description]];
    NSLog(@" Edit Mode %@ : %@", EditMode, SINo);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] == NSOrderedSame){
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=NO;
            }
        }
    }else{
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=YES;
            }
        }
    }
}
-(void)setPremiumDictionary:(NSMutableDictionary *)premiumDictionary{
    dictionaryPremium = [[NSMutableDictionary alloc]initWithDictionary:premiumDictionary];
   [heritageCalculation setPremiumDictionary:premiumDictionary];
    if ([[dictionaryPremium valueForKey:@"ProductCode"] isEqualToString:@"BCALKK"]){
        [viewSubTotal setHidden:NO];
    }
    else{
        [viewSubTotal setHidden:YES];
    }
    _Pertanggungan_Dasar = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    _PayorAge = [[dictionaryPremium valueForKey:@"PO_Age"]integerValue];;
    _PayorSex = [dictionaryPremium valueForKey:@"PO_Gender"];
    PremiType = [dictionaryPremium valueForKey:@"Payment_Term"];
    RelWithLA = [dictionaryPremium valueForKey:@"RelWithLA"];
    Highlight =[dictionaryPremium valueForKey:@"Payment_Frequency"];
    Pertanggungan_ExtrePremi = [[dictionaryPremium valueForKey:@"ExtraPremiumTerm"] longLongValue];
    ExtraPremiNumbValue  = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] longLongValue];
    LASex = [dictionaryPremium valueForKey:@"LA_Gender"];
    _LAAge = [[dictionaryPremium valueForKey:@"LA_Age"]integerValue];
    _LAAge = [[dictionaryPremium valueForKey:@"LA_Age"]integerValue];
    _ExtraPercentagePremi = [dictionaryPremium valueForKey:@"ExtraPremiumPercentage"];

    /*[self AnsuransiDasar];
    [self PremiDasarActB];
    [self ExtraPremiNumber];
    [self SubTotal];
    [self PremiDasarActB];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    heritageCalculation = [[HeritageCalculation alloc]init];
    classFormatter=[[Formatter alloc]init];
    
    Premformatter = [[NSNumberFormatter alloc] init];
    //[Premformatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [Premformatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [Premformatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [Premformatter setGeneratesDecimalNumbers:FALSE];
    [Premformatter setMaximumFractionDigits:0];
    [Premformatter setMinimumFractionDigits:0];
    //[Premformatter setCurrencySymbol:@""];
    [Premformatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
//    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
//    [newAttributes setObject:[UIFont systemFontOfSize:18] forKey:UITextAttributeFont];
//    [self.navigationBar setTitleTextAttributes:newAttributes];

    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],
                                                           NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]
                                                           }];
    
    
    [self calculateReport];
}

-(void)AnsuransiDasar
{
    NSString *AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    NSString*RatesPremiumRateTunggal;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    if ([PremiType isEqualToString:@"Premi Tunggal"])
    {
        if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",_PayorSex,@"HRT",@"S",_PayorAge];
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                    RatesPremiumRateTunggal  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRateTunggal  = [results stringForColumn:@"Female"];
                }
                
            }
            
        }
        else
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",@"S",_LAAge];
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                    RatesPremiumRateTunggal  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRateTunggal  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }
 
   }
    else
    {
        if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",_PayorSex,@"HRT",@"R",_PayorAge];
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                    RatesPremiumRate  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRate  = [results stringForColumn:@"Female"];
                }
                
            }
            
        }
        else
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",@"R",_LAAge];
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                    RatesPremiumRate  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRate  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }

    }

    int PaymentModeYear;
    int PaymentModeMonthly;
    
    PaymentModeYear = 1;
    PaymentModeMonthly = 0.1;
    
    if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
    {
        
        //lblAsuransiDasarSekaligus.textColor =[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblAsuransiDasarSekaligus.textColor = themeColour;
        lblAsuransiDasarBulanan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblAsuransiDasarTahunan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
    }
    else if ([Highlight isEqualToString:@"Bulanan"])
    {
        
        lblAsuransiDasarSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblAsuransiDasarBulanan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblAsuransiDasarTahunan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
    }
    else if ([Highlight isEqualToString:@"Tahunan"])
    {
        
        lblAsuransiDasarSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblAsuransiDasarBulanan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblAsuransiDasarTahunan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
    }
    
    double RatesInt = [RatesPremiumRate doubleValue];
    double RatesIntTunggal = [RatesPremiumRateTunggal doubleValue];
    
    
    _AnssubtotalSekaligus =(_Pertanggungan_Dasar/1000)*(PaymentModeYear * RatesIntTunggal);
    _AnssubtotalYear =(_Pertanggungan_Dasar/1000)*(PaymentModeYear * RatesInt);
    _AnssubtotalBulan =(_Pertanggungan_Dasar/1000)*(0.1 * RatesInt);
    
    NSNumber* numberSekaligus=[NSNumber numberWithLongLong:_AnssubtotalSekaligus];
    NSNumber* numberYear=[NSNumber numberWithLongLong:_AnssubtotalYear];
    NSNumber* numberBulan=[NSNumber numberWithLongLong:_AnssubtotalBulan];
    
    [lblAsuransiDasarSekaligus setText:[Premformatter stringFromNumber:numberSekaligus]/*[NSString stringWithFormat:@"%d", _AnssubtotalSekaligus]*/];
    [lblAsuransiDasarTahunan setText:[Premformatter stringFromNumber:numberYear]/*[NSString stringWithFormat:@"%d", _AnssubtotalYear]*/];
    //int RatesInt = [RatesPremiumRate intValue];
    [lblAsuransiDasarBulanan setText:[Premformatter stringFromNumber:numberBulan]/*[NSString stringWithFormat:@"%d", _AnssubtotalBulan]*/];
 }

-(void)PremiDasarActB
{
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    NSString*RatesPremiumRate;
    NSString*RatesPremiumRateSekaligus;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    if ([PremiType isEqualToString:@"Premi Tunggal"])
    {
   
        if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",_PayorSex,@"HRT",@"S",_PayorAge];
            NSLog(@"query %@",AnsuransiDasarQuery);
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                    RatesPremiumRateSekaligus  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRateSekaligus  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }
        else
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",@"S",_LAAge];
            NSLog(@"query %@",AnsuransiDasarQuery);
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                    RatesPremiumRateSekaligus  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRateSekaligus  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }
        
    }
    else
    {

    
   
        if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",_PayorSex,@"HRT",@"R",_PayorAge];
            NSLog(@"query %@",AnsuransiDasarQuery);
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                    RatesPremiumRate  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRate  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }
        else
        {
            AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",LASex,@"HRT",@"R",_LAAge];
            NSLog(@"query %@",AnsuransiDasarQuery);
            results = [database executeQuery:AnsuransiDasarQuery];
            
            while([results next])
            {
                if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                    RatesPremiumRate  = [results stringForColumn:@"Male"];
                }
                else{
                    RatesPremiumRate  = [results stringForColumn:@"Female"];
                }
                
            }
            
            
        }

    }
   
    
//        int PaymentModeYear;
//        int PaymentModeMonthly;
//
//        PaymentMode = 1;
//        PaymentMode = 0.1;
    
    
    double RatesInt = [RatesPremiumRate doubleValue];
    double RatesIntSekaligus = [RatesPremiumRateSekaligus doubleValue];
    
    
    
    float percent = [_ExtraPercentagePremi floatValue] / 100.0f;
    
    double RatesIntSekaligusPerc = percent * RatesIntSekaligus;
   
    double RatesIntPerc;
    
     if ([PremiType isEqualToString:@"Premi Tunggal"])
     {
          RatesIntPerc = percent * RatesIntSekaligus;
     }
    else
    {
         RatesIntPerc = percent * RatesInt;
    }
    
    
    long long totalDivide =(_Pertanggungan_Dasar/1000);
    
    double valueofTotal =(1.0 * RatesIntPerc);
    
    double total =(totalDivide * valueofTotal);
    //  [_basicPremiField setText:[NSString stringWithFormat:@"%d", total]];
    
    
    double totalB = total * Pertanggungan_ExtrePremi;
    
//    double TotalAB = TotalA + totalB;

    

    //_ExtraPercentsubtotalSekaligus=percent *RatesIntSekaligus*1.0*(_Pertanggungan_Dasar/1000)-_ExtraNumbsubtotalYear; //(_Pertanggungan_Dasar/1000)*(1.0 * RatesIntSekaligus)*Pertanggungan_ExtrePremi*percent;
    _ExtraPercentsubtotalSekaligus=percent *RatesIntSekaligus*1.0*(_Pertanggungan_Dasar/1000);
    _ExtraPercentsubtotalYear =percent *RatesInt*1.0*(_Pertanggungan_Dasar/1000);//-_ExtraNumbsubtotalYear;
    _ExtraPercentsubtotalBulan =percent *RatesInt*0.1*(_Pertanggungan_Dasar/1000);//-_ExtraNumbsubtotalBulan);
    
    NSNumber* numberSekaligus=[NSNumber numberWithLongLong:_ExtraPercentsubtotalSekaligus];
    NSNumber* numberYear=[NSNumber numberWithLongLong:_ExtraPercentsubtotalYear];
    NSNumber* numberBulan=[NSNumber numberWithLongLong:_ExtraPercentsubtotalBulan];
    
    [lblExtraPremiPercentSekaligus setText:[Premformatter stringFromNumber:numberSekaligus]];
    [lblExtraPremiPercentTahunan setText:[Premformatter stringFromNumber:numberYear]];
    //int RatesInt = [RatesPremiumRate intValue];
    [lblExtraPremiPercentBulanan setText:[Premformatter stringFromNumber:numberBulan]];
    
    if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
    {
        lblExtraPremiPercentSekaligus.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblExtraPremiPercentBulanan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiPercentTahunan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        
    }
    else if ([Highlight isEqualToString:@"Bulanan"])
    {
        
        lblExtraPremiPercentSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiPercentBulanan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblExtraPremiPercentTahunan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
    }
    else if ([Highlight isEqualToString:@"Tahunan"])
    {
        
        lblExtraPremiPercentSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiPercentBulanan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiPercentTahunan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
    }

 }


-(void)ExtraPremiNumber
{
//    NSString*AnsuransiDasarQuery;
//    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsPath2 = [paths2 objectAtIndex:0];
//    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:path2];
//    [database open];
//    FMResultSet *results;
//    AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT %@ FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",_PayorSex,@"HRT",@"S",_PayorAge];
//    results = [database executeQuery:AnsuransiDasarQuery];
//    
//    NSString*RatesPremiumRate;
//    int PaymentModeYear;
//    int PaymentModeMonthly;
//    FMDatabase *database1 = [FMDatabase databaseWithPath:path2];
//    if (![database open])
//    {
//        NSLog(@"Could not open db.");
//    }
//    
//    while([results next])
//    {
//        if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
//            RatesPremiumRate  = [results stringForColumn:@"Male"];
//        }
//        else{
//            RatesPremiumRate  = [results stringForColumn:@"Female"];
//        }
//        
//    }
    
    
//    PaymentModeYear = 1;
//    PaymentModeMonthly = 0.1;
    
    
//    int RatesInt = [RatesPremiumRate intValue];

    
    _ExtraNumbsubtotalYear =(ExtraPremiNumbValue* 1.0) *(_Pertanggungan_Dasar/1000);
    _ExtraNumbsubtotalBulan =(ExtraPremiNumbValue* 0.1) *(_Pertanggungan_Dasar/1000);
    
    NSNumber* numberYear=[NSNumber numberWithLongLong:_ExtraNumbsubtotalYear];
    NSNumber* numberBulan=[NSNumber numberWithLongLong:_ExtraNumbsubtotalBulan];

    [lblExtraPremiNumberTahunan setText:[Premformatter stringFromNumber:numberYear]];
    [lblExtraPremiNumberSekaligus setText:[Premformatter stringFromNumber:numberYear]];
    //int RatesInt = [RatesPremiumRate intValue];
    [lblExtraPremiNumberBulanan setText:[Premformatter stringFromNumber:numberBulan]];
    
    if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
    {
        lblExtraPremiNumberSekaligus.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblExtraPremiNumberBulanan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiNumberTahunan.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        
    }
    else if ([Highlight isEqualToString:@"Bulanan"])
    {
        
        lblExtraPremiNumberSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiNumberBulanan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblExtraPremiNumberTahunan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
    }
    else if ([Highlight isEqualToString:@"Tahunan"])
    {
        
        lblExtraPremiNumberSekaligus.textColor = [UIColor clearColor];//[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiNumberBulanan.textColor = [UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1];
        lblExtraPremiNumberTahunan.textColor = themeColour;//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
    }

    
}

-(void)SubTotal
{
    long long totalYear = (_AnssubtotalYear + _ExtraNumbsubtotalYear + _ExtraPercentsubtotalYear);
    
    long long totalBulanan = (_AnssubtotalBulan + _ExtraNumbsubtotalBulan + _ExtraPercentsubtotalBulan);
    
    long long totalSekaligus = (_AnssubtotalSekaligus + _ExtraNumbsubtotalYear + _ExtraPercentsubtotalSekaligus);
    
    NSString *year =[@(totalYear)stringValue];
    NSString *Bulan =[@(totalBulanan)stringValue];
    NSString *Sekaligus =[@(totalSekaligus)stringValue];

    NSNumber* numberSekaligus=[NSNumber numberWithLongLong:totalSekaligus];
    NSNumber* numberYear=[NSNumber numberWithLongLong:totalYear];
    NSNumber* numberBulan=[NSNumber numberWithLongLong:totalBulanan];

    [lblSubtotalBulanan setText:[Premformatter stringFromNumber:numberBulan]];
    [lblSubtotalSekaligus setText:[Premformatter stringFromNumber:numberSekaligus]];
    [lblSubtotalTahunan setText:[Premformatter stringFromNumber:numberYear]];
    
    [lblTotalBulanan setText:[Premformatter stringFromNumber:numberBulan]];
    [lblTotalSekaligus setText:[Premformatter stringFromNumber:numberSekaligus]];
    [lblTotalTahunan setText:[Premformatter stringFromNumber:numberYear]];
    
    if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
    {
        lblSubtotalSekaligus.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblTotalSekaligus.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        
        lblSubtotalBulanan.textColor =[UIColor whiteColor];
        lblTotalBulanan.textColor = [UIColor whiteColor];
        
        lblTotalTahunan.textColor = [UIColor whiteColor];
        lblSubtotalTahunan.textColor = [UIColor whiteColor];
        
        [lblTotalBulanan setText:[Premformatter stringFromNumber:[NSNumber numberWithInt:0]]];
        [lblTotalTahunan setText:[Premformatter stringFromNumber:[NSNumber numberWithInt:0]]];
    }
    else if ([Highlight isEqualToString:@"Bulanan"])
    {
        lblSubtotalSekaligus.textColor = [UIColor whiteColor];
        lblTotalSekaligus.textColor = [UIColor whiteColor];
        
        lblSubtotalBulanan.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblTotalBulanan.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        
        lblTotalTahunan.textColor = [UIColor whiteColor];
        lblSubtotalTahunan.textColor = [UIColor whiteColor];
        
        [lblTotalSekaligus setText:[Premformatter stringFromNumber:[NSNumber numberWithInt:0]]];
    }
    else if ([Highlight isEqualToString:@"Tahunan"])
    {
        lblSubtotalSekaligus.textColor = [UIColor whiteColor];
        lblTotalSekaligus.textColor = [UIColor whiteColor];
        
        lblSubtotalBulanan.textColor =[UIColor whiteColor];
        lblTotalBulanan.textColor = [UIColor whiteColor];
        
        lblTotalTahunan.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];
        lblSubtotalTahunan.textColor = [UIColor whiteColor];//[UIColor colorWithRed:250.0f/255.0f green:175.0f/255.0f blue:50.0f/255.0f alpha:1];    }
        
        [lblTotalSekaligus setText:[Premformatter stringFromNumber:[NSNumber numberWithInt:0]]];
    }
}

-(void)calculateReport
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HLA_Rates.sqlite"];
        
    getAge = self.requestAge;
    getOccpClass = self.requestOccpClass;
    getOccpCode = [self.requestOccpCode description];
    SINo = [self.requestSINo description];
    getMOP = self.requestMOP;
    getTerm = self.requestTerm;
    getBasicSA = [self.requestBasicSA description];
    getBasicHL = [self.requestBasicHL description];
    getBasicTempHL = [self.requestBasicTempHL description];
    getPlanCode = [self.requestPlanCode description];
    getBasicPlan = [self.requestBasicPlan description];
    
    // ----------- edited by heng
    [self setMHIMessage];
    // ------------- end -------------
    
    [self getBasicSIRate:getAge toAge:getAge];
    [self getLSDRate];
    [self getOccLoad];
    
    [self deleteSIStorePremium]; //heng's part for SI Report
    [self checkExistRider];
    [self calculateBasicPremium];
    
    if ([riderCode count] != 0) {
        [self calculateRiderPrem];
        [self calculateWaiver];
        if ([executeMHI isEqualToString:@"YES"]) {
            if ([self calculateCIBenefit] < 4000000) {
                [self MHIGuideLines : [requestBasicSA doubleValue]];
                [self calculateCIBenefit]; //do the final round of checking CI benefit to prompt message to user
            }
        }
    }
    [self updateSIStore];
    [self preparedHTMLTable];
    
    if ((getMOP == 9 && [getBasicSA intValue] < 1000 && getAge >= 66 && getAge <= 70)||
        (getMOP == 9 && [getBasicSA intValue] >= 1000 && getAge >= 68 && getAge <= 70)||
        (getMOP == 12 && [getBasicSA intValue] < 1000 && getAge >= 59 && getAge <= 70)||
        (getMOP == 12 && [getBasicSA intValue] >= 1000 && getAge >= 61 && getAge <= 70)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please note that the Guaranteed Benefit payout for selected plan maybe lesser than total premium outlay." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    
    if ([EAPPorSI isEqualToString:@"eAPP"]) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"e-Application Checklist" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissEApp)];
        navItem.leftBarButtonItem = leftItem;
    }
}

-(void) setMHIMessage
{
    NSString *type = nil;
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        type = @"Desired Annual Premium";
    } else {
        type = @"Basic Sum Assured";
    }
    
    AppDelegate *delegate= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    if ( [delegate.MhiMessage length]>0 ) {
        
        NSString *RevisedSumAssured = delegate.MhiMessage;
        if (requestBasicSA > RevisedSumAssured ) {
            lblMessage.text = @"";
            lblMessage.hidden = TRUE;
        } else {
            lblMessage.text = [NSString stringWithFormat:@"%@ will be increased to RM%@ in accordance to MHI Guideline. ",type,RevisedSumAssured];
            lblMessage.hidden = FALSE;
        }
    } else {
        lblMessage.hidden = TRUE;
    }
}

-(double) getFormattedRates:(NSString *) ratesStr
{
    NSString *newString = [ratesStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    double d = [newString doubleValue];   
    
    return d;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)viewWillAppear:(BOOL)animated
{    
    self.view.frame = CGRectMake(-5, 0, 785, 1004);
    [super viewWillAppear:animated];
    [self setMHIMessage];
}

#pragma mark - Calculation

-(void)preparedHTMLTable
{    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bg10.jpg"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];
    
    double BasicSA = [getBasicSA doubleValue];
    
    NSString *displayLSD = nil;
    if (BasicSA < 1200) {
        displayLSD = @"Policy Fee Loading";
    } else {
        displayLSD = @"Large Size Discount";
    }	
    
    NSString *baseHtml =  @"<html>"
                            "<body style=\"background-image:url(%@)\">"
                            "<br><br><br>"
                            "<table border='1' width='80%%' align='center' style='border-collapse:collapse; border-color:gray;'> "
                            "<tr>"
                            "<td width='32%%' align='center' style='height:45px; background-color:#4F81BD;'>&nbsp;</td>"
                            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Annually</font></td>"
                            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Semi-Annually</font></td>"
                            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Quarterly</font></td>"
                            "<td width='17%%' align='center' style='height:45px; background-color:#4F81BD;'><font face='TreBuchet MS' size='4'>Monthly</font></td>"
                            "</tr>"
                            "<tr>"
                            "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>Basic Plan</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "</tr>"
                            "<tr>"
                            "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>Occupational Loading</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "</tr>"
                            "<tr>"
                            "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>Health Loading</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "</tr>"
                            "<tr>"
                            "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "</tr>"
                            "<tr>"
                            "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>Sub-Total</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                            "</tr>";
    
    NSString *htmlBasic = nil;
    NSString *htmlTail = nil;
    
    double _annualSUM = annualRiderSum + basicPremAnn;
    double _halfSUM = halfRiderSum + basicPremHalf;
    double _quarterSUM = quarterRiderSum + basicPremQuar;
    double _monthSUM = monthRiderSum + basicPremMonth;
    
    if (_halfSUM < 200) {
        _halfSUM = 0;
    }
    
    if (_quarterSUM < 150) {
        _quarterSUM = 0;
    }
    
    if (_monthSUM < 50) {
        _monthSUM = 0;
    }
    NSString *annualSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_annualSUM]];
    NSString *halfSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_halfSUM]];
    NSString *quarterSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_quarterSUM]];
    NSString *monthSUM = [formatter stringFromNumber:[NSNumber numberWithDouble:_monthSUM]];
    
    if ([riderCode count] != 0) {        
        if (![self minimumSumPassable:annualSUM mop:getMOP]) {
            annualSUM = @"-";
            halfSUM = @"-";
            quarterSUM = @"-";
            monthSUM = @"-";
            htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                         ,url, @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", displayLSD, @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-"];
            
            htmlRider = @"<tr>"
                        "<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
                        "</tr>";
            for( int i=0; i<[annRiderCode count]; i++ ) {
                htmlRider = [htmlRider stringByAppendingFormat:
                             @"<tr>"
                             "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                             "<td align='right'><font face='TreBuchet MS' size='3'>a%@</font></td>"
                             "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                             "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                             "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                             "</tr>",[annRiderCode objectAtIndex:i],@"-",@"-",@"-",@"-"];
            }
        } else {
            if ( [[self ShowDashOrSum:halfSUM type:2 calTotal:_halfSUM] isEqualToString:@"-"] ) { //semi
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, @"-", @"-", @"-", OccpLoadA, @"-", @"-", @"-", BasicHLAnnually, @"-", @"-", @"-", displayLSD, LSDAnnually, @"-", @"-", @"-", basicTotalA, @"-", @"-", @"-"];
                halfSUM = @"-";
                quarterSUM = @"-";
                monthSUM = @"-";
            } else if ( [[self ShowDashOrSum:quarterSUM type:3 calTotal:_quarterSUM] isEqualToString:@"-"] ) { //quarter
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, @"-", @"-", OccpLoadA, OccpLoadH, @"-", @"-", BasicHLAnnually, BasicHLHalfYear, @"-", @"-", displayLSD, LSDAnnually, LSDHalfYear, @"-", @"-", basicTotalA, basicTotalS, @"-", @"-"];
                quarterSUM = @"-";
                monthSUM = @"-";
            } else if ( [[self ShowDashOrSum:monthSUM type:4 calTotal:_monthSUM] isEqualToString:@"-"] ) { //monthly
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, BasicQuarterly, @"-", OccpLoadA, OccpLoadH, OccpLoadQ, @"-", BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, @"-", displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, @"-", basicTotalA, basicTotalS, basicTotalQ, @"-"];
                monthSUM = @"-";
            } else {
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, BasicQuarterly, BasicMonthly, OccpLoadA, OccpLoadH, OccpLoadQ, OccpLoadM, BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, BasicHLMonthly, displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, LSDMonthly, basicTotalA, basicTotalS, basicTotalQ, basicTotalM];   
            }
            
        }
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr>"
                    "<td colspan='5'>&nbsp;</td>"
                    "</tr>"
                    "<tr style=\"background-color: black;\">"
                    "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3' color='white'><b>Total</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "</tr>"
                    "</table></body></html>",annualSUM,halfSUM,quarterSUM,monthSUM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlRider];
        htmlString = [htmlString stringByAppendingString:htmlTail];        
        
        NSURL *baseURL = [NSURL URLWithString:@""];
        self.WebView.backgroundColor = [UIColor clearColor];
		self.WebView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
        [self.WebView setOpaque:NO];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
        
    } else {        
        if (![self minimumSumPassable:basicTotalA mop:getMOP]) {
            basicTotalA = @"-";
            basicTotalS = @"-";
            basicTotalQ = @"-";
            basicTotalM = @"-";
            
            htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                         ,url, @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-", displayLSD, @"-", @"-", @"-", @"-", @"-", @"-", @"-", @"-"];
            
        } else {            
            if ( [[self ShowDashOrSum:basicTotalS type:2 calTotal:_halfSUM] isEqualToString:@"-" ] ) { //semi
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, @"-", @"-", @"-", OccpLoadA, @"-", @"-", @"-", BasicHLAnnually, @"-", @"-", @"-", displayLSD, LSDAnnually, @"-", @"-", @"-", basicTotalA, @"-", @"-", @"-"];
                basicTotalS = @"-";
                basicTotalQ = @"-";
                basicTotalM = @"-";
            } else if ( [[self ShowDashOrSum:basicTotalQ type:3 calTotal:_quarterSUM] isEqualToString:@"-" ] ) { //quarter
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, @"-", @"-", OccpLoadA, OccpLoadH, @"-", @"-", BasicHLAnnually, BasicHLHalfYear, @"-", @"-", displayLSD, LSDAnnually, LSDHalfYear, @"-", @"-", basicTotalA, basicTotalS, @"-", @"-"];
                basicTotalQ = @"-";
                basicTotalM = @"-";
            } else if ( [[self ShowDashOrSum:basicTotalM type:4 calTotal:_monthSUM] isEqualToString:@"-"] ) { //monthly
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, BasicQuarterly, @"-", OccpLoadA, OccpLoadH, OccpLoadQ, @"-", BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, @"-", displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, @"-", basicTotalA, basicTotalS, basicTotalQ, @"-"];
                basicTotalM = @"-";
            } else {
                htmlBasic = [[NSString alloc] initWithFormat:baseHtml
                             ,url, BasicAnnually, BasicHalfYear, BasicQuarterly, BasicMonthly, OccpLoadA, OccpLoadH, OccpLoadQ, OccpLoadM, BasicHLAnnually, BasicHLHalfYear, BasicHLQuarterly, BasicHLMonthly, displayLSD, LSDAnnually, LSDHalfYear, LSDQuarterly, LSDMonthly, basicTotalA, basicTotalS, basicTotalQ, basicTotalM]; 
            }
        }
        
        htmlTail = [[NSString alloc] initWithFormat:
                    @"<tr>"
                    "<td colspan='5'>&nbsp;</td>"
                    "</tr>"
                    "<tr style=\"background-color: black;\">"
                    "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3' color='white'><b>Total</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "<td align='right'><font face='TreBuchet MS' size='3' color='white'><b>%@</b></font></td>"
                    "</tr>"
                    "</table></body></html>",basicTotalA, basicTotalS, basicTotalQ, basicTotalM];
        
        NSString *htmlString = [htmlBasic stringByAppendingString:htmlTail];
        NSURL *baseURL = [NSURL URLWithString:@""];
		self.WebView.backgroundColor = [UIColor clearColor];
		self.WebView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
        [self.WebView setOpaque:NO];
        [WebView loadHTMLString:htmlString baseURL:baseURL];
    }
}

-(BOOL)minimumSumPassable:(NSString *) amount mop:(int)mop
{
    BOOL toReturn = true;
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        if (mop == 3) {
            toReturn = [self meetsMinGYI:amount];
        } else {
            AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
            del.allowedToShowReport = true;
        }
    } else if ([getBasicPlan isEqualToString:STR_S100]) {
        toReturn = [self meetsMinModalRequirement:amount];
    }
    
    return toReturn;
}

-(BOOL)meetsMinGYI:(NSString *)amount
{
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    amount = [amount stringByReplacingOccurrencesOfString:@"(" withString:@""];
    amount = [amount stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    float dAmount = [amount floatValue];
    
    AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
    
    if (dAmount<100000) {    
        del.allowedToShowReport = false;        
        if (!fromReport) {
            [self showReportCantDisplay:[PremiumViewController getMsgTypeWealthPlan]];
        }        
        return false;
    } else {
        del.allowedToShowReport = true;
        return true;
    }
}

-(BOOL)meetsMinModalRequirement:(NSString *) amount
{
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    amount = [amount stringByReplacingOccurrencesOfString:@"(" withString:@""];
    amount = [amount stringByReplacingOccurrencesOfString:@")" withString:@""];
    float dAmount = [amount floatValue];
    
    AppDelegate *del = (AppDelegate *) [ [UIApplication sharedApplication] delegate ];
    
    if ([executeMHI isEqualToString:@"YES"]) {
        if (dAmount<= 300) {
            del.allowedToShowReport = false;            
            if (!fromReport) {
                [self showReportCantDisplay:[PremiumViewController getMsgTypeL100]];
            }            
            return false;
        } else {
            del.allowedToShowReport = true;
            return true;
        }
    } else {
        del.allowedToShowReport = true;
        return true;
    }
    
}

-(void)showReportCantDisplay:(NSString*)type
{
    if (![EAPPorSI isEqualToString:@"eAPP"]) {
        NSString *dialogStr = nil;        
        if ([type isEqualToString:[PremiumViewController getMsgTypeWealthPlan]]) {
            dialogStr = @"Limited 3 years premium payment term is only available if the Total Annual Premium of Wealth Plan, EduEnricher and Wealth Enricher Riders is at least RM100,000. Please update premium payment options or increase GYI/RSA amount of said plan/riders.";
        } else if ([type isEqualToString:[PremiumViewController getMsgTypeL100]]) {
            dialogStr = @"Min modal premium requirement not met. Please increase sum assured for basic plan or rider(s)";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:dialogStr delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show];
    }
}

// 2 = semi; 3 = quarter; 4 = monthly
-(NSString *) ShowDashOrSum:(NSString *)amount type:(int)type calTotal:(double)calTotal
{
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];    
    NSString * returningVal = nil;
    double lessThan = 0;
    
    if (type == 2) {
        lessThan = 200;        
    } else if (type == 3) {
        lessThan = 150;
    } else if (type == 4) {
        lessThan = 50;
    }
    
    if (calTotal<lessThan) {   
        returningVal = @"-";
    } else {
        returningVal = amount;
    }
    
    return returningVal;
}

-(void)calculateBasicPremium
{
    double BasicSA = [getBasicSA doubleValue];
    double BasicHLoad = [getBasicHL doubleValue];
    double BasicTempHLoad = [getBasicTempHL doubleValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    //calculate basic premium
    double _BasicAnnually = 0;
    double _BasicHalfYear = 0;
    double _BasicQuarterly = 0;
    double _BasicMonthly = 0;
    
    double pseudoBasicAnnually = 0;
    double pseudoBasicHalfYear = 0;
    double pseudoBasicQuarterly = 0;
    double pseudoBasicMonthly = 0;
    
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        _BasicAnnually = (BasicSA) * annualRate;
        _BasicHalfYear = (BasicSA) * semiAnnualRate;
        _BasicQuarterly = (BasicSA) * quarterlyRate;
        _BasicMonthly = (BasicSA) * monthlyRate;
    } else {
        _BasicAnnually = basicRate * (BasicSA/1000) * annualRate;
        _BasicHalfYear = basicRate * (BasicSA/1000) * semiAnnualRate;
        _BasicQuarterly = basicRate * (BasicSA/1000) * quarterlyRate;
        _BasicMonthly = basicRate * (BasicSA/1000) * monthlyRate;
    }
    
    BasicAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicAnnually]];
    BasicHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicHalfYear]];
    BasicQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicQuarterly]];
    BasicMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_BasicMonthly]];
    double BasicAnnually_ = [[BasicAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHalfYear_ = [[BasicHalfYear stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicQuarterly_ = [[BasicQuarterly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicMonthly_ = [[BasicMonthly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    //calculate occupationLoading
    double _OccpLoadA = 0;
    double _OccpLoadH = 0;
    double _OccpLoadQ = 0;
    double _OccpLoadM = 0;
    int factor = 1;
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        factor = 30;
        
        double pseudoFactor = 0;
        if (getTerm == 30) {
            pseudoFactor = 1.5;
        } else if (getTerm == 50) {
            pseudoFactor = 2.5;
        }
        pseudoBasicAnnually = _BasicAnnually * pseudoFactor * getMOP * annualRate;
        pseudoBasicHalfYear = _BasicHalfYear * pseudoFactor * getMOP * semiAnnualRate;
        pseudoBasicQuarterly = _BasicQuarterly * pseudoFactor * getMOP * quarterlyRate;
        pseudoBasicMonthly = _BasicMonthly * pseudoFactor * getMOP * monthlyRate;
        
    } else if ([getBasicPlan isEqualToString:STR_S100])  {
        factor = 1;
    }
        
    _OccpLoadA = occLoad *factor * (BasicSA/1000) * annualRate;
    _OccpLoadH = occLoad *factor * (BasicSA/1000) * semiAnnualRate;
    _OccpLoadQ = occLoad *factor * (BasicSA/1000) * quarterlyRate;
    _OccpLoadM = occLoad *factor * (BasicSA/1000) * monthlyRate;
    
    OccpLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadA]];
    OccpLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadH]];
    OccpLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadQ]];
    OccpLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:_OccpLoadM]];
    double OccpLoadA_ = [[OccpLoadA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadH_ = [[OccpLoadH stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadQ_ = [[OccpLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double OccpLoadM_ = [[OccpLoadM stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    //calculate basic health loading
    double _BasicHLAnnually = BasicHLoad * (BasicSA/1000) * annualRate;
    double _BasicHLHalfYear = BasicHLoad * (BasicSA/1000) * semiAnnualRate;
    double _BasicHLQuarterly = BasicHLoad * (BasicSA/1000) * quarterlyRate;
    double _BasicHLMonthly = BasicHLoad * (BasicSA/1000) * monthlyRate;
    //calculate basic temporary health loading
    double _BasicTempHLAnnually = BasicTempHLoad * (BasicSA/1000) * annualRate;
    double _BasicTempHLHalfYear = BasicTempHLoad * (BasicSA/1000) * semiAnnualRate;
    double _BasicTempHLQuarterly = BasicTempHLoad * (BasicSA/1000) * quarterlyRate;
    double _BasicTempHLMonthly = BasicTempHLoad * (BasicSA/1000) * monthlyRate;
    
    double _allBasicHLAnn = _BasicHLAnnually + _BasicTempHLAnnually;
    double _allBasicHLHalf = _BasicHLHalfYear + _BasicTempHLHalfYear;
    double _allBasicHLQuar = _BasicHLQuarterly + _BasicTempHLQuarterly;
    double _allBasicHLMonth = _BasicHLMonthly + _BasicTempHLMonthly;
    
    BasicHLAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:_allBasicHLAnn]];
    BasicHLHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:_allBasicHLHalf]];
    BasicHLQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:_allBasicHLQuar]];
    BasicHLMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:_allBasicHLMonth]];
    double BasicHLAnnually_ = [[BasicHLAnnually stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLHalfYear_ = [[BasicHLHalfYear stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLQuarterly_ = [[BasicHLQuarterly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double BasicHLMonthly_ = [[BasicHLMonthly stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    //calculate LSD    
    double _LSDAnnually = LSDRate * (BasicSA/1000) * annualRate;
    double _LSDHalfYear = LSDRate * (BasicSA/1000) * semiAnnualRate;
    double _LSDQuarterly = LSDRate * (BasicSA/1000) * quarterlyRate;
    double _LSDMonthly = LSDRate * (BasicSA/1000) * monthlyRate;
    NSString *LSDAnnually2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDAnnually]];
    NSString *LSDHalfYear2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDHalfYear]];
    NSString *LSDQuarterly2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDQuarterly]];
    NSString *LSDMonthly2 = [formatter stringFromNumber:[NSNumber numberWithDouble:_LSDMonthly]];
    //for negative value
    LSDAnnually2 = [LSDAnnually2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDHalfYear2 = [LSDHalfYear2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDQuarterly2 = [LSDQuarterly2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDMonthly2 = [LSDMonthly2 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    LSDAnnually2 = [LSDAnnually2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDHalfYear2 = [LSDHalfYear2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDQuarterly2 = [LSDQuarterly2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    LSDMonthly2 = [LSDMonthly2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    double LSDAnnually_ = [[LSDAnnually2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDHalfYear_ = [[LSDHalfYear2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDQuarterly_ = [[LSDQuarterly2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double LSDMonthly_ = [[LSDMonthly2 stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    //calculate Total basic premium
    double _basicTotalA = 0;
    double _basicTotalS = 0;
    double _basicTotalQ = 0;	
    double _basicTotalM = 0;
    if (BasicSA < 1200) {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ + LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ + LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ + LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ + LSDMonthly_;
    } else {
        _basicTotalA = BasicAnnually_ + OccpLoadA_ + BasicHLAnnually_ - LSDAnnually_;
        _basicTotalS = BasicHalfYear_ + OccpLoadH_ + BasicHLHalfYear_ - LSDHalfYear_;
        _basicTotalQ = BasicQuarterly_ + OccpLoadQ_ + BasicHLQuarterly_ - LSDQuarterly_;
        _basicTotalM = BasicMonthly_ + OccpLoadM_ + BasicHLMonthly_ - LSDMonthly_;
    }
    
    dblTotalGrossPrem = dblTotalGrossPrem + BasicAnnually_;
    
    LSDAnnually = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDAnnually_]];
    LSDHalfYear = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDHalfYear_]];
    LSDQuarterly = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDQuarterly_]];
    LSDMonthly = [formatter stringFromNumber:[NSNumber numberWithDouble:LSDMonthly_]];
        
    basicTotalA = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalA]];
    basicTotalS = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalS]];
    basicTotalQ = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalQ]];
    basicTotalM = [formatter stringFromNumber:[NSNumber numberWithDouble:_basicTotalM]];
    
    sqlite3_stmt *statement;
    NSString *QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\", \"Annually\", \"SemiAnnually\","
                           " \"Quarterly\", \"Monthly\", 'SINO', 'PremiumWithoutHLoading') VALUES "
                           " (\"B\", \"%@\", \"%@\", \"%@\", \"%@\", '%@', '%f') ", basicTotalA, basicTotalS, basicTotalQ, basicTotalM, SINo, BasicAnnually_];
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
    }
    
    double valueBeforeAdjustedA;
    double valueBeforeAdjustedS;
    double valueBeforeAdjustedQ;
    double valueBeforeAdjustedM;
    if (BasicSA < 1200) {
        valueBeforeAdjustedA = BasicAnnually_ + _OccpLoadA + BasicHLAnnually_ + LSDAnnually_;
        valueBeforeAdjustedS = BasicHalfYear_ + _OccpLoadH + BasicHLHalfYear_ + LSDHalfYear_;
        valueBeforeAdjustedQ = BasicQuarterly_ + _OccpLoadQ + BasicHLQuarterly_ + LSDQuarterly_;
        valueBeforeAdjustedM = BasicMonthly_ + _OccpLoadM + BasicHLMonthly_ + LSDMonthly_;
    } else {
        valueBeforeAdjustedA = BasicAnnually_ + _OccpLoadA + BasicHLAnnually_ - LSDAnnually_;
        valueBeforeAdjustedS = BasicHalfYear_ + _OccpLoadH + BasicHLHalfYear_ - LSDHalfYear_;
        valueBeforeAdjustedQ = BasicQuarterly_ + _OccpLoadQ + BasicHLQuarterly_ - LSDQuarterly_;
        valueBeforeAdjustedM = BasicMonthly_ + _OccpLoadM + BasicHLMonthly_ - LSDMonthly_;
    }
    
    BOOL isAnnValid = FALSE;
    BOOL isSemiAnnValid = FALSE;
    BOOL isQtrValid = FALSE;
    BOOL isMthValid = FALSE;
//    BOOL isSemiAnnValid = (valueBeforeAdjustedS < 200);
//    BOOL isQtrValid = (valueBeforeAdjustedQ < 150);
//    BOOL isMthValid = (valueBeforeAdjustedM < 50);
    QuerySQL = [NSString stringWithFormat: @"INSERT INTO SI_Store_Premium "
                "(\"Type\",\"Annually\",\"SemiAnnually\", \"Quarterly\",\"Monthly\", 'SINO', "
                "\"IsAnnValid\", \"IsSemiAnnValid\", \"IsQtrValid\", \"IsMthValid\") VALUES "
                "(\"BOriginal\", \"%.9f\", \"%.9f\", \"%.9f\", \"%.9f\", '%@', "
                "%d, %d, %d, %d) ",
                valueBeforeAdjustedA, valueBeforeAdjustedS, valueBeforeAdjustedQ, valueBeforeAdjustedM, SINo,
                isAnnValid, isSemiAnnValid, isQtrValid, isMthValid];
    
    if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }    
    sqlite3_close(contactDB);
    //--------------
    basicPremAnn = [[basicTotalA stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremHalf = [[basicTotalS stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremQuar = [[basicTotalQ stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    basicPremMonth = [[basicTotalM stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
}

+(NSString*)getShortSex:(NSString*)sexI
{
    NSString* ret = nil;
    
    if ([sexI isEqualToString:@"MALE"]) {
        ret = @"M";
    } else if ([sexI isEqualToString:@"FEMALE"]) {
        ret = @"F";
    } else {
        ret = sexI;
    }
    
    return ret;
}

-(void)calculateRiderPrem
{
    NSMutableArray *annRiderTitle = [[NSMutableArray alloc] init];
    annRiderCode = [[NSMutableArray alloc] init];
    NSMutableArray *annRiderTerm = [[NSMutableArray alloc] init];
    annualRiderTot = [[NSMutableArray alloc] init];
    halfRiderTot = [[NSMutableArray alloc] init];
    quarterRiderTot = [[NSMutableArray alloc] init];
    monthRiderTot = [[NSMutableArray alloc] init];
    
    waiverRiderAnn = [[NSMutableArray alloc] init];
    waiverRiderHalf = [[NSMutableArray alloc] init];
    waiverRiderQuar = [[NSMutableArray alloc] init];
    waiverRiderMonth = [[NSMutableArray alloc] init];
    waiverRiderAnn2 = [[NSMutableArray alloc] init];
    waiverRiderHalf2 = [[NSMutableArray alloc] init];
    waiverRiderQuar2 = [[NSMutableArray alloc] init];
    waiverRiderMonth2 = [[NSMutableArray alloc] init];
    
    waiverRiderAnnWithoutHLAndOccLoading = [[NSMutableArray alloc] init];
    
    medRiderAnn = [[NSMutableArray alloc] init];
    medRiderHalf = [[NSMutableArray alloc] init];
    medRiderQuar = [[NSMutableArray alloc] init];
    medRiderMonth = [[NSMutableArray alloc] init];
    
    PremWithoutHLoading = [[NSMutableArray alloc] init];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];

    NSString *str_ann = @"";
    NSString *str_half;
    NSString *str_quar;
    NSString *str_month;
    
    NSUInteger i;
    NSString *RidCode;
    for (i=0; i<[riderCode count]; i++) {        
        RidCode = [[NSString alloc] initWithFormat:@"%@",[riderCode objectAtIndex:i]];        
        //getpentacode
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            if ([RidCode isEqualToString:@"C+"]) {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Level"]) {
                    plnOptC = @"L";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Increasing"]) {
                    plnOptC = @"I";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Level_NCB"]) {
                    plnOptC = @"B";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Increasing_NCB"]) {
                    plnOptC = @"N";
                }
                
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"C+\" AND PlanOption=\"%@\"",plnOptC];
                
            } else if ([RidCode isEqualToString:@"HMM"]) {
                planOptHMM = [riderPlanOpt objectAtIndex:i];
                deducHMM = [riderDeduct objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HMM\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planOptHMM,deducHMM,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            } else if ([RidCode isEqualToString:@"HSP_II"]) {
                if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                    planHSPII = @"S";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                    planHSPII = @"D";
                } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                    planHSPII = @"P";
                }
                pentaSQL = [[NSString alloc] initWithFormat:
                            @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"HSP_II\" AND PlanOption=\"%@\"",planHSPII];
            } else if ([RidCode isEqualToString:@"MG_II"]) {
                planMGII = [riderPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_II\" AND PlanOption=\"%@\"",planMGII];
                
            } else if ([RidCode isEqualToString:@"ICR"]) {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"ICR\" AND Smoker=\"%@\"",[riderSmoker objectAtIndex:i]];
                
            } else if ([RidCode isEqualToString:@"MG_IV"]) {
                planMGIV = [riderPlanOpt objectAtIndex:i];
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"MG_IV\" AND PlanOption=\"%@\" AND FromAge <= \"%@\" AND ToAge >= \"%@\"",planMGIV,[riderAge objectAtIndex:i],[riderAge objectAtIndex:i]];
            } else if ([RidCode isEqualToString:@"CIWP"] || [RidCode isEqualToString:@"LCWP"] || [RidCode isEqualToString:@"PR"]||
                       [RidCode isEqualToString:@"SP_STD"] || [RidCode isEqualToString:@"SP_PRE"]) {
                sqlite3_close(contactDB);
                continue;
            } else {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",RidCode];
                if ( [RidCode isEqualToString:@"TPDYLA"] ) {
                    pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",@"ETPD"];
                }
            }
            
            const char *query_stmt = [pentaSQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    planCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        int ridTerm = [[riderTerm objectAtIndex:i] intValue];
        age = [[riderAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[riderSex objectAtIndex:i]];
        sex = [PremiumViewController getShortSex:sex];
        NSString *ageStr = [riderAge objectAtIndex:i];
        NSString *smoker = [riderSmoker objectAtIndex:i];
        
        
        //get rate
        if ([RidCode isEqualToString:@"C+"]) {
            plnOptC = [riderPlanOpt objectAtIndex:i];
            
            [self getRiderRateAgeSexCplus:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr planOptC:plnOptC];
        } else  if ([RidCode isEqualToString:@"CPA"]) {
            [self getRiderRateClass:RidCode riderTerm:ridTerm];
        } else if ([RidCode isEqualToString:@"HSP_II"]) {            
            if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Standard"]) {
                planHSPII = @"S";
            } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Deluxe"]) {
                planHSPII = @"D";
            } else if ([[riderPlanOpt objectAtIndex:i] isEqualToString:@"Premier"]) {
                planHSPII = @"P";
            }
            planHSPII = [riderPlanOpt objectAtIndex:i];
            [self getRiderRateAgeClassHSP_II:RidCode riderTerm:ridTerm planHSPII:planHSPII fromAge:ageStr toAge:ageStr]; 
        } else if ([RidCode isEqualToString:@"PA"] ) {
            [self getRiderRateAgeClassPA:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr]; 
        } else if ([RidCode isEqualToString:@"HB"]) {
            [self getRiderRateClass:RidCode riderTerm:ridTerm];
        } else if ([RidCode isEqualToString:@"MG_IV"]) {
            [self getRiderRateAgeSexClassMG_IV:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr planOption:planMGIV];
        } else if ([RidCode isEqualToString:@"MG_II"]) {
            [self getRiderRateAgeSexClassMG_II:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr planOption:planMGII];
        } else if ([RidCode isEqualToString:@"HMM"]) {
            [self getRiderRateAgeSexClassHMM:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr planOption:planOptHMM hmm:deducHMM];
        } else if ([RidCode isEqualToString:@"ICR"]) {
            [self getRiderRateAgeSexSmoker:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr smoker:smoker];
        } else if ([RidCode isEqualToString:@"EDUWR"] || [RidCode isEqualToString:@"WB30R"] || [RidCode isEqualToString:@"WB50R"]||
                   [RidCode isEqualToString:@"WBD10R30"] || [RidCode isEqualToString:@"WBI6R30"] || [RidCode isEqualToString:@"WBM6R"]) {
            [self getHLAWPRiderRate:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr];
        } else if ([RidCode isEqualToString:@"WP30R"] || [RidCode isEqualToString:@"WP50R"] || [RidCode isEqualToString:@"WPTPD30R"] || [RidCode isEqualToString:@"WPTPD50R"]) {
            [self getHLAWPRiderRateNonGYI:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr];
        } else {
            [self getRiderRateAgeSex:RidCode riderTerm:ridTerm fromAge:ageStr toAge:ageStr];
        }
        
        double BasicSA = [getBasicSA doubleValue];        
        double ridSA = [[riderSA objectAtIndex:i] doubleValue];
        double PolicyTerm = getTerm;
        double riderHLoad = 0;
        double riderTempHLoad = 0;
        
        //--get value rider HL 
        if ([[riderHL1K objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHL1K objectAtIndex:i] doubleValue];
        } else if ([[riderHL100 objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHL100 objectAtIndex:i] doubleValue];
        } else if ([[riderHLP objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHLP objectAtIndex:i] doubleValue];
        }
        
        if ([[riderTempHL1K objectAtIndex:i] doubleValue] > 0) {
            riderTempHLoad = [[riderTempHL1K objectAtIndex:i] doubleValue];
        }
        
        //calculate occupationLoading
        strOccp = [riderOccp objectAtIndex:i];
        [self getOccLoadRider];
        
        double OccpLoadRidA = occLoadRider * ((PolicyTerm + 1)/2) * (BasicSA/1000) * annualRate;
        if ([RidCode isEqualToString:@"TPDYLA"]) {
            [self calculateTPDYLA:ridSA HealthLoading:riderHLoad TempHealthLoading:riderTempHLoad Age:[[riderAge objectAtIndex:i] intValue] AnnualStr:&str_ann Formatter:formatter];
            
        } else if ([RidCode isEqualToString:@"ICR"] || [RidCode isEqualToString:@"EDUWR"]||
                 [RidCode isEqualToString:@"WB30R"] || [RidCode isEqualToString:@"WB50R"]||
                 [RidCode isEqualToString:@"WBD10R30"] || [RidCode isEqualToString:@"WBI6R30"]||
                 [RidCode isEqualToString:@"WP30R"] || [RidCode isEqualToString:@"WP50R"]||
                 [RidCode isEqualToString:@"WPTPD30R"] || [RidCode isEqualToString:@"WPTPD50R"]) {
            [self calculateWealthBoosterRiderPremium:ridSA RiderCode:RidCode RiderTerm:ridTerm HealthLoading:riderHLoad TempHealthLoading:riderTempHLoad AnnualStr:&str_ann Formatter:formatter];
        } else if ([RidCode isEqualToString:@"WBM6R"]) {
            [self calculateWBM6RPremium:ridSA HLoad:riderHLoad THLoad:riderTempHLoad AnnualStr:&str_ann Formatter:formatter];
        } else if ([RidCode isEqualToString:@"MG_II"] || [RidCode isEqualToString:@"MG_IV"] || [RidCode isEqualToString:@"HSP_II"] || [RidCode isEqualToString:@"HMM"]) {
            [self calculateMedicalRiderPremium:riderTempHLoad riderHLoad:riderHLoad RidCode:RidCode AnnualStr:&str_ann];
            
        } else if ([RidCode isEqualToString:@"HB"]) {
            [self calculateHBRiderPremium:i riderTempHLoad:riderTempHLoad riderHLoad:riderHLoad AnnualStr:&str_ann];
            
        } else if ([RidCode isEqualToString:@"CPA"] || [RidCode isEqualToString:@"PA"]||
                 [RidCode isEqualToString:@"ACIR_MPP"] || [RidCode isEqualToString:@"CIR"] || [RidCode isEqualToString:@"C+"]) {
            [self calculateCriticalIllnessRiderPremium:ridSA riderHLoad:riderHLoad riderTempHLoad:riderTempHLoad AnnualStr:&str_ann Formatter:formatter];
        } else {
            double _ann = (riderRate *ridSA /1000 *annualRate);
            double _half = (riderRate *ridSA /1000 *semiAnnualRate);
            double _quar = (riderRate *ridSA /1000 *quarterlyRate);
            double _month = (riderRate *ridSA /1000 *monthlyRate);
            str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
            str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:_half]];
            str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:_quar]];
            str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:_month]];
            str_ann = [str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            //--HL
            
            double _HLAnn = ((riderHLoad + riderTempHLoad) *ridSA /1000 *annualRate);
            double _HLHalf = ((riderHLoad + riderTempHLoad) *ridSA /1000 *semiAnnualRate);
            double _HLQuar = ((riderHLoad + riderTempHLoad) *ridSA /1000 *quarterlyRate);
            double _HLMonth = ((riderHLoad + riderTempHLoad) *ridSA /1000 *monthlyRate);
            
            NSString *str_HLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn]];
            NSString *str_HLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf]];
            NSString *str_HLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar]];
            NSString *str_HLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth]];
            str_HLAnn = [str_HLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_HLHalf = [str_HLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_HLQuar = [str_HLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_HLMonth = [str_HLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            double _TempHLAnn = (0.00*ridSA /1000 *annualRate);
            double _TempHLHalf = (0.00 *ridSA /1000 *semiAnnualRate);
            double _TempHLQuar = (0.00 *ridSA /1000 *quarterlyRate);
            double _TempHLMonth = (0.00 *ridSA /1000 *monthlyRate);
            
            NSString *str_TempHLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLAnn]];
            NSString *str_TempHLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLHalf]];
            NSString *str_TempHLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLQuar]];
            NSString *str_TempHLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLMonth]];
            str_TempHLAnn = [str_TempHLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_TempHLHalf = [str_TempHLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_TempHLQuar = [str_TempHLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_TempHLMonth = [str_TempHLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];            
            //--end
            
            double calLoadA = occLoadRider *ridSA /1000 *annualRate;
            double calLoadH = occLoadRider *ridSA /1000 *semiAnnualRate;
            double calLoadQ = occLoadRider *ridSA /1000 *quarterlyRate;
            double calLoadM = occLoadRider *ridSA /1000 *monthlyRate;
            
            NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
            NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
            NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
            NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
            strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
            strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
                                    
            annualRider = [str_ann doubleValue] +
            [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn + _TempHLAnn + calLoadA]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            
            halfYearRider = [str_half doubleValue] +
            [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf + _TempHLHalf + calLoadH]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            
            quarterRider = [str_quar doubleValue] +
            [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar + _TempHLQuar + calLoadQ]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            
            monthlyRider = [str_month doubleValue] +
            [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth + _TempHLMonth + calLoadM]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
            
            annualRiderOnly = annualRider;
            halfYearRiderOnly = halfYearRider;
            quarterRiderOnly = quarterRider;
            monthlyRiderOnly = monthlyRider;
            
            dblTotalOverallPrem = dblTotalOverallPrem + annualRider;
            
            if (![RidCode isEqualToString:@"PLCP"] && ![RidCode isEqualToString:@"PTR"]) {
                dblTotalGrossPrem = dblTotalGrossPrem + [str_ann doubleValue];
            }

            if ([RidCode isEqualToString:@"HSP_II"]) {
                // For report part ---------- added by heng
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
                    double annualRates;
                    NSString *querySQL;
                    for (int a = 0; a<ReportHMMRates.count; a++) {
                        annualRates = ([[ReportHMMRates objectAtIndex:a] doubleValue ] *ridSA /1000 *a) + (OccpLoadRidA *ridSA /1000 *annualRate) + (riderHLoad *ridSA /1000 *a);
                        
                        querySQL = [NSString stringWithFormat: @"INSERT INTO SI_Store_premium (\"Type\",\"Annually\",\"FromAge\", \"ToAge\", 'SINO') "
                                              " VALUES(\"%@\", \"%.9f\", \"%@\", \"%@\", '%@')",
                                    RidCode, annualRates, [ReportFromAge objectAtIndex:a], [ReportToAge objectAtIndex:a], SINo];
                        
                        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                        {
                            sqlite3_step(statement);
                            sqlite3_finalize(statement);
                        }                        
                    }
                    sqlite3_close(contactDB);
                }                
                // report part end -----------
            }
        }
        
        NSString *calRiderAnnOnly = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRiderOnly]]; //without occ loading, with HL
        NSString *calRiderHalfOnly = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRiderOnly]];
        NSString *calRiderQuarterOnly = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRiderOnly]];
        NSString *calRiderMonthOnly = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRiderOnly]];
        
        NSString *calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]]; // with occ loading and with HL
        NSString *calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
        NSString *calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];
        NSString *calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];

        NSString *calRiderAnnWithoutHLAndOccLoading = [formatter stringFromNumber:[NSNumber numberWithDouble:[str_ann doubleValue]]]; // without occ loading and without HL
        
        calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
        calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
        [annualRiderTot addObject:calRiderAnn];
        [halfRiderTot addObject:calRiderHalf];
        [quarterRiderTot addObject:calRiderQuarter];
        [monthRiderTot addObject:calRiderMonth];
        [annRiderTitle addObject:RidCode];
        [annRiderTerm addObject:[riderTerm objectAtIndex:i]];
        [annRiderCode addObject:RidCode];
        [PremWithoutHLoading addObject:str_ann];
        
        //for waiver CIWP
        if (!([RidCode isEqualToString:@"ACIR_MPP"]) && !([RidCode isEqualToString:@"LCPR"]) && !([RidCode isEqualToString:@"CIR"]) && !([RidCode isEqualToString:@"PR"]) &&
            !([RidCode isEqualToString:@"LCWP"]) && !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) &&
            !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"ICR"])) {
            [waiverRiderAnn addObject:[calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""]]; // change to premium that include occ loading for other riders @ 20141105
            [waiverRiderHalf addObject:[calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [waiverRiderQuar addObject:[calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [waiverRiderMonth addObject:[calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""]];
            
            [waiverRiderAnnWithoutHLAndOccLoading addObject:[calRiderAnnWithoutHLAndOccLoading stringByReplacingOccurrencesOfString:@"," withString:@""]];
        }
        
        //for other waiver
        if (!([RidCode isEqualToString:@"PLCP"]) && !([RidCode isEqualToString:@"CIWP"]) && !([RidCode isEqualToString:@"LCWP"]) &&
            !([RidCode isEqualToString:@"SP_STD"]) && !([RidCode isEqualToString:@"SP_PRE"]) &&
            !([RidCode isEqualToString:@"PR"]) && !([RidCode isEqualToString:@"PTR"])) {
            
            [waiverRiderAnn2 addObject:[calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""]]; // change to premium that include occ loading for other riders
            [waiverRiderHalf2 addObject:[calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [waiverRiderQuar2 addObject:[calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""]];
            [waiverRiderMonth2 addObject:[calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""]];
        }
        
        if ([RidCode isEqualToString:@"MG_II"] || [RidCode isEqualToString:@"MG_IV"] || [RidCode isEqualToString:@"HSP_II"] || [RidCode isEqualToString:@"HMM"]||
           [RidCode isEqualToString:@"HB"] || [RidCode isEqualToString:@"CIR"] || [RidCode isEqualToString:@"ACIR_MPP"] || [RidCode isEqualToString:@"C+"]||
           [RidCode isEqualToString:@"ICR"]) {
            
            if ([RidCode isEqualToString:@"ICR"]) { //premium with occ loading
                [medRiderAnn addObject:[calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderHalf addObject:[calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderQuar addObject:[calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderMonth addObject:[calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""]];
            } else { //premium without occ loading
                [medRiderAnn addObject:[calRiderAnnOnly stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderHalf addObject:[calRiderHalfOnly stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderQuar addObject:[calRiderQuarterOnly stringByReplacingOccurrencesOfString:@"," withString:@""]];
                [medRiderMonth addObject:[calRiderMonthOnly stringByReplacingOccurrencesOfString:@"," withString:@""]];
            }            
        }        
    }
    
    annualRiderSum = 0;
    halfRiderSum = 0;
    quarterRiderSum = 0;
    monthRiderSum = 0;
    
    gstPremAnn = 0;
    gstPremHalf = 0;
    gstPremQuar = 0;
    gstPremMonth = 0;
    
    NSUInteger a;
    
    NSString *riderCodeTemp;
    NSString *annual, *half, *quarter, *month;
    NSString *gstannual, *gsthalf, *gstquarter, *gstmonth;
    NSString *tempPremWithoutHLoading, *QuerySQL;
    
    double dAnn, dHalf, dQtr, dMth;
    for (a=0; a<[annualRiderTot count]; a++) {        
        dAnn = [[annualRiderTot objectAtIndex:a] doubleValue];
        annual = [formatter stringFromNumber:[NSNumber numberWithDouble: dAnn]];
        dHalf = [[self roundingTwoDecimal:[halfRiderTot objectAtIndex:a]] doubleValue];
        half = [formatter stringFromNumber:[NSNumber numberWithDouble: dHalf]];
        dQtr = [[self roundingTwoDecimal:[quarterRiderTot objectAtIndex:a]] doubleValue];
        quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:dQtr]];
        dMth = [[self roundingTwoDecimal:[monthRiderTot objectAtIndex:a]] doubleValue];
        month = [formatter stringFromNumber:[NSNumber numberWithDouble:dMth]];
        tempPremWithoutHLoading = [PremWithoutHLoading objectAtIndex:a];
        
        riderCodeTemp = [annRiderCode objectAtIndex:a];
        if ([self isRiderWithGST:riderCodeTemp]) {
            gstPremAnn = dAnn * gstValue;
            gstannual = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremAnn]];
            gstPremHalf = dHalf * gstValue;
            gsthalf = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremHalf]];
            gstPremQuar = dQtr * gstValue;
            gstquarter = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremQuar]];
            gstPremMonth = dMth * gstValue;
            gstmonth = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremMonth]];
            
            //-------------- heng's part for SI Report
            QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\","
                                    "\"Annually\",\"SemiAnnually\", \"Quarterly\",\"Monthly\","                     
                                    "\"GST_Annual\",\"GST_Semi\", \"GST_Quarter\",\"GST_Month\","
                                    " 'SINO','PremiumWithoutHLoading') VALUES "
                                   " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", '%@', '%@') ",riderCodeTemp,
                                    annual, half, quarter, month,
                                    gstannual, gsthalf, gstquarter, gstmonth,
                                    SINo, tempPremWithoutHLoading ];
        } else {
            QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\","
                         "\"Annually\",\"SemiAnnually\", \"Quarterly\",\"Monthly\","
                         " 'SINO','PremiumWithoutHLoading') VALUES "
                         " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", '%@') ",riderCodeTemp,
                         annual, half, quarter, month,
                         SINo, tempPremWithoutHLoading ];
            
        }
        
        sqlite3_stmt *statement;
        
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        annualRiderSum = annualRiderSum + [[annualRiderTot objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[halfRiderTot objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[quarterRiderTot objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[monthRiderTot objectAtIndex:a] doubleValue];
    }
    
    double _halfSUM = halfRiderSum + basicPremHalf;
    double _quarterSUM = quarterRiderSum + basicPremQuar;
    double _monthSUM = monthRiderSum + basicPremMonth;
    
    int ridTerm;
    NSString *title;
    htmlRider = @"";
    for (a=0; a<[annualRiderTot count]; a++) {
        ridTerm = [[annRiderTerm objectAtIndex:a] intValue];
        title = [[NSString alloc ]initWithFormat:@"%@ - (%d years)",[annRiderTitle objectAtIndex:a],ridTerm];
        annual = [formatter stringFromNumber:[NSNumber numberWithDouble:[[annualRiderTot objectAtIndex:a] doubleValue]]];
        half = [formatter stringFromNumber:[NSNumber numberWithDouble:[[halfRiderTot objectAtIndex:a] doubleValue]]];
        quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:[[quarterRiderTot objectAtIndex:a] doubleValue]]];
        month = [formatter stringFromNumber:[NSNumber numberWithDouble:[[monthRiderTot objectAtIndex:a] doubleValue]]];
                
        half = [formatter stringFromNumber:[NSNumber numberWithDouble:[[self ShowDashOrSum:half type:2 calTotal:_halfSUM] doubleValue]]];
        quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:[[self ShowDashOrSum:quarter type:3 calTotal:_quarterSUM] doubleValue]]];
        month = [formatter stringFromNumber:[NSNumber numberWithDouble:[[self ShowDashOrSum:month type:4 calTotal:_monthSUM] doubleValue]]];
        
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr>"
                         "<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"
                         "</tr>"
                         "<tr>"
                         "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        } else {
            htmlRider = [htmlRider stringByAppendingFormat:
                         @"<tr>"
                         "<td style='height:35px;padding: 5px 5px 5px 5px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>",title,annual,half,quarter,month];
        }
    }
}

-(void)calculateTPDYLA:(double)ridSA HealthLoading:(double)riderHLoad TempHealthLoading:(double)riderTempHLoad Age:(int)rAge AnnualStr:(NSString **)str_ann Formatter:(NSNumberFormatter *)formatter
{    
    double fsar = (70-rAge) * ridSA;
    double _ann = (riderRate *ridSA /100 *annualRate);
    double _half = (riderRate *ridSA /100 *semiAnnualRate);
    double _quar = (riderRate *ridSA /100 *quarterlyRate);
    double _month = (riderRate *ridSA /100 *monthlyRate);
    *str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
    NSString *str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:_half]];
    NSString *str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:_quar]];
    NSString *str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:_month]];
    *str_ann = [*str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //--HL--
    double _HLAnn = ((riderHLoad + riderTempHLoad) /10 *ridSA /100 *annualRate);
    double _HLHalf = ((riderHLoad + riderTempHLoad) /10 *ridSA /100 *semiAnnualRate);
    double _HLQuar = ((riderHLoad + riderTempHLoad) /10 *ridSA /100 *quarterlyRate);
    double _HLMonth = ((riderHLoad + riderTempHLoad) /10 *ridSA /100 *monthlyRate);
    
    NSString *str_HLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn]];
    NSString *str_HLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf]];
    NSString *str_HLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar]];
    NSString *str_HLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth]];
    str_HLAnn = [str_HLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLHalf = [str_HLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLQuar = [str_HLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLMonth = [str_HLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double _TempHLAnn = (0.00/10 *ridSA /100 *annualRate);
    double _TempHLHalf = (0.00 /10 *ridSA /100 *semiAnnualRate);
    double _TempHLQuar = (0.00 /10 *ridSA /100 *quarterlyRate);
    double _TempHLMonth = (0.00 /10 *ridSA /100 *monthlyRate);
    
    NSString *str_TempHLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLAnn]];
    NSString *str_TempHLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLHalf]];
    NSString *str_TempHLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLQuar]];
    NSString *str_TempHLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLMonth]];
    str_TempHLAnn = [str_TempHLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLHalf = [str_TempHLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLQuar = [str_TempHLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLMonth = [str_TempHLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
        
    double _allRiderHLAnn = [str_HLAnn doubleValue] + [str_TempHLAnn doubleValue];
    double _allRiderHLHalf = [str_HLHalf doubleValue] + [str_TempHLHalf doubleValue];
    double _allRiderHLQuar = [str_HLQuar doubleValue] + [str_TempHLQuar doubleValue];
    double _allRiderHLMonth = [str_HLMonth doubleValue] + [str_TempHLMonth doubleValue];
    
    monthlyRider = [str_month doubleValue] + _allRiderHLMonth;
    
    double calLoadA = occLoadRider *fsar /1000 *annualRate;
    double calLoadH = occLoadRider *fsar /1000 *semiAnnualRate;
    double calLoadQ = occLoadRider *fsar /1000 *quarterlyRate;
    double calLoadM = occLoadRider *fsar /1000 *monthlyRate;
    
    NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
    NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
    NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
    NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
    strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    annualRider = [*str_ann doubleValue] + [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn + _TempHLAnn + calLoadA]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    halfYearRider = [str_half doubleValue] + [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf + _TempHLHalf + calLoadH]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    quarterRider = [str_quar doubleValue] + [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar + _TempHLQuar + calLoadQ]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    monthlyRider = [str_month doubleValue] + [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth + _TempHLMonth + calLoadM]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
        
    annualRiderOnly = [*str_ann doubleValue] + _allRiderHLAnn;
    halfYearRiderOnly = [str_half doubleValue] + _allRiderHLHalf;
    quarterRiderOnly = [str_quar doubleValue]  + _allRiderHLQuar;
    monthlyRiderOnly = [str_month doubleValue] + _allRiderHLMonth;
    
    dblTotalOverallPrem = dblTotalOverallPrem + [*str_ann doubleValue] + _allRiderHLAnn;
    dblTotalGrossPrem = dblTotalGrossPrem + [*str_ann doubleValue];
    
}

-(void)calculateWealthBoosterRiderPremium:(double)ridSA RiderCode:(NSString*)RidCode RiderTerm:(int)ridTerm HealthLoading:(double)riderHLoad TempHealthLoading:(double)riderTempHLoad AnnualStr:(NSString **)str_ann Formatter:(NSNumberFormatter *)formatter 
{
    double _ann = (riderRate *ridSA /1000 *annualRate);
    double _half = (riderRate *ridSA /1000 *semiAnnualRate);
    double _quar = (riderRate *ridSA /1000 *quarterlyRate);
    double _month = (riderRate *ridSA /1000 *monthlyRate);
    
    *str_ann= [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
    NSString *str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:_half]];
    NSString *str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:_quar]];
    NSString *str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:_month]];
    *str_ann = [*str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //--HL
    
    double _HLAnn = (riderHLoad *ridSA /1000 *annualRate);
    double _HLHalf = (riderHLoad *ridSA /1000.00 *semiAnnualRate);
    double _HLQuar = (riderHLoad *ridSA /1000.00 *quarterlyRate);
    double _HLMonth = (riderHLoad *ridSA /1000.00 *monthlyRate);
    
    double _TempHLAnn = (riderTempHLoad *ridSA /1000 *annualRate);
    double _TempHLHalf = (riderTempHLoad *ridSA /1000.00 *semiAnnualRate);
    double _TempHLQuar = (riderTempHLoad *ridSA /1000.00 *quarterlyRate);
    double _TempHLMonth = (riderTempHLoad *ridSA /1000.00 *monthlyRate);
    
    double _allRiderHLAnn = [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn + _TempHLAnn]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double _allRiderHLHalf = [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf + _TempHLHalf]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double _allRiderHLQuar = [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar + _TempHLQuar]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    double _allRiderHLMonth = [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth + _TempHLMonth]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
        
    double calLoadA ;
    double calLoadH ;
    double calLoadQ ;
    double calLoadM ;
    
    double OccLoadingFactor = 0.00;
    if ([RidCode isEqualToString:@"WB30R"] || [RidCode isEqualToString:@"WB50R"] || [RidCode isEqualToString:@"WBD10R30"] || [RidCode isEqualToString:@"WBI6R30"]) {
        OccLoadingFactor = occLoadRider * 20;
        calLoadA = OccLoadingFactor * ridSA/1000.00 * annualRate;
        calLoadH = OccLoadingFactor * ridSA/1000.00 * semiAnnualRate;
        calLoadQ = OccLoadingFactor * ridSA/1000.00 * quarterlyRate;
        calLoadM = OccLoadingFactor * ridSA/1000.00 * monthlyRate;
    } else if ([RidCode isEqualToString:@"WP30R"] || [RidCode isEqualToString:@"WP50R"] || [RidCode isEqualToString:@"WPTPD30R"] || [RidCode isEqualToString:@"WPTPD50R"]) {
        OccLoadingFactor = occLoadRider * 3;
        
        calLoadA = OccLoadingFactor * ridSA/1000.00 * annualRate;
        calLoadH = OccLoadingFactor * ridSA/1000.00 * semiAnnualRate;
        calLoadQ = OccLoadingFactor * ridSA/1000.00 * quarterlyRate;
        calLoadM = OccLoadingFactor * ridSA/1000.00 * monthlyRate;
    } else {
        calLoadA = occLoadRider/1000 *annualRate*((double)ridTerm)*ridSA;
        calLoadH = occLoadRider/1000 *semiAnnualRate*((double)ridTerm)*ridSA;
        calLoadQ = occLoadRider/1000 *quarterlyRate*((double)ridTerm)*ridSA;
        calLoadM = occLoadRider/1000 *monthlyRate*((double)ridTerm)*ridSA;
    }
    
    NSString *strLoadA = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadA]];
    NSString *strLoadH = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadH]];
    NSString *strLoadQ = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadQ]];
    NSString *strLoadM = [formatter stringFromNumber:[NSNumber numberWithDouble:calLoadM]];
    strLoadA = [strLoadA stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadH = [strLoadH stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadQ = [strLoadQ stringByReplacingOccurrencesOfString:@"," withString:@""];
    strLoadM = [strLoadM stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    annualRider = [*str_ann doubleValue] +
    [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn + _TempHLAnn + calLoadA]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    halfYearRider = [str_half doubleValue] +
    [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf + _TempHLHalf + calLoadH]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    quarterRider = [str_quar doubleValue] +
    [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar + _TempHLQuar + calLoadQ]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    monthlyRider = [str_month doubleValue] +
    [[[formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth + _TempHLMonth + calLoadM]] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
    
    annualRiderOnly = [*str_ann doubleValue] + _allRiderHLAnn;
    halfYearRiderOnly = [str_half doubleValue] + _allRiderHLHalf;
    quarterRiderOnly = [str_quar doubleValue] + _allRiderHLQuar;
    monthlyRiderOnly = [str_month doubleValue] + _allRiderHLMonth;
    
    dblTotalOverallPrem = dblTotalOverallPrem + annualRider;
    
    if (![RidCode isEqualToString:@"WPTPD30R"] && ![RidCode isEqualToString:@"WPTPD50R"]) {
        dblTotalGrossPrem = dblTotalGrossPrem + [*str_ann doubleValue];
    }
}

- (void)calculateMedicalRiderPremium:(double)riderTempHLoad riderHLoad:(double)riderHLoad RidCode:(NSString *)RidCode AnnualStr:(NSString **)str_ann
{
    annualRider = [self dblRoundToTwoDecimal:(riderRate * annualRate)] + [self dblRoundToTwoDecimal: (riderRate * (riderHLoad+riderTempHLoad)/100) * annualRate];
    halfYearRider = [self dblRoundToTwoDecimal:(riderRate * semiAnnualRate)] + [self dblRoundToTwoDecimal: (riderRate * (riderHLoad+riderTempHLoad)/100) * semiAnnualRate];
    quarterRider = [self dblRoundToTwoDecimal:(riderRate * quarterlyRate)] + [self dblRoundToTwoDecimal: (riderRate * (riderHLoad+riderTempHLoad)/100) * quarterlyRate];
    monthlyRider = [self dblRoundToTwoDecimal:(riderRate * monthlyRate)] + [self dblRoundToTwoDecimal: (riderRate * (riderHLoad+riderTempHLoad)/100) * monthlyRate];
    
    annualRiderOnly = annualRider;
    halfYearRiderOnly = halfYearRider;
    quarterRiderOnly = quarterRider;
    monthlyRiderOnly = monthlyRider;
    
    dblTotalOverallPrem = dblTotalOverallPrem + annualRider;
    dblTotalGrossPrem = dblTotalGrossPrem + riderRate;
    
    // For report part ---------- added by heng
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        double annualRates;
        NSString *querySQL;
        sqlite3_stmt *statement;
        for (int a = 0; a<ReportHMMRates.count; a++) {
            annualRates = [[ReportHMMRates objectAtIndex:a] doubleValue ] * (1 + riderHLoad/100) * annualRate;
            querySQL = [NSString stringWithFormat: @"INSERT INTO SI_Store_premium (\"Type\",\"Annually\",\"FromAge\", \"ToAge\", 'SINO') "
                        " VALUES(\"%@\", \"%.9f\", \"%@\", \"%@\", '%@')",
                        RidCode, annualRates, [ReportFromAge objectAtIndex:a], [ReportToAge objectAtIndex:a], SINo];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
        }
        sqlite3_close(contactDB);
    }
    // report part end -----------
    *str_ann = [NSString stringWithFormat:@"%f", riderRate ];
}

- (void)calculateHBRiderPremium:(NSUInteger)i riderTempHLoad:(double)riderTempHLoad riderHLoad:(double)riderHLoad AnnualStr:(NSString **)str_ann
{
    double tAnnFac = 1;
    double tHalfFac = 0.55;
    double tQuarterFac = 0.3;
    double tMonthFac = 0.1;
    int selectUnit = [[riderUnit objectAtIndex:i] intValue];
    annualRider = riderRate * (1 + (riderHLoad+riderTempHLoad)/100) * selectUnit * tAnnFac;
    halfYearRider = riderRate * (1 + (riderHLoad+riderTempHLoad)/100) * selectUnit * tHalfFac;
    quarterRider = riderRate * (1 + (riderHLoad+riderTempHLoad)/100) * selectUnit * tQuarterFac;
    monthlyRider = riderRate * (1 + (riderHLoad+riderTempHLoad)/100) * selectUnit * tMonthFac;
    
    annualRiderOnly = annualRider;
    halfYearRiderOnly = halfYearRider;
    quarterRiderOnly = quarterRider;
    monthlyRiderOnly = monthlyRider;
    
    dblTotalOverallPrem = dblTotalOverallPrem + annualRider;
    dblTotalGrossPrem = dblTotalGrossPrem + riderRate * (1 + (0.00)/100) * selectUnit * tAnnFac;
    *str_ann = [NSString stringWithFormat:@"%.2f",riderRate * (1 + (0.00)/100) * selectUnit * tAnnFac];
}

- (void)calculateCriticalIllnessRiderPremium:(double)ridSA riderHLoad:(double)riderHLoad riderTempHLoad:(double)riderTempHLoad AnnualStr:(NSString **)str_ann Formatter:(NSNumberFormatter *)formatter
{
    NSString *str_half;
    NSString *str_quar;
    NSString *str_month;
    
    double _ann = (riderRate *ridSA /1000 *annualRate);
    double _half = (riderRate *ridSA /1000 *semiAnnualRate);
    double _quar = (riderRate *ridSA /1000 *quarterlyRate);
    double _month = (riderRate *ridSA /1000 *monthlyRate);
    
    *str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
    str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:_half]];
    str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:_quar]];
    str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:_month]];
    *str_ann = [*str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //--HL
    
    double _HLAnn = ((riderHLoad + riderTempHLoad) *ridSA /1000 *annualRate);
    double _HLHalf = ((riderHLoad + riderTempHLoad) *ridSA /1000 *semiAnnualRate);
    double _HLQuar = ((riderHLoad + riderTempHLoad) *ridSA /1000 *quarterlyRate);
    double _HLMonth = ((riderHLoad + riderTempHLoad) *ridSA /1000 *monthlyRate);
    
    NSString *str_HLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLAnn]];
    NSString *str_HLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLHalf]];
    NSString *str_HLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLQuar]];
    NSString *str_HLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_HLMonth]];
    str_HLAnn = [str_HLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLHalf = [str_HLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLQuar = [str_HLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_HLMonth = [str_HLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double _TempHLAnn = (0.00 *ridSA /1000 *annualRate);
    double _TempHLHalf = (0.00 *ridSA /1000 *semiAnnualRate);
    double _TempHLQuar = (0.00 *ridSA /1000 *quarterlyRate);
    double _TempHLMonth = (0.00 *ridSA /1000 *monthlyRate);
    
    NSString *str_TempHLAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLAnn]];
    NSString *str_TempHLHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLHalf]];
    NSString *str_TempHLQuar = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLQuar]];
    NSString *str_TempHLMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:_TempHLMonth]];
    str_TempHLAnn = [str_TempHLAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLHalf = [str_TempHLHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLQuar = [str_TempHLQuar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_TempHLMonth = [str_TempHLMonth stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    double _allRiderHLAnn = [str_HLAnn doubleValue] + [str_TempHLAnn doubleValue];
    double _allRiderHLHalf = [str_HLHalf doubleValue] + [str_TempHLHalf doubleValue];
    double _allRiderHLQuar = [str_HLQuar doubleValue] + [str_TempHLQuar doubleValue];
    double _allRiderHLMonth = [str_HLMonth doubleValue] + [str_TempHLMonth doubleValue];
    
    //--end
    
    annualRider = [*str_ann doubleValue] + _allRiderHLAnn;
    halfYearRider = [str_half doubleValue] + _allRiderHLHalf;
    quarterRider = [str_quar doubleValue] + _allRiderHLQuar;
    monthlyRider = [str_month doubleValue] + _allRiderHLMonth;
    
    annualRiderOnly = annualRider;
    halfYearRiderOnly = halfYearRider;
    quarterRiderOnly = quarterRider;
    monthlyRiderOnly = monthlyRider;
    
    dblTotalOverallPrem = dblTotalOverallPrem + [*str_ann doubleValue] + _allRiderHLAnn;
    dblTotalGrossPrem = dblTotalGrossPrem + [*str_ann doubleValue];
}

-(void)calculateWBM6RPremium:(double)ridSA HLoad:(double)riderHLoad THLoad:(double)riderTempHLoad AnnualStr:(NSString **)str_ann Formatter:(NSNumberFormatter *)formatter {
    double _ann = (riderRate *ridSA /100 * annualRate);
    double _half = (riderRate *ridSA /100 * semiAnnualRate);
    double _quar = (riderRate *ridSA /100 * quarterlyRate);
    double _month = (riderRate *ridSA /100 * monthlyRate);
    //    NSString *str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
    *str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:_ann]];
    NSString *str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:_half]];
    NSString *str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:_quar]];
    NSString *str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:_month]];
    
    *str_ann = [*str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
    str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
    //--HL
    double _HLAnn = (riderHLoad *ridSA /1000 * annualRate);
    double _HLHalf = (riderHLoad *ridSA /1000 * semiAnnualRate);
    double _HLQuar = (riderHLoad *ridSA /1000 * quarterlyRate);
    double _HLMonth = (riderHLoad *ridSA /1000 * monthlyRate);
    
    double _TempHLAnn = (riderTempHLoad *ridSA /1000 * annualRate);
    double _TempHLHalf = (riderTempHLoad *ridSA /1000 * semiAnnualRate);
    double _TempHLQuar = (riderTempHLoad *ridSA /1000 * quarterlyRate);
    double _TempHLMonth = (riderTempHLoad *ridSA /1000 * monthlyRate);
    
    double _allRiderHLAnn = _HLAnn + _TempHLAnn;
    double _allRiderHLHalf = _HLHalf + _TempHLHalf;
    double _allRiderHLQuar = _HLQuar + _TempHLQuar;
    double _allRiderHLMonth = _HLMonth + _TempHLMonth;
    
    double OccLoadingFactor = occLoadRider * 20;
    double calLoadA = OccLoadingFactor * ridSA/1000 * annualRate;
    double calLoadH = OccLoadingFactor * ridSA/1000 * semiAnnualRate;
    double calLoadQ = OccLoadingFactor * ridSA/1000 * quarterlyRate;
    double calLoadM = OccLoadingFactor * ridSA/1000 * monthlyRate;
    
    annualRider = [*str_ann doubleValue] + _allRiderHLAnn + calLoadA;
    halfYearRider = [str_half doubleValue] + _allRiderHLHalf + calLoadH;
    quarterRider = [str_quar doubleValue] + _allRiderHLQuar + calLoadQ;
    monthlyRider = [str_month doubleValue] + _allRiderHLMonth + calLoadM;
    
    annualRiderOnly = [*str_ann doubleValue] + _allRiderHLAnn;
    halfYearRiderOnly = [str_half doubleValue] + _allRiderHLHalf;
    quarterRiderOnly = [str_quar doubleValue] + _allRiderHLQuar;
    monthlyRiderOnly = [str_month doubleValue] + _allRiderHLMonth;
    
    dblTotalOverallPrem = dblTotalOverallPrem + annualRider;
    dblTotalGrossPrem = dblTotalGrossPrem + [*str_ann doubleValue];
}

-(void)updateSIStore {
    NSString* query = [NSString stringWithFormat:@"SELECT \"SemiAnnually\", \"Quarterly\", \"Monthly\", \"Type\" FROM SI_Store_Premium WHERE SiNo=\"%@\" ", SINo];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            double sumSemiAnnual = 0;
            double sumQuarter = 0;
            double sumMonth = 0;
            
            NSString *tempStr;
            double tempValue;
            
            double semiAnnualWithBSA = 0;
            double quarterWithBSA = 0;
            double monthWithBSA = 0;
            double semiAnnualWithB = 0;
            double quarterWithB = 0;
            double monthWithB = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                if ([tempStr isEqualToString:@"BOriginal"]) {
                    if (sqlite3_column_type(statement, 0) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        semiAnnualWithBSA = semiAnnualWithBSA + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 1) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        quarterWithBSA = quarterWithBSA + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 2) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        monthWithBSA = monthWithBSA + tempValue;
                    }
                } else if ([tempStr isEqualToString:@"B"]) {
                    if (sqlite3_column_type(statement, 0) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        semiAnnualWithB = semiAnnualWithB + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 1) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        quarterWithB = quarterWithB + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 2) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        monthWithB = monthWithB + tempValue;
                    }
                } else {
                    if (sqlite3_column_type(statement, 0) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        sumSemiAnnual = sumSemiAnnual + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 1) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        sumQuarter = sumQuarter + tempValue;
                    }
                    
                    if (sqlite3_column_type(statement, 2) != SQLITE_NULL) {
                        tempStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                        tempValue = [[tempStr stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];
                        sumMonth = sumMonth + tempValue;
                    }
                }
            }
            
            semiAnnualWithB = sumMonth + semiAnnualWithB;
            quarterWithB = sumQuarter + quarterWithB;
            monthWithB = sumMonth + monthWithB;
            sqlite3_finalize(statement);
                        
            BOOL doUpdate = false;
            NSMutableString *updateQuery = [[NSMutableString alloc] initWithString:@"UPDATE SI_Store_Premium SET "];
            if (semiAnnualWithB < 200) {
                [updateQuery appendString:@"IsGSTSemiAnnValid=1"];
                doUpdate = true;
            }
            
            if (quarterWithB < 150) {
                if (semiAnnualWithB < 200) {
                    [updateQuery appendString:@","];
                }
                [updateQuery appendString:@"IsGSTQtrValid=1"];
                doUpdate = true;
            }
            
            if (monthWithB < 50) {
                if (semiAnnualWithB < 200 || quarterWithB < 150) {
                    [updateQuery appendString:@","];
                }
                [updateQuery appendString:@"IsGSTMthValid=1"];
                doUpdate = true;
            }
            
            if (doUpdate) {
                sqlite3_stmt *updateStatement;
                [updateQuery appendFormat:@" WHERE SiNo='%@'", SINo];
                if (sqlite3_prepare_v2(contactDB, [updateQuery UTF8String], -1, &updateStatement, NULL) == SQLITE_OK)
                {
                    sqlite3_step(updateStatement);
                    sqlite3_finalize(updateStatement);
                }
            }
            
            [self updateSIStorePremiumBOriginal:(semiAnnualWithBSA) sumQuarter:(quarterWithBSA) sumMonth:(monthWithBSA)];
        }
    }
    sqlite3_close(contactDB);
}

- (void)updateSIStorePremiumBOriginal:(double)semiAnnualWithBSA sumQuarter:(double)quarterWithBSA sumMonth:(double)monthWithBSA {
    BOOL doUpdate;
    NSMutableString *updateQuery;
    doUpdate = FALSE;
    
    updateQuery = [[NSMutableString alloc] initWithString:@"UPDATE SI_Store_Premium SET "];
    if (semiAnnualWithBSA < 200) {
        [updateQuery appendString:@"IsSemiAnnValid=1"];
        doUpdate = true;
    }
    
    if (quarterWithBSA < 150) {
        if (semiAnnualWithBSA < 200) {
            [updateQuery appendString:@","];
        }
        [updateQuery appendString:@"IsQtrValid=1"];
        doUpdate = true;
    }
    
    if (monthWithBSA < 50) {
        if (semiAnnualWithBSA < 200 || quarterWithBSA < 150) {
            [updateQuery appendString:@","];
        }
        [updateQuery appendString:@"IsMthValid=1"];
        doUpdate = true;
    }
    
    if (doUpdate) {
        sqlite3_stmt *updateStatement;
        [updateQuery appendFormat:@" WHERE SiNo='%@' AND Type=\"BOriginal\"", SINo];
        if (sqlite3_prepare_v2(contactDB, [updateQuery UTF8String], -1, &updateStatement, NULL) == SQLITE_OK)
        {
            sqlite3_step(updateStatement);
            sqlite3_finalize(updateStatement);
        }
    }
}

-(bool)isRiderWithGST:(NSString *)rider {
    NSString* query = [NSString stringWithFormat:@"SELECT GST FROM Trad_Sys_Rider_Mtn WHERE RiderCode = \"%@\"", rider];
    sqlite3_stmt *statement;
    bool value = false;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString* str_value = [[NSString alloc] initWithFormat:@"%d", sqlite3_column_int(statement, 0) ];
                value = [str_value isEqualToString:@"1"];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return value;
}

-(NSString *) roundingTwoDecimal:(NSString *)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];    
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];    
    NSString *temp = [formatter stringFromNumber:[NSDecimalNumber numberWithDouble:[value doubleValue ]]];
    
    return temp;
}

-(double)dblRoundToTwoDecimal:(double)value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];    
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];    
    NSString *temp = [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
    
    return [temp doubleValue];
}

-(void)calculateWaiver
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    PremWithoutHLoading = [[NSMutableArray alloc] init];
    PremWithHLoading = [[NSMutableArray alloc] init];
    PremWithTempHLoading = [[NSMutableArray alloc] init];
    
    double waiverAnnSum = 0;
    double waiverHalfSum = 0;
    double waiverQuarSum = 0;
    double waiverMonthSum = 0;
    for (NSUInteger m=0; m<[waiverRiderAnn count]; m++) {
        waiverAnnSum = waiverAnnSum + [[waiverRiderAnn objectAtIndex:m] doubleValue];
        waiverHalfSum = waiverHalfSum + [[waiverRiderHalf objectAtIndex:m] doubleValue];
        waiverQuarSum = waiverQuarSum + [[waiverRiderQuar objectAtIndex:m] doubleValue];
        waiverMonthSum = waiverMonthSum + [[waiverRiderMonth objectAtIndex:m] doubleValue];
    }
    
    double waiverAnnSum2 = 0;
    double waiverHalfSum2 = 0;
    double waiverQuarSum2 = 0;
    double waiverMonthSum2 = 0;
    for (NSUInteger m=0; m<[waiverRiderAnn2 count]; m++) {
        waiverAnnSum2 = waiverAnnSum2 + [[waiverRiderAnn2 objectAtIndex:m] doubleValue];
        waiverHalfSum2 = waiverHalfSum2 + [[waiverRiderHalf2 objectAtIndex:m] doubleValue];
        waiverQuarSum2 = waiverQuarSum2 + [[waiverRiderQuar2 objectAtIndex:m] doubleValue];
        waiverMonthSum2 = waiverMonthSum2 + [[waiverRiderMonth2 objectAtIndex:m] doubleValue];
    }
    
    double waiverAnnSumWithoutHLAndOccLoading = 0;

    for (NSUInteger m=0; m<[waiverRiderAnnWithoutHLAndOccLoading count]; m++) {
        waiverAnnSumWithoutHLAndOccLoading = waiverAnnSumWithoutHLAndOccLoading + [[waiverRiderAnnWithoutHLAndOccLoading objectAtIndex:m] doubleValue];
    }
        
    NSMutableArray *waiverTitle = [[NSMutableArray alloc] init];
    NSMutableArray *waiverCode = [[NSMutableArray alloc] init];
    NSMutableArray *waiverTerm = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidAnnTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidHalfTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidQuarTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidMonthTol = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidAnnSA = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidHalfSA = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidQuarSA = [[NSMutableArray alloc] init];
    NSMutableArray *waiverRidMonthSA = [[NSMutableArray alloc] init];
	    
    double ridSA = 0;
    double riderHLoad = 0;
    double riderTempHLoad = 0;
    
    double annualRider_ = 0;
    double halfYearRider_ = 0;
    double quarterRider_ = 0;
    double monthlyRider_ = 0;
    
    NSString *str_ann;
    NSString *str_half;
    NSString *str_quar;
    NSString *str_month;
    double waiverAnnPremSA = 0.00;
    double waiverHalfPremSA = 0.00;
    double waiverQuarPremSA = 0.00;
    double waiverMonthPremSA = 0.00;
    
    double waiverAnnPrem = 0;
    double waiverHalfPrem = 0;
    double waiverQuarPrem = 0;
    double waiverMonthPrem = 0;
    
    NSString *calRiderAnn;
    NSString *calRiderHalf;
    NSString *calRiderQuarter;
    NSString *calRiderMonth;
    
    NSString *calRiderAnnSA;
    NSString *calRiderHalfSA;
    NSString *calRiderQuarterSA;
    NSString *calRiderMonthSA;
    for (NSUInteger i=0; i<[riderCode count]; i++) {
        //getpentacode
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"] || [[riderCode objectAtIndex:i] isEqualToString:@"LCWP"] || [[riderCode objectAtIndex:i] isEqualToString:@"PR"] ||
                [[riderCode objectAtIndex:i] isEqualToString:@"SP_STD"] || [[riderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]) {
                pentaSQL = [[NSString alloc] initWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE PlanType=\"R\" AND SIPlanCode=\"%@\" AND Channel=\"AGT\"",[riderCode objectAtIndex:i]];
            } else {
                sqlite3_close(contactDB);
                continue;
            }
            
            const char *query_stmt = [pentaSQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    planCodeRider =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        int ridTerm = [[riderTerm objectAtIndex:i] intValue];
        age = [[riderAge objectAtIndex:i] intValue];
        sex = [[NSString alloc] initWithFormat:@"%@",[riderSex objectAtIndex:i]];
        sex = [PremiumViewController getShortSex:sex];
        
        //get rate
        [self getRiderRateAgeSex:[riderCode objectAtIndex:i] riderTerm:ridTerm fromAge:[riderAge objectAtIndex:i] toAge:[riderAge objectAtIndex:i]];
        
        ridSA = [[riderSA objectAtIndex:i] doubleValue];
        riderHLoad = 0;
        riderTempHLoad = 0;
        
        if ([[riderHL1K objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHL1K objectAtIndex:i] doubleValue];
        } else if ([[riderHL100 objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHL100 objectAtIndex:i] doubleValue];
        } else if ([[riderHLP objectAtIndex:i] doubleValue] > 0) {
            riderHLoad = [[riderHLP objectAtIndex:i] doubleValue];
        }
        
        if ([[riderTempHL1K objectAtIndex:i] doubleValue] > 0) {
            riderTempHLoad = [[riderTempHL1K objectAtIndex:i] doubleValue];
        }
        
        //calculate occupationLoading
        strOccp = [riderOccp objectAtIndex:i];
        [self getOccLoadRider];
        
        annualRider_ = 0;
        halfYearRider_ = 0;
        quarterRider_ = 0;
        monthlyRider_ = 0;
		
		str_ann = @"";
		str_half = @"";
		str_quar = @"";
		str_month = @"";
		waiverAnnPremSA = 0.00;
		waiverHalfPremSA = 0.00;
		waiverQuarPremSA = 0.00;
		waiverMonthPremSA = 0.00;
        if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"]) {
            double basicPremAnn2;
            double basicPremHalf2;
            double basicPremQuar2;
            double basicPremMonth2;
            double waiverAnnSum2;
            double waiverHalfSum2;
            double waiverQuarSum2;
            double waiverMonthSum2;
            
            if ([riderCode containsObject:@"ACIR_MPP"]) {
                basicPremAnn2 = [self getACIR_CIWP_waiver:basicPremAnn];
                basicPremHalf2 = [self getACIR_CIWP_waiver:basicPremHalf];
                basicPremQuar2 = [self getACIR_CIWP_waiver:basicPremQuar];
                basicPremMonth2 = [self getACIR_CIWP_waiver:basicPremMonth];
                waiverAnnSum2 = waiverAnnSum;
                waiverHalfSum2 = waiverHalfSum;
                waiverQuarSum2 = waiverQuarSum;
                waiverMonthSum2 = waiverMonthSum;
                
            } else {
                basicPremAnn2 = basicPremAnn;
                basicPremHalf2 = basicPremHalf;
                basicPremQuar2 = basicPremQuar;
                basicPremMonth2 = basicPremMonth;
                waiverAnnSum2 = waiverAnnSum;
                waiverHalfSum2 = waiverHalfSum;
                waiverQuarSum2 = waiverQuarSum;
                waiverMonthSum2 = waiverMonthSum;
            }            
            
            waiverAnnPrem = ridSA/100 * (waiverAnnSum2+basicPremAnn2);
            waiverHalfPrem = ridSA/100 * (waiverHalfSum2+basicPremHalf2);
            waiverQuarPrem = ridSA/100 * (waiverQuarSum2+basicPremQuar2) ;
            waiverMonthPrem = ridSA/100 * (waiverMonthSum2+basicPremMonth2) ;
            
			waiverAnnPremSA = ridSA/100 * (waiverAnnSum2+basicPremAnn2);
			waiverHalfPremSA = ridSA/100 * (waiverHalfSum2+basicPremHalf2) ;
			waiverQuarPremSA = ridSA/100 * (waiverQuarSum2+basicPremQuar2) ;
			waiverMonthPremSA = ridSA/100 * (waiverMonthSum2+basicPremMonth2);
			str_ann = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverAnnPrem]];
			str_half = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverHalfPrem]];
			str_quar = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverQuarPrem]];
			str_month = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverMonthPrem]];
            str_ann = [str_ann stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_half = [str_half stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_quar = [str_quar stringByReplacingOccurrencesOfString:@"," withString:@""];
            str_month = [str_month stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            // newly added, the newly round up value multiply by MOP
            str_ann = [NSString stringWithFormat:@"%f", [str_ann doubleValue] * 1 ];
            str_half = [NSString stringWithFormat:@"%f", [str_half doubleValue] * 2 ];
            str_quar = [NSString stringWithFormat:@"%f", [str_quar doubleValue] * 4 ];
            str_month = [NSString stringWithFormat:@"%f", [str_month doubleValue] * 12 ];
            //end
            
            annualRider = [self dblRoundToTwoDecimal:annualRate * [str_ann doubleValue] * (riderRate/100)] +
                                [self dblRoundToTwoDecimal:annualRate *[str_ann doubleValue] * ((riderHLoad+riderTempHLoad)/100)];
            halfYearRider = [self dblRoundToTwoDecimal: semiAnnualRate * [str_half doubleValue] * (riderRate/100)] +
                                [self dblRoundToTwoDecimal:semiAnnualRate *[str_half doubleValue] * ((riderHLoad+riderTempHLoad)/100)];
            quarterRider = [self dblRoundToTwoDecimal:quarterlyRate * [str_quar doubleValue] * (riderRate/100)]  +
                                [self dblRoundToTwoDecimal:quarterlyRate *[str_quar doubleValue] * ((riderHLoad+riderTempHLoad)/100)];
            monthlyRider = [self dblRoundToTwoDecimal:monthlyRate * [str_month doubleValue] * (riderRate/100)]  +
                                [self dblRoundToTwoDecimal:monthlyRate *[str_month doubleValue] * ((riderHLoad+riderTempHLoad)/100)];
            
        } else if ([[riderCode objectAtIndex:i] isEqualToString:@"LCWP"] || [[riderCode objectAtIndex:i] isEqualToString:@"PR"]||
                   [[riderCode objectAtIndex:i] isEqualToString:@"SP_STD"] || [[riderCode objectAtIndex:i] isEqualToString:@"SP_PRE"]) {
			waiverAnnPremSA = ridSA/100 * (waiverAnnSum2+basicPremAnn);
            waiverAnnPrem = [self dblRoundToTwoDecimal:waiverAnnPremSA] * 1;
            
			waiverHalfPremSA = ridSA/100 * (waiverHalfSum2+basicPremHalf);
            waiverHalfPrem = [self dblRoundToTwoDecimal:waiverHalfPremSA] * 2;
            
			waiverQuarPremSA = ridSA/100 * (waiverQuarSum2+basicPremQuar);
            waiverQuarPrem = [self dblRoundToTwoDecimal:waiverQuarPremSA] * 4;
            
			waiverMonthPremSA = ridSA/100 * (waiverMonthSum2+basicPremMonth);
            waiverMonthPrem = [self dblRoundToTwoDecimal:waiverMonthPremSA] *12;
            
            annualRider = [self dblRoundToTwoDecimal:annualRate * waiverAnnPrem * (riderRate/100)]  +
            [self dblRoundToTwoDecimal:annualRate * waiverAnnPrem * ((double)ridTerm/1000 *occLoadRider + (riderHLoad+riderTempHLoad)/100)];
            
            halfYearRider = [self dblRoundToTwoDecimal: semiAnnualRate * waiverHalfPrem * (riderRate/100)]  +
            [self dblRoundToTwoDecimal:semiAnnualRate * waiverHalfPrem * ((double)ridTerm/1000 *occLoadRider + (riderHLoad+riderTempHLoad)/100)];
            
            quarterRider = [self dblRoundToTwoDecimal:quarterlyRate * waiverQuarPrem * (riderRate/100)]  +
            [self dblRoundToTwoDecimal:quarterlyRate * waiverQuarPrem * ((double)ridTerm/1000 *occLoadRider + (riderHLoad+riderTempHLoad)/100)];
            
            monthlyRider = [self dblRoundToTwoDecimal:monthlyRate * waiverMonthPrem * (riderRate/100)]  +
            [self dblRoundToTwoDecimal:monthlyRate * waiverMonthPrem * ((double)ridTerm/1000 *occLoadRider + (riderHLoad+riderTempHLoad)/100)];
            
        }
        
        calRiderAnn = [formatter stringFromNumber:[NSNumber numberWithDouble:annualRider]];
        calRiderAnn = [calRiderAnn stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderHalf = [formatter stringFromNumber:[NSNumber numberWithDouble:halfYearRider]];
        calRiderHalf = [calRiderHalf stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderQuarter = [formatter stringFromNumber:[NSNumber numberWithDouble:quarterRider]];        
        calRiderQuarter = [calRiderQuarter stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderMonth = [formatter stringFromNumber:[NSNumber numberWithDouble:monthlyRider]];
        calRiderMonth = [calRiderMonth stringByReplacingOccurrencesOfString:@"," withString:@""];        

        dblTotalOverallPrem = dblTotalOverallPrem + [calRiderAnn doubleValue];
        if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"] ) { //take the first life assured only since second life assured and payor doesnt need it
            dblTotalGrossPrem = dblTotalGrossPrem + [self dblRoundToTwoDecimal:annualRate * (waiverAnnSumWithoutHLAndOccLoading + basicPremAnn) * ridSA/100.00  * (riderRate/100)];
        }
        
        [waiverTitle addObject:[riderCode objectAtIndex:i]];
        [waiverTerm addObject:[riderTerm objectAtIndex:i]];
        [waiverCode addObject:[riderCode objectAtIndex:i]];
        [waiverRidAnnTol addObject:calRiderAnn];
        [waiverRidHalfTol addObject:calRiderHalf];
        [waiverRidQuarTol addObject:calRiderQuarter];
        [waiverRidMonthTol addObject:calRiderMonth];
		
		calRiderAnnSA = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverAnnPremSA]];
        calRiderAnnSA = [calRiderAnnSA stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderHalfSA = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverHalfPremSA]];
        calRiderHalfSA = [calRiderHalfSA stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderQuarterSA = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverQuarPremSA]];
        calRiderQuarterSA = [calRiderQuarterSA stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        calRiderMonthSA = [formatter stringFromNumber:[NSNumber numberWithDouble:waiverMonthPremSA]];        
        calRiderMonthSA = [calRiderMonthSA stringByReplacingOccurrencesOfString:@"," withString:@""];
		
		[waiverRidAnnSA addObject:calRiderAnnSA];
        [waiverRidHalfSA addObject:calRiderHalfSA];
        [waiverRidQuarSA addObject:calRiderQuarterSA];
        [waiverRidMonthSA addObject:calRiderMonthSA];
		
        if ([[riderCode objectAtIndex:i] isEqualToString:@"CIWP"]) {
            [PremWithoutHLoading addObject:[NSString stringWithFormat:@"%f", riderRate]];
        } else {
            [PremWithoutHLoading addObject:[NSString stringWithFormat:@"%f", riderRate]];
        }
    
    }
    
    NSString *title;
    NSString *annual;
    NSString *half;
    NSString *quarter;
    NSString *month;
    
    double annValue, halfValue, qtrValue, mthValue;
    NSString *gstannual, *gsthalf, *gstquarter, *gstmonth;
    NSString *QuerySQL;
    
    NSMutableDictionary *tempDict;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSString *riderCodeTemp;
    bool isGSTExempted;
    int ridTerm;
    for (NSUInteger a=0; a<[waiverRidAnnTol count]; a++) {
        ridTerm = [[waiverTerm objectAtIndex:a] intValue];
        title = [[NSString alloc ]initWithFormat:@"%@ - (%d years)",[waiverTitle objectAtIndex:a],ridTerm];
        annValue = [ [self roundingTwoDecimal:[waiverRidAnnTol objectAtIndex:a]] doubleValue];
        annual = [formatter stringFromNumber:[NSNumber numberWithDouble:annValue]];
        halfValue = [ [self roundingTwoDecimal:[waiverRidHalfTol objectAtIndex:a]] doubleValue];
        half = [formatter stringFromNumber:[NSNumber numberWithDouble:halfValue]];        
        qtrValue = [ [self roundingTwoDecimal:[waiverRidQuarTol objectAtIndex:a]] doubleValue];
        quarter = [formatter stringFromNumber:[NSNumber numberWithDouble:qtrValue]];        
        mthValue = [ [self roundingTwoDecimal:[waiverRidMonthTol objectAtIndex:a]] doubleValue];
        month = [formatter stringFromNumber:[NSNumber numberWithDouble:mthValue]];
        
        //-------------- heng's part for SI Report
        
        riderCodeTemp = [waiverCode objectAtIndex:a];
        sqlite3_stmt *statement;
        isGSTExempted = [self isRiderWithGST:riderCodeTemp];
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            QuerySQL =  [ NSString stringWithFormat: @"Delete from SI_Store_Premium where sino = '%@' AND ridercode in ('CIWP', 'LCWP', 'PR', 'SP_PRE', 'SP_STD') ", SINo];

            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            
            if (isGSTExempted) {
                gstPremAnn = annValue * gstValue;
                gstannual = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremAnn]];
                gstPremHalf = halfValue * gstValue;
                gsthalf = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremHalf]];
                gstPremQuar = qtrValue * gstValue;
                gstquarter = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremQuar]];
                gstPremMonth = mthValue * gstValue;
                gstmonth = [formatter stringFromNumber:[NSNumber numberWithDouble:gstPremMonth]];
                //-------------- heng's part for SI Report
                QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\","
                             "\"Annually\",\"SemiAnnually\", \"Quarterly\",\"Monthly\", "
                             "\"GST_Annual\",\"GST_Semi\", \"GST_Quarter\",\"GST_Month\", "
                             "'SINO', "
                             "'WaiverSAAnnual','WaiverSASemi', 'WaiverSAQuarter', 'WaiverSAMonth', "
                             "'PremiumWithoutHLoading') VALUES "
                             " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\", \"%@\",'%@','%@','%@','%@','%@','%@') ",
                             riderCodeTemp,
                             annual, half, quarter, month,
                             gstannual, gsthalf, gstquarter, gstmonth,
                             SINo,
                             [waiverRidAnnSA objectAtIndex:a], [waiverRidHalfSA objectAtIndex:a],
                             [waiverRidQuarSA objectAtIndex:a], [waiverRidMonthSA objectAtIndex:a],
                             [PremWithoutHLoading objectAtIndex:a]];
                
            } else {
                QuerySQL =  [ NSString stringWithFormat: @"INSERT INTO SI_Store_Premium (\"Type\","
                             "\"Annually\",\"SemiAnnually\", \"Quarterly\",\"Monthly\", "
                             "'SINO', "
                             "'WaiverSAAnnual','WaiverSASemi', 'WaiverSAQuarter', 'WaiverSAMonth', "
                             "'PremiumWithoutHLoading') VALUES "
                             " (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\",'%@','%@','%@','%@','%@','%@') ",
                             riderCodeTemp,
                             annual, half, quarter, month,
                             SINo,
                             [waiverRidAnnSA objectAtIndex:a], [waiverRidHalfSA objectAtIndex:a],
                             [waiverRidQuarSA objectAtIndex:a], [waiverRidMonthSA objectAtIndex:a],
                             [PremWithoutHLoading objectAtIndex:a]];
            }
            
            if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                sqlite3_step(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
        //---------------
        
        tempDict = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:title, annual, half, quarter, month, nil]
                                                        forKeys:[NSArray arrayWithObjects:@"title", @"annual", @"half", @"quarter", @"month", nil]];
        [tempArr addObject:tempDict];
        
        annualRiderSum = annualRiderSum + [[waiverRidAnnTol objectAtIndex:a] doubleValue];
        halfRiderSum = halfRiderSum + [[waiverRidHalfTol objectAtIndex:a] doubleValue];
        quarterRiderSum = quarterRiderSum + [[waiverRidQuarTol objectAtIndex:a] doubleValue];
        monthRiderSum = monthRiderSum + [[waiverRidMonthTol objectAtIndex:a] doubleValue];
        
    }
    
    double tempHalf = halfRiderSum + basicPremHalf;
    double tempQtr = quarterRiderSum + basicPremQuar;
    double tempMonth = monthRiderSum + basicPremMonth;
    
    for (NSMutableDictionary *dict in tempArr) {
        annual = [dict objectForKey:@"annual"];
        if (tempHalf < 200) {
            half = @"-";
        } else {            
            half = [dict objectForKey:@"half"];
        }
        if (tempQtr < 150) {
            quarter = @"-";
        } else {
            quarter = [dict objectForKey:@"quarter"];
        }
        if (tempMonth < 50) {
            month = @"-";
        } else {
            month = [dict objectForKey:@"month"];
        }
        
        if (htmlRider.length == 0) {
            htmlRider = [[NSString alloc]initWithFormat:
                         @"<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>"
                         "<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>", [dict objectForKey:@"title"], annual, half, quarter, month];
        } else {
            htmlRider = [htmlRider stringByAppendingFormat:
                         @"<tr><td style='height:35px;'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "<td align='right'><font face='TreBuchet MS' size='3'>%@</font></td>"
                         "</tr>", [dict objectForKey:@"title"], annual, half, quarter, month];
        }
    }
}

-(void)calculateMedRiderPrem
{
    if (medRiderAnn.count != 0) {        
        annualMedRiderSum = 0;
        halfMedRiderSum = 0;
        quarterMedRiderSum = 0;
        monthMedRiderSum = 0;
        for (NSUInteger a=0; a<[medRiderAnn count]; a++) {
            annualMedRiderSum = annualMedRiderSum + [[medRiderAnn objectAtIndex:a] doubleValue];
            halfMedRiderSum = halfMedRiderSum + [[medRiderHalf objectAtIndex:a] doubleValue];
            quarterMedRiderSum = quarterMedRiderSum + [[medRiderQuar objectAtIndex:a] doubleValue];
            monthMedRiderSum = monthMedRiderSum + [[medRiderMonth objectAtIndex:a] doubleValue];
        }
    }
}

-(double) getACIR_CIWP_waiver:(double) value
{    
    double ridSA = 0.00;    
    for (int i=0; i<[riderCode count]; i++) {
        if ( [[riderCode objectAtIndex:i] isEqualToString:@"ACIR_MPP"] ) {
            ridSA = [[riderSA objectAtIndex:i] doubleValue];
            break;
        }
    }
    value = ((1 - (ridSA / [getBasicSA doubleValue]))) * value ;    
    return value;
}

-(void) getRiderTermRule : (NSString *)aaRidercode
{
    sqlite3_stmt *statement;
    double dblPseudoBSA;
    double dblPseudoBSA2 ;
    double dblPseudoBSA3 ;
    double dblPseudoBSA4 ;
    
    if ([getBasicPlan isEqualToString:STR_HLAWP]) {
        dblPseudoBSA = [getBasicSA doubleValue] * getMOP * [self getBasicSAFactor];
        dblPseudoBSA2 = dblPseudoBSA * 0.1;
        dblPseudoBSA3 = dblPseudoBSA * 5;
        dblPseudoBSA4 = dblPseudoBSA * 2;
    } else {
        dblPseudoBSA = [getBasicSA doubleValue] / 0.05;
        dblPseudoBSA2 = dblPseudoBSA * 0.1;
        dblPseudoBSA3 = dblPseudoBSA * 5;
        dblPseudoBSA4 = dblPseudoBSA * 2;
    }
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,ExpiryAge,MinTerm,MaxTerm,MinSA,MaxSA,MaxSAFactor FROM "
                              "Trad_Sys_Rider_Mtn WHERE RiderCode=\"%@\"",aaRidercode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                expAge_PREM =  sqlite3_column_int(statement, 2);
                minTerm_PREM =  sqlite3_column_int(statement, 3);
                maxTerm_PREM =  sqlite3_column_int(statement, 4);
                minSATerm_PREM = sqlite3_column_int(statement, 5);
                maxSATerm_PREM = sqlite3_column_int(statement, 6);
                maxSAFactor_PREM = sqlite3_column_double(statement, 7);
                
                if ([aaRidercode isEqualToString:@"CPA"]) {
                    maxSATerm_PREM = 100000;
                    
                    if (getOccpClass == 1 || getOccpClass == 2) {
                        if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                            if (dblPseudoBSA < 100000) {

                                maxSATerm_PREM = fmin(dblPseudoBSA3,200000);
                            } else if (dblPseudoBSA >= 100000) {
                                maxSATerm_PREM = fmin(dblPseudoBSA4,1000000);
                            }
                        } else if ([getPlanCode isEqualToString:STR_S100]) {
                            if ([getBasicSA doubleValue] < 100000) {
                                   maxSATerm_PREM = fmin([getBasicSA doubleValue]*5,200000);

                            } else if ([getBasicSA doubleValue] >= 100000) {
                                maxSATerm_PREM = fmin([getBasicSA doubleValue]*2,1000000);
                            }
                        }
                    } else if (getOccpClass == 3 || getOccpClass == 4) {
                        if ([getBasicPlan isEqualToString:STR_HLAWP]) {
                            maxSATerm_PREM = fmin(dblPseudoBSA3,100000);
                        } else if ([getPlanCode isEqualToString:STR_S100]) {
                            maxSATerm_PREM = fmin([getBasicSA doubleValue] *5,100000);
                        }
                    }
                }
            }
            sqlite3_finalize(statement);
        }
    
        sqlite3_close(contactDB);
    }

    if ([aaRidercode isEqualToString:@"LCPR"]) {
        if ([riderCode indexOfObject:@"CIWP"] != NSNotFound) {
            [self calculateBasicPremium]; //to get latest prem of Basic 
            [self calculateWaiver]; //to get the latest SA of waiver after revising the basic SA 
        }
        maxSATerm_PREM = 4000000 - [self calculateCIBenefitByRidercode:@"First" :@"LCPR"];
    } else if ([aaRidercode isEqualToString:@"WPTPD50R"]) {
        dblTotalGrossPrem = 0.00;
        [self calculateBasicPremium];
        [self calculateRiderPrem];
        [self calculateWaiver];
        [self updateSIStore];
        
        double tempLimit = 3500000 - [self CalcTPDbenefitByRidercode:@"WPTPD50R"];
        
        double temps;
        double tempGrossPrem = 0.00;
        
        if ([riderCode indexOfObject:@"WPTPD30R"] != NSNotFound) {
            temps =  1000000 - [[riderSA objectAtIndex:[riderCode indexOfObject:@"WPTPD30R"]] doubleValue];
            tempGrossPrem = 60 * dblTotalGrossPrem - [[riderSA objectAtIndex:[riderCode indexOfObject:@"WPTPD30R"]] doubleValue];
        } else {
            temps = 1000000;
            tempGrossPrem = 60 * dblTotalGrossPrem;
        }
        
        maxSATerm_PREM = floor(MIN(tempLimit, MIN(temps, tempGrossPrem)));
        
    } else if ([aaRidercode isEqualToString:@"WPTPD30R"]) {
        dblTotalGrossPrem = 0.00;
        [self calculateBasicPremium];
        [self calculateRiderPrem];
        [self calculateWaiver];
        [self updateSIStore];
        
        double tempLimit = 3500000 - [self CalcTPDbenefitByRidercode:@"WPTPD30R"];
        
        double temps;
        double tempGrossPrem = 0.00;
        
        if ( [riderCode indexOfObject:@"WPTPD50R"] != NSNotFound) {
            temps =  1000000 - [[riderSA objectAtIndex:[riderCode indexOfObject:@"WPTPD50R"]] doubleValue];
            tempGrossPrem = 60 * dblTotalGrossPrem - [[riderSA objectAtIndex:[riderCode indexOfObject:@"WPTPD50R"]] doubleValue];
        } else {
            temps = 1000000;
            tempGrossPrem = 60 * dblTotalGrossPrem;
        }
        
        maxSATerm_PREM = floor(MIN(tempLimit, MIN(temps, tempGrossPrem)));
    }

}

-(double)getBasicSAFactor{
    if (getTerm == 50) {
        return 2.5;
    } else if (getTerm == 30) {
        return 1.5;
    } else {
        return 0.00;
    }
}

-(void) getRiderTermRuleGYCC:(NSString*)rider aariderTerm:(int)aariderTerm
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK) {        
        NSString *querySQL = [NSString stringWithFormat: @"select gycc from SI_Trad_Rider_HLAWP_GYCC where planoption='%@' and PolTerm='%d' and premPayOpt='%d' and StartAge <= \"%d\" AND EndAge >= \"%d\"", rider,
                              [rider isEqualToString:@"EDUWR"] ? getTerm : aariderTerm,
                              getMOP,getAge,getAge];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                maxGycc = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    //edd case formula is not here because edd case does not have any medical rider therefore MHI wont be triggered
    if ([rider isEqualToString:@"WB30R"] || [rider isEqualToString:@"WB50R"] || [rider isEqualToString:@"WBD10R30"] || [rider isEqualToString:@"WBI6R30"] ) {
        maxSATerm_PREM = MIN(floor([requestBasicSA doubleValue] *  maxGycc/1000.00), 9999999) ;
    } else if ([rider isEqualToString:@"EDUWR"] ) {
        maxSATerm_PREM =[requestBasicSA doubleValue] * maxGycc/1000;
        
    }    
    minSATerm_PREM = 100;    
}

-(void)MHIGuideLines : (double)aaBasicSA
{
    double totalPrem;
    double medicDouble;
    double minus;
    double varSA;
    double TempRiderSA;
    double NewRiderSA;
    bool pop = false;
    double dGetBasicSA = aaBasicSA;
    NSString *newBasicSA = @"";
    [self calculateMedRiderPrem ];
    
    totalPrem = basicPremAnn + dblTotalOverallPrem;
    medicDouble = annualMedRiderSum * 2;
    if (medicDouble > totalPrem) {
        minus = totalPrem - annualMedRiderSum;
        
        if (minus > 0) {
            htmlRider = @"";
            varSA = (annualMedRiderSum/minus * dGetBasicSA + 0.5);
            newBasicSA = [NSString stringWithFormat:@"%.0f",varSA];
            dGetBasicSA = [newBasicSA doubleValue];
            getBasicSA = newBasicSA;
            [self getLSDRate];
            pop = true;
            
            //update basicSA to varSA
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
                NSString *querySQL = [NSString stringWithFormat:
                                      @"UPDATE Trad_Details SET BasicSA=\"%@\" WHERE SINo=\"%@\"",newBasicSA, requestSINo];
                
                if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                sqlite3_close(contactDB);
            }
            
            //update riderSA
            NSString *ridCode;
            NSString *updatetSQL;
            double newSA;
            for (NSUInteger u=0; u<[riderCode count]; u++)
            {
                ridCode = [riderCode objectAtIndex:u];
                
                if (!([ridCode isEqualToString:@"ACIR_MPP"]) && !([ridCode isEqualToString:@"C+"]) && !([ridCode isEqualToString:@"CIR"]) && !([ridCode isEqualToString:@"MG_II"]) &&
					!([ridCode isEqualToString:@"MG_IV"]) && !([ridCode isEqualToString:@"HB"]) && !([ridCode isEqualToString:@"HSP_II"]) &&
					!([ridCode isEqualToString:@"HMM"]) && !([ridCode isEqualToString:@"CIWP"]) && !([ridCode isEqualToString:@"LCWP"]) &&
					!([ridCode isEqualToString:@"PR"]) && !([ridCode isEqualToString:@"SP_STD"]) && !([ridCode isEqualToString:@"SP_PRE"] ) && !([ridCode isEqualToString:@"ICR"])) {
                    
                    if ([ridCode isEqualToString:@"WB30R"] || [ridCode isEqualToString:@"WB50R"] || [ridCode isEqualToString:@"WBD10R30"] ||
                       [ridCode isEqualToString:@"WBI6R30"] || [ridCode isEqualToString:@"EDUWR"] || [ridCode isEqualToString:@"WBM6R"]) {
                        [self getRiderTermRuleGYCC:ridCode aariderTerm:[[riderTerm objectAtIndex:u] integerValue]];
                    } else {
                        [self getRiderTermRule : ridCode];
                    }
                    
                    TempRiderSA = [[riderSA  objectAtIndex:u] doubleValue];
                    
                    if (TempRiderSA > 0) {
                        NewRiderSA= (annualMedRiderSum/minus) * TempRiderSA;
                    
                        if (NewRiderSA > maxSATerm_PREM) {
                            if (maxSATerm_PREM < 0) { //that mean it has violate the CI benefit rules, therefore no more SA can be allocate for this rider, so put back the ori SA to this rider
                                newSA = TempRiderSA;
                            } else {
                                if (maxSATerm_PREM < minSATerm_PREM) {
                                    newSA = TempRiderSA;
                                } else {
                                    if (maxSATerm_PREM < TempRiderSA && [ridCode isEqualToString:@"LCPR"]) { // mean new revised SA is lower than previous SA. this happenned to CI Rider only
                                        newSA = TempRiderSA;
                                    } else {
                                        newSA = maxSATerm_PREM;
                                    }
                                }                            
                            }
                        } else {
                            if (NewRiderSA < TempRiderSA) { // mean new revised SA is lower than previous SA. this happenned to CI Rider only
                                newSA = TempRiderSA;
                            } else {
                                newSA = NewRiderSA;
                            }                        
                        }
                        
                        newSA = round(newSA);
                        
                        sqlite3_stmt *statement;
                        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                        {
                            updatetSQL = [NSString stringWithFormat:
                                                    @"UPDATE Trad_Rider_Details SET SumAssured=\"%.f\" WHERE SINo=\"%@\" AND RiderCode=\"%@\" ", newSA,requestSINo,ridCode];
                            
                            if (sqlite3_prepare_v2(contactDB, [updatetSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                                sqlite3_step(statement);
                                sqlite3_finalize(statement);
                            }                            
                            sqlite3_close(contactDB);
                        }
                    }
                } else {
                    continue;
                }
            }
            
            dblTotalOverallPrem = 0.00;
            
            [self calculateBasicPremium];
            [self checkExistRider];
            [self calculateRiderPrem];  //calculate riderPrem
            [self calculateWaiver];     //calculate waiverPrem
            [self calculateMedRiderPrem];       //calculate medicalPrem
            [self updateSIStore];
            //--second cycle--//
            
            totalPrem = basicPremAnn + dblTotalOverallPrem;
            medicDouble = annualMedRiderSum * 2;
            
            if (medicDouble > totalPrem) {
                [self MHIGuideLines:[newBasicSA doubleValue]];
            } else { 
                if (pop) {
                    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                    del.MhiMessage = newBasicSA;
                } else {
                    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                    del.MhiMessage = @"";
                }
            }
        }
    } else {
        AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        del.MhiMessage = @"";
    }
}

-(double)calculateCIBenefit
{
    sqlite3_stmt *statement;
    double CI = 0.00;
    NSMutableArray *ArrayCIRider = [[NSMutableArray alloc] init ];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    NSString *strRiders = @"";
    int count = 0;
    NSString *tempCode;
    
    int tempRiderTerm;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *SelectSQL = [NSString stringWithFormat:
                               @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                               "('ACIR_MPP', 'CIR', 'ICR', 'LCPR','CIWP') and sino = \"%@\" ", SINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                if ([tempCode isEqualToString:@"ACIR_MPP"] || [tempCode isEqualToString:@"CIR"] || [tempCode isEqualToString:@"LCPR"] || [tempCode isEqualToString:@"PLCP"]) {
                    CI = CI + sqlite3_column_double(statement, 1);
                    count++;
                } else if ([tempCode isEqualToString:@"ICR"]) {
                    CI = CI +  sqlite3_column_double(statement, 1) * 10;
                    count++;
                } else if ([tempCode isEqualToString:@"CIWP"] ) {
                    [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                             forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                    count++;
                }                
                strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];                
            }            
            sqlite3_finalize(statement);
        }
        
        SelectSQL = [NSString stringWithFormat:
                     @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                     "('CIWP') and sino = \"%@\" ", SINo];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                    tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];                    
                    
                    if (tempRiderTerm <= 10) {
                        CI = CI +  sqlite3_column_double(statement, 1) * 4;                        
                    } else {
                        CI = CI +  sqlite3_column_double(statement, 1) * 8;                        
                    }                    
                } 
            }            
            sqlite3_finalize(statement);
        }
        
        if (CI > 4000000 && count > 0) {
            NSString *msg = [NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                             "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 1st Life Assured"
                             " has exceeded RM4mil.\n %@", strRiders];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
            [alert show ];
            
        } else {
            temp = [[NSMutableDictionary alloc] init];
            count = 0;
            CI = 0.00;
            ArrayCIRider = [[NSMutableArray alloc] init ];
            strRiders = @"";
            
            SelectSQL = [NSString stringWithFormat:
                         @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                         "('LCWP') and sino = \"%@\" ", SINo];
            
            if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    
                    if ([tempCode isEqualToString:@"LCWP"] ) {
                        [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                                 forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                        count++;
                    }                    
                    strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];                    
                }                
                sqlite3_finalize(statement);
            }
            
            SelectSQL = [NSString stringWithFormat:
                            @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                            "('LCWP') and sino = \"%@\" ", SINo];
                
            if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                       [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                       [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                        tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];                        
                        
                        if (tempRiderTerm <= 10) {
                            CI = CI +  sqlite3_column_double(statement, 1) * 4;                            
                        } else {
                            CI = CI +  sqlite3_column_double(statement, 1) * 8;                            
                        }                        
                    }                    
                }                
                sqlite3_finalize(statement);
            }
            
            if (CI > 4000000 && count > 0) {
                NSString *msg = [NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                 "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for Payor"
                                 " has exceeded RM4mil.\n %@", strRiders];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                [alert show ];
            } else {
                temp = [[NSMutableDictionary alloc] init];
                count = 0;
                CI = 0.00;
                ArrayCIRider = [[NSMutableArray alloc] init ];
                strRiders = @"";
                
                SelectSQL = [NSString stringWithFormat:
                             @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                             "('SP_PRE') and sino = \"%@\" ", SINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        tempCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                        
                        if ([tempCode isEqualToString:@"SP_PRE"]) {
                            [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                                     forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                            count++;
                        }                    
                        strRiders = [strRiders stringByAppendingString:[NSString stringWithFormat:@"%d. %@\n", count, tempCode   ]];                    
                    }                
                    sqlite3_finalize(statement);
                }
                
                SelectSQL = [NSString stringWithFormat:
                             @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                             "('SP_PRE') and sino = \"%@\" ", SINo];
                
                if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                           [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                           [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                            tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];                        
                            
                            if (tempRiderTerm <= 10) {
                                CI = CI +  sqlite3_column_double(statement, 1) * 4;                            
                            } else {
                                CI = CI +  sqlite3_column_double(statement, 1) * 8;                            
                            }
                        }                    
                    }
                    
                    sqlite3_finalize(statement);
                }
                
                if (CI > 4000000 && count > 0) {
                    NSString *msg = [NSString stringWithFormat:@"CI Benefit Limit per Life across industry is capped at RM4mil. "
                                     "Please revise the RSA of CI related rider(s) below as the CI Benefit Limit per Life across industry for 2nd Life Assured"
                                     " has exceeded RM4mil.\n %@", strRiders];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "  message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                    [alert show ];
                }
            }
        }
        
        sqlite3_close(contactDB);
    }
    
    temp = Nil;
    ArrayCIRider = Nil;
    return CI;
}

-(double)calculateCIBenefitByRidercode: (NSString *)PersonType :(NSString *)Ridercode
{    
    sqlite3_stmt *statement;
    double CI = 0.00;
    NSMutableArray *ArrayCIRider = [[NSMutableArray alloc] init ];
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    int tempRiderTerm;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *SelectSQL;
        
        if ([PersonType isEqualToString:@"First"]) {
            SelectSQL = [NSString stringWithFormat:
                         @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                         "('ACIR_MPP', 'CIR', 'ICR', 'LCPR','CIWP') and sino = \"%@\" AND Ridercode <> '%@' ", SINo, Ridercode];
        } else if ([PersonType isEqualToString:@"Second"]) {
            SelectSQL = [NSString stringWithFormat:
                         @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                         "('PLCP') and sino = \"%@\" AND Ridercode <> '%@' ", SINo, Ridercode];
        } else if ([PersonType isEqualToString:@"Payor"]) {
            SelectSQL = [NSString stringWithFormat:
                         @"select ridercode, sumAssured, riderterm from trad_rider_details where ridercode in "
                         "('PLCP') and sino = \"%@\" AND Ridercode <> '%@' ", SINo, Ridercode];
        }
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"ACIR_MPP"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIR"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"PLCP"]) {
                    CI = CI + sqlite3_column_double(statement, 1);
                    
                } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"ICR"]) {
                    CI = CI +  sqlite3_column_double(statement, 1) * 10;
                    
                } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                        [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                        [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                    
                    [temp setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                             forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                }                
            }            
            sqlite3_finalize(statement);
        }
        
        SelectSQL = [NSString stringWithFormat:
                     @"select type, WaiverSAAnnual from SI_Store_Premium where Type in "
                     "('CIWP') and sino = \"%@\" AND Type <> '%@' ", SINo, Ridercode];
        
        if (sqlite3_prepare_v2(contactDB, [SelectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CIWP"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCWP"] ||
                   [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"SP_PRE"]) {
                    tempRiderTerm = [[temp objectForKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]] intValue];
                    
                    if (tempRiderTerm <= 10) {
                        CI = CI +  sqlite3_column_double(statement, 1) * 4;
                    } else {
                        CI = CI +  sqlite3_column_double(statement, 1) * 8;
                    }                    
                }                
            }            
            sqlite3_finalize(statement);
        }        
        sqlite3_close(contactDB);
    }
    
    temp = Nil;
    ArrayCIRider = Nil;
    return CI;
}

-(double)CalcTPDbenefitByRidercode :(NSString *)Ridercode
{
    sqlite3_stmt *statement;
    double tempValue = 0.00;
    double tempPrem = 0;
    double tempPremWithoutLoading = 0;
    NSMutableDictionary *tempArray = [[NSMutableDictionary alloc] init];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;        
        querySQL = [NSString stringWithFormat:@"SELECT Ridercode, sumAssured FROM TRAD_Rider_Details WHERE RiderCode in ('CCTR', 'LCPR', 'WPTPD30R', 'WPTPD50R' ) "
                    "AND SINO = '%@' ", SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {                
                [tempArray setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]
                              forKey:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];                
            }            
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT Type, REPLACE(Annually, ',', ''),REPLACE(PremiumWithoutHLoading, ',', '') "
                    "FROM SI_Store_Premium WHERE Type IN ('B', 'CCTR', 'EDUWR', 'LCPR', 'WB30R', 'WB50R', 'WBI6R30', 'WBD10R30', 'WBM6R', 'WPTPD30R', 'WPTPD50R' ) "
                    "AND SINo = '%@' AND Type <> '%@' ", SINo, Ridercode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempPrem = sqlite3_column_double(statement, 1);
                tempPremWithoutLoading = sqlite3_column_double(statement, 2);
                
                if (getTerm == 30) {
                    if (getMOP == 6) {                        
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 9; //9 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBM6R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            
                        }                        
                    } else {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 15; //9 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            
                        }
                    }
                } else {
                    if (getMOP == 6) {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 15; //15 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBM6R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 6; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD50R"] doubleValue]; //50% of the Rider Sum Assured
                        }
                    } else {
                        if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"B"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 25; //15 times basic premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"CCTR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"CCTR"] doubleValue]; // 1 time rider sum assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"EDUWR"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total rider premium payable calculated based on annual mode of payment
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"LCPR"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"LCPR"] doubleValue];
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB30R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WB50R"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBD10R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WBI6R30"]) {
                            tempValue = tempValue + tempPremWithoutLoading * 10; //6 times of total premium payable calculated based on an annual basis
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD30R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD30R"] doubleValue]; //50% of the Rider Sum Assured
                        } else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] isEqualToString:@"WPTPD50R"]) {
                            tempValue = tempValue + 1 * [[tempArray valueForKey:@"WPTPD50R"] doubleValue]; //50% of the Rider Sum Assured
                        }
                    }
                }
            }            
            sqlite3_finalize(statement);
        }                
        sqlite3_close(contactDB);
    }
    
    return tempValue;
}

#pragma mark - handle db

-(void)getBasicSIRate:(int)fromAge toAge:(int)toAge
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        NSString *sexStr;
        
        if ( [sex isEqualToString:@"FEMALE"] ) {
            sexStr = @"F";
        } else if ( [sex isEqualToString:@"MALE"] ) {
            sexStr = @"M";
        } else {
            sexStr = sex;
        }
        
        if ([getBasicPlan isEqualToString:STR_HLAWP] ) {
            querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem_new WHERE PlanCode=\"%@\" AND FromAge<=\"%d\" AND ToAge>=\"%d\" AND FromTerm <=\"%d\" "
                        "AND ToTerm >= \"%d\" AND PremPayOpt=\"%d\" ",
                        getBasicPlan,fromAge,toAge,getTerm,getTerm,getMOP];
        } else if ([getBasicPlan isEqualToString:STR_S100]) {
            querySQL = [NSString stringWithFormat: @"SELECT Rate, PremPayOpt FROM Trad_Sys_Basic_Prem_new WHERE PlanCode=\"%@\" AND Sex=\"%@\" AND FromAge=\"%d\" AND ToAge=\"%d\" ",
                        getBasicPlan,sexStr,fromAge,toAge];
        }
        else if([getBasicPlan isEqualToString:@"BCALH"])
        {
            querySQL = [NSString stringWithFormat: @"SELECT Rates FROM Basic_Prem WHERE trim(Gender) = '%@' AND EntryAge = '%d' AND Premium_Term = '%d'  ", sexStr, fromAge, getMOP ];
        }

        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if ([getBasicPlan isEqualToString:STR_S100]) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    basicRate =  sqlite3_column_double(statement, 0);
                    if (sqlite3_column_int(statement, 1) == getMOP) {
                        break;
                    }
                }
            } else {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    basicRate =  sqlite3_column_double(statement, 0);
                }
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}


-(void)getLSDRate
{
    sqlite3_stmt *statement;
    if (sqlite3_open([RatesDatabasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Basic_LSD WHERE PlanCode=\"%@\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",getBasicPlan,getBasicSA,getBasicSA];
        
        if ([getBasicPlan isEqualToString:STR_HLAWP]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Basic_LSD WHERE PlanCode=\"%@\" AND FromSA <=\"%@\" AND ToSA >= \"%@\" and PremPayOpt='%d'",getBasicPlan,getBasicSA,getBasicSA,getMOP];
        } else if ([getBasicPlan isEqualToString:STR_S100]) {
            int prem = 100;
            if (getMOP <= 20) { // not dynamic
                prem = getMOP;
            }
            
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Basic_LSD WHERE PlanCode=\"%@\" AND FromSA <=\"%@\" AND ToSA >= \"%@\" and PremPayOpt='%d'",getBasicPlan,getBasicSA,getBasicSA,prem];
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                LSDRate =  sqlite3_column_double(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccLoad
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",getOccpCode];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoad =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }    
}

-(void)checkExistRider
{
    riderCode = [[NSMutableArray alloc] init];
    riderDesc = [[NSMutableArray alloc] init];
    riderTerm = [[NSMutableArray alloc] init];
    riderSA = [[NSMutableArray alloc] init];
    riderPlanOpt = [[NSMutableArray alloc] init];
    riderUnit = [[NSMutableArray alloc] init];
    riderDeduct = [[NSMutableArray alloc] init];
    riderHL1K = [[NSMutableArray alloc] init];
    riderHL100 = [[NSMutableArray alloc] init];
    riderHLP = [[NSMutableArray alloc] init];
    riderCustCode = [[NSMutableArray alloc] init];
    riderSmoker = [[NSMutableArray alloc] init];
    riderSex = [[NSMutableArray alloc] init];
    riderAge = [[NSMutableArray alloc] init];
    riderOccp = [[NSMutableArray alloc] init];
    riderTempHL1K = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.RiderCode, b.RiderDesc, a.RiderTerm, a.SumAssured, a.PlanOption, a.Units, a.Deductible, a.HL1KSA, a.HL100SA, a.HLPercentage, c.CustCode, d.Smoker, d.Sex, d.ALB, d.OccpCode, a.TempHL1kSA from Trad_Rider_Details a, Trad_Sys_Rider_Profile b, Trad_LAPayor c, Clt_Profile d WHERE a.RiderCode=b.RiderCode AND a.PTypeCode=c.PTypeCode AND a.Seq=c.Sequence AND d.CustCode=c.CustCode AND a.SINo=c.SINo AND a.SINo=\"%@\" ORDER by a.Seq ASC, a.RiderCode ASC", SINo];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *rider = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                [riderCode addObject:rider];
                [riderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                
                const char *RTerm = (const char *) sqlite3_column_text(statement, 2);
                [riderTerm addObject:RTerm == NULL ? nil :[[NSString alloc] initWithUTF8String:(const char *)RTerm]];
                
                const char *RsumA = (const char *) sqlite3_column_text(statement, 3);
                [riderSA addObject:RsumA == NULL ? nil :[[NSString alloc] initWithUTF8String:RsumA]];
                
                const char *plan = (const char *) sqlite3_column_text(statement, 4);
                [riderPlanOpt addObject:plan == NULL ? nil :[[NSString alloc] initWithUTF8String:plan]];
                
                const char *uni = (const char *) sqlite3_column_text(statement, 5);
                [riderUnit addObject:uni == NULL ? nil :[[NSString alloc] initWithUTF8String:uni]];
                
                const char *deduct2 = (const char *) sqlite3_column_text(statement, 6);
                [riderDeduct addObject:deduct2 == NULL ? nil :[[NSString alloc] initWithUTF8String:deduct2]];
                
                double ridHL = sqlite3_column_double(statement, 7);
                [riderHL1K addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHL]];
                
                double ridHL100 = sqlite3_column_double(statement, 8);
                [riderHL100 addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHL100]];
                
                double ridHLP = sqlite3_column_double(statement, 9);
                [riderHLP addObject:[[NSString alloc] initWithFormat:@"%.2f",ridHLP]];
                
                [riderCustCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)]];
                [riderSmoker addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)]];
                [riderSex addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]];
                [riderAge addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)]];
                [riderOccp addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)]];
                
                double tempRidHL = sqlite3_column_double(statement, 15);
                [riderTempHL1K addObject:[[NSString alloc] initWithFormat:@"%.2f",tempRidHL]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

//---

-(void)getRiderRateAgeSexCplus:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOptC:(NSString *) plnOptC2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {        
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\"  AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND Sex=\"%@\" AND RiderOpt=\"%@\" ",
                              RidCode,aaterm,fromAge,toAge,sex, plnOptC2];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(void)getRiderRateSex:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND PremPayOpt=\"%d\" AND Sex=\"%@\" ",
                              RidCode,aaterm,fromAge,toAge,getMOP,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAge:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {        
        //----------------- edited by heng on 25th oct 2012 because IE20R and IE30R dont have term
        NSString *querySQL;
        if (aaterm == 0) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND PremPayOpt=\"%d\"",
                        RidCode,fromAge,toAge,getMOP];
        } else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND PremPayOpt=\"%d\"",
                        RidCode,fromAge,toAge,getMOP];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexSmoker:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge smoker:(NSString*)smoker
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\"  AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND Sex=\"%@\" AND LTRIM(RTRIM(Smoker))=\"%@\"",
                              RidCode,aaterm,fromAge,toAge,sex,smoker];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getHLAWPRiderRate:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND PremPayOpt=\"%d\"",
                              RidCode,aaterm,fromAge,toAge,getMOP];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getHLAWPRiderRateNonGYI:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND PremPayOpt=\"%d\" and sex='%@'",
                              RidCode,aaterm,fromAge,toAge,getMOP,sex];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSex:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Term = \"%d\"  AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND Sex=\"%@\" ",
                              RidCode,aaterm,fromAge,toAge,sex];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassMG_IV:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString * entryAgeGrp;
        int ageNo = [fromAge intValue];
        if ( ageNo > 60 ) {
            entryAgeGrp = @"2";
        } else {
            entryAgeGrp = @"1";
        }
        
        int subClass;
        if (getOccpClass == 2) {
            subClass = 1;
        } else {
            subClass = getOccpClass;
        }
        
        planOption2 = [planOption2 stringByReplacingOccurrencesOfString:@"IVP_" withString:@""];
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, \"FromAge\", \"ToAge\" FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND Sex=\"%@\" AND occpClass = \"%d\" AND PlanOption=\"%@\" AND EntryAgeGroup=\"%@\"",
                              RidCode,fromAge,toAge,sex, subClass, planOption2, entryAgeGrp];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //----------- for report part  ----------- added by heng
        if ([RidCode isEqualToString:@"HMM"] || [RidCode isEqualToString:@"MG_II"] || [RidCode isEqualToString:@"MG_IV"] ) {
            ReportHMMRates = [[NSMutableArray alloc] init ];
            ReportFromAge = [[NSMutableArray alloc] init ];
            ReportToAge = [[NSMutableArray alloc] init ];
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate, \"FromAge\", \"ToAge\" FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Sex=\"%@\" "
                        "AND occpClass = \"%d\" AND PlanOption=\"%@\" AND EntryAgeGroup=\"%@\"",
                        RidCode,[sex substringToIndex:1], subClass, planOption2, entryAgeGrp];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    [ReportHMMRates addObject:[NSString stringWithFormat:@"%.3f", sqlite3_column_double(statement, 0)]];
                    [ReportFromAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)]];
                    [ReportToAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }
        }
        //----------- report part end -------------------------
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassMG_II:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" "
                              "AND occpClass = \"%d\" AND PlanOption=\"%@\"",
                              RidCode,fromAge,toAge,sex, getOccpClass, planOption2];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //----------- for report part  ----------- added by heng
        if ([RidCode isEqualToString:@"HMM"] || [RidCode isEqualToString:@"MG_II"] || [RidCode isEqualToString:@"MG_IV"] ) {
            ReportHMMRates = [[NSMutableArray alloc] init ];
            ReportFromAge = [[NSMutableArray alloc] init ];
            ReportToAge = [[NSMutableArray alloc] init ];
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND Sex=\"%@\" "
                        "AND occpClass = \"%d\" AND PlanOption=\"%@\"",
                        RidCode,sex, getOccpClass, planOption2];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    [ReportHMMRates addObject:[NSString stringWithFormat:@"%.3f", sqlite3_column_double(statement, 0)]];
                    [ReportFromAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)]];
                    [ReportToAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }
        }
        //----------- report part end -------------------------
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeSexClassHMM:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge planOption:(NSString *)planOption2 hmm:(NSString *)hmm
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString * entryAgeGrp;
        int ageNo = [fromAge intValue];
        if ( ageNo > 60 ) {
            entryAgeGrp = @"2";
        } else {
            entryAgeGrp = @"1";
        }
        
        int subClass;
        if (getOccpClass == 2) {
            subClass = 1;
        } else {
            subClass = getOccpClass;
        }
        
        planOption2 = [planOption2 stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE "
                              "RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND Sex=\"%@\" "
                              "AND occpClass = \"%d\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND EntryAgeGroup=\"%@\"",
                              RidCode,fromAge,toAge,sex, subClass, planOption2, hmm, entryAgeGrp];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //----------- for report part  ----------- added by heng
        if ([RidCode isEqualToString:@"HMM"] || [RidCode isEqualToString:@"MG_II"] || [RidCode isEqualToString:@"MG_IV"] ) {
            ReportHMMRates = [[NSMutableArray alloc] init ];
            ReportFromAge = [[NSMutableArray alloc] init ];
            ReportToAge = [[NSMutableArray alloc] init ];
            querySQL = [NSString stringWithFormat:
                        @"SELECT replace(Rate, ',', '') as Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE "
                        "RiderCode=\"%@\" AND Sex=\"%@\" AND occpClass = \"%d\" AND PlanOption=\"%@\" AND Deductible=\"%@\" AND EntryAgeGroup=\"%@\"",
                        RidCode,sex, subClass, planOption2, hmm, entryAgeGrp];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                    [ReportHMMRates addObject:[NSString stringWithFormat:@"%.3f", sqlite3_column_double(statement, 0)]];
                    [ReportFromAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)]];
                    [ReportToAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }
        }
        //----------- report part end -------------------------
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeClassPA:(NSString *)RidCode riderTerm:(int)aaterm fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" AND occpClass = \"%d\" ",
                              RidCode, fromAge,toAge, getOccpClass ];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //----------- for report part  ----------- added by heng
        if ([RidCode isEqualToString:@"HSP_II"]) {
            ReportHMMRates = [[NSMutableArray alloc] init ];
            ReportFromAge = [[NSMutableArray alloc] init ];
            ReportToAge = [[NSMutableArray alloc] init ];
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND occpClass = \"%d\" ",RidCode, getOccpClass ];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    [ReportHMMRates addObject:[NSString stringWithFormat:@"%.3f", sqlite3_column_double(statement, 0)]];
                    [ReportFromAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)]];
                    [ReportToAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }
        }
        //----------- report part end -------------------------
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateAgeClassHSP_II:(NSString *)RidCode riderTerm:(int)aaterm planHSPII:(NSString *)plans fromAge:(NSString*)fromAge toAge:(NSString*)toAge
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND FromAge<=\"%@\" AND ToAge >=\"%@\" "
                              "AND occpClass = \"%d\" AND RiderOpt=\"%@\"",
                              RidCode, fromAge,toAge, getOccpClass,plans ];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        
        //----------- for report part  ----------- added by heng
        if ([RidCode isEqualToString:@"HSP_II"]) {
            ReportHMMRates = [[NSMutableArray alloc] init ];
            ReportFromAge = [[NSMutableArray alloc] init ];
            ReportToAge = [[NSMutableArray alloc] init ];
            querySQL = [NSString stringWithFormat:
                        @"SELECT Rate, FromAge, ToAge FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" AND occpClass = \"%d\" AND RiderOpt=\"%@\"",
                        RidCode, getOccpClass,plans ];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    [ReportHMMRates addObject:[NSString stringWithFormat:@"%.3f", sqlite3_column_double(statement, 0)]];
                    [ReportFromAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 1)]];
                    [ReportToAge addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }
        }
        //----------- report part end -------------------------
        
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRateClass:(NSString *)RidCode riderTerm:(int)aaterm 
{
    const char *dbpath = [RatesDatabasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Rate FROM Trad_Sys_Rider_Prem_New WHERE RiderCode=\"%@\" "
                              " AND occpClass = \"%d\" ",
                              RidCode, getOccpClass];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  [self getFormattedRates:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

//-----

-(void)getOccLoadRider
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT OccLoading_TL FROM Adm_Occp_Loading_Penta WHERE OccpCode=\"%@\"",strOccp];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoadRider =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
}

#pragma mark - memory management

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setWebView:nil];
    [self setRequestOccpCode:nil];
    [self setRequestSINo:nil];
    [self setRequestBasicSA:nil];
    [self setRequestBasicHL:nil];
    [self setRequestBasicTempHL:nil];
    [self setRequestPlanCode:nil];
    [self setGetOccpCode:nil];
    [self setSINo:nil];
    [self setGetBasicSA:nil];
    [self setGetBasicHL:nil];
    [self setGetBasicTempHL:nil];
    [self setGetPlanCode:nil];
    [self setSex:nil];
    [self setRiderCode:nil];
    [self setRiderDesc:nil];
    [self setRiderTerm:nil];
    [self setRiderSA:nil];
    [self setRiderHL1K:nil];
    [self setRiderHL100:nil];
    [self setRiderHLP:nil];
    [self setRiderPlanOpt:nil];
    [self setRiderUnit:nil];
    [self setRiderDeduct:nil];
    [self setRiderCustCode:nil];
    [self setRiderSmoker:nil];
    [self setRiderSex:nil];
    [self setRiderAge:nil];
    [self setRiderOccp:nil];
    [self setStrOccp:nil];
    [self setPlanCodeRider:nil];
    [self setPentaSQL:nil];
    [self setPlnOptC:nil];
    [self setPlanOptHMM:nil];
    [self setDeducHMM:nil];
    [self setPlanHSPII:nil];
    [self setPlanMGII:nil];
    [self setPlanMGIV:nil];
    [self setHtmlRider:nil];
    [self setAnnualRiderTot:nil];
    [self setHalfRiderTot:nil];
    [self setQuarterRiderTot:nil];
    [self setMonthRiderTot:nil];
    [self setWaiverRiderAnn:nil];
    [self setWaiverRiderAnn2:nil];
    [self setWaiverRiderHalf:nil];
    [self setWaiverRiderHalf2:nil];
    [self setWaiverRiderQuar:nil];
    [self setWaiverRiderQuar2:nil];
    [self setWaiverRiderMonth:nil];
    [self setWaiverRiderMonth2:nil];
    [self setLblMessage:nil];
    [self setReportHMMRates:nil];
    [self setReportFromAge:nil];
    [self setReportToAge:nil];
    [self setRiderTempHL1K:nil];
    [self setHeaderTitle:nil];
    [self setMyToolBar:nil];
    [super viewDidUnload];
}

-(void)deleteSIStorePremium{
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *DeleteSQL =  [ NSString stringWithFormat: @"DELETE from SI_Store_Premium where sino = '%@'", SINo];
        if (sqlite3_prepare_v2(contactDB, [DeleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }    
    
}

-(double)ReturnGrossPrem{
    return dblTotalGrossPrem;
}

-(void)CloseWindow{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark created by faiz
-(NSString *)getRatesInt{
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    NSString* premType;
    
    if ([PremiType isEqualToString:@"Premi 5 Tahun"]){
        premType = @"R";
    }
    else{
        premType = @"S";
    }
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_PayorAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
        
    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_LAAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
        
    }
    return RatesPremiumRate;
}

-(NSString *)getRatesIntPremiDasar{
    NSString*AnsuransiDasarQuery;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    NSString* premType;
    
    if ([PremiType isEqualToString:@"Premi 5 Tahun"]){
        premType = @"R";
    }
    else{
        premType = @"S";
    }
    

    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_PayorAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_LAAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([LASex isEqualToString:@"Male"]||[LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
        }
    }
    return RatesPremiumRate;
}

-(double)totalPremiBulanan{
    return [self calculateExtraPremiPercentBulanan] + [self calculateExtraPremiNumberBulanan] + [self getPremiDasarBulanan];
}

-(double)totalPremiTahunan{
    return [self calculateExtraPremiPercentTahunan] + [self calculateExtraPremiNumberTahunan] + [self getPremiDasarTahunan];
}

-(double)getPremiDasarBulanan{
    double PaymentMode=0.1;
    double RatesInt = [[self getRatesIntPremiDasar] doubleValue];
    double test = PaymentMode * RatesInt;
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double test2 = (test * BasisSumAssured)/1000;
    return test2;
}

-(double)getPremiDasarTahunan{
    double PaymentMode=1;
    double RatesInt = [[self getRatesIntPremiDasar] doubleValue];
    double test = PaymentMode * RatesInt;
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double test2 = (test * BasisSumAssured)/1000;
    return test2;
}

-(double)calculateExtraPremiPercentSekaligus{
    double PaymentMode=1;
    double RatesInt0 = [[self getRatesInt] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;
}

-(double)calculateExtraPremiPercentTahunan{
    double PaymentMode=1;
    double RatesInt0 = [[self getRatesInt] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;

}

-(double)calculateExtraPremiPercentBulanan{
    double PaymentMode=0.1;
    double RatesInt0 = [[self getRatesInt] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;

}

-(double)calculateExtraPremiNumberSekaligus{
    double PaymentMode=1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
}

-(double)calculateExtraPremiNumberTahunan{
    double PaymentMode=1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
    
}

-(double)calculateExtraPremiNumberBulanan{
    double PaymentMode=0.1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
}

-(void)loadDataFromDB{
    NSString* premiDasar = [dictionaryPremium valueForKey:@"PremiumPolicyA"];
    NSString* totalPremi = [dictionaryPremium valueForKey:@"TotalPremiumLoading"];
    int IsInternalStaff =[[dictionaryPremium valueForKey:@"IsInternalStaff"] intValue];
    
    [lblAsuransiDasarSekaligus setText:@"0"];
    [lblExtraPremiPercentSekaligus setText:@"0"];
    [lblExtraPremiNumberSekaligus setText:@"0"];
    [lblDiskonSekaligus setText:@"0"];
    [lblTotalSekaligus setText:@"0"];
    
    [lblAsuransiDasarBulanan setText:@"0"];
    [lblExtraPremiPercentBulanan setText:@"0"];
    [lblExtraPremiNumberBulanan setText:@"0"];
    [lblDiskonBulanan setText:@"0"];
    [lblTotalBulanan setText:@"0"];
    
    [lblAsuransiDasarTahunan setText:@"0"];
    [lblExtraPremiPercentTahunan setText:@"0"];
    [lblExtraPremiNumberTahunan setText:@"0"];
    [lblDiskonTahunan setText:@"0"];
    [lblTotalTahunan setText:@"0"];
    
    
    [lblAsuransiDasarSekaligus setTextColor:[UIColor clearColor]];
    [lblExtraPremiPercentSekaligus setTextColor:[UIColor clearColor]];
    [lblExtraPremiNumberSekaligus setTextColor:[UIColor clearColor]];
    [lblDiskonSekaligus setTextColor:[UIColor clearColor]];
    [lblTotalSekaligus setTextColor:[UIColor whiteColor]];
    
    [lblAsuransiDasarBulanan setTextColor:[UIColor clearColor]];
    [lblExtraPremiPercentBulanan setTextColor:[UIColor clearColor]];
    [lblExtraPremiNumberBulanan setTextColor:[UIColor clearColor]];
    [lblDiskonBulanan setTextColor:[UIColor clearColor]];
    [lblTotalBulanan setTextColor:[UIColor whiteColor]];
    
    [lblAsuransiDasarTahunan setTextColor:[UIColor clearColor]];
    [lblExtraPremiPercentTahunan setTextColor:[UIColor clearColor]];
    [lblExtraPremiNumberTahunan setTextColor:[UIColor clearColor]];
    [lblDiskonTahunan setTextColor:[UIColor clearColor]];
    [lblTotalTahunan setTextColor:[UIColor whiteColor]];
    
    /*if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
     {
     [lblAsuransiDasarSekaligus setText:premiDasar];
     [lblExtraPremiPercentSekaligus setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiPercentSekaligus]]]]];
     [lblExtraPremiNumberSekaligus setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiNumberSekaligus]]]]];
     [lblTotalSekaligus setText:totalPremi];
     
     [lblAsuransiDasarSekaligus setTextColor:themeColour];
     [lblExtraPremiPercentSekaligus setTextColor:themeColour];
     [lblExtraPremiNumberSekaligus setTextColor:themeColour];
     
     }
     else if ([Highlight isEqualToString:@"Bulanan"]){
     [lblAsuransiDasarBulanan setText:premiDasar];
     [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiPercentBulanan]]]]];
     [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiNumberBulanan]]]]];
     [lblTotalBulanan setText:totalPremi];
     
     [lblAsuransiDasarTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self getPremiDasarTahunan]]]]];
     [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiPercentTahunan]]]]];
     [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiNumberTahunan]]]]];
     [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self totalPremiTahunan]]]]];
     
     [lblAsuransiDasarBulanan setTextColor:themeColour];
     [lblExtraPremiPercentBulanan setTextColor:themeColour];
     [lblExtraPremiNumberBulanan setTextColor:themeColour];
     
     [lblAsuransiDasarTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     [lblExtraPremiPercentTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     [lblExtraPremiNumberTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     }
     else{
     [lblAsuransiDasarBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self getPremiDasarBulanan]]]]];
     [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiPercentBulanan]]]]];
     [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiNumberBulanan]]]]];
     [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self totalPremiBulanan]]]]];
     
     [lblAsuransiDasarTahunan setText:premiDasar];
     [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiPercentTahunan]]]]];
     [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[Premformatter stringFromNumber:[NSNumber numberWithDouble:[self calculateExtraPremiNumberTahunan]]]]];
     [lblTotalTahunan setText:totalPremi];
     
     [lblAsuransiDasarBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     [lblExtraPremiPercentBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     [lblExtraPremiNumberBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
     
     [lblAsuransiDasarTahunan setTextColor:themeColour];
     [lblExtraPremiPercentTahunan setTextColor:themeColour];
     [lblExtraPremiNumberTahunan setTextColor:themeColour];
     }*/
    
    [lblAsuransiDasarSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarSekaligus]]]]];
    [lblExtraPremiPercentSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentSekaligus]]]]];
    [lblExtraPremiNumberSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberSekaligus]]]]];
    //[lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiSekaligus]]]]];
    //[lblDiskonSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonSekaligus]]]]];
    
    [lblAsuransiDasarBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarBulanan]]]]];
    [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentBulanan]]]]];
    [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberBulanan]]]]];
    //[lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiBulanan]]]]];
    //[lblDiskonBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonBulanan]]]]];
    
    [lblAsuransiDasarTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarTahunan]]]]];
    [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentTahunan]]]]];
    [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberTahunan]]]]];
    //[lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiTahunan]]]]];
    //[lblDiskonTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonTahunan]]]]];
    
    if (IsInternalStaff==1){
        [lblDiskonSekaligus setText:[NSString stringWithFormat:@"(%@)",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonSekaligus]]]]];
        [lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonSekaligus] BasicPremi:[heritageCalculation getPremiDasarSekaligus]] ExtraPremi:[heritageCalculation extraPremiSekaligus]]]]]];
        
        [lblDiskonBulanan setText:[NSString stringWithFormat:@"(%@)",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonBulanan]]]]];
        [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonBulanan] BasicPremi:[heritageCalculation getPremiDasarBulanan]] ExtraPremi:[heritageCalculation extraPremiBulanan]]]]]];
        
        [lblDiskonTahunan setText:[NSString stringWithFormat:@"(%@)",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonTahunan]]]]];
        [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:[heritageCalculation getDiskonTahunan] BasicPremi:[heritageCalculation getPremiDasarTahunan]] ExtraPremi:[heritageCalculation extraPremiTahunan]]]]]];
        
        [viewDiskon setHidden:NO];
    }
    else{
        [lblDiskonSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]]]];
        [lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarSekaligus]] ExtraPremi:[heritageCalculation extraPremiSekaligus]]]]]];
        
        [lblDiskonBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]]]];
        [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarBulanan]] ExtraPremi:[heritageCalculation extraPremiBulanan]]]]]];
        
        [lblDiskonTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:0]]]];
        [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiAll:[heritageCalculation totalPremiDiscount:0 BasicPremi:[heritageCalculation getPremiDasarTahunan]] ExtraPremi:[heritageCalculation extraPremiTahunan]]]]]];
        
        [viewDiskon setHidden:YES];
    }
    
    if ([Highlight isEqualToString:@"Pembayaran Sekaligus"])
    {
        /*[lblAsuransiDasarSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarSekaligus]]]]];
        [lblExtraPremiPercentSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentSekaligus]]]]];
        [lblExtraPremiNumberSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberSekaligus]]]]];
        [lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiSekaligus]]]]];
        [lblDiskonSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonSekaligus]]]]];
        
        [lblAsuransiDasarBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarBulanan]]]]];
        [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentBulanan]]]]];
        [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberBulanan]]]]];
        [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiBulanan]]]]];
        [lblDiskonBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonBulanan]]]]];
        
        [lblAsuransiDasarTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarTahunan]]]]];
        [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentTahunan]]]]];
        [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberTahunan]]]]];
        [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiTahunan]]]]];
        [lblDiskonTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getDiskonTahunan]]]]];*/
        
        [lblAsuransiDasarSekaligus setTextColor:themeColour];
        [lblExtraPremiPercentSekaligus setTextColor:themeColour];
        [lblExtraPremiNumberSekaligus setTextColor:themeColour];
        [lblDiskonSekaligus setTextColor:themeColour];
        
        [lblAsuransiDasarBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        
        [lblAsuransiDasarTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        
    }
    else if ([Highlight isEqualToString:@"Bulanan"]){
        /*[lblAsuransiDasarSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarSekaligus]]]]];
        [lblExtraPremiPercentSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentSekaligus]]]]];
        [lblExtraPremiNumberSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberSekaligus]]]]];
        [lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiSekaligus]]]]];
        
        [lblAsuransiDasarBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarBulanan]]]]];
        [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentBulanan]]]]];
        [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberBulanan]]]]];
        [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiBulanan]]]]];
        
        [lblAsuransiDasarTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarTahunan]]]]];
        [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentTahunan]]]]];
        [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberTahunan]]]]];
        [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiTahunan]]]]];*/
        
        [lblAsuransiDasarSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        
        [lblAsuransiDasarBulanan setTextColor:themeColour];
        [lblExtraPremiPercentBulanan setTextColor:themeColour];
        [lblExtraPremiNumberBulanan setTextColor:themeColour];
        [lblDiskonBulanan setTextColor:themeColour];
        
        [lblAsuransiDasarTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonTahunan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    else{
        /*[lblAsuransiDasarSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarSekaligus]]]]];
        [lblExtraPremiPercentSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentSekaligus]]]]];
        [lblExtraPremiNumberSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberSekaligus]]]]];
        [lblTotalSekaligus setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiSekaligus]]]]];
        
        [lblAsuransiDasarBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarBulanan]]]]];
        [lblExtraPremiPercentBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentBulanan]]]]];
        [lblExtraPremiNumberBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberBulanan]]]]];
        [lblTotalBulanan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiBulanan]]]]];
        
        [lblAsuransiDasarTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation getPremiDasarTahunan]]]]];
        [lblExtraPremiPercentTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiPercentTahunan]]]]];
        [lblExtraPremiNumberTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation calculateExtraPremiNumberTahunan]]]]];
        [lblTotalTahunan setText:[NSString stringWithFormat:@"%@",[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:[heritageCalculation totalPremiTahunan]]]]];*/
        
        [lblAsuransiDasarSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonSekaligus setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        
        [lblAsuransiDasarBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiPercentBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblExtraPremiNumberBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        [lblDiskonBulanan setTextColor:[UIColor colorWithRed:128.0f/255.0f green:130.0f/255.0f blue:133.0f/255.0f alpha:1]];
        
        [lblAsuransiDasarTahunan setTextColor:themeColour];
        [lblExtraPremiPercentTahunan setTextColor:themeColour];
        [lblExtraPremiNumberTahunan setTextColor:themeColour];
        [lblDiskonTahunan setTextColor:themeColour];
    }
}

- (IBAction)simpanAct:(id)sender {
    NSLog(@"simpan has been pressed");
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Konfirmasi" message:@"Anda tidak dapat melakukan perubahan setelah simpan" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"ok");
            LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
            [loginDB updateSIMaster:[self.requestSINo description] EnableEditing:@"0"];
            [delegate heritageSimpan];
        }
            break;
        case 1:
        {
            // Do something for button #2
            NSLog(@"cancel");
        }
            break;
    }
}



@end
