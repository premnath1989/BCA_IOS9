//
//  PremiumKeluargakuViewController.m
//  BLESS
//
//  Created by Erwin Lim  on 3/23/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PremiumKeluargaku.h"
#import "LoginDBManagement.h"
#import "UIView+viewRecursion.h"

@implementation PremiumKeluargaku

@synthesize simpan, delegate;
@synthesize lblAsuransiDasarTahun, lblAsuransiDasarSemester, lblAsuransiDasarKuartal,
            lblAsuransiDasarBulan;
@synthesize lblOccpTahun, lblOccpSemester, lblOccpKuartal, lblOccpBulan;
@synthesize lblPremiPercentageTahun, lblPremiPercentageSemester, lblPremiPercentageKuartal,
            lblPremiPercentageBulan;
@synthesize lblPremiNumTahun, lblPremiNumSemester, lblPremiNumKuartal, lblPremiNumBulan;
@synthesize lblDiscountTahun, lblDiscountSemester, lblDiscountKuartal, lblDiscountBulan;
@synthesize lblSubTotalTahun, lblSubTotalSemester, lblSubTotalKuartal, lblSubTotalBulan;
@synthesize lblMDBKKTahun, lblMDBKKSemester, lblMDBKKKuartal, lblMDBKKBulan;
@synthesize lblMDKKTahun, lblMDKKSemester, lblMDKKKuartal, lblMDKKBulan;
@synthesize lblBPTahun, lblBPSemester, lblBPKuartal, lblBPBulan;
@synthesize lblTotalTahun, lblTotalSemester, lblTotalKuartal, lblTotalBulan;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self updatePremiLabel];
    
    classFormatter = [[Formatter alloc]init];
    riderCalculation = [[RiderCalculation alloc]init];
    
    UIButton* infoButton = [UIButton buttonWithType: UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(simpanAct:) forControlEvents:UIControlEventTouchDown];
    
    simpan =[[UIBarButtonItem alloc]initWithCustomView:infoButton];
    
    [self setPremiBulanan];
    [self setPremiTahunan];
    [self setPremiKuartalan];
    [self setPremiSemesteran];
    //test disable the fields
    [self checkEditingMode];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil SINO:(NSString *)SiNo{
    SINO = SiNo;
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void) updatePremiLabel{
    LoginDBManagement *DBclass = [[LoginDBManagement alloc]init];
    
    NSMutableDictionary *tempResult = [DBclass premiKeluargaku:SINO];
    NSLog(@"Premi Payment term : %@", [tempResult valueForKey:@"Payment_Frequency"]);
    NSString *PaymentFreq = [tempResult valueForKey:@"Payment_Frequency"];
    if([PaymentFreq caseInsensitiveCompare:@"Tahunan"] == NSOrderedSame){
        lblAsuransiDasarSemester.text = @""; lblAsuransiDasarKuartal.text = @"";
        lblAsuransiDasarBulan.text = @""; lblOccpSemester.text = @"";
        lblOccpKuartal.text = @""; lblOccpBulan.text = @"";
        lblPremiPercentageSemester.text = @""; lblPremiPercentageKuartal.text = @"";
        lblPremiPercentageBulan.text = @""; lblPremiNumSemester.text = @"";
        lblPremiNumKuartal.text = @""; lblPremiNumBulan.text = @"";
        lblDiscountSemester.text = @""; lblDiscountKuartal.text = @"";
        lblDiscountBulan.text = @""; lblSubTotalSemester.text = @"";
        lblSubTotalKuartal.text = @""; lblAsuransiDasarSemester.text = @"";
        lblAsuransiDasarSemester.text = @""; lblSubTotalBulan.text = @"";
        lblMDBKKSemester.text = @""; lblMDBKKKuartal.text = @"";
        lblMDBKKBulan.text = @""; lblMDKKSemester.text = @"";
        lblMDKKKuartal.text = @""; lblMDKKBulan.text = @"";
        lblTotalSemester.text = @""; lblTotalKuartal.text = @"";
        lblTotalBulan.text = @"";lblBPSemester.text = @"";
        lblBPKuartal.text = @""; lblBPBulan.text = @"";
        
        lblAsuransiDasarTahun.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpTahun.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageTahun.text = [tempResult valueForKey:@"ExtraPremiumPolicy"];
        lblPremiNumTahun.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountTahun.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalTahun.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblTotalTahun.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        
        lblMDBKKTahun.text = [DBclass RiderCode:SINO riderCode:@"MDBKK"];
        lblMDKKTahun.text = [DBclass RiderCode:SINO riderCode:@"MDKK"];
        lblBPTahun.text = [DBclass RiderCode:SINO riderCode:@"BP"];
        
    }else if([PaymentFreq caseInsensitiveCompare:@"Semester"] == NSOrderedSame){lblPremiPercentageTahun.text = @""; lblPremiPercentageKuartal.text = @"";
        lblPremiPercentageBulan.text = @""; lblPremiNumTahun.text = @"";
        lblPremiNumKuartal.text = @""; lblPremiNumBulan.text = @"";
        lblDiscountTahun.text = @""; lblDiscountKuartal.text = @"";
        lblDiscountBulan.text = @""; lblSubTotalTahun.text = @"";
        lblSubTotalKuartal.text = @""; lblAsuransiDasarTahun.text = @"";
        lblAsuransiDasarTahun.text = @""; lblSubTotalBulan.text = @"";
        lblMDBKKTahun.text = @""; lblMDBKKKuartal.text = @"";
        lblMDBKKBulan.text = @""; lblMDKKTahun.text = @"";
        lblMDKKKuartal.text = @""; lblMDKKBulan.text = @"";
        lblTotalTahun.text = @""; lblTotalKuartal.text = @"";
        lblTotalBulan.text = @""; lblBPTahun.text = @"";
        lblBPKuartal.text = @""; lblBPBulan.text = @"";
        lblAsuransiDasarKuartal.text = @""; lblAsuransiDasarBulan.text = @"";
        
        lblAsuransiDasarSemester.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpSemester.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageSemester.text = [tempResult valueForKey:@"ExtraPremiumPolicy"];
        lblPremiNumSemester.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountSemester.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalSemester.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblTotalSemester.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        
        lblMDBKKSemester.text = [DBclass RiderCode:SINO riderCode:@"MDBKK"];
        lblMDKKSemester.text = [DBclass RiderCode:SINO riderCode:@"MDKK"];
        lblBPSemester.text = [DBclass RiderCode:SINO riderCode:@"BP"];
    }else if([PaymentFreq caseInsensitiveCompare:@"Kuartal"] == NSOrderedSame){
        
        lblAsuransiDasarTahun.text = @""; lblAsuransiDasarSemester.text = @"";
        lblAsuransiDasarBulan.text = @""; lblOccpTahun.text = @"";
        lblOccpSemester.text = @""; lblOccpBulan.text = @"";
        lblPremiPercentageTahun.text = @""; lblPremiPercentageSemester.text = @"";
        lblPremiPercentageBulan.text = @""; lblPremiNumTahun.text = @"";
        lblPremiNumSemester.text = @""; lblPremiNumBulan.text = @"";
        lblDiscountTahun.text = @""; lblDiscountSemester.text = @"";
        lblDiscountBulan.text = @""; lblSubTotalTahun.text = @"";
        lblSubTotalSemester.text = @""; lblAsuransiDasarTahun.text = @"";
        lblAsuransiDasarTahun.text = @""; lblSubTotalBulan.text = @"";
        lblMDBKKTahun.text = @""; lblMDBKKSemester.text = @"";
        lblMDBKKBulan.text = @""; lblMDKKTahun.text = @"";
        lblMDKKSemester.text = @""; lblMDKKBulan.text = @"";
        lblTotalTahun.text = @""; lblTotalSemester.text = @"";
        lblTotalBulan.text = @""; lblBPTahun.text = @"";
        lblBPSemester.text = @""; lblBPBulan.text = @"";
        
        lblAsuransiDasarKuartal.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpKuartal.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageKuartal.text = [tempResult valueForKey:@"ExtraPremiumPolicy"];
        lblPremiNumKuartal.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountKuartal.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalKuartal.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblTotalKuartal.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        
        lblMDBKKKuartal.text = [DBclass RiderCode:SINO riderCode:@"MDBKK"];
        lblMDKKKuartal.text = [DBclass RiderCode:SINO riderCode:@"MDKK"];
        lblBPKuartal.text = [DBclass RiderCode:SINO riderCode:@"BP"];
        
    }else if([PaymentFreq caseInsensitiveCompare:@"Bulanan"] == NSOrderedSame){
        
        lblAsuransiDasarTahun.text = @""; lblAsuransiDasarSemester.text = @"";
        lblAsuransiDasarKuartal.text = @""; lblOccpTahun.text = @"";
        lblOccpSemester.text = @""; lblOccpKuartal.text = @"";
        lblPremiPercentageTahun.text = @""; lblPremiPercentageSemester.text = @"";
        lblPremiPercentageKuartal.text = @""; lblPremiNumTahun.text = @"";
        lblPremiNumSemester.text = @""; lblPremiNumKuartal.text = @"";
        lblDiscountTahun.text = @""; lblDiscountSemester.text = @"";
        lblDiscountKuartal.text = @""; lblSubTotalTahun.text = @"";
        lblSubTotalSemester.text = @""; lblAsuransiDasarTahun.text = @"";
        lblAsuransiDasarTahun.text = @""; lblSubTotalKuartal.text = @"";
        lblMDBKKTahun.text = @""; lblMDBKKSemester.text = @"";
        lblMDBKKKuartal.text = @""; lblMDKKTahun.text = @"";
        lblMDKKSemester.text = @""; lblMDKKKuartal.text = @"";
        lblTotalTahun.text = @""; lblTotalSemester.text = @"";
        lblTotalKuartal.text = @""; lblBPTahun.text = @"";
        lblBPSemester.text = @""; lblBPKuartal.text = @"";
        
        lblAsuransiDasarBulan.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpBulan.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageBulan.text = [tempResult valueForKey:@"ExtraPremiumPolicy"];
        lblPremiNumBulan.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountBulan.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalBulan.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblTotalBulan.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        
        lblMDBKKBulan.text = [DBclass RiderCode:SINO riderCode:@"MDBKK"];
        lblMDKKBulan.text = [DBclass RiderCode:SINO riderCode:@"MDKK"];
        lblBPBulan.text = [DBclass RiderCode:SINO riderCode:@"BP"];
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
            [loginDB updateSIMaster:SINO EnableEditing:@"0"];
            simpan.enabled = NO;
            [delegate savePremium];
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

#pragma mark created by faiz
-(int)getDiscount:(int)PurchaseNumber PaymentFrequesncy:(int)paymentFrequency{
    NSString* RelWithLA=[_dictionaryPOForInsert valueForKey:@"RelWithLA"];
    NSString* PayorSex = [_dictionaryPOForInsert valueForKey:@"PO_Gender"];
    int PayorAge = [[_dictionaryPOForInsert valueForKey:@"PO_Age"] intValue];

    NSString* LASex = [_dictionaryPOForInsert valueForKey:@"LA_Gender"];
    int LAAge = [[_dictionaryPOForInsert valueForKey:@"LA_Age"] intValue];

    if(([RelWithLA isEqualToString:@"DIRI SENDIRI"])||([RelWithLA isEqualToString:@"SELF"]))
    {
        PayorSex = LASex;
        PayorAge = LAAge;
    }
    
    NSString*WaiverRate;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    double PaymentMode;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    //    if([RelWithLA isEqualToString:@"DIRI SENDIRI"])
    //    {
    WaiverRate = [NSString stringWithFormat:@"SELECT %@ FROM Keluargaku_Rates_basicPrem Where BasicCode = '%@' AND EntryAge = %i",LASex,@"KLK",LAAge];
    results = [database executeQuery:WaiverRate];
    while([results next])
    {
        if ([PayorSex isEqualToString:@"Male"]||[PayorSex isEqualToString:@"MALE"]){
            RatesPremiumRate  = [results stringForColumn:@"Male"];
        }
        else{
            RatesPremiumRate  = [results stringForColumn:@"Female"];
        }
        
    }
    
    double RatesInt = [RatesPremiumRate doubleValue];
    
    NSString*PaymentFactoryQuery;
    [database open];
    FMResultSet *Results2;
    NSString * RatesMop = [NSString stringWithFormat:@"SELECT Payment_Fact FROM Keluargaku_Rates_MOP Where Payment_Code = %i",paymentFrequency];
    Results2 = [database executeQuery:RatesMop];
    
    
    while([Results2 next])
    {
        PaymentFactoryQuery = [Results2 stringForColumn:@"Payment_Fact"];
        
    }
    
    float percentPaymentMode = [PaymentFactoryQuery floatValue] / 100.0f;
    double discountPembelian;
    if (PurchaseNumber>=2){
        discountPembelian=0.05;
    }
    else{
        discountPembelian=0;
    }
    
    long long BasisSumAssured = [[_dictionaryForBasicPlan valueForKey:@"Number_Sum_Assured"] longLongValue];
    
    long long total =(BasisSumAssured/1000);
    
    DiscountCalculation = discountPembelian * RatesInt * total * percentPaymentMode;
    
    NSNumberFormatter *format21 = [[NSNumberFormatter alloc]init];
    [format21 setNumberStyle:NSNumberFormatterNoStyle];
    [format21 setGeneratesDecimalNumbers:TRUE];
    [format21 setMaximumFractionDigits:1];
    [format21 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    DiscountCalculation = [[format21 stringFromNumber:[NSNumber numberWithDouble:DiscountCalculation]] doubleValue];
    int roundedDiscount=round(DiscountCalculation);
    
    return roundedDiscount;
}

-(NSMutableDictionary *)getDictCalculatePPremi:(NSDictionary *)dictPO{
    NSMutableDictionary* dictForCalculateBPPremi;
    
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        dictForCalculateBPPremi=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumPercentage"],@"ExtraPremiPerCent",[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumSum"],@"ExtraPremiPerMil",[_dictionaryForBasicPlan valueForKey:@"ExtraPremiumTerm"],@"MasaExtraPremi", nil];
    }
    else{
        dictForCalculateBPPremi=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"0",@"ExtraPremiPerCent",@"0",@"ExtraPremiPerMil",@"0",@"MasaExtraPremi", nil];
    }
    
    return dictForCalculateBPPremi;
}

-(NSString *)getPersonType:(NSDictionary *)dictPO{
    NSString *personCharacterType;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        personCharacterType = @"T";
    }
    else{
        personCharacterType = @"P";
    }
    return personCharacterType;
}

-(void)setPremiBulanan{
    NSDictionary *dictPO = [[NSDictionary alloc]initWithDictionary:_dictionaryPOForInsert];
    NSMutableDictionary *dictBasicPlan = [[NSMutableDictionary alloc]initWithDictionary:_dictionaryForBasicPlan];
    
    [dictBasicPlan setObject:@"Bulanan" forKey:@"Payment_Frequency"];
    int diskon = [self getDiscount:[[dictBasicPlan valueForKey:@"PurchaseNumber"] intValue] PaymentFrequesncy:4];
    double MDBKKPremi = [riderCalculation calculateMDBKK:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];
    
    double premiDasar = MDBKKPremi + diskon;
    double MDBKKLoading = [riderCalculation calculateMDBKKLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];

    double MDBKKLoadingPercent = [riderCalculation calculateMDBKKLoadingPercent:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingNumber = [riderCalculation calculateMDBKKLoadingNumber:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];

    
    double MDBKK = MDBKKPremi+MDBKKLoading;

    double RiderPremium = [riderCalculation calculateBPPremi:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];
    double RiderLoading = [riderCalculation calculateBPPremiLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:4 PersonType:[self getPersonType:dictPO]];
    double BP = RiderPremium + RiderLoading;
    double allTotal = BP + MDBKK;
    [lblAsuransiDasarBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiDasar]]];
    //lblOccpBulan;
    [lblPremiPercentageBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingPercent]]];
    [lblPremiNumBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingNumber]]];
    [lblDiscountBulan setText:[classFormatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%i",diskon]]];
    [lblSubTotalBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    [lblMDBKKBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    //lblMDKKBulan;
    [lblBPBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:BP]]];;
    [lblTotalBulan setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:allTotal]]];
}

-(void)setPremiTahunan{
    NSDictionary *dictPO = [[NSDictionary alloc]initWithDictionary:_dictionaryPOForInsert];
    NSMutableDictionary *dictBasicPlan = [[NSMutableDictionary alloc]initWithDictionary:_dictionaryForBasicPlan];
    [dictBasicPlan setObject:@"Tahunan" forKey:@"Payment_Frequency"];
    
    int diskon = [self getDiscount:[[dictBasicPlan valueForKey:@"PurchaseNumber"] intValue] PaymentFrequesncy:1];
    double MDBKKPremi = [riderCalculation calculateMDBKK:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoading = [riderCalculation calculateMDBKKLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingPercent = [riderCalculation calculateMDBKKLoadingPercent:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingNumber = [riderCalculation calculateMDBKKLoadingNumber:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];

    double MDBKK = MDBKKPremi+MDBKKLoading;

    double RiderPremium = [riderCalculation calculateBPPremi:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];
    double RiderLoading = [riderCalculation calculateBPPremiLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:1 PersonType:[self getPersonType:dictPO]];
    
    double BP = RiderPremium + RiderLoading;
    
    double premiDasar = MDBKKPremi + diskon;
        double allTotal = BP + MDBKK;
    [lblAsuransiDasarTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiDasar]]];
    //lblOccpTahun;
    [lblPremiPercentageTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingPercent]]];
    [lblPremiNumTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingNumber]]];
    [lblDiscountTahun setText:[classFormatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%i",diskon]]];
    [lblSubTotalTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    [lblMDBKKTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    //lblMDKKTahun;
    [lblBPTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:BP]]];
    [lblTotalTahun setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:allTotal]]];
}

-(void)setPremiSemesteran{
    NSDictionary *dictPO = [[NSDictionary alloc]initWithDictionary:_dictionaryPOForInsert];
    NSMutableDictionary *dictBasicPlan = [[NSMutableDictionary alloc]initWithDictionary:_dictionaryForBasicPlan];
    [dictBasicPlan setObject:@"Semester" forKey:@"Payment_Frequency"];

    int diskon = [self getDiscount:[[dictBasicPlan valueForKey:@"PurchaseNumber"] intValue] PaymentFrequesncy:2];
    double MDBKKPremi = [riderCalculation calculateMDBKK:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];
    double premiDasar = MDBKKPremi + diskon;
    double MDBKKLoading = [riderCalculation calculateMDBKKLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingPercent = [riderCalculation calculateMDBKKLoadingPercent:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingNumber = [riderCalculation calculateMDBKKLoadingNumber:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];

    double MDBKK = MDBKKPremi+MDBKKLoading;

    double RiderPremium = [riderCalculation calculateBPPremi:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];
    double RiderLoading = [riderCalculation calculateBPPremiLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:2 PersonType:[self getPersonType:dictPO]];
    double BP = RiderPremium + RiderLoading;
        double allTotal = BP + MDBKK;
    [lblAsuransiDasarSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiDasar]]];
    //lblOccpSemester;
    [lblPremiPercentageSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingPercent]]];
    [lblPremiNumSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingNumber]]];
    [lblDiscountSemester setText:[classFormatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%i",diskon]]];
    [lblSubTotalSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    [lblMDBKKSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    //lblMDKKSemester;
    [lblBPSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:BP]]];
    [lblTotalSemester setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:allTotal]]];
}

-(void)setPremiKuartalan{
    NSDictionary *dictPO = [[NSDictionary alloc]initWithDictionary:_dictionaryPOForInsert];
    NSMutableDictionary *dictBasicPlan = [[NSMutableDictionary alloc]initWithDictionary:_dictionaryForBasicPlan];
    [dictBasicPlan setObject:@"Kuartal" forKey:@"Payment_Frequency"];

    int diskon = [self getDiscount:[[dictBasicPlan valueForKey:@"PurchaseNumber"] intValue] PaymentFrequesncy:3];
    double MDBKKPremi = [riderCalculation calculateMDBKK:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];
    double premiDasar = MDBKKPremi + diskon;

    double MDBKKLoading = [riderCalculation calculateMDBKKLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingPercent = [riderCalculation calculateMDBKKLoadingPercent:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];
    double MDBKKLoadingNumber = [riderCalculation calculateMDBKKLoadingNumber:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];

    double MDBKK = MDBKKPremi+MDBKKLoading;

    
    double RiderPremium = [riderCalculation calculateBPPremi:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];
    double RiderLoading = [riderCalculation calculateBPPremiLoading:[self getDictCalculatePPremi:dictPO] DictionaryBasicPlan:dictBasicPlan DictionaryPO:dictPO BasicCode:@"KLK" PaymentCode:3 PersonType:[self getPersonType:dictPO]];
    double BP = RiderPremium + RiderLoading;
    
    double allTotal = BP + MDBKK;
    [lblAsuransiDasarKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:premiDasar]]];
    //lblOccpKuartal;
    [lblPremiPercentageKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingPercent]]];
    [lblPremiNumKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKKLoadingNumber]]];
    [lblDiscountKuartal setText:[classFormatter stringToCurrencyDecimalFormatted:[NSString stringWithFormat:@"%i",diskon]]];
    [lblSubTotalKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    [lblMDBKKKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:MDBKK]]];
    //lblMDKKKuartal;
    [lblBPKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:BP]]];
    [lblTotalKuartal setText:[classFormatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:allTotal]]];
}

- (void) checkEditingMode {
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:SINO];
    NSLog(@" Edit Mode %@ : %@", EditMode, SINO);
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


@end