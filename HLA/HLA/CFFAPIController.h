//
//  CFFAPIController.h
//  BLESS
//
//  Created by Basvi on 7/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFAPIController : NSObject
-(void)apiCallCFFHtmtable:(NSString *)URL;
-(void)apiCallCrateCFFHtml:(NSString *)URL;
@end
