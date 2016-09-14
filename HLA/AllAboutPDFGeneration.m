//
//  AllAboutPDFGeneration.m
//  BLESS
//
//  Created by Basvi on 9/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AllAboutPDFGeneration.h"

@implementation AllAboutPDFGeneration
@synthesize delegatePDFGeneration;
-(void)joinSPAJPDF:(NSMutableArray *)arrayHTMLName DictTransaction:(NSDictionary *)dictTransaction{
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    
    NSMutableArray *arrayPDFPath = [[NSMutableArray alloc]init];
    NSMutableArray *arrayPDFURLRef = [[NSMutableArray alloc]init];
    NSMutableArray *arrayPDFDocumentRef = [[NSMutableArray alloc]init];
    NSMutableArray *arrayNumberOfPageFile = [[NSMutableArray alloc]init];
    
    for (int i=0;i<[arrayHTMLName count];i++){
        NSString* filePDFPath =[NSString stringWithFormat:@"%@/SPAJ/%@/%@_%i.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"],i];
        [arrayPDFPath addObject:filePDFPath];
    }
    
    for (int i=0;i<[arrayPDFPath count];i++){
        CFURLRef pdfURLFilePath = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:(NSString *)[arrayPDFPath objectAtIndex:i]];
        [arrayPDFURLRef addObject:(__bridge id _Nonnull)(pdfURLFilePath)];
    }
    
    for (int i=0;i<[arrayPDFURLRef count];i++){
        CGPDFDocumentRef pdfRefFilePath = CGPDFDocumentCreateWithURL((CFURLRef)[arrayPDFURLRef objectAtIndex:i]);
        [arrayPDFDocumentRef addObject:(__bridge id _Nonnull)(pdfRefFilePath)];
    }
    
    for (int i=0;i<[arrayPDFDocumentRef count];i++){
        NSInteger numberOfPagesFilePath = CGPDFDocumentGetNumberOfPages((__bridge CGPDFDocumentRef)([arrayPDFDocumentRef objectAtIndex:i]));
        [arrayNumberOfPageFile addObject:[NSNumber numberWithInteger:numberOfPagesFilePath]];
    }
    
    NSString* filePathSPAJ = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_SPAJ.pdf",documentsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathOutput = filePathSPAJ;
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:(NSString *)pdfPathOutput];//(CFURLRef)
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    for (int i=0;i<[arrayHTMLName count];i++){
        for (int j=1; j<=[(NSNumber *)[arrayNumberOfPageFile objectAtIndex:i] integerValue]; j++) {
            page = CGPDFDocumentGetPage((__bridge CGPDFDocumentRef)([arrayPDFDocumentRef objectAtIndex:i]), j);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
    }
    CGPDFContextClose(writeContext);
    CFRelease(pdfURLOutput);
    CGContextRelease(writeContext);
    [delegatePDFGeneration voidPDFCreated];
}

#pragma mark image from pdf
-(void)splitPDF:(NSURL *)sourcePDFUrl withOutputName:(NSString *)outputBaseName intoDirectory:(NSString *)directory
{
    CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)sourcePDFUrl);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:directory];
    NSError *error;
    /*if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
     withIntermediateDirectories:NO
     attributes:nil
     error:&error])
     {
     NSLog(@"Create directory error: %@", error);
     return;
     }*/
    for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
    {
        CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
        // CoreGraphics: MUST retain the Page-Refernce manually
        CGPDFPageRetain(SourcePDFPage);
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"SPAJ/%@/%@%d.jpg", directory, outputBaseName, currentPage];
        NSString *ImageFileName = [documentsDirectory stringByAppendingPathComponent:relativeOutputFilePath];
        CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage, kCGPDFMediaBox);
        UIGraphicsBeginPDFContextToFile(ImageFileName, sourceRect, nil);
        UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width,sourceRect.size.height));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height); //596,842 //640×960,
        CGContextScaleCTM(currentContext, 1.0, -1.0);
        CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent: relativeOutputFilePath];
        [UIImageJPEGRepresentation(image, 1) writeToFile: imagePath atomically:YES];
    }
}

-(NSString *)getSPAJImageNameFromPath:(NSString *)stringImageName{
    NSString *stringName;
    NSArray *chunks = [stringImageName componentsSeparatedByString: @"/"];
    
    NSString* realString;
    if ([chunks count]>0){
         realString = [chunks lastObject];
         NSArray *chunks1 = [realString componentsSeparatedByString: @"."];
         stringName = [chunks1 objectAtIndex:0];
    }
    
    
    return stringName;
}

-(UIImage *)generateSignatureForImage:(UIImage *)mainImg signatureImage1:(UIImage *)signatureImage1 signaturePostion1:(CGRect)signaturePosition1 signatureImage2:(UIImage *)signatureImage2 signaturePostion2:(CGRect)signaturePosition2 signatureImage3:(UIImage *)signatureImage3 signaturePostion3:(CGRect)signaturePosition3 signatureImage4:(UIImage *)signatureImage4 signaturePostion4:(CGRect)signaturePosition4{
    UIImage *backgroundImage = mainImg;
    UIImage *signImage1 = signatureImage1;
    UIImage *signImage2 = signatureImage2;
    UIImage *signImage3 = signatureImage3;
    UIImage *signImage4 = signatureImage4;
    
    //Now re-drawing your  Image using drawInRect method
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    [signImage1 drawInRect:signaturePosition1];
    [signImage2 drawInRect:signaturePosition2];
    [signImage3 drawInRect:signaturePosition3];
    [signImage4 drawInRect:signaturePosition4];
    
    // now merging two images into one
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

-(void)removeSPAJSigned:(NSDictionary *)dictTransaction{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSMutableArray* fileNameForDelete = [[NSMutableArray alloc]init];
    
    [fileNameForDelete addObject:@"SPAJSigned.pdf"];
    [fileNameForDelete addObject:@"SPAJSignedPage1.pdf"];
    [fileNameForDelete addObject:@"SPAJSigned9.pdf"];
    [fileNameForDelete addObject:@"SPAJSignedPage9.pdf"];
    [fileNameForDelete addObject:@"SPAJSigned.pdf"];
    [fileNameForDelete addObject:[NSString stringWithFormat:@"%@_0.pdf",[dictTransaction valueForKey:@"SPAJEappNumber"]]];
    [fileNameForDelete addObject:[NSString stringWithFormat:@"%@_1.pdf",[dictTransaction valueForKey:@"SPAJEappNumber"]]];
    [fileNameForDelete addObject:[NSString stringWithFormat:@"%@_2.pdf",[dictTransaction valueForKey:@"SPAJEappNumber"]]];
    
    for (int i=0;i<[fileNameForDelete count];i++){
        NSError *error;
        NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/%@",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"],[fileNameForDelete objectAtIndex:i]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success =[fileManager removeItemAtPath:pdfPath1 error:&error];
        
        if (success) {
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    // File paths
    /*NSString *pdfPath1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage1.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage9 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSigned9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    NSString *pdfPathPage9_1 = [NSString stringWithFormat:@"%@/SPAJ/%@/SPAJSignedPage9.pdf",docsDirectory,[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:pdfPath1 error:&error];
    BOOL successPage1 = [fileManager removeItemAtPath:pdfPathPage1 error:&error];
    BOOL successPage9 = [fileManager removeItemAtPath:pdfPathPage9 error:&error];
    BOOL successPage9_1 = [fileManager removeItemAtPath:pdfPathPage9_1 error:&error];
    if (success) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    if (successPage1) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    if (successPage9) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    if (successPage9_1) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }*/
}

#pragma mark image signature
-(void)voidSaveSignatureForImages:(NSDictionary *)dictTransaction DictionaryPOData:(NSDictionary *)dictionaryPOData {
    classImageProcessing = [[ClassImageProcessing alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    
    NSData* imageParty1=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty1 options:0];;
    NSData* imageParty2=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty2 options:0];;
    NSData* imageParty3=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty3 options:0];;
    NSData* imageParty4=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty4 options:0];;
    
    UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
    UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
    UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
    UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
    
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
    
    NSMutableArray *arrayIMGName;
    NSMutableArray *arrayPureIMGName = [[NSMutableArray alloc]init];
    if ([[dictionaryPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH"]];
    }
    else{
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_IN"]];
    }
    
    for (int i=0;i<[arrayIMGName count];i++){
        NSString *pureName = [self getSPAJImageNameFromPath:[arrayIMGName objectAtIndex:i]];
        [arrayPureIMGName addObject:pureName];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int x=0;x<[arrayPureIMGName count];x++){
            [self saveSignatureForImage:imageConverted1 ImageSigned2:imageConverted2 ImageSigned3:imageConverted3 ImageSigned4:imageConverted4 FileName:[arrayPureIMGName objectAtIndex:x] DictTransaction:dictTransaction];
        }
    });
}


-(void)saveSignatureForImage:(UIImage *)imageSigned1 ImageSigned2:(UIImage *)imageSigned2 ImageSigned3:(UIImage *)imageSigned3 ImageSigned4:(UIImage *)imageSigned4 FileName:(NSString *)stringFileName DictTransaction:(NSDictionary *)dictTransaction{
    
    formatter = [[Formatter alloc]init];
    NSString *mainFileName = [NSString stringWithFormat:@"%@_%@.jpg",[dictTransaction valueForKey:@"SPAJEappNumber"],stringFileName];
    NSString *fullpath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    fullpath = [NSString stringWithFormat:@"%@/%@",fullpath,mainFileName];
    
    UIImage *baseImage = [UIImage imageWithContentsOfFile:fullpath];
    if ([stringFileName rangeOfString:@"amandement"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
        
    }
    else if ([stringFileName rangeOfString:@"chestpain"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"diabetes"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"digestion"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"epilepsy"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"hypertension"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"respiratory"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if ([stringFileName rangeOfString:@"tumor"].location != NSNotFound) {
        CGRect rectSign1 = CGRectMake(0, 0, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(100, 0, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 0, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(300, 0, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else {
        NSLog(@"string contains bla!");
    }
    [delegatePDFGeneration imgSigned];
};

@end
