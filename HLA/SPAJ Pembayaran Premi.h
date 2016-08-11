//
//  SPAJ Pembayaran Premi.h
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"
#import "ModelSPAJTransaction.h"
#import "ModelSPAJHtml.h"
#import "ModelSPAJAnswers.h"

@protocol SPAJPembayaranPremiDelegate
    -(NSString *)voidGetEAPPNumber;
    -(void)voidSetPembayaranPremiBoolValidate:(BOOL)boolValidate;
@end

@interface SPAJ_Pembayaran_Premi : HtmlGenerator{
    NSString *filePath;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJHtml* modelSPAJHtml;
    ModelSPAJAnswers* modelSPAJAnswers;
}
@property (strong, nonatomic) NSString* htmlFileName;
@property (nonatomic,strong) id <SPAJPembayaranPremiDelegate> delegate;
-(void)voidDoneSPAJPembayaranPremi;
@end
