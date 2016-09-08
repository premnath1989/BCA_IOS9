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
@property (nonatomic,strong) id <PDFGenerationDelegate> delegatePDFGeneration;
@end
