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

@implementation PremiumKeluargaku

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
    [self updatePremiLabel];
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


@end
