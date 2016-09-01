//
//  ClassImageProcessing.m
//  BLESS
//
//  Created by Basvi on 9/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ClassImageProcessing.h"

@implementation ClassImageProcessing


-(UIImage*)changeColor:(UIImage*)myImage fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor{
    CGImageRef originalImage    = [myImage CGImage];
    CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext  =
    CGBitmapContextCreate(NULL,CGImageGetWidth(originalImage),CGImageGetHeight(originalImage),
                          8,CGImageGetWidth(originalImage)*4,colorSpace,kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0,
                                                 CGBitmapContextGetWidth(bitmapContext),CGBitmapContextGetHeight(bitmapContext)),
                       originalImage);
    UInt8 *data          = CGBitmapContextGetData(bitmapContext);
    int numComponents    = 4;
    int bytesInContext   = CGBitmapContextGetHeight(bitmapContext) *
    CGBitmapContextGetBytesPerRow(bitmapContext);
    double redIn, greenIn, blueIn,alphaIn;
    CGFloat fromRed,fromGreen,fromBlue,fromAlpha;
    CGFloat toRed,toGreen,toBlue,toAlpha;
    
    //Get RGB values of fromColor
    int fromCountComponents = CGColorGetNumberOfComponents([fromColor CGColor]);
    if (fromCountComponents == 4) {
        const CGFloat *_components = CGColorGetComponents([fromColor CGColor]);
        fromRed = _components[0];
        fromGreen = _components[1];
        fromBlue = _components[2];
        fromAlpha = _components[3];
    }
    
    
    //Get RGB values for toColor
    int toCountComponents = CGColorGetNumberOfComponents([toColor CGColor]);
    if (toCountComponents == 4) {
        const CGFloat *_components = CGColorGetComponents([toColor CGColor]);
        toRed   = _components[0];
        toGreen = _components[1];
        toBlue  = _components[2];
        toAlpha = _components[3];
    }
    
    
    //Now iterate through each pixel in the image..
    for (int i = 0; i < bytesInContext; i += numComponents) {
        //rgba value of current pixel..
        redIn    =   (double)data[i]/255.0;
        greenIn  =   (double)data[i+1]/255.0;
        blueIn   =   (double)data[i+2]/255.0;
        alphaIn  =   (double)data[i+3]/255.0;
        
        //now you got current pixel rgb values...check it curresponds with your fromColor
        if( redIn == fromRed && greenIn == fromGreen && blueIn == fromBlue ){
            //image color matches fromColor, then change current pixel color to toColor
            data[i]    =   toRed;
            data[i+1]  =   toGreen;
            data[i+2]  =   toBlue;
            data[i+3]  = toAlpha;
        }
    }
    CGImageRef outImage =   CGBitmapContextCreateImage(bitmapContext);
    myImage             =   [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return myImage;
}

@end
