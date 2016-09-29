//
//  AllAboutPDFGeneration.h
//  BLESS
//
//  Created by Basvi on 9/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassImageProcessing.h"
#import "ModelSPAJSignature.h"
#import "ModelSPAJHtml.h"
#import "Formatter.h"
@protocol PDFGenerationDelegate

- (void) voidPDFCreated;
- (void) imgSigned;
- (void) allImgSigned;
@end

@interface AllAboutPDFGeneration : NSObject{
    ClassImageProcessing *classImageProcessing;
    ModelSPAJSignature *modelSPAJSignature;
    ModelSPAJHtml *modelSPAJHtml;
    Formatter* formatter;
}
-(void)joinSPAJPDF:(NSMutableArray *)arrayHTMLName DictTransaction:(NSDictionary *)dictTransaction;
-(void)splitPDF:(NSURL *)sourcePDFUrl withOutputName:(NSString *)outputBaseName intoDirectory:(NSString *)directory;
-(NSString *)getSPAJImageNameFromPath:(NSString *)stringImageName;
-(UIImage *)generateSignatureForImage:(UIImage *)mainImg signatureImage1:(UIImage *)signatureImage1 signaturePostion1:(CGRect)signaturePosition1 signatureImage2:(UIImage *)signatureImage2 signaturePostion2:(CGRect)signaturePosition2 signatureImage3:(UIImage *)signatureImage3 signaturePostion3:(CGRect)signaturePosition3 signatureImage4:(UIImage *)signatureImage4 signaturePostion4:(CGRect)signaturePosition4;
-(void)removeSPAJSigned:(NSDictionary *)dictTransaction;
-(void)removeUnNecesaryPDFFiles:(NSDictionary *)dictTransaction;
-(void)removeActivityAndHealthQuestionaireJPGFiles:(NSDictionary *)dictTransaction;

-(void)voidSaveSignatureForImages:(NSDictionary *)dictTransaction DictionaryPOData:(NSDictionary *)dictionaryPOData;
-(void)saveSignatureForImage:(UIImage *)imageSigned1 ImageSigned2:(UIImage *)imageSigned2 ImageSigned3:(UIImage *)imageSigned3 ImageSigned4:(UIImage *)imageSigned4 FileName:(NSString *)stringFileName DictTransaction:(NSDictionary *)dictTransaction;

-(BOOL)doesString:(NSString *)string containCharacter:(NSString *)character;

-(NSString *)getWordFromString:(NSString *)stringImageName IndexWord:(int)index;


@property (nonatomic,strong) id <PDFGenerationDelegate> delegatePDFGeneration;
@end
