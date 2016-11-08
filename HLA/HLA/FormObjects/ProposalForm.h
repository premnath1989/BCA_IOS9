//
//  ProposalForm.h
//  MPOS
//
//  Created by compurex on 1/9/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ProposalForm : NSObject
@property (nonatomic,retain)UIWebView *PDFGenerator;
-(void)GenerateProposalPDF:(NSDictionary*)DataDictionary RNNumber:(NSMutableString *)RNNumber;
@end
