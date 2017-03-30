//
//  ActivityStatus.h
//  BLESS
//
//  Created by administrator on 3/30/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPopover.h"

@protocol ActivityStatusDelegate
-(void) selectedStatus:(NSString *)status;
@end

@interface ActivityStatus : UITableViewController {
    NSMutableArray *_items;
    id <ActivityStatusDelegate> _delegate;
    ModelPopover* modelPopOver;
}

@property (nonatomic, retain) id <ActivityStatusDelegate> delegate;
@end
