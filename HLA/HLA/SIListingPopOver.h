//
//  SIListingPopOver.h
//  BLESS
//
//  Created by Basvi on 7/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_SI_Master.h"
#import "SIListingForSPAJTableViewCell.h"

@protocol SIListingDelegate
-(void)selectedSI:(NSString *)SINO;
@end

@interface SIListingPopOver : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    Model_SI_Master* modelSIMaster;
    id <SIListingDelegate> _delegate;
    NSArray *sorted;
    NSMutableArray* arrayPOName;
    NSMutableArray* arrayProductName;
    NSMutableArray* arraySINo;
    NSMutableArray* arraySIDate;
}
@property (nonatomic, strong) id <SIListingDelegate> delegate;
@property (nonatomic, strong) NSNumber *data;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* FilteredData;
@property (nonatomic, strong) NSString *stringSINO;


@end
