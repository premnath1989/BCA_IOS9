//
//  ApplicationAuthorization.h
//  MPOS
//
//  Created by compurex on 1/9/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationAuthorization : NSObject
@property (nonatomic,retain)UIWebView *PDFGenerator;
-(void)GenerateApplicationAuthorizationPDF:(NSDictionary*)DataDictionary RNNumber:(NSMutableString*) RNNumber;
@end
