//
//  CAform.h
//  MPOS
//
//  Created by compurex on 12/24/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CAform : NSObject
@property (nonatomic,retain)UIWebView *PDFGenerator;
-(void)GenerateCAPDF:(NSDictionary*)DataDictionary RNNumber:(NSMutableString*) RNNumber;
@end
