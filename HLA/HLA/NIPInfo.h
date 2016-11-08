//
//  NIPInfo.h
//  BLESS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDataReferral.h"

@protocol NIPInfoDelegate
-(void)selectedNIP:(NSString *)nipNumber Name:(NSString *)name;
@end


@interface NIPInfo : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    ModelDataReferral* modelDataReferral;
    id <NIPInfoDelegate> _delegate;
    NSArray *sorted;
    NSMutableArray* arrayNIP;
    NSMutableArray* arrayRefName;
}
@property (nonatomic, strong) id <NIPInfoDelegate> delegate;
@property (nonatomic, strong) NSNumber *data;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* FilteredData;
@property (nonatomic, strong) NSString *nipText;

@end
