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

-(NSString *)getWordFromString:(NSString *)stringImageName IndexWord:(int)index{
    NSString *stringName;
    NSArray *chunks = [stringImageName componentsSeparatedByString: @"_"];
    stringName = [chunks objectAtIndex:index];
    
    /*NSString* realString;
    if ([chunks count]>0){
        realString = [chunks lastObject];
        NSArray *chunks1 = [realString componentsSeparatedByString: @"."];
        stringName = [chunks1 objectAtIndex:0];
    }*/
    
    
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

-(UIImage *)generateSignatureForThirdPartyImage:(UIImage *)mainImg signatureImage1:(UIImage *)signatureImage1 signaturePostion1:(CGRect)signaturePosition1 signatureImage2:(UIImage *)signatureImage2 signaturePostion2:(CGRect)signaturePosition2 signatureImage3:(UIImage *)signatureImage3 signaturePostion3:(CGRect)signaturePosition3 signatureImage4:(UIImage *)signatureImage4  signaturePostion4:(CGRect)signaturePosition4 signatureImage5:(UIImage *)signatureImage5
    signaturePostion5:(CGRect)signaturePosition5{
    UIImage *backgroundImage = mainImg;
    UIImage *signImage1 = signatureImage1;
    UIImage *signImage2 = signatureImage2;
    UIImage *signImage3 = signatureImage3;
    UIImage *signImage4 = signatureImage4;
    UIImage *signImage5 = signatureImage5;
    
    //Now re-drawing your  Image using drawInRect method
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    [signImage1 drawInRect:signaturePosition1];
    [signImage2 drawInRect:signaturePosition2];
    [signImage3 drawInRect:signaturePosition3];
    [signImage4 drawInRect:signaturePosition4];
    [signImage5 drawInRect:signaturePosition5];
    
    
    // now merging two images into one
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

-(void)removeSPAJFolder:(NSDictionary *)dictTransaction{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSMutableArray* fileNameForDelete = [[NSMutableArray alloc]init];
    [fileNameForDelete addObject:@"ImageSignature"];
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
}

-(void)removeSPAJSigned:(NSDictionary *)dictTransaction{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSMutableArray* fileNameForDelete = [[NSMutableArray alloc]init];
    
    //[fileNameForDelete addObject:@"ImageSignature"];
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
}



-(void)removeUnNecesaryPDFFiles:(NSDictionary *)dictTransaction{
    formatter = [[Formatter alloc]init];
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];

    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *fileNameForDelete = [directoryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @"pdf"]];
    
    for (int i=0;i<[fileNameForDelete count];i++){
        NSString *fileName = [fileNameForDelete objectAtIndex:i];
        
        NSString *filter1 = @"SPAJ.pdf";
        NSString *filter2 = [NSString stringWithFormat:@"%@.pdf",[dictTransaction valueForKey:@"SPAJSINO"]];
        
        if (([self doesString:fileName containCharacter:filter1])||([self doesString:fileName containCharacter:filter2])){
            NSLog(@"'a' found");
        }
        else{
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
    }
}

-(void)removeActivityAndHealthQuestionaireJPGFiles:(NSDictionary *)dictTransaction{
    formatter = [[Formatter alloc]init];
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *fileNameForDelete = [directoryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @"jpg"]];
    
    for (int i=0;i<[fileNameForDelete count];i++){
        NSString *fileName = [fileNameForDelete objectAtIndex:i];
        
        NSString *filter1 = @"healthquestionnairepdf";
        NSString *filter2 = @"activityquestionnairepdf";
        NSString *filter3 = @"kuesionerkesehatan";
        NSString *filter4 = @"kuesioneraktivitas";
        NSString *filter5 = @"wna";
        
        if (([self doesString:fileName containCharacter:filter1])||([self doesString:fileName containCharacter:filter2])||([self doesString:fileName containCharacter:filter3])||([self doesString:fileName containCharacter:filter4])||([self doesString:fileName containCharacter:filter5])){
            //NSLog(@"'a' found");
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
        else{
        }
    }
}

-(void)removeThirdPartyJPGFiles:(NSDictionary *)dictTransaction{
    formatter = [[Formatter alloc]init];
    NSString* stringFilePath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stringFilePath error:NULL];
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *fileNameForDelete = [directoryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @"jpg"]];
    
    for (int i=0;i<[fileNameForDelete count];i++){
        NSString *fileName = [fileNameForDelete objectAtIndex:i];
        
        NSString *filter1 = @"pihakketiga";
        
        if ([self doesString:fileName containCharacter:filter1]){
            //NSLog(@"'a' found");
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
        else{
        }
    }
}



-(BOOL)doesString:(NSString *)string containCharacter:(NSString *)character
{
    if ([string rangeOfString:[NSString stringWithFormat:@"%@",character]].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

#pragma mark image signature
-(void)voidSaveSignatureForSingleImage:(NSDictionary *)dictTransaction StringFileName:(NSString *)stringFileName{
    classImageProcessing = [[ClassImageProcessing alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty5=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty5" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    
    NSData* imageParty1=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty1 options:0];;
    NSData* imageParty2=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty2 options:0];;
    NSData* imageParty3=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty3 options:0];;
    NSData* imageParty4=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty4 options:0];;
    NSData* imageParty5=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty5 options:0];;
    
    UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
    UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
    UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
    UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
    UIImage *imageSignatureParty5 = [UIImage imageWithData:imageParty5];
    
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted5 = [classImageProcessing changeColor:imageSignatureParty5 fromColor:fromColor toColor:toColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool {
                [self saveSignatureForImage:imageConverted1 ImageSigned2:imageConverted2 ImageSigned3:imageConverted3 ImageSigned4:imageConverted4 ImageSigned5:imageConverted5 FileName:stringFileName DictTransaction:dictTransaction];
            }
    });
}

-(void)voidSaveSignatureForImages:(NSDictionary *)dictTransaction DictionaryPOData:(NSDictionary *)dictionaryPOData {
    classImageProcessing = [[ClassImageProcessing alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    NSString* base64StringImageParty5=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty5" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:@"";
    
    NSData* imageParty1=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty1 options:0];;
    NSData* imageParty2=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty2 options:0];;
    NSData* imageParty3=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty3 options:0];;
    NSData* imageParty4=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty4 options:0];;
    NSData* imageParty5=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty5 options:0];;
    
    UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
    UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
    UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
    UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
    UIImage *imageSignatureParty5 = [UIImage imageWithData:imageParty5];
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted5 = [classImageProcessing changeColor:imageSignatureParty5 fromColor:fromColor toColor:toColor];
    
    NSMutableArray *arrayIMGName;
    NSMutableArray *arrayIMGNameTranslate;
    NSMutableArray *arrayPureIMGName = [[NSMutableArray alloc]init];
    if ([[dictionaryPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
        //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH"]];
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"TP\",\"AF"]];
        arrayIMGNameTranslate = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlTranslateName" SPAJSection:@"IMG_PH\",\"TP\",\"AF"]];
    }
    else{
        //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_IN"]];
        //arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"IMG_IN"]];
        arrayIMGName = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlName" SPAJSection:@"IMG_PH\",\"IMG_IN\",\"TP\",\"AF"]];
        arrayIMGNameTranslate = [[NSMutableArray alloc]initWithArray:[modelSPAJHtml selectArrayHtmlFileName:@"SPAJHtmlTranslateName" SPAJSection:@"IMG_PH\",\"IMG_IN\",\"TP\",\"AF"]];
    }
    
    for (int i=0;i<[arrayIMGNameTranslate count];i++){
        NSString *pureName = [self getSPAJImageNameFromPath:[arrayIMGNameTranslate objectAtIndex:i]];
        [arrayPureIMGName addObject:pureName];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int x=0;x<[arrayPureIMGName count];x++){
            @autoreleasepool {
                [self saveSignatureForImage:imageConverted1 ImageSigned2:imageConverted2 ImageSigned3:imageConverted3 ImageSigned4:imageConverted4 ImageSigned5:imageConverted5 FileName:[arrayPureIMGName objectAtIndex:x] DictTransaction:dictTransaction];
            }
        }
    });
    
    [delegatePDFGeneration allImgSigned];
}


-(void)saveSignatureForImage:(UIImage *)imageSigned1 ImageSigned2:(UIImage *)imageSigned2 ImageSigned3:(UIImage *)imageSigned3 ImageSigned4:(UIImage *)imageSigned4 ImageSigned5:(UIImage *)imageSigned5 FileName:(NSString *)stringFileName DictTransaction:(NSDictionary *)dictTransaction{
    
    formatter = [[Formatter alloc]init];
    NSString *mainFileName = [NSString stringWithFormat:@"%@_%@.jpg",[dictTransaction valueForKey:@"SPAJEappNumber"],stringFileName];
    NSString *fullpath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
    fullpath = [NSString stringWithFormat:@"%@/%@",fullpath,mainFileName];
    
    UIImage *baseImage = [UIImage imageWithContentsOfFile:fullpath];
    if (([stringFileName rangeOfString:@"amandment"].location != NSNotFound)||([stringFileName rangeOfString:@"amandemen"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  2600, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 2600, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 2600, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 2600, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4] ;
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
        
    } else if (([stringFileName rangeOfString:@"chestpain"].location != NSNotFound)||([stringFileName rangeOfString:@"nyeridada"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7842, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7842, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7842, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7842, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"diabetes"].location != NSNotFound)||([stringFileName rangeOfString:@"diabetes"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7470, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7470, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7470, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7470, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"digestion"].location != NSNotFound)||([stringFileName rangeOfString:@"pencernaan"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  9148, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 9148, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 9148, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 9148, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"epilepsy"].location != NSNotFound)||([stringFileName rangeOfString:@"epilepsi"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7224, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7224, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7224, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7224, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"hypertension"].location != NSNotFound)||([stringFileName rangeOfString:@"darahtinggi"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8320, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8320, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8320, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8320, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"respiratory"].location != NSNotFound)||([stringFileName rangeOfString:@"pernapasan"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8683, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8683, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8683, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8683, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"tumor"].location != NSNotFound)||([stringFileName rangeOfString:@"tumor"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8180, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8180, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8180, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8180, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"diving"].location != NSNotFound)||([stringFileName rangeOfString:@"menyelam"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7500, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7500, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7500, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7500, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"oilgas"].location != NSNotFound)||([stringFileName rangeOfString:@"pertambangan"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7403, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7403, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7403, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7403, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"military"].location != NSNotFound)||([stringFileName rangeOfString:@"angkatanbersenjata"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  4900, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 4900, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 4900, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 4900, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"flight"].location != NSNotFound)||([stringFileName rangeOfString:@"penerbangan"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7712, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7712, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7712, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7712, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"alcohol"].location != NSNotFound)||([stringFileName rangeOfString:@"alkohol"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7808, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7808, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7808, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7808, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"gland"].location != NSNotFound)||([stringFileName rangeOfString:@"kelenjargondok"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  10252, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 10252, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 10252, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 10252, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"hiking"].location != NSNotFound)||([stringFileName rangeOfString:@"mendaki"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  10348, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 10348, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 10348, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 10348, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"joint"].location != NSNotFound)||([stringFileName rangeOfString:@"sendi"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8407, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8407, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8407, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8407, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"paragliding"].location != NSNotFound)||([stringFileName rangeOfString:@"terbanglayang"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7192, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7192, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7192, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7192, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"racing"].location != NSNotFound)||([stringFileName rangeOfString:@"balapmotor"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  7193, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 7193, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 7193, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 7193, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"traveling"].location != NSNotFound)||([stringFileName rangeOfString:@"perjalanankeluarnegeri"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8270, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8270, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8270, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8270, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"backbone"].location != NSNotFound)||([stringFileName rangeOfString:@"tulangbelakang"].location != NSNotFound)) {
        CGRect rectSign1 = CGRectMake(120,  8405, imageSigned1.size.width, imageSigned1.size.height);
        CGRect rectSign2 = CGRectMake(720, 8405, imageSigned2.size.width, imageSigned2.size.height);
        CGRect rectSign3 = CGRectMake(200, 8405, imageSigned3.size.width, imageSigned3.size.height);
        CGRect rectSign4 = CGRectMake(1320, 8405, imageSigned4.size.width, imageSigned4.size.height);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"salesdeclaration"].location != NSNotFound)||([stringFileName rangeOfString:@"tenagapenjual"].location != NSNotFound)) {
        NSString *mainFileName = [NSString stringWithFormat:@"%@_%@.jpg",[dictTransaction valueForKey:@"SPAJNumber"],stringFileName];
        NSString *fullpath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        fullpath = [NSString stringWithFormat:@"%@/%@",fullpath,mainFileName];
        
        UIImage *baseImage = [UIImage imageWithContentsOfFile:fullpath];
        CGRect rectSign1 = CGRectMake(120,  8060, 0, 0);
        CGRect rectSign2 = CGRectMake(720, 8060, 0, 0);
        CGRect rectSign3 = CGRectMake(200, 8060, 0, 0);
        CGRect rectSign4 = CGRectMake(100, 2702, 275,149);
        
        UIImage *resultImage = [self generateSignatureForImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4];
        NSData *thumbnailData = UIImageJPEGRepresentation(resultImage, 0);
        
        NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@", fullpath];
        [thumbnailData writeToFile:relativeOutputFilePath atomically:YES];
    }
    else if (([stringFileName rangeOfString:@"thirdparty"].location != NSNotFound)||([stringFileName rangeOfString:@"pihakketiga"].location != NSNotFound)) {
        //NSString *mainFileName = [NSString stringWithFormat:@"%@_ThirdParty.jpg",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *mainFileName = [NSString stringWithFormat:@"%@_pihakketiga.jpg",[dictTransaction valueForKey:@"SPAJEappNumber"]];
        NSString *fullpath = [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]];
        fullpath = [NSString stringWithFormat:@"%@/%@",fullpath,mainFileName];
        
        UIImage *baseImage = [UIImage imageWithContentsOfFile:fullpath];
        
        CGRect rectSign1 = CGRectMake(750,  10685, 400, 247);
        CGRect rectSign2 = CGRectMake(720, 10685, 0, 0);
        CGRect rectSign3 = CGRectMake(200, 10685, 0, 0);
        CGRect rectSign4 = CGRectMake(1250, 10685, 400, 247);
        CGRect rectSign5 = CGRectMake(250, 10685, 400, 247);
        
        UIImage *resultImage = [self generateSignatureForThirdPartyImage:baseImage signatureImage1:imageSigned1 signaturePostion1:rectSign1 signatureImage2:imageSigned2 signaturePostion2:rectSign2 signatureImage3:imageSigned3 signaturePostion3:rectSign3 signatureImage4:imageSigned4 signaturePostion4:rectSign4 signatureImage5:imageSigned5 signaturePostion5:rectSign5];
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
