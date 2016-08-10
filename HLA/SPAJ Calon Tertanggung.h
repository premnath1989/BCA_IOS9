//
//  SPAJ Calon Tertanggung.h
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
#import "ModelProspectProfile.h"
#import "ModelSIPOData.h"

@protocol SPAJCalonTertanggungDelegate
    -(NSString *)voidGetEAPPNumber;
    -(void)voidSetCalonTertnggungBoolValidate:(BOOL)boolValidate;
@end

@interface SPAJ_Calon_Tertanggung : HtmlGenerator{
    NSString *filePath;
    ModelProspectProfile *modelProspectProfile;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJHtml* modelSPAJHtml;
    ModelSPAJAnswers* modelSPAJAnswers;
    ModelSIPOData* modelSIPData;
}
@property (strong, nonatomic) NSString* htmlFileName;
@property (nonatomic,strong) id <SPAJCalonTertanggungDelegate> delegate;
-(void)voidDoneSPAJCalonTertanggung;
@end
