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
@synthesize lblMDKCTahun, lblMDKCSemester, lblMDKCKuartal, lblMDKCBulan;
@synthesize lblBPMDTahun, lblBPMDSemester, lblBPMDKuartal, lblBPMSDBulan;
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
        lblMDKCSemester.text = @""; lblMDKCKuartal.text = @"";
        lblMDKCBulan.text = @""; lblBPMDSemester.text = @"";
        lblBPMDKuartal.text = @""; lblBPMSDBulan.text = @"";
        lblTotalSemester.text = @""; lblTotalKuartal.text = @"";
        lblTotalBulan.text = @"";
        
        lblAsuransiDasarTahun.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpTahun.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageTahun.text = [tempResult valueForKey:@"ExtraPremiumPercentage"];
        lblPremiNumTahun.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountTahun.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalTahun.text = [tempResult valueForKey:@"SubTotalPremium"];
        
    }else if([PaymentFreq caseInsensitiveCompare:@"Semesteran"] == NSOrderedSame){lblPremiPercentageTahun.text = @""; lblPremiPercentageKuartal.text = @"";
        lblPremiPercentageBulan.text = @""; lblPremiNumTahun.text = @"";
        lblPremiNumKuartal.text = @""; lblPremiNumBulan.text = @"";
        lblDiscountTahun.text = @""; lblDiscountKuartal.text = @"";
        lblDiscountBulan.text = @""; lblSubTotalTahun.text = @"";
        lblSubTotalKuartal.text = @""; lblAsuransiDasarTahun.text = @"";
        lblAsuransiDasarTahun.text = @""; lblSubTotalBulan.text = @"";
        lblMDKCTahun.text = @""; lblMDKCKuartal.text = @"";
        lblMDKCBulan.text = @""; lblBPMDTahun.text = @"";
        lblBPMDKuartal.text = @""; lblBPMSDBulan.text = @"";
        lblTotalTahun.text = @""; lblTotalKuartal.text = @"";
        lblTotalBulan.text = @"";
        
        lblAsuransiDasarSemester.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpSemester.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageSemester.text = [tempResult valueForKey:@"ExtraPremiumPercentage"];
        lblPremiNumSemester.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountSemester.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalSemester.text = [tempResult valueForKey:@"SubTotalPremium"];
        
    }else if([PaymentFreq caseInsensitiveCompare:@"Kuartalan"] == NSOrderedSame){
        
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
        lblMDKCTahun.text = @""; lblMDKCSemester.text = @"";
        lblMDKCBulan.text = @""; lblBPMDTahun.text = @"";
        lblBPMDSemester.text = @""; lblBPMSDBulan.text = @"";
        lblTotalTahun.text = @""; lblTotalSemester.text = @"";
        lblTotalBulan.text = @"";
        
        lblAsuransiDasarKuartal.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpKuartal.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageKuartal.text = [tempResult valueForKey:@"ExtraPremiumPercentage"];
        lblPremiNumKuartal.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountKuartal.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalKuartal.text = [tempResult valueForKey:@"SubTotalPremium"];
        
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
        lblMDKCTahun.text = @""; lblMDKCSemester.text = @"";
        lblMDKCKuartal.text = @""; lblBPMDTahun.text = @"";
        lblBPMDSemester.text = @""; lblBPMDKuartal.text = @"";
        lblTotalTahun.text = @""; lblTotalSemester.text = @"";
        lblTotalKuartal.text = @"";
        
        lblAsuransiDasarBulan.text = [tempResult valueForKey:@"PremiumPolicyA"];
        lblOccpBulan.text = [tempResult valueForKey:@"TotalPremiumLoading"];
        lblPremiPercentageBulan.text = [tempResult valueForKey:@"ExtraPremiumPercentage"];
        lblPremiNumBulan.text = [tempResult valueForKey:@"ExtraPremiumSum"];
        lblDiscountBulan.text = [tempResult valueForKey:@"Discount"];
        lblSubTotalBulan.text = [tempResult valueForKey:@"SubTotalPremium"];
    }
}


@end
