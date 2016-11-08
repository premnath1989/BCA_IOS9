//
//  ReferralSource.h
//  BLESS
//
//  Created by Basvi on 2/10/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPopover.h"

@protocol ReferralSourceDelegate
-(void)selectedReferralSource:(NSString *)referralSource;
@end

@interface ReferralSource : UITableViewController{
    NSMutableArray *_items;
    id <ReferralSourceDelegate> _delegate;
    ModelPopover* modelPopOver;
}
@property (nonatomic, strong) id <ReferralSourceDelegate> delegate;
@end
