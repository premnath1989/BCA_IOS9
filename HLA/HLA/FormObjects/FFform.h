//
//  FFform.h
//  HLA_InfoConnect
//
//  Created by compurex on 12/31/13.
//  Copyright (c) 2013 compurex. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FFform : NSObject
@property (nonatomic,retain)UIWebView *PDFGenerator;
-(void)GenerateFFPDF:(NSDictionary*)DataDictionary RNNumber:(NSMutableString*) RNNumber;
@end