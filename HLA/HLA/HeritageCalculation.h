//
//  HeritageCalculation.h
//  BLESS
//
//  Created by Basvi on 5/4/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface HeritageCalculation : NSObject{
    double Pertanggungan_Dasar;
    double Pertanggungan_ExtrePremi;
    NSString *PayorSex;
    NSString *PremiType;
    int *PayorAge;
    int *LAAge;
    
    double AnssubtotalBulan;
    double AnssubtotalYear;
    double AnssubtotalSekaligus;
    
    double ExtraPercentsubtotalBulan;
    double ExtraPercentsubtotalYear;
    double ExtraPercentsubtotalSekaligus;
    double ExtraNumbsubtotalBulan;
    double ExtraNumbsubtotalYear;
    double ExtraNumbsubtotalSekaligus;
    
    double ExtraPremiNumbValue;
    NSString *Highlight,*ExtraPercentagePremi;
    
    
    NSMutableDictionary *dictionaryPremium;
}
@property (nonatomic, assign,readwrite) double Pertanggungan_Dasar;
@property (nonatomic, assign,readwrite) double Pertanggungan_ExtrePremi;
@property (nonatomic,strong) NSString *PayorSex,*PremiType,*RelWithLA,*LASex;
@property (nonatomic, assign,readwrite) int PayorAge;
@property (nonatomic, assign,readwrite) int LAAge;

@property (nonatomic, assign,readwrite) double AnssubtotalBulan;
@property (nonatomic, assign,readwrite) double AnssubtotalYear;
@property (nonatomic, assign,readwrite) double AnssubtotalSekaligus;

@property (nonatomic, assign,readwrite) double ExtraPercentsubtotalBulan;
@property (nonatomic, assign,readwrite) double ExtraPercentsubtotalYear;
@property (nonatomic, assign,readwrite) double ExtraPercentsubtotalSekaligus;
@property (nonatomic, assign,readwrite) double ExtraNumbsubtotalBulan;
@property (nonatomic, assign,readwrite) double ExtraNumbsubtotalYear;
@property (nonatomic, assign,readwrite) double ExtraNumbsubtotalSekaligus;
@property (nonatomic, assign,readwrite) double ExtraPremiNumbValue;

-(void)setPremiumDictionary:(NSMutableDictionary *)premiumDictionary;
-(NSString *)getRatesInt;
-(NSString *)getRatesIntPremiDasar:(NSString *)premType;

-(double)extraPremiBulanan;
-(double)extraPremiTahunan;
-(double)extraPremiSekaligus;
-(double)totalPremiDiscount:(double)discount BasicPremi:(double)basicPremi;
-(double)totalPremiAll:(double)basicPremi ExtraPremi:(double)extraPremi;
-(double)totalPremiBulanan;
-(double)totalPremiTahunan;
-(double)totalPremiSekaligus;
-(double)getPremiDasarBulanan;
-(double)getPremiDasarTahunan;
-(double)getPremiDasarSekaligus;
-(double)getDiskonTahunan;
-(double)getDiskonBulanan;
-(double)getDiskonSekaligus;
-(double)calculateExtraPremiPercentSekaligus;
-(double)calculateExtraPremiPercentTahunan;
-(double)calculateExtraPremiPercentBulanan;
-(double)calculateExtraPremiNumberSekaligus;
-(double)calculateExtraPremiNumberTahunan;
-(double)calculateExtraPremiNumberBulanan;
@end
