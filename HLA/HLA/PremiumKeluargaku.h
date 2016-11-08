//
//  PremiumKeluargakuViewController.h
//  BLESS
//
//  Created by Erwin Lim  on 3/23/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "Formatter.h"
#import "RiderCalculation.h"
#import "ModelSIRider.h"

@class PremiumKeluargaku;
@protocol PremiumKeluargaKuProtocol
-(void)savePremium;
@end


@interface PremiumKeluargaku : UIViewController{
    ModelSIRider *_modelSIRider;
    NSString *SINO;
    double DiscountCalculation;
    Formatter* classFormatter;
    RiderCalculation* riderCalculation;
    UIColor *themeColour;
    UIColor *unHighlightColor;
}

@property (retain, nonatomic) NSMutableDictionary* dictionaryPOForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForBasicPlan;

@property (nonatomic,strong) id <PremiumKeluargaKuProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *simpan;
- (IBAction)simpanAct:(id)sender;

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

@property (weak, nonatomic) IBOutlet UILabel *lblMDBKKTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblMDBKKSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblMDBKKKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblMDBKKBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblMDKKTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKKSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKKKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblMDKKBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblBPTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblBPSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblBPKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblBPBulan;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalTahun;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalKuartal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBulan;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil SINO:(NSString *)SiNo;

@end