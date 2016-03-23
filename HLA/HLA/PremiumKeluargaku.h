//
//  PremiumKeluargakuViewController.h
//  BLESS
//
//  Created by Erwin Lim  on 3/23/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PremiumKeluargaku : UIViewController{
    NSString *SINO;
}

@property (weak, nonatomic) IBOutlet UILabel *lblAsuransiDasarTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblAsuransiDasarSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblAsuransiDasarKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblAsuransiDasarBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblOccpTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblOccpSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblOccpKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblOccpBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblPremiPercentageTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiPercentageSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiPercentageKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiPercentageBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblPremiNumTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiNumSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiNumKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblPremiNumBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscountTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTotalTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotalSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotalKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTotalBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblMDKCTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKCSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKCKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKCBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblBPMDTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblBPMDSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblBPMDKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblBPMSDBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBulan;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil SINO:(NSString *)SiNo;

@end