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
#import "ModelIdentificationType.h"
#import "Formatter.h"
#import "ModelOccupation.h"
#import "Model_SI_Premium.h"
#import "AllAboutPDFGeneration.h"
#import "SPAJThirdParty.h"

@protocol SPAJCalonPemegangPolisDelegate
    -(NSString *)voidGetEAPPNumber;
-(void)voidSetCalonPemegangPolisBoolValidate:(BOOL)boolValidate StringSection:(NSString *)stringSection;
-(void)setRightButtonEnable:(BOOL)boolEnabled;
@end


@interface SPAJ_Calon_Pemegang_Polis : HtmlGenerator{
    NSString *filePath;
    Formatter* formatter;
    ModelOccupation *modelOccupation;
    ModelProspectProfile *modelProspectProfile;
    ModelSPAJTransaction *modelSPAJTransaction;
    ModelSPAJHtml* modelSPAJHtml;
    ModelSPAJAnswers* modelSPAJAnswers;
    ModelSIPOData* modelSIPData;
    ModelIdentificationType* modelIdentificationType;
    Model_SI_Premium *modelSIPremium;
    AllAboutPDFGeneration *allAboutPDFGeneration;
    SPAJThirdParty *spajThirdPartyViewController;
    
    IBOutlet UIView *viewActivityIndicator;
}
@property (strong, nonatomic) NSDictionary* dictTransaction;
@property (strong, nonatomic) NSString* htmlFileName;
-(void)loadFirstHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadSecondHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadThirdHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadFourthHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadFivethHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadSixthHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
-(void)loadSeventhHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection;
@property (nonatomic,strong) id <SPAJCalonPemegangPolisDelegate> delegate;
-(void)voidDoneSPAJCalonPemegangPolis;
@end
