//
//  KodePosInfo.h
//  BLESS
//
//  Created by Basvi on 3/16/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelKodepos.h"

@protocol KodeposInfoDelegate
-(void)selectedKodePosText:(NSString *)selectText SenderTag:(int)senderTag;
@end

@interface KodePosInfo : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    ModelKodepos* modelKodepos;
    id <KodeposInfoDelegate> _delegate;
    NSArray *sorted;
    NSMutableArray* arrayProvinsi;
    NSMutableArray* arrayKota;
}
@property (nonatomic, strong) id <KodeposInfoDelegate> delegate;
@property (nonatomic, strong) NSNumber *data;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* FilteredData;
@property (nonatomic, strong) NSString *provinsiText;
@end
