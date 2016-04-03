//
//  CA_Form.h
//  MPOS
//
//  Created by Danial D. Moghaddam on 3/11/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CA_Form : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *tableFooter;
@property (weak, nonatomic) IBOutlet UITableView *RiderTableView;
@property (strong, nonatomic) IBOutlet UILabel *name;


-(NSString *)returnPDFFromDictionary:(NSDictionary *)infoDic proposalNo:(NSString *)proposalNo referenceNo:(NSString *)referenceNo;

@end
