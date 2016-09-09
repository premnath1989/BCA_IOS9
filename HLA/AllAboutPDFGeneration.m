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
@end
