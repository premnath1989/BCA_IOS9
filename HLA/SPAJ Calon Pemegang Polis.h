//
//  SPAJ Calon Pemegang Polis.h
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

@protocol SPAJCalonPemegangPolisDelegate
    -(NSString *)voidGetEAPPNumber;
@end


@interface SPAJ_Calon_Pemegang_Polis : HtmlGenerator{
    NSString *filePath;
    ModelProspectProfile *modelProspectProfile;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJHtml* modelSPAJHtml;
    ModelSPAJAnswers* modelSPAJAnswers;
    ModelSIPOData* modelSIPData;
}
@property (strong, nonatomic) NSString* htmlFileName;
@property (nonatomic,strong) id <SPAJCalonPemegangPolisDelegate> delegate;
-(void)voidDoneSPAJCalonPemegangPolis;
@end
