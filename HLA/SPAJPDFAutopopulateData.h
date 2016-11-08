//
//  SPAJPDFAutopopulate.h
//  BLESS
//
//  Created by Basvi on 8/26/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAJPDFAutopopulateData : NSObject
-(NSMutableArray *)arrayInitializeAgentProfileDB;
-(NSMutableArray *)arrayInitializeReferralDB;
-(NSMutableArray *)arrayInitializePODataDB;
-(NSMutableArray *)arrayInitializeSIMasterDB;
-(NSMutableArray *)arrayInitializeSignatureDB;
-(NSMutableArray *)arrayInitializeAgentProfileHTML;
-(NSMutableArray *)arrayInitializeReferralHTML;
-(NSMutableArray *)arrayInitializePODataHTML;
-(NSMutableArray *)arrayInitializeSIMasterHTML;
-(NSMutableArray *)arrayInitializeSignatureHTML;
@end
