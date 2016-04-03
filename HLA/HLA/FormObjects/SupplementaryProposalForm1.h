//
//  FFform.h
//  MPOS
//
//  Created by compurex on 12/31/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SupplementaryProposalform1 : NSObject
@property (nonatomic,retain)UIWebView *PDFGenerator;
-(void)GenerateSupplementaryProposalPDF1:(NSDictionary*)DataDictionary RNNumber:(NSMutableString*) RNNumber;
@end
