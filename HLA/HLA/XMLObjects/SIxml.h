//
//  SIxml.h
//  MPOS
//
//  Created by compurex on 12/30/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIxml : NSObject
-(void)GenerateSIXML:(NSDictionary*)DataDictionary RNNumber:(NSString*) RNNumber;
@end
