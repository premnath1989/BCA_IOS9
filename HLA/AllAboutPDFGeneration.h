//
//  AllAboutPDFGeneration.h
//  BLESS
//
//  Created by Basvi on 9/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PDFGenerationDelegate

- (void) voidPDFCreated;

@end

@interface AllAboutPDFGeneration : NSObject
-(void)joinSPAJPDF:(NSMutableArray *)arrayHTMLName DictTransaction:(NSDictionary *)dictTransaction;
-(void)splitPDF:(NSURL *)sourcePDFUrl withOutputName:(NSString *)outputBaseName intoDirectory:(NSString *)directory;
-(NSString *)getSPAJImageNameFromPath:(NSString *)stringImageName;
-(UIImage *)generateSignatureForImage:(UIImage *)mainImg signatureImage1:(UIImage *)signatureImage1 signaturePostion1:(CGRect)signaturePosition1 signatureImage2:(UIImage *)signatureImage2 signaturePostion2:(CGRect)signaturePosition2 signatureImage3:(UIImage *)signatureImage3 signaturePostion3:(CGRect)signaturePosition3 signatureImage4:(UIImage *)signatureImage4 signaturePostion4:(CGRect)signaturePosition4;
@property (nonatomic,strong) id <PDFGenerationDelegate> delegatePDFGeneration;
@end
