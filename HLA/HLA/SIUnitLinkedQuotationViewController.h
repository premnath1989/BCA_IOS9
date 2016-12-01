//
//  SIUnitLinkedQuotationViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULQuotationViewControllerDelegate
    -(NSString *)getRunnigSINumber;
    -(NSMutableDictionary *)getBasicPlanDictionary;
    -(NSMutableDictionary *)getPOLADictionary;
    -(NSMutableDictionary *)getULFundAllocationDictionary;
@end

@interface SIUnitLinkedQuotationViewController : UIViewController{
    IBOutlet UIWebView* webIlustration;
}

@property (nonatomic,strong) id <ULQuotationViewControllerDelegate> delegate;
@end
