//
//  VIPClass.h
//  BLESS
//
//  Created by Basvi on 2/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPopover.h"

@protocol VIPClassDelegate
-(void)selectedVIPClass:(NSString *)VIPClass;
@end

@interface VIPClass : UITableViewController {
    NSMutableArray *_items;
    id <VIPClassDelegate> _delegate;
    ModelPopover* modelPopOver;

}
@property (nonatomic, strong) id <VIPClassDelegate> delegate;
@end
